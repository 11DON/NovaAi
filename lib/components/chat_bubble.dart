import 'package:flutter/material.dart';
import 'package:jarvis/models/message.dart';

class ChatBubble extends StatelessWidget {
  final Message message;
  final String? avatar;
  const ChatBubble({super.key, required this.message, required this.avatar});

  @override
  Widget build(BuildContext context) {
    final isUser = message.iUser;
    return Align(
      alignment: message.iUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          mainAxisAlignment:
              isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            if (!isUser && avatar != null)
              Padding(
                padding: EdgeInsets.only(right: 8),
                child: CircleAvatar(
                  backgroundImage: AssetImage(avatar!),
                ),
              ),

            // chatBubble
            Flexible(
              child: Container(
                padding: EdgeInsets.all(12),
                margin: EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  color: isUser
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.secondary,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16),
                    bottomLeft: isUser ? Radius.circular(16) : Radius.zero,
                    bottomRight: isUser ? Radius.circular(16) : Radius.zero,
                  ),
                ),
                child: Text(
                  message.content,
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.inversePrimary),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
