import 'package:flutter/material.dart';
import 'package:jarvis/Providers/navigation_provider.dart';
import 'package:jarvis/pages/main_wrapper.dart';
import 'package:jarvis/themes/theme_provider.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        //Theme Provider
        ChangeNotifierProvider(create: (context) => ThemeProvider()),
        //Navigation Provider
        ChangeNotifierProvider(create: (context) => NavigationProvider()),
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
