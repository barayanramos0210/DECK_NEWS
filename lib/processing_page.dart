import 'package:flutter/material.dart';
import 'theme.dart';
import 'claude_service.dart';
import 'analysis_model.dart';

class ProcessingPage extends StatefulWidget {
  const ProcessingPage({super.key});

  @override
  State<ProcessingPage> createState() => _ProcessingPageState();
}

class _ProcessingPageState extends State<ProcessingPage> {
  int _messageIndex = 0;
  final List<String> _messages = [
    "El gatito está leyendo la noticia...",
    "Analizando la carga emocional del lenguaje...",
    "Buscando fuentes verificables...",
    "Rastreando la red de circulación...",
    "Evaluando la arquitectura algorítmica...",
    "Formulando preguntas problematizadoras...",
    "Casi listo, organizando los hallazgos...",
  ];

  @override
  void initState() {
    super.initState();
    _startMessageCycle();
    _runAnalysis();
  }

  void _startMessageCycle() {
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _messageIndex = (_messageIndex + 1) % _messages.length;
        });
        _startMessageCycle();
      }
    });
  }

  Future<void> _runAnalysis() async {
    try {
      // Agregamos un pequeño delay para asegurar que el contexto esté listo en web
      await Future.delayed(const Duration(milliseconds: 500));

      final args = ModalRoute.of(context)?.settings.arguments;
      final text = args is String ? args : null;

      if (text == null) {
        debugPrint("Error: No se recibió el texto de la noticia");
        if (mounted) {
          Navigator.pop(context);
        }
        return;
      }

      final service = ClaudeService();

      // Usamos un timeout para evitar el congelamiento infinito
      final result = await service.analyzeNews(text).timeout(
        const Duration(seconds: 15),
        onTimeout: () {
          debugPrint("Análisis agotó el tiempo de espera");
          return null;
        },
      );

      if (mounted) {
        if (result != null) {
          Navigator.pushReplacementNamed(context, '/results', arguments: result);
        } else {
          // En lugar de solo hacer pop, avisamos que algo salió mal
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Miau... hubo un problema analizando la noticia. ¡Inténtalo de nuevo!")),
          );
        }
      }
    } catch (e) {
      debugPrint("ERROR CRÍTICO EN PROCESSING: $e");
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error técnico: $e")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const GatitoThinking(),
                const SizedBox(height: 40),
                Text(
                  _messages[_messageIndex],
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 20,
                    fontStyle: FontStyle.italic,
                    color: DeckNewsTheme.colorTextoOscuro,
                  ),
                ),
                const SizedBox(height: 30),
                const SizedBox(
                  width: 50,
                  height: 50,
                  child: CircularProgressIndicator(
                    color: DeckNewsTheme.colorPrimario,
                    strokeWidth: 4,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class GatitoThinking extends StatelessWidget {
  const GatitoThinking({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 200,
          height: 200,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: DeckNewsTheme.colorPrimario.withOpacity(0.1),
          ),
        ),
        const Icon(
          Icons.pets,
          size: 120,
          color: DeckNewsTheme.colorPrimario,
        ),
        Positioned(
          top: 10,
          right: 20,
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
              ],
            ),
            child: const Icon(Icons.lightbulb, color: Colors.amber, size: 20),
          ),
        ),
      ],
    );
  }
}
