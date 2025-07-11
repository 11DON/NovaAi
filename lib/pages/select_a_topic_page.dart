import 'package:flutter/material.dart';
import 'package:jarvis/components/my_topic_tab.dart';

class SelectATopicPage extends StatelessWidget {
  const SelectATopicPage({super.key});

  // Sample Topics
  final List<Map<String, dynamic>> topics = const [
    {
      "icon": Icons.favorite_outline,
      "title": "Mental Health",
      "description": "Support, tips, and coping strategies"
    },
    {
      "icon": Icons.school_outlined,
      "title": "Education",
      "description": "Study help, learning tools"
    },
    {
      "icon": Icons.fitness_center,
      "title": "Fitness",
      "description": "Workouts, nutrition, habits"
    },
    {
      "icon": Icons.code,
      "title": "Programming",
      "description": "Help with code and logic"
    },
    {
      "icon": Icons.science_outlined,
      "title": "Science",
      "description": "Ask about nature, physics, and more"
    },
    {
      "icon": Icons.language,
      "title": "Languages",
      "description": "Practice and translate languages"
    }
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Center(
            child: Text('Select a Topic'),
          ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Popular Topics",
              style: TextStyle(
                  color: Theme.of(context).colorScheme.inversePrimary,
                  fontFamily: 'Poppins',
                  fontSize: 24,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 7,
            ),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: [
            //     MyTopicTab(
            //         icon: Icons.favorite_outline,
            //         title: "Mental Health",
            //         describtion: "Support, tips, and coping strategies"),
            //     MyTopicTab(
            //         icon: Icons.favorite_outline,
            //         title: "Mental Health",
            //         describtion: "Support, tips, and coping strategies"),
            //   ],
            // ),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: [
            //     MyTopicTab(
            //         icon: Icons.favorite_outline,
            //         title: "Mental Health",
            //         describtion: "Support, tips, and coping strategies"),
            //     MyTopicTab(
            //         icon: Icons.favorite_outline,
            //         title: "Mental Health",
            //         describtion: "Support, tips, and coping strategies"),
            //   ],
            // ),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: [
            //     MyTopicTab(
            //         icon: Icons.favorite_outline,
            //         title: "Mental Health",
            //         describtion: "Support, tips, and coping strategies"),
            //     MyTopicTab(
            //         icon: Icons.favorite_outline,
            //         title: "Mental Health",
            //         describtion: "Support, tips, and coping strategies"),
            //   ],
            // ),
            Expanded(
              child: GridView.builder(
                itemCount: topics.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 12,
                    childAspectRatio: 0.9),
                itemBuilder: (context, index) {
                  final topic = topics[index];
                  return MyTopicTab(
                    describtion: topic['description'],
                    title: topic['title'],
                    icon: topic['icon'],
                  );
                },
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              "Or Create Your Own",
              style: TextStyle(
                  color: Theme.of(context).colorScheme.inversePrimary,
                  fontFamily: 'Poppins',
                  fontSize: 24,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
