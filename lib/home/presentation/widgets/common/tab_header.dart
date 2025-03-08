import 'package:flutter/material.dart';

class TabHeader extends StatelessWidget {
  static const mainColor = Color.fromRGBO(0, 0, 100, 1);
  final String title;
  final String description;

  const TabHeader({
    super.key,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: double.infinity,
          color: mainColor,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          color: mainColor.withOpacity(0.1),
          child: Text(
            description,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
