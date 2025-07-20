import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

import 'package:nova_ai/Pages/home_page.dart';
import 'package:nova_ai/Pages/pick_a_character_page.dart';
import 'package:nova_ai/Pages/select_a_topic_page.dart';
import 'package:nova_ai/Pages/settings_page.dart';
import 'package:nova_ai/Providers/navigation_provider.dart';
import 'package:provider/provider.dart';

class MainWrapper extends StatelessWidget {
  const MainWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final navProvider = Provider.of<NavigationProvider>(context);

    const pages = [
      Homepage(),
      SelectATopicPage(),
      PickACharacterPage(),
      SettingsPage(),
    ];

    return Scaffold(
      body: pages[navProvider.currnetIndex],
      bottomNavigationBar: SafeArea(
        child: GNav(
          duration: const Duration(microseconds: 900),
          curve: Curves.bounceOut,
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          gap: 8,
          backgroundColor: const Color(0xFF19191F).withValues(alpha: 0.9),
          tabBackgroundColor: Theme.of(context).colorScheme.surface,
          selectedIndex: navProvider.currnetIndex,
          activeColor: Theme.of(context).colorScheme.inversePrimary,
          onTabChange: (index) => navProvider.setIndex(index),
          tabs: const [
            GButton(icon: Icons.home_outlined, text: "Home"),
            GButton(icon: Icons.topic_outlined, text: "Topics"),
            GButton(icon: Icons.people_alt_outlined, text: "Talk to AIs"),
            GButton(icon: Icons.settings, text: "Settings"),
          ],
        ),
      ),
    );
  }
}
