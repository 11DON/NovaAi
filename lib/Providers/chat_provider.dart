import 'dart:async';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:nova_ai/Providers/persona_provider.dart';
import 'package:nova_ai/Providers/topic_provider.dart';
import 'package:nova_ai/ai%20services/ai_services.dart';
import 'package:nova_ai/modesl/message.dart';
import 'package:nova_ai/modesl/persona.dart';
import 'package:nova_ai/modesl/topic.dart';
import 'package:provider/provider.dart';

class ChatProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<Message> _messages = [];
  bool _isloading = false;
  String? _currentSessionKey;
  Map<String, dynamic> _currentSessionMeta = {};
  DocumentSnapshot? _lastDocument;
  bool _hasMore = true;

  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _sessionSubscription;

  List<Message> get messages => _messages;
  bool get isloading => _isloading;
  String? get currentSessionKey => _currentSessionKey;
  Map<String, dynamic> get session => _currentSessionMeta;

  static const int pageSize = 20;

  ChatProvider() {
    loadSession("default");
  }

  Future<void> createNewSession(
    String title, {
    bool isTopic = false,
    bool isDefaultCharacter = false,
    String? avatarPath,
  }) async {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final cleanTitle = title.trim().replaceAll(' ', '-');
    String prefix;
    if (isTopic) {
      prefix = 'topic';
    } else if (isDefaultCharacter) {
      prefix = 'default'; // 🟢 Use "default" for system characters
    } else {
      prefix = 'persona';
    }
    final sessionKey = '$prefix||$cleanTitle||$timestamp';

    final sessionDoc = _firestore.collection('chat_sessions').doc(sessionKey);

    if (!(await sessionDoc.get()).exists) {
      await sessionDoc.set({
        'type': prefix,
        'title': cleanTitle,
        'timestamp': timestamp,
        'avatar': avatarPath, // 🟡 Save custom avatar
      });
    }

    _currentSessionKey = sessionKey;
    _messages = [];
    _lastDocument = null;
    _hasMore = true;

    notifyListeners();
    await loadSession(sessionKey);
  }

  Future<void> loadSession(String sessionKey) async {
    await _sessionSubscription?.cancel();

    _currentSessionKey = sessionKey;
    _messages = [];
    _lastDocument = null;
    _hasMore = true;
    try {
      final doc = await _firestore
          .collection('chat_sessions')
          .doc(sessionKey)
          .get();
      if (doc.exists) {
        _currentSessionMeta = doc.data() ?? {};
        _currentSessionMeta['key'] = sessionKey;
      }
    } catch (e) {
      print('Error loading session metadata: $e');
      _currentSessionMeta = {};
    }
    _sessionSubscription = _firestore
        .collection('chat_sessions')
        .doc(sessionKey)
        .collection('messages')
        .orderBy('timeStamp', descending: false)
        .snapshots()
        .listen((querySnapshot) {
          bool newMessageAdded = false;
          for (var change in querySnapshot.docChanges) {
            if (change.type == DocumentChangeType.added) {
              final data = change.doc.data() ?? {};
              final msg = Message(
                content: data['content'] ?? '',
                iUser: data['iUser'] ?? false,
                timeStamp: (data['timeStamp'] as Timestamp).toDate(),
              );

              final exists = _messages.any(
                (m) => m.content == msg.content && m.timeStamp == msg.timeStamp,
              );
              if (!exists) {
                _messages.add(msg);
                newMessageAdded = true;
              }
            }
          }
          if (newMessageAdded) notifyListeners();
        });
  }

  Future<void> sendMesage(BuildContext context, String content) async {
    if (content.trim().isEmpty || _currentSessionKey == null) return;

    final personaProvider = Provider.of<PersonaProvider>(
      context,
      listen: false,
    );
    final topicProvider = Provider.of<TopicProvider>(context, listen: false);

    final systemPrompt =
        personaProvider.selectedPersona?.systemPrompt ??
        topicProvider.selectedTopic?.systemPrompt ??
        "You are a helpful assistant.";

    final userMessage = Message(
      content: content,
      iUser: true,
      timeStamp: DateTime.now(),
    );

    _isloading = true;
    notifyListeners();

    try {
      final msgRef = _firestore
          .collection('chat_sessions')
          .doc(_currentSessionKey)
          .collection('messages');

      await msgRef.add({
        'content': userMessage.content,
        'iUser': userMessage.iUser,
        'timeStamp': Timestamp.fromDate(userMessage.timeStamp),
      });

      final aiReply = await AiServices.sendMessage(
        content,
        systemPrompt: systemPrompt,
      );

      await msgRef.add({
        'content': aiReply,
        'iUser': false,
        'timeStamp': Timestamp.fromDate(DateTime.now()),
      });
    } catch (e) {
      print('Send message error: $e');
      _messages.add(
        Message(content: 'Error: $e', iUser: false, timeStamp: DateTime.now()),
      );
    }

    _isloading = false;
    notifyListeners();
  }

  Future<List<Map<String, dynamic>>> getAllSessionsData() async {
    try {
      final snapshot = await _firestore.collection('chat_sessions').get();
      final sessions = <Map<String, dynamic>>[];

      for (var doc in snapshot.docs) {
        final data = doc.data();
        final key = doc.id;

        String type = data['type'] ?? 'unknown';
        String title = data['title']?.replaceAll('-', ' ') ?? 'Unknown';
        int timestamp = data['timestamp'] ?? 0;
        String? avatar = data['avatar']; // 🔥 Load avatar

        final lastMsgSnapshot = await doc.reference
            .collection('messages')
            .orderBy('timeStamp', descending: true)
            .limit(1)
            .get();

        String lastMessage = '';
        if (lastMsgSnapshot.docs.isNotEmpty) {
          lastMessage = lastMsgSnapshot.docs.first.data()['content'] ?? '';
        }

        sessions.add({
          'key': key,
          'title': title,
          'timestamp': timestamp,
          'type': type,
          'lastMessage': lastMessage,
          'avatar':
              avatar ?? getAvatarForName(title), // 🟢 Fall back to default
          'icon': type == 'persona' ? null : getTopicIconForTitle(title),
        });
      }

      sessions.sort(
        (a, b) => (b['timestamp'] as int).compareTo(a['timestamp'] as int),
      );
      return sessions;
    } catch (e) {
      print('Get sessions data error: $e');
      return [];
    }
  }

  Future<void> startTopicSession(Topic topic) async {
    final sessionKey = topic.sessionKey;
    final sessionDoc = _firestore.collection('chat_sessions').doc(sessionKey);

    final docSnapshot = await sessionDoc.get();
    if (!docSnapshot.exists) {
      await sessionDoc.set({
        'type': 'topic',
        'title': topic.title.trim().replaceAll(' ', '-'),
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      });
    }
    final messagesSnapshot = await sessionDoc.collection('messages').get();
    if (messagesSnapshot.docs.isEmpty) {
      final introMessage = Message(
        content: "Let's talk about ${topic.title}. ${topic.systemPrompt}",
        iUser: false,
        timeStamp: DateTime.now(),
      );

      await sessionDoc.collection('messages').add({
        'content': introMessage.content,
        'iUser': introMessage.iUser,
        'timeStamp': Timestamp.fromDate(introMessage.timeStamp),
      });
    }

    await loadSession(sessionKey);
  }

  Future<List<String>> getAllSessionsKeys() async {
    try {
      final snapshot = await _firestore.collection('chat_sessions').get();
      return snapshot.docs.map((doc) => doc.id).toList();
    } catch (e) {
      print('Error fetching session keys: $e');
      return [];
    }
  }

  /// Get the last session key for a given prefix (e.g. "persona" or "topic")
  Future<String?> getLastSessionFor(String sessionPrefix) async {
    try {
      final keys = await getAllSessionsKeys();
      final matching = keys
          .where((key) => key.startsWith('$sessionPrefix||'))
          .toList();
      if (matching.isEmpty) return null;

      matching.sort();
      return matching.last;
    } catch (e) {
      print('Error getting last session: $e');
      return null;
    }
  }

  Future<void> startCharacterSession(Persona persona) async {
    final docRef = _firestore
        .collection('chat_sessions')
        .doc(persona.sessionKey);
    final doc = await docRef.get();

    if (!doc.exists) {
      await docRef.set({
        'type': 'persona',
        'title': persona.name.trim().replaceAll(' ', '-'),
        'timestamp': DateTime.now().millisecondsSinceEpoch,
        'avatar': persona.avatar, // ✅ Store avatar path
      });
    }

    final messages = await docRef.collection('messages').get();
    if (messages.docs.isEmpty) {
      final intro = Message(
        content:
            "Hey there! I’m ${persona.name}. ${persona.systemPrompt.split('.').first}.",
        iUser: false,
        timeStamp: DateTime.now(),
      );

      await docRef.collection('messages').add({
        'content': intro.content,
        'iUser': intro.iUser,
        'timeStamp': Timestamp.fromDate(intro.timeStamp),
      });
    }

    await loadSession(persona.sessionKey);
  }

  Future<void> clearMessages() async {
    if (_currentSessionKey == null) return;
    final col = _firestore
        .collection('chat_sessions')
        .doc(_currentSessionKey)
        .collection('messages');
    final snap = await col.get();
    for (final doc in snap.docs) {
      await doc.reference.delete();
    }
    _messages.clear();
    notifyListeners();
  }

  Future<bool> deleteSession(String sessionKey) async {
    try {
      final docRef = _firestore.collection('chat_sessions').doc(sessionKey);
      final messages = await docRef.collection('messages').get();
      for (final doc in messages.docs) {
        await doc.reference.delete();
      }
      await docRef.delete();

      if (_currentSessionKey == sessionKey) {
        _messages.clear();
        _currentSessionKey = null;
      }

      notifyListeners();
      return true;
    } catch (e) {
      print('Delete session error: $e');
      return false;
    }
  }

  String getAvatarForName(String name) {
    final avatars = {
      'Ronaldo': 'images/cr7.jpg',
      'Messi': 'images/messi.jpg',
      'Sherlock Holmes': 'images/sholmes.jpg',
      'Thomas Shelby': 'images/tshelby.jpg',
      'Salah El-Din': 'images/saladin.jpg',
      'Batman': 'images/batman.jpg',
      'AI Assistant': 'images/assistant.jpg',
    };
    return avatars[name] ?? 'images/default_avatar.jpg';
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

  Future<void> loadOlderMessages() async {
    if (_isloading || !_hasMore || _currentSessionKey == null) return;
    _isloading = true;
    notifyListeners();

    try {
      var query = _firestore
          .collection('chat_sessions')
          .doc(_currentSessionKey)
          .collection('messages')
          .orderBy('timeStamp', descending: true)
          .limit(pageSize);

      if (_lastDocument != null) {
        query = query.startAfterDocument(_lastDocument!);
      }

      final snapshot = await query.get();
      if (snapshot.docs.isEmpty) {
        _hasMore = false;
      } else {
        _lastDocument = snapshot.docs.last;
        final older = snapshot.docs.map((doc) {
          final data = doc.data();
          return Message(
            content: data['content'] ?? '',
            iUser: data['iUser'] ?? false,
            timeStamp: (data['timeStamp'] as Timestamp).toDate(),
          );
        }).toList();

        _messages = [...older.reversed, ..._messages];
        notifyListeners();
      }
    } catch (e) {
      print('Error loading older messages: $e');
    }

    _isloading = false;
    notifyListeners();
  }

  void saveSession(String sessionKey, String title, String avatar) async {
    final sessionDoc = _firestore.collection('chat_sessions').doc(sessionKey);

    final docSnapshot = await sessionDoc.get();

    if (!docSnapshot.exists) {
      await sessionDoc.set({
        'type': 'topic',
        'title': title.trim().replaceAll(' ', '-'),
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      });
    }
  }

  @override
  void dispose() {
    _sessionSubscription?.cancel();
    super.dispose();
  }
}
