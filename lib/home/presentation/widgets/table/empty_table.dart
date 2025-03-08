import 'package:flutter/material.dart';

class EmptyTable extends StatelessWidget {
  static const mainColor = Color.fromRGBO(0, 0, 100, 1);
  final String message;

  const EmptyTable({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: mainColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.emoji_events_outlined,
              size: 40,
              color: mainColor,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            message,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Text(
            'La tabla se actualizará automáticamente\ncuando haya resultados registrados',
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
