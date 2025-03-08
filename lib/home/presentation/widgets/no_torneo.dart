import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NoTorneoWidget extends StatelessWidget {
  static const mainColor = Color.fromRGBO(0, 0, 100, 1);

  const NoTorneoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Header con gradiente
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color.fromRGBO(0, 0, 100, 1),
                Color.fromRGBO(0, 0, 150, 1),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: mainColor.withOpacity(0.3),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            children: [
              const SizedBox(height: 30),
              // Logo
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
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Bienvenido a GH',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 15),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Text(
                  'Organiza y gestiona tus torneos de fútbol de manera fácil y profesional',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.9),
                    fontSize: 16,
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 30),
              // Curva decorativa inferior
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
        ),
        // Sección de características
        Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              _FeatureItem(
                icon: Icons.emoji_events,
                title: 'Crea tu Torneo',
                description: 'Configura todos los detalles de tu competición',
                onTap: () => context.push('/create-championship'),
              ),
              const SizedBox(height: 15),
              // _FeatureItem(
              //   icon: Icons.group_add,
              //   title: 'Gestiona Equipos',
              //   description: 'Administra los equipos y jugadores participantes',
              //   onTap: () {},
              // ),
              // const SizedBox(height: 15),
              // _FeatureItem(
              //   icon: Icons.sports_soccer,
              //   title: 'Sigue los Partidos',
              //   description: 'Mantén el control de todos los encuentros',
              //   onTap: () {},
              // ),
            ],
          ),
        ),
        // Botón de acción principal
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 30),
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: mainColor.withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: ElevatedButton(
              onPressed: () => context.push('/create-championship'),
              style: ElevatedButton.styleFrom(
                backgroundColor: mainColor,
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              child: const Text(
                'Crear Nuevo Torneo',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _FeatureItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final VoidCallback onTap;

  const _FeatureItem({
    required this.icon,
    required this.title,
    required this.description,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(15),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: NoTorneoWidget.mainColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: NoTorneoWidget.mainColor,
                  size: 24,
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: NoTorneoWidget.mainColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: Colors.grey[400],
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
