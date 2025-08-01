import 'package:flutter/material.dart';

// ignore: must_be_immutable
class MyThirdButton extends StatelessWidget {
  final Function()? onTap;
  Icon? icon;
  String title;
  Color color;
  double width;
  double height;
  MyThirdButton({
    super.key,
    required this.color,
    required this.height,
    required this.icon,
    required this.title,
    required this.width,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
        ),
        width: width,
        height: height,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (icon != null) icon!,
            const SizedBox(width: 5),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontFamily: 'Roboto',
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
