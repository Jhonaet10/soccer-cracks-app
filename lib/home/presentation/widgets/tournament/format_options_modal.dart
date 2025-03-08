import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app_project/home/presentation/providers/torneo_form_provider.dart';

class FormatoOptionsModal extends ConsumerWidget {
  const FormatoOptionsModal({super.key});

  static const mainColor = Color.fromRGBO(0, 0, 100, 1);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final torneoForm = ref.watch(torneoFormProvider);

    return Container(
      padding: const EdgeInsets.all(30),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const Text(
            'Formato de Juego',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: mainColor,
            ),
          ),
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _FormatOption(
                icon: Icons.format_list_numbered,
                title: 'Liga',
                description: 'Todos contra todos',
                isSelected: torneoForm.formatoJuego.value == 'Liga',
                onTap: () => ref
                    .read(torneoFormProvider.notifier)
                    .setFormatoJuego('Liga'),
              ),
              _FormatOption(
                icon: Icons.group_work,
                title: 'Grupos',
                description: 'Fase de grupos + eliminatorias',
                isSelected: torneoForm.formatoJuego.value == 'Grupos',
                onTap: () => ref
                    .read(torneoFormProvider.notifier)
                    .setFormatoJuego('Grupos'),
              ),
            ],
          ),
          const SizedBox(height: 40),
          const Text(
            'Duración de Partidos',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: mainColor,
            ),
          ),
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _DurationOption(
                duration: '90 min',
                description: 'Tiempo completo',
                isSelected: torneoForm.duracionJuego.value == '90 min',
                onTap: () => ref
                    .read(torneoFormProvider.notifier)
                    .setDuracionJuego('90 min'),
              ),
              _DurationOption(
                duration: '60 min',
                description: 'Tiempo reducido',
                isSelected: torneoForm.duracionJuego.value == '60 min',
                onTap: () => ref
                    .read(torneoFormProvider.notifier)
                    .setDuracionJuego('60 min'),
              ),
              _DurationOption(
                duration: '40 min',
                description: 'Tiempo corto',
                isSelected: torneoForm.duracionJuego.value == '40 min',
                onTap: () => ref
                    .read(torneoFormProvider.notifier)
                    .setDuracionJuego('40 min'),
              ),
            ],
          ),
          const SizedBox(height: 40),
          SizedBox(
            width: double.infinity,
            height: 55,
            child: ElevatedButton(
              onPressed: () {
                ref.read(torneoFormProvider.notifier).onFormatoChange(
                      torneoForm.formatoJuego.value,
                      torneoForm.duracionJuego.value,
                    );
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                backgroundColor: mainColor,
                elevation: 2,
              ),
              child: const Text(
                'Confirmar',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FormatOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final bool isSelected;
  final VoidCallback onTap;

  const _FormatOption({
    required this.icon,
    required this.title,
    required this.description,
    required this.isSelected,
    required this.onTap,
  });

  static const mainColor = Color.fromRGBO(0, 0, 100, 1);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 150,
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: isSelected ? mainColor : Colors.grey[100],
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: isSelected ? mainColor : Colors.grey[300]!,
            width: 2,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: mainColor.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [],
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 40,
              color: isSelected ? Colors.white : Colors.grey[600],
            ),
            const SizedBox(height: 10),
            Text(
              title,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.grey[800],
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              description,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: isSelected ? Colors.white70 : Colors.grey[600],
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DurationOption extends StatelessWidget {
  final String duration;
  final String description;
  final bool isSelected;
  final VoidCallback onTap;

  const _DurationOption({
    required this.duration,
    required this.description,
    required this.isSelected,
    required this.onTap,
  });

  static const mainColor = Color.fromRGBO(0, 0, 100, 1);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 100,
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: isSelected ? mainColor : Colors.grey[100],
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: isSelected ? mainColor : Colors.grey[300]!,
            width: 2,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: mainColor.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [],
        ),
        child: Column(
          children: [
            Icon(
              Icons.timer,
              size: 30,
              color: isSelected ? Colors.white : Colors.grey[600],
            ),
            const SizedBox(height: 10),
            Text(
              duration,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.grey[800],
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              description,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: isSelected ? Colors.white70 : Colors.grey[600],
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
