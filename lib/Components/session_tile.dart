import 'dart:io';

import 'package:flutter/material.dart';

import 'package:nova_ai/Providers/chat_provider.dart';
import 'package:nova_ai/Providers/topic_provider.dart';
import 'package:nova_ai/utils/util.dart';
import 'package:provider/provider.dart';

class SessionTile extends StatelessWidget {
  final Map session;
  final ImageProvider? avatarImage;
  final void Function()? onTap;

  const SessionTile({
    super.key,
    required this.session,
    this.onTap,
    this.avatarImage,
  });

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
          final path = avatarPath ?? 'images/default_avatar.jpg';
          final isFilePath = path.startsWith('/data/');

          return CircleAvatar(
            radius: 24,
            backgroundImage: isFilePath
                ? FileImage(File(path))
                : AssetImage(path) as ImageProvider,
            backgroundColor: Colors.grey.shade300,
          );
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
        style: TextStyle(color: Theme.of(context).colorScheme.secondary),
      ),
      trailing: Text(
        time,
        style: const TextStyle(color: Colors.grey, fontSize: 12),
      ),
      onTap: onTap,
    );
  }
}
