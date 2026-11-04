import 'package:flutter/material.dart';
import 'package:deck_news/theme.dart';
import 'package:deck_news/claude_service.dart';
import 'package:deck_//deck_news/analysis_model.dart';

enum AppState { home, processing, results }

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  AppState _currentState = AppState.home;
  String _bubbleText = "¿Qué noticia vamos to analizar hoy?";
  bool _isWaving = false;
  AnalysisResult? _lastResult;
  final TextEditingController _controller = TextEditingController();

  void _interactCat(String text) {
    setState(() {
      _bubbleText = text;
      _isWaving = true;
    });
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => _isWaving = false);
    });
  }

  Future<void> _startAnalysis() async {
    if (_controller.text.trim().isEmpty) return;

    setState(() {
      _currentState = AppState.processing;
    });

    final service = ClaudeService();
    final result = await service.analyzeNews(_//controller.text);

    if (mounted) {
      setState(() {
        _lastResult = result;
        _currentState = result != null ? AppState.results : AppState.home;
      });
      if (result == null) {
        _interactCat("Ups, miau... no pude analizar esto.");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: DeckNewsTheme.bgWood,
        child: Center(
          child: Container(
            width: 360,
            height: 720,
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(40),
              border: Border.all(color: Colors.grey[900]!, width: 12),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(28),
              child: _buildCurrentState(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCurrentState() {
    switch (_currentState) {
      case AppState.home:
        return _buildHomeView();
      case AppState.processing:
        return _buildProcessingView();
      case AppState.results:
        return _buildResultsView();
    }
  }

  Widget _buildHomeView() {
    return Stack(
      children: [
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage('https://images.unsplash.com/photo-1521587760476-6c12a4b040da?q=80&w=800&auto=format&fit=crop'),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        Positioned(
          top: 80, left: 30, right: 30,
          child: Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: DeckNewsTheme.bubbleBg,
              border: Border.all(color: DeckNewsTheme.panelBorder, width: 4),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(_bubbleText, textAlign: TextAlign.center, style: DeckNewsTheme.textColorStyle),
          ),
        ),
        Positioned(
          bottom: 120, left: 0, right: 0,
          child: Center(child: InteractiveCat(isWaving: _isWaving)),
        ),
        Positioned(
          bottom: 0, left: 0, right: 0,
          child: Container(
            padding: const EdgeInsets.only(bottom: 20, top: 10),
            decoration: BoxDecoration(
              color: DeckNewsTheme.panelBg,
              border: Border(top: BorderSide(color: DeckNewsTheme.panelBorder, width: 4)),
            ),
            child: Column(
              children: [
                TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    hintText: "Pega la noticia aquí...",
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: _startAnalysis,
                  child: const Text("ANALIZAR 🚀"),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProcessingView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.pets, size: 100, color: Colors.indigo),
          const SizedBox(height: 20),
          const Text("Miau... analizando...", style: TextStyle(fontSize: 20, color: Colors.white)),
          const SizedBox(height: 20),
          const CircularProgressIndicator(color: Colors.indigo),
        ],
      ),
    );
  }

  Widget _buildResultsView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Text("Resultados del Análisis", style: DeckNewsTheme.textColorStyle),
          const SizedBox(height: 20),
          Text(_lastResult?.resumenNeutral ?? "Sin resumen"),
          // Aquí irían los hallazgos simplificados
          ElevatedButton(
            onPressed: () => setState(() => _currentState = AppState.home),
            child: const Text("Volver"),
          ),
        ],
      ),
    );
  }
}

class InteractiveCat extends StatelessWidget {
  final bool isWaving;
  const InteractiveCat({super.key, required this.isWaving});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200, height: 200,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Container(
            width: 110, height: 80,
            decoration: BoxDecoration(
              color: const Color(0xFFF4ECD8),
              border: Border.all(color: DeckNewsTheme.panelBorder, width: 4),
              borderRadius: BorderRadius.circular(40),
            ),
          ),
          Positioned(
            top: 40,
            child: Container(
              width: 90, height: 70,
              decoration: BoxDecoration(
                color: const Color(0xFFF4ECD8),
                border: Border.all(color: DeckNewsTheme.panelBorder, width: 4),
                borderRadius: BorderRadius.circular(35),
              ),
              child: Stack(
                children: [
                  Positioned(left: 20, top: 20, child: CircleAvatar(radius: 4, backgroundColor: DeckNewsTheme.textColor)),
                  Positioned(right: 20, top: 20, child: CircleAvatar(radius: 4, backgroundColor: DeckNewsTheme.textColor)),
                  Positioned(left: 40, bottom: 10, child: Icon(Icons.sentiment_satisfied, size: 20, color: DeckNewsTheme.textColor)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
