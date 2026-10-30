import 'package:flutter/material.dart';
import 'analysis_model.dart';
import 'theme.dart';

class CategoryDetailPage extends StatelessWidget {
  final String category;
  final List<dynamic> hallazgos;
  final Color color;
  final IconData icon;

  const CategoryDetailPage({
    super.key,
    required this.category,
    required this.hallazgos,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DeckNewsTheme.colorFondo,
      appBar: AppBar(
        title: Text(
          category.toUpperCase().replaceFirst('_', ' '),
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: color,
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
            Center(
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 60),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Análisis Detallado",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: DeckNewsTheme.colorTextoOscuro,
              ),
            ),
            const SizedBox(height: 30),
            ...hallazgos.map((h) => Container(
              margin: const EdgeInsets.only(bottom: 15),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: DeckNewsTheme.colorBlanco,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 5, offset: const Offset(0, 3)),
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.check_circle_outline, color: color, size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      h.toString(),
                      style: const TextStyle(fontSize: 16, height: 1.5),
                    ),
                  ),
                ],
              ),
            )).toList(),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
