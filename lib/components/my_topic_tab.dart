import 'package:flutter/material.dart';

class MyTopicTab extends StatelessWidget {
  final String title;
  final String describtion;
  final IconData? icon;
  final void Function()? onTap;
  const MyTopicTab(
      {super.key,
      required this.describtion,
      this.icon,
      required this.title,
      this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 201,
        height: 200,
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
                  fontSize: 12,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 9,
            ),
            Text(
              describtion,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
                fontFamily: 'Roboto',
                fontSize: 14,
              ),
            )
          ],
        ),
      ),
    );
  }
}
