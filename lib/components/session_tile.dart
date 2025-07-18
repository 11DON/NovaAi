import 'dart:io';

import 'package:flutter/material.dart';
import 'package:jarvis/Providers/chat_provider.dart';
import 'package:jarvis/Providers/topic_provider.dart';
import 'package:jarvis/utils/util.dart';
import 'package:provider/provider.dart';

class SessionTile extends StatelessWidget {
  final Map session;
  final void Function()? onTap;

  const SessionTile({super.key, required this.session, this.onTap});

  @override
  Widget build(BuildContext context) {
    final lastMessage = session['lastMessage'];
    final time = formatTimestamp(session['timestamp']);
    final avatarPath = session['avatar'];
    context.read<ChatProvider>();
    final title = session['title'] ?? '';

    return ListTile(
      tileColor: Theme.of(context).colorScheme.tertiary,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
      contentPadding: const EdgeInsets.all(12),
      leading: Consumer2<ChatProvider, TopicProvider>(
        builder: (context, chatProvider, topicProvider, child) {
          if (session['type'] == 'persona') {
            final path = avatarPath ?? 'images/default_avatar.jpg';
            final isFilePath = path.startsWith('/data/');
            ImageProvider imageProvider;
            if (isFilePath) {
              imageProvider = FileImage(File(path));
            } else {
              imageProvider = AssetImage(path);
            }
            return CircleAvatar(
              radius: 24,
              backgroundImage:
                  avatarPath != null && avatarPath.startsWith('/data/')
                      ? FileImage(File(avatarPath))
                      : AssetImage(path ?? 'images/default_avatar.jpg')
                          as ImageProvider,
              backgroundColor: Colors.grey,
            );
          } else {
            return CircleAvatar(
              radius: 24,
              backgroundColor: Colors.grey.shade300,
              backgroundImage: const AssetImage('images/default_avatar.jpg'),
            );
          }
        },
      ),
      title: Text(
        title,
        style: TextStyle(
          color: Theme.of(context).colorScheme.inversePrimary,
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(
        lastMessage,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: Theme.of(context).colorScheme.secondary,
        ),
      ),
      trailing: Text(
        time,
        style: const TextStyle(color: Colors.grey, fontSize: 12),
      ),
      onTap: onTap,
    );
  }
}
