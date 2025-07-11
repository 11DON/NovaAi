import 'package:flutter/material.dart';

class PickACharacterPage extends StatelessWidget {
  const PickACharacterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Text(
              "Hello",
              style: TextStyle(color: Colors.white),
            )
          ],
        ),
      ),
    );
  }
}
