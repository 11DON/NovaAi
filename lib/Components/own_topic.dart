import 'package:flutter/material.dart';

import 'package:nova_ai/Pages/chat_page.dart';
import 'package:nova_ai/Providers/chat_provider.dart';
import 'package:nova_ai/Providers/persona_provider.dart';
import 'package:nova_ai/Providers/topic_provider.dart';
import 'package:nova_ai/modesl/topic.dart';
import 'package:provider/provider.dart';

class OwnTopic extends StatefulWidget {
  const OwnTopic({super.key});

  @override
  State<OwnTopic> createState() => _OwnTopicState();
}

class _OwnTopicState extends State<OwnTopic> {
  final _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey.shade300.withValues(alpha: 0.2),
          ),
          color: const Color(0xFF19191F).withValues(alpha: 0.9),
          borderRadius: BorderRadius.circular(12),
        ),
        width: double.infinity,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  hintText: 'Type your own unique topic...',
                  hintStyle: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  prefixIcon: Icon(
                    Icons.forum_outlined,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                    borderSide: BorderSide(
                      color: Colors.grey.shade300.withValues(alpha: 0.2),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey.shade300.withValues(alpha: 0.2),
                    ),
                  ),
                  fillColor: Theme.of(context).colorScheme.surface,
                  filled: true,
                ),
              ),
            ),
            const SizedBox(height: 15),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: GestureDetector(
                onTap: () {
                  final text = _controller.text.trim();
                  if (text.isEmpty) return;
                  final topicProvider = Provider.of<TopicProvider>(
                    context,
                    listen: false,
                  );

                  final personaProvider = Provider.of<PersonaProvider>(
                    context,
                    listen: false,
                  );

                  personaProvider.clearPersona();
                  final customTopic = Topic(
                    title: text,
                    systemPrompt: text,
                    avatar: 'images/default_avatar.jpg',
                  );
                  final chatProvider = Provider.of<ChatProvider>(
                    context,
                    listen: false,
                  );
                  chatProvider.saveSession(
                    customTopic.sessionKey,
                    customTopic.title,
                    customTopic.avatar,
                  );
                  topicProvider.setTopic(customTopic);
                  _controller.clear();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatPage(
                        sessionKey: customTopic.sessionKey,
                        title: customTopic.title,
                      ),
                    ),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Start Custom Chat",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(width: 5),
                      Icon(Icons.arrow_forward),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
