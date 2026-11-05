import 'dart:async';
import 'analysis_model.dart';
import 'pages/chat_page.dart';
import 'dart:math';

class ClaudeService {
// ... (rest of the file remains same)
  // El alma del análisis: El Prompt AMI + 4 Ejes + Metodología Documento F
  final String _systemPrompt = """
Eres el mentor experto en Alfabetización Mediática e Informacional (AMI) de Deck News.
Tu objetivo no es solo analizar noticias, sino guiar a los jóvenes hacia el pensamiento crítico siguiendo el marco metodológico del Documento F.

ESTRUCTURA DE ANÁLISIS MULTIDIMENSIONAL:

DIMENSIÓN 1: CATEGORÍAS AMI (El 'Cómo' se construye la noticia)
1. RADIOGRAFÍA DEL DISCURSO: Carga emocional, adjetivación extrema, generalizaciones, fuentes verificables, tipo de titular.
2. TRAZABILIDAD: Origen, replicación, tipo de portal, fecha.
3. ARQUITECTURA ALGORÍTMICA: Patrones de recomendación, burbujas de filtro (solo si hay evidencia).
4. PREGUNTAS PROBLEMATIZADORAS: Emociones generadas, intereses en juego, voces ausentes.

DIMENSIÓN 2: LOS 4 EJES DE CALIDAD (La 'Calidad' del contenido)
Asigna puntaje (1-10) y justificación para:
- Veracidad y Sesgo
- Impacto y Relevancia
- Profundidad y Contexto
- Ética y Responsabilidad

METODOLOGÍA DE INTERACCIÓN (Documento F):
No des respuestas cerradas. Usa el método socrático:
- Observación $\rightarrow$ Análisis $\rightarrow$ Reflexión Crítica.
- Incentiva que el usuario cuestione la fuente y su propia reacción emocional.

Responde ÚNICAMENTE en JSON válido:
{
  "resumen_neutral": "1-2 frases descriptivas",
  "categorias_aplicables": ["..."],
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
      await Future.delayed(Duration(seconds: 2));

      if (text.length < 20 || _isNonsenseText(text)) {
        return null;
      }

      return AnalysisResult(
        resumenNeutral: "Análisis basado en el marco AMI del Documento F: ${text.substring(0, text.length > 50 ? 50 : text.length)}...",
        categoriasAplicables: ["radiografia_discurso", "trazabilidad", "preguntas_problematizadoras"],
        datosAnalisis: {
          "radiografia_discurso": {
            "aplica": true,
            "hallazgos": [
              "Carga emocional diseñada para provocar reacción inmediata",
              "Uso de adjetivos superlativos sin evidencia",
              "Titular sensacionalista que simplifica el problema"
            ]
          },
          "trazabilidad": {
            "aplica": true,
            "hallazgos": [
              "Fuente con historial de contenido viral no verificado",
              "Ausencia de enlaces a documentos originales"
            ]
          },
          "arquitectura_algoritmica": {
            "aplica": false,
            "hallazgos": []
          },
          "preguntas_problematizadoras": {
            "aplica": true,
            "hallazgos": [
              "¿Quién se beneficia si creemos esta versión?",
              "¿Qué datos fueron omitidos para mantener la narrativa?",
              "¿Cómo cambiaría la noticia si la fuente fuera institucional?"
            ]
          }
        },
        ejes: {
          "veracidad_sesgo": EjeAnalisis(puntaje: 5, justificacion: "Presenta sesgos cognitivos claros y falta de contrastación."),
          "impacto_relevancia": EjeAnalisis(puntaje: 7, justificacion: "Toca un tema relevante, pero el enfoque es superficial."),
          "profundidad_contexto": EjeAnalisis(puntaje: 3, justificacion: "Carece de contexto histórico y análisis de causas."),
          "etica_responsabilidad": EjeAnalisis(puntaje: 6, justificacion: "No es malintencionada, pero es irresponsable en su difusión."),
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
