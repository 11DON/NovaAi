import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:jarvis/Providers/navigation_provider.dart';
import 'package:jarvis/pages/homePage.dart';
import 'package:jarvis/pages/pick_a_character_page.dart';
import 'package:jarvis/pages/select_a_topic_page.dart';
import 'package:jarvis/pages/settings_page.dart';
import 'package:provider/provider.dart';

class MainWrapper extends StatelessWidget {
  const MainWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final navProvider = Provider.of<NavigationProvider>(context);

    final pages = const [
      Homepage(),
      SelectATopicPage(),
      PickACharacterPage(),
      SettingsPage()
    ];

    return Scaffold(
      body: pages[navProvider.currnetIndex],
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: GNav(
            gap: 8,
            backgroundColor: Theme.of(context).colorScheme.surface,
            tabBackgroundColor: Theme.of(context).colorScheme.tertiary,
            selectedIndex: navProvider.currnetIndex,
            activeColor: Theme.of(context).colorScheme.inversePrimary,
            onTabChange: (index) => navProvider.setIndex(index),
            tabs: const [
              GButton(
                icon: Icons.home_outlined,
                text: "Home",
              ),
              GButton(
                icon: Icons.topic_outlined,
                text: "Topics",
              ),
              GButton(
                icon: Icons.people_alt_outlined,
                text: "AIs",
              ),
              GButton(
                icon: Icons.settings,
                text: "Settings",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
