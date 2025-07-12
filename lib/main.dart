import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:jarvis/Providers/chat_provider.dart';
import 'package:jarvis/Providers/navigation_provider.dart';
import 'package:jarvis/Providers/persona_provider.dart';
import 'package:jarvis/Providers/topic_provider.dart';
import 'package:jarvis/models/message.dart';
import 'package:jarvis/pages/main_wrapper.dart';
import 'package:jarvis/Providers/theme_provider.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize Hive
  await Hive.initFlutter();
  Hive.registerAdapter(MessageAdapter());
  // Open box for chat sessions

  await Hive.openBox<List<Message>>('chat_history');

  runApp(
    MultiProvider(
      providers: [
        //Theme Provider
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        //Navigation Provider
        ChangeNotifierProvider(create: (context) => NavigationProvider()),
        // Chat Provider
        ChangeNotifierProvider(create: (context) => ChatProvider()),
        // Persona Provider
        ChangeNotifierProvider(create: (context) => PersonaProvider()),
        // Topic Provider
        ChangeNotifierProvider(create: (context) => TopicProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: Provider.of<ThemeProvider>(context).themeData,
      home: const MainWrapper(),
    );
  }
}
