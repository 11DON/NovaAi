import 'package:hive/hive.dart';
part 'message.g.dart';

@HiveType(typeId: 0)
class Message extends HiveObject {
  @HiveField(0)
  final String content;
  @HiveField(1)
  final bool iUser;
  @HiveField(2)
  final DateTime timeStamp;

  Message(
      {required this.content, required this.iUser, required this.timeStamp});
}
