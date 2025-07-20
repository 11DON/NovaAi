import 'dart:io';

import 'package:flutter/material.dart';
import 'package:nova_ai/Components/chat_bubble.dart';
import 'package:nova_ai/Providers/chat_provider.dart';
import 'package:nova_ai/Providers/topic_provider.dart';
import 'package:provider/provider.dart';

class CustomChatPage extends StatefulWidget {
  final String sessionKey;
  final String? title;
  final String? avatarPath;
  const CustomChatPage({
    super.key,
    required this.sessionKey,
    this.title,
    this.avatarPath,
  });

  @override
  State<CustomChatPage> createState() => _CustomChatPageState();
}

class _CustomChatPageState extends State<CustomChatPage> {
  final _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isLoadingMore = false;

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final chatProvider = context.read<ChatProvider>();
      if (chatProvider.currentSessionKey != widget.sessionKey) {
        chatProvider.loadSession(widget.sessionKey);
      }
    });

    _scrollController.addListener(() async {
      final chatProvider = context.read<ChatProvider>();
      if (_scrollController.offset <= 100 &&
          !_isLoadingMore &&
          chatProvider.messages.length >= ChatProvider.pageSize) {
        _isLoadingMore = true;
        await chatProvider.loadOlderMessages();
        _isLoadingMore = false;
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          scrolledUnderElevation: 0,
          title: Consumer2<ChatProvider, TopicProvider>(
            builder: (context, chatProvider, topicProvider, child) {
              final session = chatProvider.session;
              final title = session['title'] ?? 'Chat';
              final avatarPath = session['avatar'];

              ImageProvider avatarImage;

              if (avatarPath != null &&
                  avatarPath.startsWith('/data/') &&
                  File(avatarPath).existsSync()) {
                avatarImage = FileImage(File(avatarPath));
              } else {
                avatarImage = const AssetImage('images/default_avatar.jpg');
              }

              return Row(
                children: [
                  const SizedBox(width: 70),
                  Expanded(
                    child: Text(
                      title,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  CircleAvatar(
                    backgroundImage: avatarImage,
                    radius: 20,
                    backgroundColor: Colors.grey[300],
                  ),
                ],
              );
            },
          ),
        ),
        body: Column(
          children: [
            // Chat messages
            Expanded(
              child: Consumer<ChatProvider>(
                builder: (context, chatProvider, child) {
                  if (chatProvider.messages.isEmpty) {
                    return const Center(child: Text("Start a conversation"));
                  }

                  final session = chatProvider.session;
                  final avatarPath = session['avatar'];

                  ImageProvider? avatarImage;
                  if (avatarPath != null &&
                      avatarPath.startsWith('/data/') &&
                      File(avatarPath).existsSync()) {
                    avatarImage = FileImage(File(avatarPath));
                  } else {
                    avatarImage = const AssetImage('images/default_avatar.jpg');
                  }

                  return Stack(
                    children: [
                      ListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.only(bottom: 10),
                        itemCount: chatProvider.messages.length,
                        itemBuilder: (context, index) {
                          final message = chatProvider.messages[index];

                          return ChatBubble(
                            message: message,
                            avatar: message.iUser ? null : avatarImage,
                          );
                        },
                      ),
                      if (chatProvider.isloading)
                        const Positioned(
                          top: 10,
                          left: 0,
                          right: 0,
                          child: Center(child: CircularProgressIndicator()),
                        ),
                    ],
                  );
                },
              ),
            ),

            // Input section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.inversePrimary,
                      ),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Theme.of(context).colorScheme.tertiary,
                        hintText: 'Type a message...',
                        hintStyle: TextStyle(
                          color: Colors.grey.withOpacity(0.6),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.tertiary,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Consumer<ChatProvider>(
                    builder: (context, chatProvider, child) {
                      WidgetsBinding.instance.addPostFrameCallback(
                        (_) => _scrollToBottom(),
                      );
                      return chatProvider.isloading
                          ? const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: CircularProgressIndicator(),
                            )
                          : const SizedBox(width: 10);
                    },
                  ),
                  IconButton(
                    onPressed: () async {
                      if (_controller.text.isNotEmpty) {
                        final chatProvider = context.read<ChatProvider>();
                        await chatProvider.sendMesage(
                          context,
                          _controller.text,
                        );
                        _controller.clear();
                        _scrollToBottom();
                      }
                    },
                    icon: const Icon(Icons.send),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
