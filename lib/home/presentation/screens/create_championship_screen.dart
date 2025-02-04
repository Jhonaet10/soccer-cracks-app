import 'package:app_project/home/presentation/providers/equipo_form_provider.dart';
import 'package:app_project/home/presentation/providers/torneo_form_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreateChampionshipScreen extends ConsumerWidget {
  static const name = 'create-championship-screen';
  const CreateChampionshipScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final torneoForm = ref.watch(torneoProvider);
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.asset(
                'assets/logo.png',
                width: 200,
              ),
            ),
            const Center(
              child: Text(
                'Crear Torneo de Futbol',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 30,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                children: [
                  TextField(
                    onChanged:
                        ref.read(torneoProvider.notifier).onNombreTorneoChange,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.sports_soccer),
                      labelText: 'Nombre del Torneo',
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: TextEditingController(
                      text: ref.watch(torneoProvider).fechaInicio != null
                          ? '${ref.watch(torneoProvider).fechaInicio!.day}/${ref.watch(torneoProvider).fechaInicio!.month}/${ref.watch(torneoProvider).fechaInicio!.year}'
                          : '',
                    ),
                    decoration: const InputDecoration(
                      labelText: 'Fecha de Inicio',
                      prefixIcon: Icon(Icons.calendar_today),
                    ),
                    readOnly: true,
                    onTap: () => _selectDate(context, ref),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: TextEditingController(
                        text: '${torneoForm.formatoJuego.value} - ${torneoForm.duracionJuego.value}'),
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.sports_soccer),
                      labelText: 'Seleccionar Formato de Juego',
                    ),
                    readOnly: true,
                    onTap: () {
                      showModalBottomSheet(
                          context: context,
                          builder: (context) {
                            return const _ModalFormatoOptions();
                          });
                    },
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Equipos Registrados',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            builder: (context) {
                              return const _ModalEquiposOptions();
                            },
                          );
                        },
                        child: const Text('Agregar Equipo'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 100,
                    child: torneoForm.equipos.isEmpty
                        ? const Center(
                            child: Text(
                              'No hay equipos registrados',
                              style: TextStyle(color: Colors.grey),
                            ),
                          )
                        : ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: torneoForm.equipos.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: Container(
                                  width: 100,
                                  decoration: BoxDecoration(
                                    color: Colors.blue,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    torneoForm.equipos[index].nombre,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      // Acción para crear el torneo
                      ref.read(torneoProvider.notifier).registrarTorneo();
                    },
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child:
                          Text('Crear Torneo', style: TextStyle(fontSize: 18)),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context, WidgetRef ref) async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );
    if (date != null) {
      ref.read(torneoProvider.notifier).onFechaInicioChange(date);
    }
  }
}

class _ModalFormatoOptions extends ConsumerWidget {
  const _ModalFormatoOptions();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final torneoForm = ref.watch(torneoProvider);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      height: 300,
      decoration: const BoxDecoration(
        color: Color.fromRGBO(0, 0, 100, 1),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: 15),
          const Text(
            'Seleccionar Formato de Juego',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                child: Container(
                  width: 65,
                  height: 65,
                  decoration: BoxDecoration(
                    color: torneoForm.formatoJuego.value == 'Liga'
                        ? Colors.lightBlue
                        : Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.black),
                  ),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.sports_soccer, size: 25),
                      Text('Liga', style: TextStyle(fontSize: 12)),
                    ],
                  ),
                ),
                onTap: () {
                  ref.read(torneoProvider.notifier).setFormatoJuego(
                        'Liga',
                      );
                },
              ),
              const SizedBox(width: 25),
              GestureDetector(
                child: Container(
                  width: 65,
                  height: 65,
                  decoration: BoxDecoration(
                    color: torneoForm.formatoJuego.value == 'Grupos'
                        ? Colors.lightBlue
                        : Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.sports_soccer, size: 25),
                      Text('Grupos', style: TextStyle(fontSize: 12)),
                    ],
                  ),
                ),
                onTap: () {
                  ref.read(torneoProvider.notifier).setFormatoJuego(
                        'Grupos',
                      );
                },
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Text(
            'Seleccionar Tiempo de Juego',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              GestureDetector(
                child: Container(
                  width: 65,
                  height: 65,
                  decoration: BoxDecoration(
                    color: torneoForm.duracionJuego.value == '90 min'
                        ? Colors.lightBlue
                        : Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.black),
                  ),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.timer, size: 25),
                      Text('90 min', style: TextStyle(fontSize: 12)),
                    ],
                  ),
                ),
                onTap: () {
                  ref.read(torneoProvider.notifier).setDuracionJuego(
                        '90 min',
                      );
                },
              ),
              GestureDetector(
                child: Container(
                  width: 65,
                  height: 65,
                  decoration: BoxDecoration(
                    color: torneoForm.duracionJuego.value == '60 min'
                        ? Colors.lightBlue
                        : Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.black),
                  ),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.timer, size: 25),
                      Text('60 min', style: TextStyle(fontSize: 12)),
                    ],
                  ),
                ),
                onTap: () {
                  ref.read(torneoProvider.notifier).setDuracionJuego(
                        '60 min',
                      );
                },
              ),
              GestureDetector(
                child: Container(
                  width: 65,
                  height: 65,
                  decoration: BoxDecoration(
                    color: torneoForm.duracionJuego.value == '40 min'
                        ? Colors.lightBlue
                        : Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.timer, size: 25),
                      Text('40 min', style: TextStyle(fontSize: 12)),
                    ],
                  ),
                ),
                onTap: () {
                  ref.read(torneoProvider.notifier).setDuracionJuego(
                        '40 min',
                      );
                },
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
            ElevatedButton(
              onPressed: () {
                ref.read(torneoProvider.notifier).onFormatoChange(
                      torneoForm.formatoJuego.value,
                      torneoForm.duracionJuego.value,
                    );
                Navigator.pop(context);
              },
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Text('Aplicar', style: TextStyle(fontSize: 15)),
              ),
            ),
          ]),
        ],
      ),
    );
  }
}

