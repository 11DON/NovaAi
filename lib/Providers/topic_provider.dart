import 'package:flutter/material.dart';
import 'package:nova_ai/modesl/topic.dart';

class TopicProvider with ChangeNotifier {
  Topic? _selectedTopic;

  Topic? get selectedTopic => _selectedTopic;

  final List<Map<String, dynamic>> topics = const [
    {
      "icon": Icons.favorite_outline,
      "title": "Mental Health",
      "description": "Support, tips, and coping strategies",
    },
    {
      "icon": Icons.school_outlined,
      "title": "Education",
      "description": "Study help, learning tools",
    },
    {
      "icon": Icons.fitness_center,
      "title": "Fitness",
      "description": "Workouts, nutrition, habits",
    },
    {
      "icon": Icons.code,
      "title": "Programming",
      "description": "Help with code and logic",
    },
    {
      "icon": Icons.science_outlined,
      "title": "Science",
      "description": "Ask about nature, physics, and more",
    },
    {
      "icon": Icons.language,
      "title": "Languages",
      "description": "Practice and translate languages",
    },
  ];

  void setTopic(Topic topic) {
    _selectedTopic = topic;
    notifyListeners();
  }

  void ClearTopic() {
    _selectedTopic = null;
    notifyListeners();
  }
}
