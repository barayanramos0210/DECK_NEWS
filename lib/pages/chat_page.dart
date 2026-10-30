import 'package:flutter/material.dart';
import 'package:deck_news/claude_service.dart';
import 'package:deck_news/analysis_model.dart';
import 'package:deck_news/theme.dart';

class ChatPage extends StatefulWidget {
  final AnalysisResult? result;

  const ChatPage({super.key, this.result});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _controller = TextEditingController();
  final List<ChatMessage> _messages = [];
  final ClaudeService _claudeService = ClaudeService();
  bool _isTyping = false;
  String _connectionError = "";

  @override
  void initState() {
    super.initState();
    _messages.add(ChatMessage(
      text: "¡Miau! Soy Miau-Análisis. He revisado la noticia. ¿Qué te llamó la atención?",
      isUser: false,
    ));
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

    return Scaffold(
      appBar: AppBar(
        title: const Text("Interpelar al Gatito"),
        actions: [
          IconButton(
            icon: const Icon(Icons.check_circle),
            onPressed: () => Navigator.pushNamed(context, '/reflection'),
          ),
        ],
      ),
      body: Column(
        children: [
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
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return ChatBubble(message: _messages[index]);
              },
            ),
          ),
          if (_isTyping)
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text("Miau-Análisis está pensando... 🐾", style: TextStyle(fontStyle: FontStyle.italic)),
            ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.cardColor,
              border: Border(top: BorderSide(color: theme.dividerColor)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: "Hazle una pregunta crítica...",
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
                    ),
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                const SizedBox(width: 10),
                FloatingActionButton(
                  onPressed: _sendMessage,
                  child: const Icon(Icons.send),
                ),
              ],
            ),
          ),
        ],
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
              margin: const EdgeInsets.symmetric(vertical: 5),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: message.isUser ? theme.colorScheme.primary : Colors.grey[200],
                borderRadius: BorderRadius.circular(15),
              ),
              child: Text(
                message.text,
                style: TextStyle(color: message.isUser ? Colors.white : Colors.black),
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
