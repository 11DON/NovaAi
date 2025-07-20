import 'dart:io';
import 'package:flutter/material.dart';

ImageProvider getAvatarProvider(String? avatarPath) {
  if (avatarPath != null && avatarPath.startsWith('/data/')) {
    return FileImage(File(avatarPath));
  } else if (avatarPath != null && avatarPath.isNotEmpty) {
    return AssetImage(avatarPath);
  } else {
    return const AssetImage('images/default_avatar.jpg');
  }
}
