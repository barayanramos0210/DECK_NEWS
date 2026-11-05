import 'package:flutter/material.dart';
import 'package:deck_news/analysis_model.dart';
import 'package:deck_news/theme.dart';

class ResultsPage extends StatelessWidget {
  final AnalysisResult result;

  const ResultsPage({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: DeckNewsTheme.panelBorder,
        foregroundColor: Colors.white,
        title: const Text("Análisis Multidimensional"),
        actions: [
          TextButton.icon(
            onPressed: () => Navigator.pushNamed(context, '/chat', arguments: result),
            icon: const Icon(Icons.chat, color: Colors.white),
            label: const Text("Hablar con Miau", style: TextStyle(color: Colors.white)),
          ),
          const SizedBox(width: 20),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1100),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Resumen Neutral - Layout Web (Horizontal)
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: DeckNewsTheme.panelBg,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: DeckNewsTheme.panelBorder.withOpacity(0.3)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.info_outline, color: DeckNewsTheme.panelBorder, size: 32),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Resumen Neutral", style: theme.textTheme.titleLarge),
                            const SizedBox(height: 12),
                            Text(
                              result.resumenNeutral,
                              style: theme.textTheme.bodyMedium?.copyWith(fontSize: 18),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),

                Text(
                  "Diagnóstico de 4 Ejes",
                  style: theme.textTheme.titleLarge?.copyWith(fontSize: 28),
                ),
                const SizedBox(height: 24),

                // Ejes Layout Responsivo
                if (result.ejes != null)
                  LayoutBuilder(builder: (context, constraints) {
                    int crossAxisCount = screenWidth > 800 ? 4 : (screenWidth > 500 ? 2 : 1);
                    return GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20,
                      childAspectRatio: 1.1,
                      children: [
                        _buildEjeCard(context, "Veracidad", result.ejes!["veracidad_sesgo"], Colors.blue),
                        _buildEjeCard(context, "Impacto", result.ejes!["impacto_relevancia"], Colors.orange),
                        _buildEjeCard(context, "Profundidad", result.ejes!["profundidad_contexto"], Colors.green),
                        _buildEjeCard(context, "Ética", result.ejes!["etica_responsabilidad"], Colors.purple),
                      ],
                    );
                  }),

                const SizedBox(height: 48),
                Text(
                  "Hallazgos Detallados",
                  style: theme.textTheme.titleLarge?.copyWith(fontSize: 28),
                ),
                const SizedBox(height: 24),

                // Hallazgos Layout Web
                Wrap(
                  spacing: 20,
                  runSpacing: 20,
                  children: result.categoriasAplicables.map((cat) {
                    final data = result.datosAnalisis[cat];
                    if (data == null || data['aplica'] == false) return const SizedBox.shrink();

                    return SizedBox(
                      width: screenWidth > 800 ? (screenWidth - 100) / 2 : screenWidth,
                      child: CategoryCard(
                        category: cat,
                        hallazgos: List<String>.from(data['hallazgos']),
                      ),
                    );
                  }).toList(),
                ),

                const SizedBox(height: 60),
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: DeckNewsTheme.panelBorder,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    ),
                    onPressed: () => Navigator.pushNamed(context, '/chat', arguments: result),
                    child: const Text("Interpelar al Gatito 🐾", style: TextStyle(fontSize: 20)),
                  ),
                ),
                const SizedBox(height: 60),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEjeCard(BuildContext context, String label, EjeAnalisis? eje, Color color) {
    final theme = Theme.of(context);
    if (eje == null) return const SizedBox.shrink();

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: color.withOpacity(0.4), width: 2),
        boxShadow: [
          BoxShadow(color: color.withOpacity(0.1), blurRadius: 8, offset: const Offset(0, 4)),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(label, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold, color: color)),
            const SizedBox(height: 12),
            Text(
              "${eje.puntaje}/10",
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
                fontSize: 32,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              eje.justificacion,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodySmall?.copyWith(fontSize: 14),
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

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: cardColor.withOpacity(0.3), width: 2),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: cardColor.withOpacity(0.2),
                radius: 20,
                child: Icon(icon, color: cardColor, size: 20),
              ),
              const SizedBox(width: 15),
              Text(label, style: theme.textTheme.titleLarge?.copyWith(fontSize: 20, color: cardColor, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 20),
          ...hallazgos.map((h) => Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.check_circle, size: 18, color: cardColor),
                const SizedBox(width: 12),
                Expanded(child: Text(h, style: theme.textTheme.bodyMedium?.copyWith(fontSize: 16))),
              ],
            ),
          )).toList(),
        ],
      ),
    );
  }
}
