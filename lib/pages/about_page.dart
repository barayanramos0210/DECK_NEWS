import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Sobre Deck News"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Center(
              child: CircleAvatar(
                radius: 60,
                backgroundColor: Colors.transparent,
                child: Icon(Icons.auto_awesome, size: 60, color: Colors.indigo),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              "Nuestra Esencia",
              style: theme.textTheme.displayLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),

            _buildSection(
              context,
              "Misión",
              "Empoderar a los ciudadanos mediante el análisis crítico de la información, proporcionando herramientas tecnológicas que permitan desglosar la narrativa mediática y fomentar un consumo de noticias consciente y libre de manipulaciones.",
              Icons.rocket_launch,
            ),
            const SizedBox(height: 24),
            _buildSection(
              context,
              "Visión",
              "Convertirnos en el estándar global de alfabetización mediática digital, donde cada persona tenga la capacidad de diseccionar la arquitectura del discurso y validar la trazabilidad de la verdad en la era de la desinformación.",
              Icons.visibility,
            ),
            const SizedBox(height: 24),
            _buildSection(
              context,
              "Valores",
              "• Rigurosidad Analítica\n• Transparencia de Fuentes\n• Independencia Cognitiva\n• Accesibilidad Educativa",
              Icons.verified_user,
            ),
            const SizedBox(height: 40),
            const Divider(),
            const SizedBox(height: 24),
            Text(
              "Deck News no es solo una herramienta, es un ejercicio de libertad mental.",
              style: theme.textTheme.bodyMedium?.copyWith(
                fontStyle: FontStyle.italic,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, String content, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Theme.of(context).colorScheme.primary.withOpacity(0.1)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(icon, color: Theme.of(context).colorScheme.primary),
              const SizedBox(width: 12),
              Text(title, style: Theme.of(context).textTheme.titleLarge),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            content,
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
