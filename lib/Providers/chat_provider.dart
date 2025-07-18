import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:jarvis/Providers/topic_provider.dart';
import 'package:jarvis/models/message.dart';
import 'package:jarvis/ai%20services/ai_services.dart';
import 'package:jarvis/Providers/persona_provider.dart';
import 'package:jarvis/models/persona.dart';
import 'package:jarvis/models/topic.dart';
import 'package:provider/provider.dart';

class ChatProvider with ChangeNotifier {
  List<Message> _messages = [];
  bool _isloading = false;
  String? _currentSessionKey;

  Box<List<Message>>? _box;

  List<Message> get messages => _messages;
  bool get isloading => _isloading;
  String? get currentSessionKey => _currentSessionKey;

  ChatProvider() {
    _init();
  }

  Future<void> _init() async {
    if (!Hive.isBoxOpen('chat_history')) {
      _box = await Hive.openBox<List<Message>>('chat_history');
    } else {
      _box = Hive.box<List<Message>>('chat_history');
    }

    loadSession("default");
  }

  void loadSession(String sessionKey) {
    if (_box == null) return;

    _currentSessionKey = sessionKey;

    final stored = _box!.get(sessionKey);
    if (stored != null) {
      _messages = List<Message>.from(stored.cast<Message>());
    } else {
      _messages = [];
    }

    notifyListeners();
  }

  void createNewSession(String title, {bool isTopic = false}) {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final cleanTitle = title.trim().replaceAll(' ', '-');
    final prefix = isTopic ? 'topic' : 'persona';
    final sessionKey = '$prefix||$cleanTitle||$timestamp';

    _currentSessionKey = sessionKey;
    _messages = [];

    // Get avatar path
    String? avatarPath;
    if (!isTopic) {
      avatarPath = getAvatarForName(title);
    }

    // Save empty messages but attach avatar as metadata in a parallel structure if needed
    _box?.put(sessionKey, []);

    // Optionally store metadata elsewhere (if you're using a Hive box for metadata)

    notifyListeners();
  }

  bool isTopicSession(String sessionKey) {
    return sessionKey.startsWith('topic||');
  }

  Future<void> sendMesage(BuildContext context, String content) async {
    if (content.trim().isEmpty || _box == null) return;

    final personaProvider =
        Provider.of<PersonaProvider>(context, listen: false);
    final topicProvider = Provider.of<TopicProvider>(context, listen: false);

    final selectedName = personaProvider.selectedPersona?.name ??
        topicProvider.selectedTopic?.title ??
        'AI Assistant';

    final systemPrompt = personaProvider.selectedPersona?.systemPrompt ??
        topicProvider.selectedTopic?.systemPrompt ??
        "You are a helpful assistant.";

    if (_currentSessionKey == null) {
      createNewSession(selectedName);
    }

    final userMessage = Message(
      content: content,
      iUser: true,
      timeStamp: DateTime.now(),
    );

    _messages.add(userMessage);
    _saveCurrentSession();
    notifyListeners();

    _isloading = true;
    notifyListeners();

    try {
      final response = await AiServices.sendMessage(
        content,
        systemPrompt: systemPrompt,
      );

      final responseMessage = Message(
        content: response,
        iUser: false,
        timeStamp: DateTime.now(),
      );

      _messages.add(responseMessage);
    } catch (e) {
      _messages.add(
        Message(
          content: 'Error: $e',
          iUser: false,
          timeStamp: DateTime.now(),
        ),
      );
    }

    _isloading = false;
    _saveCurrentSession();
    notifyListeners();
  }

  void clearMessages() {
    _messages.clear();
    if (_currentSessionKey != null && _box != null) {
      _box!.put(_currentSessionKey, _messages);
    }
    notifyListeners();
  }

  void _saveCurrentSession() {
    if (_currentSessionKey != null && _box != null) {
      _box!.put(_currentSessionKey, _messages);
    }
  }

  List<String> getAllSessionsKeys() {
    if (_box == null) return [];
    return _box!.keys.cast<String>().toList();
  }

  String? getLastSessionFor(String sessionPrefix) {
    if (_box == null) return null;

    final keys = _box!.keys.cast<String>().toList();
    final matching =
        keys.where((key) => key.startsWith('$sessionPrefix||')).toList();

    if (matching.isEmpty) return null;

    matching.sort(); // Optional, to make sure it's in time order
    return matching.last;
  }

  void deleteSession(String sessionKey) {
    if (_box == null) return;

    _box!.delete(sessionKey);
    if (_currentSessionKey == sessionKey) {
      _messages.clear();
      _currentSessionKey = null;
    }
    notifyListeners();
  }

  String getAvatarForName(String name) {
    final avatars = {
      'Ronaldo': 'images/cr7.jpg',
      'Messi': 'images/messi.jpg',
      'Sherlock Holmes': 'images/sholmes.jpg',
      'Thomas Shelby': 'images/tshelby.jpg',
      'Salah El-Din': 'images/saladin.jpg',
      'Batman': 'images/batman.jpg',
      'AI Assistant': 'images/assistant.jpg', // Add default assistant avatar
    };
    print(avatars[name]);
    return avatars[name] ?? 'images/default_avatar.jpg';
  }

  List<Map<String, dynamic>> getAllSessionsData() {
    if (_box == null) return [];

    return _box!.keys.cast<String>().map((key) {
      print('Raw session key: $key');

      final stored = _box!.get(key);
      final messages = (stored ?? []).whereType<Message>().toList();
      final lastMessage = messages.isNotEmpty ? messages.last : null;

      String title = 'Unknown';
      int timestamp = 0;
      String type = 'unknown';

      if (key.contains('||')) {
        final parts = key.split('||');
        if (parts.length >= 3) {
          type = parts[0]; // 'topic' or 'persona'
          title = parts[1].replaceAll('-', ' '); // restore original title
          timestamp = int.tryParse(parts[2]) ?? 0;
        }
      }

      final isPersona = type == 'persona';
      final avatar = getAvatarForName(title);

      final icon = !isPersona ? getTopicIconForTitle(title) : null;
      print('Session type: $type');
      print('Session title: $title');
      print('Avatar path: $avatar');

      return {
        'key': key,
        'title': title,
        'timestamp': timestamp,
        'lastMessage': lastMessage?.content ?? '',
        'type': type,
        'avatar': avatar,
        'icon': icon,
      };
    }).toList()
      ..sort(
          (a, b) => (b['timestamp'] as int).compareTo(a['timestamp'] as int));
  }

  IconData getTopicIconForTitle(String title) {
    switch (title) {
      case 'Mental Health':
        return Icons.favorite_outline;
      case 'Education':
        return Icons.school_outlined;
      case 'Fitness':
        return Icons.fitness_center;
      case 'Programming':
        return Icons.code;
      case 'Science':
        return Icons.science_outlined;
      case 'Languages':
        return Icons.language;
      default:
        return Icons.help_outline;
    }
  }

  void startTopicSession(Topic topic) {
    final sessionKey = topic.sessionKey;

    if (!_box!.containsKey(sessionKey)) {
      _box!.put(sessionKey, []);
    }

    _currentSessionKey = sessionKey;
    _messages = [];

    notifyListeners();
  }

  void startPersonaSession(Persona persona) {
    final sessionKey = persona.sessionKey;
    _currentSessionKey = sessionKey;
    _messages = [];
  }
}
