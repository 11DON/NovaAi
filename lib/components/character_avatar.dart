import 'dart:io';
import 'package:flutter/material.dart';

class CharacterAvatar extends StatelessWidget {
  final String avatarPath;
  final double radius;

  const CharacterAvatar({
    super.key,
    required this.avatarPath,
    this.radius = 40.0,
  });

  @override
  Widget build(BuildContext context) {
    ImageProvider imageProvider;

    if (avatarPath.startsWith('/data') || avatarPath.startsWith('/storage')) {
      imageProvider = FileImage(File(avatarPath));
    } else {
      imageProvider = AssetImage(avatarPath);
    }

    return CircleAvatar(
      radius: radius,
      backgroundImage: imageProvider,
      backgroundColor: Colors.grey[300],
    );
  }
}
