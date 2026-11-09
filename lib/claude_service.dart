import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'analysis_model.dart';
import 'pages/chat_page.dart';

class ClaudeService {
  // La API Key se carga desde las variables de entorno en el despliegue
  final String _apiKey = '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';
  final String _apiUrl = 'https://api.openai.com/v1/chat/completions';

  final String _systemPrompt = """
Eres el mentor experto en Alfabetización Mediática e Informacional (AMI) de Deck News.
Tu objetivo es guiar a los jóvenes hacia el pensamiento crítico siguiendo el marco metodológico del Documento F.

ESTRUCTURA DE ANÁLISIS:
1. DIMENSIÓN AMI: Radiografía del discurso, Trazabilidad, Arquitectura Algorítmica y Preguntas Problematizadoras.
2. LOS 4 EJES DE CALIDAD: Veracidad y Sesgo, Impacto y Relevancia, Profundidad y Contexto, Ética y Responsabilidad.

REGLA CRÍTICA: Responde ÚNICAMENTE en formato JSON válido. No añadas texto antes ni después del JSON.
Formato esperado:
{
  "resumen_neutral": "texto",
  "categorias_aplicables": ["radiografia_discurso", "trazabilidad", ...],
  "radiografia_discurso": { "aplica": true, "hallazgos": ["..."] },
  "trazabilidad": { "aplica": true, "hallazgos": ["..."] },
  "arquitectura_algoritmica": { "aplica": false, "hallazgos": [] },
  "preguntas_problematizadoras": { "aplica": true, "hallazgos": ["..."] },
  "ejes": {
    "veracidad_sesgo": { "puntaje": 8, "justificacion": "..." },
    "impacto_relevancia": { "puntaje": 5, "justificacion": "..." },
    "profundidad_contexto": { "puntaje": 7, "justificacion": "..." },
    "etica_responsabilidad": { "puntaje": 9, "justificacion": "..." }
  }
}
""";

  Future<AnalysisResult?> analyzeNews(String text) async {
    try {
      final response = await http.post(
        Uri.parse(_apiUrl),
        headers: {
          'Authorization': 'Bearer $_apiKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "model": "gpt-4o", // Usamos GPT-4o para máxima calidad en el análisis
          "messages": [
            {"role": "system", "content": _systemPrompt},
            {"role": "user", "content": "Analiza la siguiente noticia siguiendo el marco AMI: $text"}
          ],
          "response_format": {"type": "json_object"} // Forzamos a OpenAI a responder JSON
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final content = data['choices'][0]['message']['content'];
        return AnalysisResult.fromJson(jsonDecode(content));
      } else {
        print('Error de OpenAI API: ${response.statusCode} - ${response.body}');
        return null;
      }
    } catch (e) {
      print('Error de conexión con OpenAI: $e');
      return null;
    }
  }

  Future<String> interpellate(AnalysisResult previousAnalysis, String userMessage, List<ChatMessage> history) async {
    try {
      final response = await http.post(
        Uri.parse(_apiUrl),
        headers: {
          'Authorization': 'Bearer $_apiKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "model": "gpt-4o-mini", // Usamos mini para respuestas rápidas y baratas en el chat
          "messages": [
            {"role": "system", "content": "Eres un mentor socrático de AMI. No des respuestas cerradas. Usa la información del análisis previo para hacer que el usuario reflexione. Sé breve, juvenil y empático."},
            {"role": "user", "content": "Análisis previo: ${jsonEncode(previousAnalysis.toJson())}\n\nUsuario dice: $userMessage"}
          ],
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['choices'][0]['message']['content'];
      }
      return "Ups, tuve un problema pensando... ¿Puedes repetirlo?";
    } catch (e) {
      return "Mi conexión falló, pero sigo aquí. ¿Qué opinas de la fuente de la noticia?";
    }
  }
}

