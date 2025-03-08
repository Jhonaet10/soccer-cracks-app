import 'package:flutter/material.dart';

class MatchStatus extends StatelessWidget {
  final String? resultado;

  const MatchStatus({
    super.key,
    this.resultado,
  });

  @override
  Widget build(BuildContext context) {
    if (resultado != null) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.green[50],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.check_circle,
              size: 12,
              color: Colors.green[700],
            ),
            const SizedBox(width: 4),
            Text(
              'Finalizado',
              style: TextStyle(
                color: Colors.green[700],
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.orange[50],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.schedule,
            size: 12,
            color: Colors.orange[700],
          ),
          const SizedBox(width: 4),
          Text(
            'Pendiente',
            style: TextStyle(
              color: Colors.orange[700],
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
