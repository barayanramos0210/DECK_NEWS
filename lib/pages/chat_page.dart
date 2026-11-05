import 'package:flutter/material.dart';
import 'package:deck_news/claude_service.dart';
import 'package:deck_news/analysis_model.dart';
import 'package:deck_news/theme.dart';
import 'dart:math';

class ChatPage extends StatefulWidget {
  final AnalysisResult? result;

  const ChatPage({super.key, this.result});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin {
  final TextEditingController _controller = TextEditingController();
  final List<ChatMessage> _messages = [];
  final ClaudeService _claudeService = ClaudeService();
  bool _isTyping = false;
  String _connectionError = "";

  // Animación del Gato
  late AnimationController _danceController;
  late AnimationController _bounceController;

  @override
  void initState() {
    super.initState();

    _danceController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _bounceController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    )..repeat(reverse: true);

    _messages.add(ChatMessage(
      text: "¡Miau! Soy Miau-Análisis. He revisado la noticia. ¿Qué te llamó la atención?",
      isUser: false,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    _danceController.dispose();
    _bounceController.dispose();
    super.dispose();
  }

  void _feedCat() async {
    _danceController.forward(from: 0.0);
    setState(() {
      _messages.add(ChatMessage(
        text: "¡Mmmm! ¡Delicioso! 🐟 Ahora tengo más energía para analizar. ¿En qué estábamos?",
        isUser: false,
      ));
    });
  }

  void _sendMessage() async {
    if (_controller.text.trim().isEmpty) return;

    final userMsg = _controller.text;
    setState(() {
      _messages.add(ChatMessage(text: userMsg, isUser: true));
      _isTyping = true;
      _connectionError = "";
    });
    _controller.clear();

    try {
      if (widget.result == null) {
        throw Exception("No hay datos de análisis disponibles.");
      }

      final response = await _claudeService.interpellate(widget.result!, userMsg, _messages);

      setState(() {
        _messages.add(ChatMessage(text: response, isUser: false));
      });
    } catch (e) {
      debugPrint("CHAT ERROR: $e");
      setState(() {
        _connectionError = "Error de conexión: $e";
        _messages.add(ChatMessage(
          text: "Miau... tengo problemas para conectar con mi cerebro central. Pero aquí tienes un consejo: ¡Cuestiona siempre la fuente y busca el sesgo! 🐾",
          isUser: false,
        ));
      });
    } finally {
      setState(() => _isTyping = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: DeckNewsTheme.panelBg,
      appBar: AppBar(
        backgroundColor: DeckNewsTheme.panelBorder,
        foregroundColor: Colors.white,
        title: const Text("Interpelar al Gatito"),
        actions: [
          TextButton.icon(
            onPressed: () => Navigator.pushNamed(context, '/reflection'),
            icon: const Icon(Icons.check_circle, color: Colors.white),
            label: const Text("Finalizar", style: TextStyle(color: Colors.white)),
          ),
          const SizedBox(width: 20),
        ],
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1000),
          child: Column(
            children: [
              // Área del Gato Interactivo
              Container(
                padding: const EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AnimatedBuilder(
                      animation: _bounceController,
                      builder: (context, child) {
                        return Transform.translate(
                          offset: Offset(0, _bounceController.value * -10),
                          child: RotationTransition(
                            turns: _danceController,
                            child: const Icon(Icons.pets, size: 80, color: Colors.indigo),
                          ),
                        );
                      },
                    ),
                    const SizedBox(width: 20),
                    ElevatedButton.icon(
                      onPressed: _feedCat,
                      icon: const Icon(Icons.restaurant),
                      label: const Text("Alimentar al Gato 🐟"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orangeAccent,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),

              if (_connectionError.isNotEmpty)
                Container(
                  color: Colors.redAccent,
                  width: double.infinity,
                  padding: const EdgeInsets.all(8),
                  child: Text(_connectionError,
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                    textAlign: TextAlign.center,
                  ),
                ),

              Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 15, offset: const Offset(0, 5)),
                    ],
                  ),
                  child: ListView.builder(
                    padding: const EdgeInsets.all(24),
                    itemCount: _messages.length,
                    itemBuilder: (context, index) {
                      return ChatBubble(message: _messages[index]);
                    },
                  ),
                ),
              ),

              if (_isTyping)
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text("Miau-Análisis está pensando... 🐾",
                    style: TextStyle(fontStyle: FontStyle.italic, color: DeckNewsTheme.textColor)),
                ),

              Container(
                padding: const EdgeInsets.all(24),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        decoration: InputDecoration(
                          hintText: "Hazle una pregunta crítica...",
                          fillColor: Colors.white,
                          filled: true,
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
                        ),
                        onSubmitted: (_) => _sendMessage(),
                      ),
                    ),
                    const SizedBox(width: 15),
                    FloatingActionButton(
                      backgroundColor: DeckNewsTheme.panelBorder,
                      onPressed: _sendMessage,
                      child: const Icon(Icons.send, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ChatBubble extends StatelessWidget {
  final ChatMessage message;
  const ChatBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Align(
      alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Row(
        mainAxisAlignment: message.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!message.isUser)
            const Padding(
              padding: EdgeInsets.only(right: 8),
              child: Icon(Icons.pets, size: 30, color: Colors.indigo),
            ),
          Flexible(
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 8),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: message.isUser ? DeckNewsTheme.panelBorder : Colors.grey[100],
                borderRadius: BorderRadius.circular(20),
                border: message.isUser ? null : Border.all(color: Colors.grey[300]!),
              ),
              child: Text(
                message.text,
                style: TextStyle(
                  color: message.isUser ? Colors.white : Colors.black,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ChatMessage {
  final String text;
  final bool isUser;
  ChatMessage({required this.text, required this.isUser});
}
