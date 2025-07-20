import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String content;
  final bool iUser;
  final DateTime timeStamp;

  Message({
    required this.content,
    required this.iUser,
    required this.timeStamp,
  });

  // Optional: Add toJson and fromJson if you're using Firebase or APIs
  factory Message.fromJson(Map<String, dynamic> json) {
    final timestamp = json['timeStamp'];
    DateTime parsedTime;

    if (timestamp is String) {
      parsedTime = DateTime.parse(timestamp);
    } else if (timestamp is Timestamp) {
      parsedTime = timestamp.toDate();
    } else {
      parsedTime = DateTime.now();
    }

    return Message(
      content: json['content'] ?? '',
      iUser: json['iUser'] ?? false,
      timeStamp: parsedTime,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'content': content,
      'iUser': iUser,
      'timeStamp': timeStamp.toIso8601String(),
    };
  }
}
