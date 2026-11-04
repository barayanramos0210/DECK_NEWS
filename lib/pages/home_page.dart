import 'package:flutter/material.dart';
import 'package:deck_news/theme.dart';
import 'package:deck_news/claude_service.dart';
import 'package:deck_news/processing_page.dart';
import 'package:deck_news/results_page.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _bubbleText = "¿Qué noticia vamos a analizar hoy?";
  bool _isWaving = false;

  void _interactCat(String text) {
    setState(() {
      _bubbleText = text;
      _isWaving = true;
    });

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() => _isWaving = false);
      }
    });
  }

  void _handleNewsInput() {
    TextEditingController _controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: DeckNewsTheme.panelBg,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
          side: BorderSide(color: DeckNewsTheme.panelBorder, width: 4),
        ),
        title: Row(
          children: [
            const Icon(Icons.pets, color: Colors.indigo, size: 30),
            const SizedBox(width: 10),
            Text("Miau-Análisis", style: DeckNewsTheme.textColorStyle),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Pega aquí la noticia o el enlace que quieres que analice, miau.",
              textAlign: TextAlign.center,
              style: TextStyle(color: DeckNewsTheme.textColor, fontSize: 16),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _controller,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: "Escribe o pega aquí...",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                filled: true,
                fillColor: Colors.white.withOpacity(0.1),
              ),
            ),
          ],
        ),
        actions: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                if (_controller.text.isNotEmpty) {
                  // Aquí lanzamos el análisis real
                  Navigator.pop(context);
                  _startAnalysis(_controller.text);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: DeckNewsTheme.accentGreen,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              ),
              child: const Text("¡Analizar ahora! 🚀", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  void _startAnalysis(String text) async {
    // En lugar de analizar aquí y esperar, navegamos a la ProcessingPage
    // que se encargará de la espera y la animación.
    Navigator.pushNamed(
      context,
      '/processing',
      arguments: text
    );
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
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.8),
                  blurRadius: 40,
                  offset: const Offset(0, 20),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(28),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage('https://images.unsplash.com/photo-1521587760476-6c12a4b040da?q=80&w=800&auto=format&fit=crop'),
                          fit: BoxFit.cover,
                          colorFilter: ColorFilter.mode(
                            Colors.black.withOpacity(0.2),
                            BlendMode.darken,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 20,
                    left: 0,
                    right: 0,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildTopButton("☰"),
                          _buildTopButton("🌰"),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 80,
                    left: 30,
                    right: 30,
                    child: Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: DeckNewsTheme.bubbleBg,
                        border: Border.all(color: DeckNewsTheme.panelBorder, width: 4),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(color: Colors.black26, offset: Offset(0, 6)),
                        ],
                      ),
                      child: Text(
                        _bubbleText,
                        textAlign: TextAlign.center,
                        style: DeckNewsTheme.textColorStyle,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 120,
                    left: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: () => _interactCat("¡Miau! Soy tu guía. ¿Subimos un PDF o vemos noticias?"),
                      child: Center(
                        child: InteractiveCat(isWaving: _isWaving),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.only(bottom: 20, top: 10),
                      decoration: BoxDecoration(
                        color: DeckNewsTheme.panelBg,
                        border: Border(top: BorderSide(color: DeckNewsTheme.panelBorder, width: 4)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildNavItem("📰", "NOTICIAS", () => _interactCat("¡Exploremos las noticias de hoy!")),
                          _buildNavItem("📚", "BIBLIOTECA", () => _interactCat("Aquí está tu historial de análisis.")),
                          _buildCenterNavItem(),
                          _buildNavItem("🍙", "ALIMENTO", () => _interactCat("¡Mmm, gracias por la comida! 🐟")),
                          _buildNavItem("🎮", "JUEGO", () => _interactCat("¡Hora de jugar un poco!")),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTopButton(String icon) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: DeckNewsTheme.panelBg,
        border: Border.all(color: DeckNewsTheme.panelBorder, width: 3),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: DeckNewsTheme.panelBorder, offset: Offset(0, 4))],
      ),
      child: Center(
        child: Text(icon, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildNavItem(String icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFFF7E6CE),
              border: Border.all(color: DeckNewsTheme.panelBorder, width: 3),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [BoxShadow(color: DeckNewsTheme.panelBorder, offset: Offset(0, 3))],
            ),
            child: Center(child: Text(icon, style: const TextStyle(fontSize: 22))),
          ),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: DeckNewsTheme.textColor)),
        ],
      ),
    );
  }

  Widget _buildCenterNavItem() {
    return GestureDetector(
      onTap: _handleNewsInput,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: DeckNewsTheme.accentGreen,
              shape: BoxShape.circle,
              border: Border.all(color: DeckNewsTheme.panelBorder, width: 4),
              boxShadow: [BoxShadow(color: DeckNewsTheme.accentGreenDark, offset: Offset(0, 4))],
            ),
            child: Center(
              child: Text("📥", style: const TextStyle(fontSize: 28, color: Colors.white)),
            ),
          ),
          const SizedBox(height: 4),
          Text("ANALIZAR", style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: DeckNewsTheme.textColor)),
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
      width: 200,
      height: 200,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Container(
            width: 110,
            height: 80,
            decoration: BoxDecoration(
              color: const Color(0xFFF4ECD8),
              border: Border.all(color: DeckNewsTheme.panelBorder, width: 4),
              borderRadius: BorderRadius.circular(40),
            ),
          ),
          Positioned(
            top: 40,
            child: Container(
              width: 90,
              height: 70,
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
          Positioned(
            right: 40,
            bottom: 20,
            child: AnimatedRotation(
              duration: const Duration(milliseconds: 300),
              turns: isWaving ? 0.1 : 0.0,
              child: Container(
                width: 30,
                height: 20,
                decoration: BoxDecoration(
                  color: const Color(0xFFF4ECD8),
                  border: Border.all(color: DeckNewsTheme.panelBorder, width: 3),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

extension ThemeExtensions on DeckNewsTheme {
  static TextStyle get textColorStyle => const TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: DeckNewsTheme.textColor,
        fontFamily: 'Comic Sans MS',
      );
}
