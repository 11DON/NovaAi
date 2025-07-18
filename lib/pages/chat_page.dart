import 'dart:io';

import 'package:flutter/material.dart';
import 'package:jarvis/Providers/chat_provider.dart';
import 'package:jarvis/Providers/topic_provider.dart';
import 'package:jarvis/components/chat_bubble.dart';
import 'package:provider/provider.dart';

class ChatPage extends StatefulWidget {
  final String sessionKey;
  const ChatPage({super.key, required this.sessionKey});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  // Scroll to the bottom of the page when a new message is added
  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(_scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final chatProvider = context.read<ChatProvider>();
      chatProvider.loadSession(widget.sessionKey);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          scrolledUnderElevation: 0,
          title: Center(child: Consumer2<ChatProvider, TopicProvider>(
            builder: (context, chatProvider, topicProvider, child) {
              final isTopic = widget.sessionKey.startsWith('topic||');

              if (isTopic) {
                final topic = topicProvider.selectedTopic;
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (topic?.icon != null)
                      Padding(
                        padding: const EdgeInsets.only(left: 70),
                        child: Text(topic?.title ?? 'Topic'),
                      ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Icon(
                        topic!.icon,
                        size: 24,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ],
                );
              } else {
                final name =
                    widget.sessionKey.split('||')[1].replaceAll('-', ' ');
                final avatarPath = chatProvider.getAvatarForName(name);
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 95),
                      child: Text(name),
                    ),
                    CircleAvatar(
                      backgroundImage:
                          avatarPath != null && File(avatarPath).existsSync()
                              ? FileImage(File(avatarPath))
                              : AssetImage(avatarPath),
                    ),
                  ],
                );
              }
            },
          )),
        ),
        body: Column(
          children: [
            // TOP SECTION : chat messages
            Expanded(
              child: Consumer<ChatProvider>(
                builder: (context, chatProvider, child) {
                  if (chatProvider.messages.isEmpty) {
                    return const Center(
                      child: Text("Start convesation"),
                    );
                  }
                  // chat Messages
                  return ListView.builder(
                    controller: _scrollController,
                    itemCount: chatProvider.messages.length,
                    itemBuilder: (context, index) {
                      // get each message
                      final message = chatProvider.messages[index];
                      final avatar = message.iUser
                          ? null
                          : chatProvider.getAvatarForName(chatProvider
                                  .currentSessionKey
                                  ?.split('||')[1]
                                  .replaceAll('-', ' ') ??
                              '');

                      // return message
                      return ChatBubble(
                        message: message,
                        avatar: avatar,
                      );
                    },
                  );
                },
              ),
            ),
            // User input
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Row(
                children: [
                  // text box
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.inversePrimary),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Theme.of(context).colorScheme.tertiary,
                        hintText: 'Type a message...',
                        hintStyle: TextStyle(
                          color: Colors.grey.withValues(alpha: 0.6),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.tertiary),
                        ),
                      ),
                    ),
                  ),
                  Consumer<ChatProvider>(
                      builder: (context, chatProvider, child) {
                    // Scroll to bottom after new message added
                    WidgetsBinding.instance
                        .addPostFrameCallback((_) => _scrollToBottom());
                    if (chatProvider.isloading) {
                      return const CircularProgressIndicator();
                    }
                    return const SizedBox();
                  }),

                  // Icon Button
                  IconButton(
                      onPressed: () async {
                        if (_controller.text.isNotEmpty) {
                          final chatProvider = context.read<ChatProvider>();
                          await chatProvider.sendMesage(
                              context, _controller.text);
                          _controller.clear();
                          _scrollToBottom();
                        }
                      },
                      icon: const Icon(Icons.send))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
