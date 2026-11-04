import 'package:flutter/material.dart';
import 'theme.dart';

class ProcessingPage extends StatefulWidget {
  const ProcessingPage({super.key});

  @override
  State<ProcessingPage> createState() => _ProcessingPageState();
}

class _ProcessingPageState extends State<ProcessingPage> {
  @override
  void initState() {
    super.initState();
    // ELIMINAMOS TODO: Sin ciclos, sin animaciones, sin llamadas a la IA.
    // Solo un temporizador simple que garantiza la navegación.
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        final args = ModalRoute.of(context)?.settings.arguments;
        Navigator.pushReplacementNamed(context, '/results', arguments: args);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DeckNewsTheme.bgWood,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.pets, size: 100, color: Colors.indigo),
            const SizedBox(height: 20),
            Text(
              "Analizando la noticia...",
              style: DeckNewsTheme.textColorStyle,
            ),
            const SizedBox(height: 20),
            const CircularProgressIndicator(color: Colors.indigo),
          ],
        ),
      ),
    );
  }
}