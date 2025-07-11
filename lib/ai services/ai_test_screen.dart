import 'package:flutter/material.dart';
import 'package:jarvis/ai%20services/ai_services.dart';

class AiTestScreen extends StatefulWidget {
  const AiTestScreen({super.key});

  @override
  State<AiTestScreen> createState() => _AiTestScreenState();
}

class _AiTestScreenState extends State<AiTestScreen> {
  final TextEditingController _controller = TextEditingController();
  String? _reply;
  bool _loading = false;

  Future<void> _sendMessage() async {
    final message = _controller.text.trim();
    if (message.isEmpty) return;

    setState(() {
      _loading = true;
      _reply = null;
    });
    try {
      final result = await AiServices.sendMessage(message);
      setState(() {
        _reply = result;
      });
    } catch (e) {
      setState(() {
        _reply = "Error: ${e.toString()}";
      });
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("AI chat Test"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: _controller,
                decoration: const InputDecoration(
                  hintText: "Ask The AI",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                onPressed: _loading ? null : _sendMessage,
                child: _loading
                    ? const CircularProgressIndicator()
                    : const Text("send"),
              ),
              const SizedBox(
                height: 10,
              ),
              if (_reply != null)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    _reply ?? '',
                    style: const TextStyle(fontSize: 16, color: Colors.white),
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}
