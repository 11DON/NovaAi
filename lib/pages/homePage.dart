import 'package:flutter/material.dart';
import 'package:jarvis/Providers/navigation_provider.dart';
import 'package:jarvis/components/my_button.dart';
import 'package:jarvis/pages/pick_a_character_page.dart';
import 'package:provider/provider.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Center(
          child: Text(
            "Ai Chat",
            style: TextStyle(
                fontFamily: "Poppins", fontSize: 18, color: Colors.white),
          ),
        ),
      ),
      body: Column(
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Stack(
                children: [
                  Container(
                    margin: const EdgeInsets.only(bottom: 70),
                    padding: const EdgeInsets.fromLTRB(15, 55, 0, 5),
                    height: 150,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      image: const DecorationImage(
                        image: AssetImage('images/Selection.JPG'),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                    child: Container(
                      height: 150,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.1),
                            Colors.black.withOpacity(0.1),
                            Colors.black.withOpacity(1),
                          ],
                          stops: const [0.0, 0.4, 0.7, 1.0],
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.fromLTRB(35, 50, 0, 0),
                    height: 150,
                    width: double.infinity,
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Your Intelligent",
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: "Poppins",
                              fontSize: 24,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "Companion Awaits",
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: "Poppins",
                              fontSize: 24,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "Connect with AI for personalized conversations.",
                          style: TextStyle(
                              color: Colors.grey,
                              fontFamily: "Roboto-Regular",
                              fontSize: 14),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          MyButton(
              onTap: () =>
                  Provider.of<NavigationProvider>(context, listen: false)
                      .setIndex(1),
              color: const Color(0xFFC4005F),
              height: 110,
              icon: const Icon(
                Icons.broadcast_on_personal_outlined,
                color: Colors.white,
              ),
              title: 'Talk to AI Assistant',
              width: double.infinity),
          MyButton(
              onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PickACharacterPage(),
                    ),
                  ),
              color: const Color(0xFFC4005F),
              height: 110,
              icon: const Icon(
                Icons.people_alt_outlined,
                color: Colors.white,
              ),
              title: 'Talk to a Character',
              width: double.infinity),
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 20, 0, 0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Recent Chats",
                style: TextStyle(
                    color: Theme.of(context).colorScheme.inversePrimary,
                    fontSize: 20,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.bold),
              ),
            ),
          )
        ],
      ),
    );
  }
}
