import 'package:flutter/material.dart';

class TournamentHeader extends StatelessWidget {
  const TournamentHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color.fromRGBO(0, 0, 100, 1),
            Color.fromRGBO(0, 0, 150, 1),
          ],
          stops: [0.0, 1.0],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color.fromRGBO(0, 0, 100, 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          const SizedBox(height: 30),
          Hero(
            tag: 'tournament_logo',
            child: Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: ClipOval(
                child: Image.asset(
                  'assets/logo.jpg',
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          const SizedBox(height: 25),
          const Text(
            'Crear Nuevo Torneo',
            style: TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 15),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              'Configura los detalles de tu torneo',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(height: 40),
          Container(
            height: 30,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(30),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
