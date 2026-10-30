import 'package:flutter/material.dart';
import 'theme.dart';

class ProcessingPage extends StatefulWidget {
  final VoidCallback onFinished;

  const ProcessingPage({super.key, required this.onFinished});

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
  }

  void _startMessageCycle() {
    // Cambia el mensaje cada 2 segundos para dar dinamismo
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _messageIndex = (_messageIndex + 1) % _messages.length;
        });
        _startMessageCycle();
      }
    });
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
                // Animación del Gatito Pensativo
                const GatitoThinking(),
                const SizedBox(height: 40),
                // Mensaje Dinámico
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
                // Indicador de carga estilizado
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
        // Círculo de fondo con pulsación (efecto aura)
        Container(
          width: 200,
          height: 200,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: DeckNewsTheme.colorPrimario.withOpacity(0.1),
          ),
        ),
        // El gatito
        const Icon(
          Icons.pets,
          size: 120,
          color: DeckNewsTheme.colorPrimario,
        ),
        // Burbuja de pensamiento (estilo minimalista)
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
