import 'package:flutter/material.dart';
import 'package:deck_news/analysis_model.dart';
import 'package:deck_news/theme.dart';

class ResultsPage extends StatelessWidget {
  final AnalysisResult result;

  const ResultsPage({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Análisis Multidimensional"),
        actions: [
          IconButton(
            icon: const Icon(Icons.chat),
            onPressed: () => Navigator.pushNamed(context, '/chat'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Resumen Neutral
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.info_outline, color: theme.colorScheme.primary),
                      const SizedBox(width: 10),
                      Text("Resumen Neutral", style: theme.textTheme.titleLarge),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    result.resumenNeutral,
                    style: theme.textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // SECCIÓN DE LOS 4 EJES (NUEVO)
            Text(
              "Diagnóstico de 4 Ejes",
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: 20),
            if (result.ejes != null) ...[
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
                childAspectRatio: 0.8,
                children: [
                  _buildEjeCard(context, "Veracidad", result.ejes!["veracidad_sesgo"], Colors.blue),
                  _buildEjeCard(context, "Impacto", result.ejes!["impacto_relevancia"], Colors.orange),
                  _buildEjeCard(context, "Profundidad", result.ejes!["profundidad_contexto"], Colors.green),
                  _buildEjeCard(context, "Ética", result.ejes!["etica_responsabilidad"], Colors.purple),
                ],
              ),
              const SizedBox(height: 30),
            ],

            Text(
              "Hallazgos Detallados",
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: 20),

            // Tarjetas Dinámicas basadas en categorias_aplicables
            ...result.categoriasAplicables.map((cat) {
              final data = result.datosAnalisis[cat];
              if (data == null || data['aplica'] == false) return const SizedBox.shrink();

              return CategoryCard(
                category: cat,
                hallazgos: List<String>.from(data['hallazgos']),
              );
            }).toList(),

            const SizedBox(height: 40),
            Center(
              child: ElevatedButton(
                onPressed: () => Navigator.pushNamed(context, '/chat'),
                child: const Text("Interpelar al Gatito"),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildEjeCard(BuildContext context, String label, EjeAnalisis? eje, Color color) {
    final theme = Theme.of(context);
    if (eje == null) return const SizedBox.shrink();

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: color.withOpacity(0.3)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(label, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold, color: color)),
            const SizedBox(height: 8),
            Text(
              "${eje.puntaje}/10",
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
                fontSize: 24,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              eje.justificacion,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodySmall,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

class CategoryCard extends StatelessWidget {
  final String category;
  final List<String> hallazgos;

  const CategoryCard({super.key, required this.category, required this.hallazgos});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Color cardColor = DeckNewsTheme.catRadiografia;
    String label = "Análisis";
    IconData icon = Icons.pets;

    if (category == 'radiografia_discurso') {
      cardColor = DeckNewsTheme.catRadiografia;
      label = "Radiografía del Discurso";
      icon = Icons.remove_red_eye;
    } else if (category == 'trazabilidad') {
      cardColor = DeckNewsTheme.catTrazabilidad;
      label = "Trazabilidad";
      icon = Icons.map;
    } else if (category == 'arquitectura_algoritmica') {
      cardColor = DeckNewsTheme.catArquitectura;
      label = "Arquitectura Algorítmica";
      icon = Icons.settings_suggest;
    } else if (category == 'preguntas_problematizadoras') {
      cardColor = DeckNewsTheme.catPreguntas;
      label = "Preguntas Problematizadoras";
      icon = Icons.help_outline;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 20),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: cardColor.withOpacity(0.3)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    'https://cdn-icons-png.flaticon.com/512/616/616408.png',
                    width: 30,
                    height: 30,
                    errorBuilder: (context, error, stackTrace) => Icon(icon, color: cardColor),
                  ),
                ),
                const SizedBox(width: 10),
                Text(label, style: theme.textTheme.titleLarge?.copyWith(fontSize: 18, color: cardColor)),
              ],
            ),
            const constHBox(),
            ...hallazgos.map((h) => Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.check_circle, size: 16, color: Colors.green),
                  const SizedBox(width: 8),
                  Expanded(child: Text(h, style: theme.textTheme.bodyMedium)),
                ],
              ),
            )).toList(),
          ],
        ),
      ),
    );
  }
}

class constHBox extends StatelessWidget {
  const constHBox({super.key});
  @override
  Widget build(BuildContext context) => const SizedBox(height: 15);
}
