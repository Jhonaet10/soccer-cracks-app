import 'package:flutter/material.dart';

class TableHeader extends StatelessWidget {
  static const mainColor = Color.fromRGBO(0, 0, 100, 1);

  const TableHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: mainColor,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Tabla de Posiciones',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            'Estadísticas y clasificación del torneo',
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
