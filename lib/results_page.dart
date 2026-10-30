import 'package:flutter/material.dart';
import 'analysis_model.dart';
import 'theme.dart';
import 'pages/category_detail_page.dart';
import 'pages/chat_page.dart';

class ResultsPage extends StatelessWidget {
  final AnalysisResult result;
  const ResultsPage({super.key, required this.result});

  // Mapeo de categorías a colores e iconos según el diseño AMI
  Map<String, (Color, IconData)> _getCategoryStyle(String category) {
    return {
      'radiografia_discurso': (DeckNewsTheme.catRadiografia, Icons.remove_red_eye),
      'trazabilidad': (DeckNewsTheme.catTrazabilidad, Icons.map),
      'arquitectura_algoritmica': (DeckNewsTheme.catArquitectura, Icons.settings_suggest),
      'preguntas_problematizadoras': (DeckNewsTheme.catPreguntas, Icons.help_outline),
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DeckNewsTheme.colorFondo,
      appBar: AppBar(
        title: const Text("Análisis del Gatito",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: DeckNewsTheme.colorPrimario,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // SECCIÓN: Resumen Neutral (Caja destacada)
            const Text("Resumen del análisis:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: DeckNewsTheme.colorTextoOscuro)),
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: DeckNewsTheme.colorBlanco,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 5)),
                ],
                border: Border.all(color: DeckNewsTheme.colorPrimario, width: 2),
              ),
              child: Text(
                result.resumenNeutral,
                style: const TextStyle(fontSize: 16, fontStyle: FontStyle.italic, height: 1.5),
              ),
            ),
            const SizedBox(height: 30),

            // SECCIÓN: Hallazgos
            const Text("Hallazgos Críticos",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: DeckNewsTheme.colorTextoOscuro)),
            const SizedBox(height: 20),

            // Tarjetas Dinámicas: SOLO las categorías que aplican
            ...result.categoriasAplicables.map((cat) {
              final catData = result.datosAnalisis[cat];
              final hallazgos = catData['hallazgos'] as List<dynamic>;

              // Obtener color e icono dinámicamente
              final style = _getCategoryStyle(cat);
              final color = style.containsKey(cat) ? style[cat]!.$1 : Colors.grey;
              final icon = style.containsKey(cat) ? style[cat]!.$2 : Icons.info;

              return CategoryCard(
                category: cat,
                hallazgos: hallazgos,
                color: color,
                icon: icon,
              );
            }).toList(),
            const SizedBox(height: 30),
            // BOTÓN PARA INICIAR CHAT DE INTERPELACIÓN
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ChatPage(result: result)),
                  );
                },
                icon: const Icon(Icons.chat_bubble_outline),
                label: const Text("Conversar con el Gatito sobre este análisis"),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

class CategoryCard extends StatelessWidget {
  final String category;
  final List<dynamic> hallazgos;
  final Color color;
  final IconData icon;

  const CategoryCard({
    super.key,
    required this.category,
    required this.hallazgos,
    required this.color,
    required this.icon
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: DeckNewsTheme.colorBlanco,
        borderRadius: BorderRadius.circular(20),
        border: Border(left: BorderSide(color: color, width: 8)),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: Offset(0, 5)),
        ],
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CategoryDetailPage(
                category: category,
                hallazgos: hallazgos.cast<String>(),
              ),
            ),
          );
        },
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icon, color: color, size: 24),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      category.toUpperCase().replaceFirst('_', ' '),
                      style: TextStyle(fontWeight: FontWeight.bold, color: color, fontSize: 16),
                    ),
                  ),
                  const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
                ],
              ),
              const Divider(height: 25),
              ...hallazgos.take(3).map((h) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.circle, size: 6, color: Colors.grey),
                    const SizedBox(width: 10),
                    Expanded(child: Text(h.toString(), style: const TextStyle(fontSize: 15))),
                  ],
                ),
              )).toList(),
              if (hallazgos.length > 3)
                Text(
                  "+${hallazgos.length - 3} más hallazgos...",
                  style: const TextStyle(fontSize: 13, color: Colors.grey, fontStyle: FontStyle.italic),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
