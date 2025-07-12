import 'package:flutter/material.dart';

class CreateCharacterTab extends StatelessWidget {
  final String img;
  final String title;
  final String describtion;
  final String role;
  final VoidCallback onTap;
  const CreateCharacterTab(
      {super.key,
      required this.describtion,
      required this.title,
      required this.img,
      required this.role,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        width: 200,
        height: 250,
        decoration: BoxDecoration(
          color: const Color(0xFF19191F).withValues(alpha: 0.9),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.grey.shade300.withValues(alpha: 0.2),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              height: 5,
            ),
            Expanded(
              flex: 3,
              child: ClipRRect(
                borderRadius: BorderRadiusGeometry.circular(5),
                child: Image.asset(
                  img,
                  width: 160,
                  height: 160,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Text(
              title,
              style: TextStyle(
                  color: Theme.of(context).colorScheme.inversePrimary,
                  fontFamily: 'Poppins',
                  fontSize: 12,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              describtion,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
                fontFamily: 'Roboto',
                fontSize: 9,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: onTap,
                child: Container(
                  width: 70,
                  height: 30,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Center(
                    child: Text(
                      "Talk",
                      style: TextStyle(fontSize: 17, fontFamily: 'Poppins'),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
