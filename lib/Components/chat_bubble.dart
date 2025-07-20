import 'package:flutter/material.dart';
import 'package:nova_ai/modesl/message.dart';

class ChatBubble extends StatelessWidget {
  final Message message;
  final ImageProvider? avatar;

  const ChatBubble({super.key, required this.message, this.avatar});

  @override
  Widget build(BuildContext context) {
    final isUser = message.iUser;
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          mainAxisAlignment: isUser
              ? MainAxisAlignment.end
              : MainAxisAlignment.start,
          children: [
            if (!isUser && avatar != null)
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: CircleAvatar(
                  backgroundImage: avatar,
                  radius: 16,
                  backgroundColor: Colors.grey[300],
                ),
              ),
            Flexible(
              child: Container(
                padding: const EdgeInsets.all(12),
                margin: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  color: isUser
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.secondary,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  message.content,
                  style: TextStyle(
                    color: isUser
                        ? Colors.white
                        : Theme.of(context).colorScheme.inversePrimary,
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
