import 'package:app_project/home/presentation/widgets/tournament/format_options_modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:app_project/home/presentation/providers/torneo_form_provider.dart';

class TournamentForm extends ConsumerWidget {
  const TournamentForm({super.key});

  static const mainColor = Color.fromRGBO(0, 0, 100, 1);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final torneoForm = ref.watch(torneoFormProvider);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Información Básica',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: mainColor,
            ),
          ),
          const SizedBox(height: 20),
          TextFormField(
            onChanged:
                ref.read(torneoFormProvider.notifier).onNombreTorneoChange,
            decoration: InputDecoration(
              labelText: 'Nombre del Torneo',
              labelStyle: const TextStyle(color: mainColor),
              hintText: 'Ej: Copa Libertadores 2024',
              prefixIcon: const Icon(Icons.emoji_events, color: mainColor),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              focusedBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(15)),
                borderSide: BorderSide(color: mainColor, width: 2),
              ),
              filled: true,
              fillColor: Colors.grey[50],
            ),
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: TextEditingController(
              text: torneoForm.fechaInicio != null
                  ? '${torneoForm.fechaInicio!.day}/${torneoForm.fechaInicio!.month}/${torneoForm.fechaInicio!.year}'
                  : '',
            ),
            decoration: InputDecoration(
              labelText: 'Fecha de Inicio',
              labelStyle: const TextStyle(color: mainColor),
              hintText: 'Selecciona una fecha',
              prefixIcon: const Icon(Icons.calendar_today, color: mainColor),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              focusedBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(15)),
                borderSide: BorderSide(color: mainColor, width: 2),
              ),
              filled: true,
              fillColor: Colors.grey[50],
            ),
            readOnly: true,
            onTap: () => _selectDate(context, ref),
          ),
          const SizedBox(height: 20),
          TextFormField(
            controller: TextEditingController(
              text:
                  '${torneoForm.formatoJuego.value} - ${torneoForm.duracionJuego.value}',
            ),
            decoration: InputDecoration(
              labelText: 'Formato de Juego',
              labelStyle: const TextStyle(color: mainColor),
              hintText: 'Selecciona el formato',
              prefixIcon: const Icon(Icons.sports_soccer, color: mainColor),
              suffixIcon: const Icon(Icons.arrow_drop_down, color: mainColor),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              focusedBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(15)),
                borderSide: BorderSide(color: mainColor, width: 2),
              ),
              filled: true,
              fillColor: Colors.grey[50],
            ),
            readOnly: true,
            onTap: () {
              showModalBottomSheet(
                context: context,
                builder: (context) => const FormatoOptionsModal(),
                backgroundColor: Colors.transparent,
                isScrollControlled: true,
              );
            },
          ),
        ],
      ),
    );
  }

  Future<void> _selectDate(BuildContext context, WidgetRef ref) async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: mainColor,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (date != null) {
      ref.read(torneoFormProvider.notifier).onFechaInicioChange(date);
    }
  }
}
