import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:nova_ai/Pages/main_wrapper.dart';
import 'package:nova_ai/Providers/chat_provider.dart';
import 'package:nova_ai/Providers/navigation_provider.dart';
import 'package:nova_ai/Providers/persona_provider.dart';
import 'package:nova_ai/Providers/theme_provider.dart';
import 'package:nova_ai/Providers/topic_provider.dart';
import 'package:nova_ai/firebase_options.dart';
import 'package:provider/provider.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
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
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: Provider.of<ThemeProvider>(context).themeData,
      home: const MainWrapper(),
    );
  }
}
