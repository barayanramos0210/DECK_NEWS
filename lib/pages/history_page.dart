import 'package:flutter/material.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mi Historial de Análisis"),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_sweep),
            onPressed: () {},
            tooltip: "Limpiar historial",
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 5, // Mock de 5 análisis pasados
        itemBuilder: (context, index) {
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              leading: const CircleAvatar(
                backgroundColor: Colors.indigo,
                child: Icon(Icons.article, color: Colors.white),
              ),
              title: Text(
                "Análisis de Noticia #${index + 1}",
                style: theme.textTheme.titleLarge?.copyWith(fontSize: 16),
              ),
              subtitle: const Text("Analizado hace 2 días • Radiografía y Trazabilidad"),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                // Navegaría al detalle del análisis guardado
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.pushNamed(context, '/'),
        label: const Text("Nueva Noticia"),
        icon: const Icon(Icons.add),
      ),
    );
  }
}
