import 'package:flutter/material.dart';

class TeamInfo extends StatelessWidget {
  static const mainColor = Color.fromRGBO(0, 0, 100, 1);
  final String nombre;
  final bool isLocal;

  const TeamInfo({
    super.key,
    required this.nombre,
    required this.isLocal,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: mainColor.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.shield,
            color: mainColor,
            size: 24,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          nombre,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        Text(
          isLocal ? 'Local' : 'Visitante',
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
