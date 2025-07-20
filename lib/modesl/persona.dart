class Persona {
  final String name;
  final String role;
  final String systemPrompt;
  final String avatar;

  Persona({
    required this.name,
    required this.role,
    required this.systemPrompt,
    required this.avatar,
  });

  String get sessionKey {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final cleanTitle = name.trim().replaceAll(' ', '-');
    return 'persona||$cleanTitle||$timestamp';
  }
}
