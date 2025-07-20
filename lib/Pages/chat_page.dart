import 'dart:io';

import 'package:flutter/material.dart';
import 'package:nova_ai/Components/chat_bubble.dart';
import 'package:nova_ai/Providers/chat_provider.dart';
import 'package:nova_ai/Providers/topic_provider.dart';
import 'package:provider/provider.dart';

class ChatPage extends StatefulWidget {
  final String sessionKey;
  final String? title;
  final String? avatarPath;
  const ChatPage({
    Key? key,
    required this.sessionKey,
    this.title,
    this.avatarPath,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
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
      // When user scrolls to within 100 pixels of top, load more messages
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
          title: Center(
            child: Consumer2<ChatProvider, TopicProvider>(
              builder: (context, chatProvider, topicProvider, child) {
                final isTopic = widget.sessionKey.startsWith('topic||');
                if (isTopic) {
                  final topic = topicProvider.selectedTopic;

                  // Fallback title from sessionKey if topic is not found
                  final fallbackTitle = widget.sessionKey.split('||').length > 1
                      ? widget.sessionKey.split('||')[1].replaceAll('-', ' ')
                      : 'Topic';

                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 70),
                        child: Text(
                          topic?.title ?? fallbackTitle,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      if (topic?.icon != null)
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
                  print(widget.avatarPath);
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 70),
                        child: Text(
                          widget.title ?? 'Chat',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      CircleAvatar(
                        radius: 16,
                        backgroundImage: (widget.avatarPath != null)
                            ? (widget.avatarPath!.startsWith('/data/')
                                      ? FileImage(File(widget.avatarPath!))
                                      : AssetImage(widget.avatarPath!))
                                  as ImageProvider
                            : const AssetImage('images/default_avatar.jpg'),
                      ),
                    ],
                  );
                }
              },
            ),
          ),
        ),
        body: Column(
          children: [
            // Chat Messages
            Expanded(
              child: Consumer<ChatProvider>(
                builder: (context, chatProvider, child) {
                  if (chatProvider.messages.isEmpty) {
                    return const Center(child: Text("Start a conversation"));
                  }

                  return Stack(
                    children: [
                      ListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.only(bottom: 10),
                        itemCount: chatProvider.messages.length,
                        itemBuilder: (context, index) {
                          final message = chatProvider.messages[index];

                          ImageProvider<Object>? avatarImage;

                          if (!message.iUser) {
                            final avatarPath = chatProvider.getAvatarForName(
                              chatProvider.currentSessionKey
                                      ?.split('||')[1]
                                      .replaceAll('-', ' ') ??
                                  '',
                            );

                            avatarImage = File(avatarPath).existsSync()
                                ? FileImage(File(avatarPath))
                                : AssetImage(avatarPath)
                                      as ImageProvider<Object>;
                          }

                          return ChatBubble(
                            message: message,
                            avatar: avatarImage,
                          );
                        },
                      ),
                    ],
                  );
                },
              ),
            ),

            // Input
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
                      if (chatProvider.isloading) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: CircularProgressIndicator(),
                        );
                      }
                      return const SizedBox(width: 10);
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
