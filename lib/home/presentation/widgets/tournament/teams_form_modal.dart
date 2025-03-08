import 'package:app_project/home/presentation/providers/equipo_form_provider.dart';
import 'package:app_project/shared/presentation/widgets/custom_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TeamsFormModal extends ConsumerStatefulWidget {
  const TeamsFormModal({super.key});

  @override
  TeamsFormModalState createState() => TeamsFormModalState();
}

class TeamsFormModalState extends ConsumerState<TeamsFormModal> {
  final nombreController = TextEditingController();
  final numeroController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    nombreController.dispose();
    numeroController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final equipoForm = ref.watch(equipoProvider);

    ref.listen<EquipoState>(equipoProvider, (prev, next) {
      if (prev?.isSubmitting == true && !next.isSubmitting) {
        if (next.successMessage.isNotEmpty) {
          showCustomSnackbar(context, message: next.successMessage);
          ref.read(equipoProvider.notifier).clearSuccessMessage();
          if (next.successMessage == 'Equipo registrado exitosamente') {
            Navigator.pop(context);
          }
        }
        if (next.errorMessage.isNotEmpty) {
          showCustomSnackbar(context,
              message: next.errorMessage, isError: true);
          ref.read(equipoProvider.notifier).clearErrorMessage();
        }
      }

      if (prev?.jugadores.length != next.jugadores.length) {
        nombreController.clear();
        numeroController.clear();
      }
    });

    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Registrar Equipo',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Nombre del Equipo',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    onChanged:
                        ref.read(equipoProvider.notifier).onNombreEquipoChange,
                    decoration: const InputDecoration(
                      hintText: 'Ingrese el nombre del equipo',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Jugadores',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: TextFormField(
                                controller: nombreController,
                                onChanged: ref
                                    .read(equipoProvider.notifier)
                                    .onNombreJugadorChange,
                                decoration: const InputDecoration(
                                  hintText: 'Nombre del jugador',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: TextFormField(
                                controller: numeroController,
                                onChanged: ref
                                    .read(equipoProvider.notifier)
                                    .onNumeroJugadorChange,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  hintText: '#',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: equipoForm.isValid
                                ? ref
                                    .read(equipoProvider.notifier)
                                    .agregarJugador
                                : null,
                            icon: const Icon(Icons.add),
                            label: const Text('Agregar Jugador'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromRGBO(0, 0, 100, 1),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  if (equipoForm.jugadores.isNotEmpty) ...[
                    const Text(
                      'Lista de Jugadores',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: equipoForm.jugadores.length,
                      itemBuilder: (context, index) {
                        final jugador = equipoForm.jugadores[index];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.grey[300]!),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: Colors.grey[100],
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Center(
                                  child: Text(
                                    '${jugador.numero}',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 15),
                              Expanded(
                                child: Text(
                                  jugador.nombre,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: equipoForm.jugadores.isNotEmpty
                    ? ref.read(equipoProvider.notifier).registrarEquipo
                    : null,
                style: FilledButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(0, 0, 100, 1),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  'Registrar Equipo',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
