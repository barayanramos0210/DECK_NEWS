import 'package:flutter/material.dart';
import 'package:deck_news/analysis_model.dart';

class CategoryDetailPage extends StatelessWidget {
  final String category;
  final List<String> hallazgos;

  const CategoryDetailPage({super.key, required this.category, required this.hallazgos});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(category.replaceAll('_', ' ').toUpperCase())),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Análisis Detallado", style: theme.textTheme.titleLarge),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: hallazgos.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      leading: CircleAvatar(child: Text("${index + 1}")),
                      title: Text(hallazgos[index], style: theme.textTheme.bodyMedium),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
