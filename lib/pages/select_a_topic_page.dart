import 'package:flutter/material.dart';
import 'package:jarvis/Providers/chat_provider.dart';
import 'package:jarvis/Providers/persona_provider.dart';
import 'package:jarvis/Providers/topic_provider.dart';
import 'package:jarvis/components/my_topic_tab.dart';
import 'package:jarvis/components/own_topic.dart';
import 'package:jarvis/models/topic.dart';
import 'package:jarvis/pages/chat_page.dart';
import 'package:provider/provider.dart';

class SelectATopicPage extends StatelessWidget {
  const SelectATopicPage({super.key});

  // Sample Topics
  final List<Map<String, dynamic>> topics = const [
    {
      "icon": Icons.favorite_outline,
      "title": "Mental Health",
      "description":
          "A compassionate mental health coach who offers support, coping strategies, and emotional guidance."
    },
    {
      "icon": Icons.school_outlined,
      "title": "Education",
      "description":
          "An experienced academic tutor who explains difficult concepts clearly and helps with study techniques."
    },
    {
      "icon": Icons.fitness_center,
      "title": "Fitness",
      "description":
          "A professional fitness trainer who builds custom workout advice and promotes healthy habits."
    },
    {
      "icon": Icons.code,
      "title": "Programming",
      "description":
          "A senior software engineer who teaches coding concepts and helps debug code efficiently."
    },
    {
      "icon": Icons.science_outlined,
      "title": "Science",
      "description":
          "A knowledgeable science teacher who explains scientific topics in simple and engaging ways."
    },
    {
      "icon": Icons.language,
      "title": "Languages",
      "description":
          "A friendly language tutor who helps practice speaking, translate phrases, and learn grammar rules."
    }
  ];
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Theme.of(context).colorScheme.surface,
          scrolledUnderElevation: 0,
          title: const Center(
            child: Text('Select a Topic'),
          ),
        ),
        body: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsetsGeometry.symmetric(vertical: 16),
                child: Center(
                  child: Text(
                    "Popular Topics",
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.inversePrimary,
                        fontFamily: 'Poppins',
                        fontSize: 24,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsetsGeometry.symmetric(horizontal: 12),
              sliver: SliverGrid(
                delegate: SliverChildBuilderDelegate((context, index) {
                  final topicData = topics[index];
                  final topic = Topic(
                    title: topicData['title'],
                    systemPrompt: topicData['description'],
                    avatar: '',
                    icon: topicData['icon'],
                  );
                  return MyTopicTab(
                    icon: topic.icon,
                    title: topic.title,
                    describtion: topic.systemPrompt,
                    onTap: () {
                      final personaProvider =
                          Provider.of<PersonaProvider>(context, listen: false);
                      final topicProvider =
                          Provider.of<TopicProvider>(context, listen: false);
                      Provider.of<ChatProvider>(context, listen: false);
                      final chatProvider =
                          Provider.of<ChatProvider>(context, listen: false);
                      chatProvider.startTopicSession(topic);

                      personaProvider.clearPersona();
                      topicProvider.setTopic(topic);

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ChatPage(sessionKey: topic.sessionKey),
                        ),
                      );
                    },
                  );
                }, childCount: topics.length),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 0.9,
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsetsGeometry.symmetric(vertical: 20),
                child: Center(
                  child: Text(
                    "Or Create Your Own",
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.inversePrimary,
                        fontFamily: 'Poppins',
                        fontSize: 24,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: OwnTopic(),
              ),
            )
          ],
        ),
      ),
    );
  }
}
