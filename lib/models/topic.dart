import 'package:flutter/material.dart';

class Topic {
  final String title;
  final String avatar; // if using asset image
  final String systemPrompt;
  final IconData? icon;

  Topic({
    required this.title,
    required this.systemPrompt,
    required this.avatar,
    this.icon,
  });

  String get sessionKey => "topic_${title.toLowerCase().replaceAll(' ', '_')}";
}
