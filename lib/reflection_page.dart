import 'package:flutter/material.dart';
import 'theme.dart';
import 'analysis_model.dart';

class ReflectionPage extends StatelessWidget {
  final AnalysisResult result;

  const ReflectionPage({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DeckNewsTheme.colorFondo,
      appBar: AppBar(
        title: const Text("Mi Reflexión Final",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: DeckNewsTheme.colorPrimario,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: Icon(Icons.psychology, size: 80, color: DeckNewsTheme.colorPrimario),
            ),
            const SizedBox(height: 20),
            const Text(
              "Momento de decidir",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: DeckNewsTheme.colorTextoOscuro),
            ),
            const SizedBox(height: 10),
            const Text(
              "Después de analizar la noticia y conversar con el gatito, ¿cuál es tu conclusión?",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 30),

            _buildDecisionCard(
              title: "Confío en la información",
              subtitle: "Considero que es veraz y útil",
              icon: Icons.check_circle,
              color: Colors.green,
            ),
            const SizedBox(height: 15),

            _buildDecisionCard(
              title: "Tengo mis dudas",
              subtitle: "Hay elementos que me hacen desconfiar",
              icon: Icons.help,
              color: Colors.orange,
            ),
            const SizedBox(height: 15),

            _buildDecisionCard(
              title: "Es contenido engañoso",
              subtitle: "Presenta sesgos o falta de evidencia",
              icon: Icons.warning,
              color: Colors.red,
            ),
            const SizedBox(height: 30),

            const Text("¿Por qué tomaste esta decisión?",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: DeckNewsTheme.colorTextoOscuro)),
            const SizedBox(height: 10),
            TextField(
              maxLines: 4,
              decoration: const InputDecoration(
                hintText: "Escribe aquí tu reflexión final...",
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.popUntil(context, (route) => route.isFirst);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("¡Reflexión guardada! Gracias por analizar críticamente.")),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                ),
                child: const Text("Finalizar Análisis", style: TextStyle(fontSize: 18)),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildDecisionCard({required String title, required String subtitle, required IconData icon, required Color color}) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 30),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 13)),
              ],
            ),
          ),
          const Icon(Icons.radio_button_unchecked, color: Colors.grey),
        ],
      ),
    );
  }
}
