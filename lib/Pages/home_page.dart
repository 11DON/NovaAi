import 'package:flutter/material.dart';
import 'package:nova_ai/Pages/chat_page.dart';
import 'package:nova_ai/Pages/custom_chat_page.dart';
import 'package:provider/provider.dart';
import 'package:nova_ai/Providers/chat_provider.dart';
import 'package:nova_ai/Providers/navigation_provider.dart';

import 'package:nova_ai/components/my_button.dart';
import 'package:nova_ai/components/session_tile.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  late Future<List<Map<String, dynamic>>> _sessionsFuture;

  @override
  void initState() {
    super.initState();
    _loadSessions();
  }

  void _loadSessions() {
    final chatProvider = Provider.of<ChatProvider>(context, listen: false);
    _sessionsFuture = chatProvider.getAllSessionsData();
  }

  Future<void> _deleteMostRecentChat() async {
    final chatProvider = Provider.of<ChatProvider>(context, listen: false);
    final sessions = await chatProvider.getAllSessionsData();

    if (sessions.isNotEmpty) {
      final mostRecentSessionKey = sessions.first['key'] as String;
      await chatProvider.deleteSession(mostRecentSessionKey);

      // Reload sessions after deletion
      final success = await chatProvider.deleteSession(mostRecentSessionKey);
      if (!mounted) return;
      if (success) {
        setState(() {
          _sessionsFuture = chatProvider.getAllSessionsData();
        });
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Most recent chat was deleted")),
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("No chats to delete")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.black,
        title: const Center(
          child: Text(
            "Ai Chat",
            style: TextStyle(
              fontFamily: "Poppins",
              fontSize: 18,
              color: Colors.white,
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Column(
              children: [
                // Your header with image and texts (unchanged)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                    child: Stack(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(bottom: 70),
                          padding: const EdgeInsets.fromLTRB(15, 40, 0, 5),
                          height: 150,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            image: const DecorationImage(
                              image: AssetImage('images/Selection.jpg'),
                              fit: BoxFit.cover,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        Container(
                          height: 150,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black.withOpacity(0.1),
                                Colors.black.withOpacity(0.1),
                                Colors.black.withOpacity(1),
                              ],
                              stops: const [0.0, 0.4, 0.7, 1.0],
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.fromLTRB(25, 30, 0, 0),
                          height: 150,
                          width: double.infinity,
                          child: const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Your Intelligent",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: "Poppins",
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "Companion Awaits",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: "Poppins",
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                textAlign: TextAlign.center,
                                "Connect with AI for personalized conversations.",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontFamily: "Roboto-Regular",
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Buttons
                MyButton(
                  onTap: () => Provider.of<NavigationProvider>(
                    context,
                    listen: false,
                  ).setIndex(1),
                  color: const Color(0xFFC4005F),
                  height: 110,
                  icon: const Icon(
                    Icons.broadcast_on_personal_outlined,
                    color: Colors.white,
                  ),
                  title: 'Talk to AI Assistant',
                  width: double.infinity,
                ),
                MyButton(
                  onTap: () => Provider.of<NavigationProvider>(
                    context,
                    listen: false,
                  ).setIndex(2),
                  color: const Color(0xFFC4005F),
                  height: 110,
                  icon: const Icon(
                    Icons.broadcast_on_personal_outlined,
                    color: Colors.white,
                  ),
                  title: 'Talk to a Character',
                  width: double.infinity,
                ),
                // Recent Chats Header & Delete Button
                Padding(
                  padding: const EdgeInsets.fromLTRB(15, 20, 0, 0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Recent Chats",
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.inversePrimary,
                            fontSize: 20,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 15, 10),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.tertiary,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: TextButton.icon(
                              onPressed: _deleteMostRecentChat,
                              icon: const Icon(
                                Icons.delete_forever,
                                color: Colors.red,
                              ),
                              label: Text(
                                "Delete Chat",
                                style: TextStyle(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.inversePrimary,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Recent Chats List: Use FutureBuilder to await getAllSessionsData()
                FutureBuilder<List<Map<String, dynamic>>>(
                  future: _sessionsFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Padding(
                        padding: EdgeInsets.all(20),
                        child: CircularProgressIndicator(),
                      );
                    } else if (snapshot.hasError) {
                      return Padding(
                        padding: const EdgeInsets.all(20),
                        child: Text('Error loading chats: ${snapshot.error}'),
                      );
                    } else {
                      final sessions = snapshot.data ?? [];
                      if (sessions.isEmpty) {
                        return const Padding(
                          padding: EdgeInsets.all(20),
                          child: Text("No Chats to show yet"),
                        );
                      }
                      return ListView.separated(
                        itemCount: sessions.length,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        separatorBuilder: (_, __) => const SizedBox(height: 10),
                        itemBuilder: (context, index) {
                          final session = sessions[index];

                          return SessionTile(
                            session: session,
                            onTap: () {
                              final sessionType = session['type'] ?? 'default';
                              final sessionKey = session['key'] as String;
                              final sessionTitle = session['title'] as String?;
                              final avatar = session['avatar'] as String?;
                              print('THIS IS SESSSION TYPE $sessionType');
                              print('THIS IS SESSSION PTH $avatar');
                              print(
                                'THIS IS SESSSION AVATR TITLE $sessionTitle',
                              );
                              if (sessionType == 'persona') {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => CustomChatPage(
                                      sessionKey: sessionKey,
                                      title: sessionTitle,
                                      avatarPath: avatar,
                                    ),
                                  ),
                                );
                              } else {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ChatPage(
                                      sessionKey: sessionKey,
                                      avatarPath: avatar,
                                      title: sessionTitle,
                                    ),
                                  ),
                                );
                              }
                            },
                          );
                        },
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
