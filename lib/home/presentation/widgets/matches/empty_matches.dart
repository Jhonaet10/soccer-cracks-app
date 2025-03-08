import 'package:flutter/material.dart';

class EmptyMatches extends StatelessWidget {
  const EmptyMatches({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.sports_soccer,
                size: 40,
                color: Colors.grey[400],
              ),
            ),
            const SizedBox(height: 15),
            Text(
              'No hay partidos programados',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              'Los partidos aparecerán aquí cuando inicies el torneo',
              style: TextStyle(
                color: Colors.grey[400],
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