class _ModalEquiposOptions extends ConsumerWidget {
  const _ModalEquiposOptions();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final equipoState = ref.watch(equipoProvider);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      height: 470,
      decoration: const BoxDecoration(
        color: Color.fromRGBO(0, 0, 100, 1),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 15),
            const Text(
              'Registrar Equipo',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                labelText: 'Nombre del Equipo',
                prefixIcon: Icon(Icons.sports_soccer),
              ),
              onChanged: ref.read(equipoProvider.notifier).onNombreEquipoChange,
            ),
            const SizedBox(height: 10),
            const Text(
              'Agregar Jugadores',
              textAlign: TextAlign.left,
              style: TextStyle(fontSize: 15, color: Colors.white),
            ),
            Row(
              children: [
                Flexible(
                  flex: 3,
                  child: TextField(
                      controller: TextEditingController(
                          text: equipoState.nombreJugador.value)
                        ..selection = TextSelection.fromPosition(
                          TextPosition(
                              offset: equipoState.nombreJugador.value.length),
                        ),
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        labelText: 'Nombre del Jugador',
                        prefixIcon: Icon(Icons.sports_soccer),
                      ),
                      onChanged: ref
                          .read(equipoProvider.notifier)
                          .onNombreJugadorChange),
                ),
                const SizedBox(width: 10),
                Flexible(
                  flex: 2,
                  child: TextField(
                    controller: TextEditingController(
                        text: equipoState.numeroJugador.value)
                      ..selection = TextSelection.fromPosition(
                        TextPosition(
                            offset: equipoState.numeroJugador.value.length),
                      ),
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(
                      labelText: 'Número',
                      prefixIcon: Icon(Icons.sports_soccer),
                    ),
                    keyboardType: TextInputType.number,
                    onChanged:
                        ref.read(equipoProvider.notifier).onNumeroJugadorChange,
                  ),
                ),
                const SizedBox(width: 10),
                Flexible(
                  flex: 1,
                  child: IconButton(
                    onPressed: () {
                      ref.read(equipoProvider.notifier).agregarJugador();
                    },
                    icon: const Icon(Icons.add, color: Colors.white),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 160,
              child: ListView.builder(
                itemCount: equipoState.jugadores.length,
                itemBuilder: (context, index) {
                  final jugador = equipoState.jugadores[index];
                  return ListTile(
                    title: Text(
                      '${jugador.nombre} - #${jugador.numero}',
                      style: const TextStyle(color: Colors.white),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => ref
                          .read(equipoProvider.notifier)
                          .eliminarJugador(jugador),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: equipoState.isSubmitting
                  ? null
                  : () async {
                      try {
                        await ref
                            .read(equipoProvider.notifier)
                            .registrarEquipo();
                        Navigator.pop(context);
                      } catch (e) {
                        // Muestra un error si algo falla
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(e.toString())),
                        );
                      }
                    },
              child: equipoState.isSubmitting
                  ? const CircularProgressIndicator()
                  : const Text('Agregar Equipo'),
            ),
          ],
        ),
      ),
    );
  }
}
