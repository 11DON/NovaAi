import 'package:flutter/material.dart';

class MyTopicTab extends StatelessWidget {
  final String title;
  final String describtion;
  final IconData? icon;
  MyTopicTab(
      {super.key, required this.describtion, this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: GestureDetector(
        child: Container(
          width: 181,
          height: 180,
          decoration: BoxDecoration(
            color: Color(0xFF19191F).withValues(alpha: 0.9),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.grey.shade300.withValues(alpha: 0.2),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                CircleAvatar(
                  backgroundColor: Theme.of(context)
                      .colorScheme
                      .primary
                      .withValues(alpha: 0.2),
                  child: Icon(icon,
                      size: 25, color: Theme.of(context).colorScheme.primary),
                )
              ],
              const SizedBox(
                height: 10,
              ),
              Text(
                title,
                style: TextStyle(
                    color: Theme.of(context).colorScheme.inversePrimary,
                    fontFamily: 'Poppins',
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                describtion,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontFamily: 'Roboto',
                  fontSize: 14,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
