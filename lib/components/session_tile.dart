import 'package:flutter/material.dart';
import 'package:jarvis/utils/util.dart';

class SessionTile extends StatelessWidget {
  final Map session;
  final void Function()? onTap;

  const SessionTile({super.key, required this.session, this.onTap});

  @override
  Widget build(BuildContext context) {
    final title = session['title'];
    final lastMessage = session['lastMessage'];
    final time = formatTimestamp(session['timestamp']);
    final avatarPath = session['avatar'];

    return ListTile(
      tileColor: Theme.of(context).colorScheme.tertiary,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
      contentPadding: const EdgeInsets.all(12),
      leading: CircleAvatar(
        radius: 24,
        backgroundImage: AssetImage(avatarPath ?? 'images/default_avatar.png'),
        backgroundColor: Colors.grey,
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
