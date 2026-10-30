import 'dart:async';
import 'analysis_model.dart';
import 'pages/chat_page.dart';
import 'dart:math';

class ClaudeService {
// ... (rest of the file remains same)
  // El alma del análisis: El Prompt AMI
  final String _systemPrompt = """
Eres el motor de análisis de Deck News, una herramienta de alfabetización mediática (AMI) para jóvenes.
Recibirás el texto de una noticia. Tu tarea es analizarla usando ÚNICAMENTE estas 4 categorías.
No todas aplican siempre: evalúa cuáles tienen evidencia real en el texto y omite las que no.

1. RADIOGRAFÍA DEL DISCURSO (texto como objeto de análisis)
- Nivel de carga emocional del lenguaje
- Presencia de adjetivación extrema
- Uso de generalizaciones ("todos", "nadie")
- Presencia o ausencia de fuentes verificables
- Tipo de titular (sensacionalista, informativo, opinativo)

2. TRAZABILIDAD (red de circulación de la información)
- De dónde proviene la noticia
- Si otros medios la replican
- Si proviene de un blog, portal o medio institucional
- Fecha de publicación

3. ARQUITECTURA ALGORÍTMICA (visibiliza la mediación, solo si hay evidencia)
- Por qué probablemente está viendo esta noticia
- Qué tipo de contenido similar pudo haber consumido antes
- Qué patrones de recomendación se activan

4. PREGUNTAS PROBLEMATIZADORAS (consumo crítico del contenido)
- Qué emociones genera este contenido
- Qué intereses podrían estar en juego
- Qué información falta
- Qué voces no aparecen
- ¿Lo compartirías? ¿Por qué?

Responde ÚNICAMENTE en JSON válido, sin texto adicional, con este formato:
{
  "categorias_aplicables": ["radiografia_discurso", "trazabilidad", "preguntas_problematizadoras"],
  "radiografia_discurso": { "aplica": true, "hallazgos": ["...", "..."] },
  "trazabilidad": { "aplica": true, "hallazgos": ["...", "..."] },
  "arquitectura_algoritmica": { "aplica": false, "hallazgos": [] },
  "preguntas_problematizadoras": { "aplica": true, "hallazgos": ["...", "..."] },
  "resumen_neutral": "1-2 frases describiendo de qué trata la noticia, sin juzgar si es verdadera o falsa"
}

Reglas importantes:
- Nunca dictamines si la noticia es "verdadera" o "falsa".
- "arquitectura_algoritmica" solo aplica si hay contexto de cómo llegó la noticia al usuario.
- Los "hallazgos" deben ser observaciones concretas basadas en el texto.
- Sé breve: máximo 4 hallazgos por categoría.
""";

  Future<AnalysisResult?> analyzeNews(String text) async {
    try {
      await Future.delayed(Duration(seconds: 2));

      // VALIDACIÓN DE ENTRADA (Evitar que analice "hh" o textos sin sentido)
      if (text.length < 20 || _isNonsenseText(text)) {
        print("Entrada inválida: texto demasiado corto o sin sentido");
        return null; // Retornamos null para que la UI muestre que no es una noticia válida
      }

      // SIMULACIÓN DE RESPUESTA DEL LLM basada en el Prompt AMI
      // En producción, aquí iría la llamada a la API de Claude con _systemPrompt
      return AnalysisResult(
        resumenNeutral: "Análisis de: ${text.substring(0, text.length > 50 ? 50 : text.length)}...",
        categoriasAplicables: ["radiografia_discurso", "trazabilidad", "preguntas_problematizadoras"],
        datosAnalisis: {
          "radiografia_discurso": {
            "aplica": true,
            "hallazgos": [
              "Se detecta adjetivación extrema en el titular",
              "Carga emocional alta enfocada en generar urgencia",
              "Ausencia de fuentes verificables en el primer párrafo"
            ]
          },
          "trazabilidad": {
            "aplica": true,
            "hallazgos": [
              "Fuente no identificada claramente como medio institucional",
              "No se especifica fecha de publicación original"
            ]
          },
          "arquitectura_algoritmica": {
            "aplica": false,
            "hallazgos": []
          },
          "preguntas_problematizadoras": {
            "aplica": true,
            "hallazgos": [
              "¿Qué voces quedaron fuera de este relato?",
              "¿Quién se beneficia con la difusión de esta narrativa?",
              "¿Cuál es la intención detrás del uso de palabras alarmistas?"
            ]
          }
        },
      );
    } catch (e) {
      print(e);
      return null;
    }
  }

  bool _isNonsenseText(String text) {
    // Si es un enlace (empieza con http), es válido automáticamente
    if (text.trim().startsWith('http')) return false;

    final regex = RegExp(r'^([a-zA-Z0-9])\1{3,}$'); // 4 o más letras iguales
    if (regex.hasMatch(text.trim())) return true;
    if (text.length > 10 && !text.contains(" ")) return true;
    return false;
  }

  Future<String> interpellate(AnalysisResult previousAnalysis, String userMessage, List<ChatMessage> history) async {
    try {
      await Future.delayed(Duration(seconds: 1));
      String msg = userMessage.toLowerCase().trim();

      if (msg.length < 4 || (msg.length < 10 && !msg.contains(" ") && !msg.contains("?"))) {
        final shortResponses = [
          "¿Eh? No entendí muy bien eso... ¿podrías contarme más sobre lo que piensas de la noticia?",
          "Miau... creo que el teclado te jugó una mala pasada. ¿Qué querías decirme sobre el análisis?",
        ];
        return (shortResponses..shuffle())[0];
      }

      if (msg.contains("verdad") || msg.contains("falso") || msg.contains("mentira") || msg.contains("real")) {
        return "Esa es la pregunta del millón. Pero recuerda: yo no te diré si es verdad o mentira. Miremos la 'Trazabilidad', ¿la fuente es confiable? ¿Qué opinas tú?";
      }

      if (msg.contains("no sé") || msg.contains("confundido") || msg.contains("ayuda")) {
        return "No te preocupes. Intentemos esto: ¿hay alguna palabra en la noticia que te haga sentir incómodo o sorprendido? Ahí suele estar la clave.";
      }

      if (msg.contains("emocion") || msg.contains("sentir") || msg.contains("triste") || msg.contains("miedo")) {
        return "Exactamente. La 'Radiografía del Discurso' detectó carga emocional. Cuando una noticia nos hace sentir mucho, es más difícil pensar críticamente. ¿Sientes que el autor intenta manipularte?";
      }

      if (msg.contains("quien") || msg.contains("fuente") || msg.contains("donde") || msg.contains("autor")) {
        return "Buena observación. La trazabilidad es la huella digital de la noticia. Si no sabemos quién lo dice, es como un rumor. ¿Crees que la fuente tiene algún interés oculto?";
      }

      final genericReflections = [
        "Interesante punto de vista. Si miramos los hallazgos, ¿crees que hay alguna pieza de información que falte?",
        "Vaya, no lo había visto así. ¿Crees que alguien con una opinión opuesta diría lo mismo?",
        "Eso es un gran punto. Si tuvieras que explicarle esto a un amigo para que no sea engañado, ¿qué le señalarías?",
      ];
      return (genericReflections..shuffle())[0];

    } catch (e) {
      return "Ups, me distraje persiguiendo un láser... ¿Puedes repetir eso?";
    }
  }
}
