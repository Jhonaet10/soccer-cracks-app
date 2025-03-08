import 'package:app_project/home/domain/entities/partido_detalle.dart';
import 'package:app_project/home/presentation/providers/registro_resultado_form_provider.dart';
import 'package:app_project/home/presentation/providers/tabla_posicion_provider.dart';
import 'package:app_project/home/presentation/providers/partido_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RegisterResultModal extends ConsumerWidget {
  final PartidoDetalle partido;
  static const mainColor = Color.fromRGBO(0, 0, 100, 1);

  const RegisterResultModal({
    super.key,
    required this.partido,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formState = ref.watch(registroResultadoFormProvider);
    final formNotifier = ref.read(registroResultadoFormProvider.notifier);

    // Escuchar cambios en el estado para mostrar mensajes
    ref.listen<RegistroResultadoFormState>(
      registroResultadoFormProvider,
      (previous, current) async {
        if (current.errorMessage.isNotEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(current.errorMessage),
              backgroundColor: Colors.red,
            ),
          );
          formNotifier.clearMessages();
        }

        if (current.successMessage.isNotEmpty) {
          // Recargar los datos antes de cerrar el modal
          await ref
              .read(partidosProvider.notifier)
              .cargarPartidos(partido.torneoId);

          if (context.mounted) {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(current.successMessage),
                backgroundColor: Colors.green,
              ),
            );
          }
          formNotifier.clearMessages();
        }
      },
    );

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Barra de arrastre
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),

            // Título
            const Text(
              'Registrar Resultado',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: mainColor,
              ),
            ),
            const SizedBox(height: 16),

            // Formulario
            Column(
              children: [
                // Equipos y marcador
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Equipo Local
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.35,
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: mainColor.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.shield,
                              color: mainColor,
                              size: 20,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            partido.equipo1Nombre,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 8),
                          SizedBox(
                            width: 45,
                            child: TextFormField(
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 14),
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(2),
                              ],
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.grey[100],
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide.none,
                                ),
                                contentPadding:
                                    const EdgeInsets.symmetric(vertical: 8),
                              ),
                              onChanged: formNotifier.updateGolesEquipo1,
                            ),
                          ),
                          const SizedBox(height: 8),
                          // Tarjetas Equipo 1
                          Wrap(
                            spacing: 2,
                            runSpacing: 0,
                            alignment: WrapAlignment.center,
                            children: [
                              _buildCardCounter(
                                title: 'Amarillas',
                                cardColor: Colors.yellow,
                                count: formState.yellowCardsTeam1,
                                onIncrement:
                                    formNotifier.incrementYellowCardsTeam1,
                                onDecrement:
                                    formNotifier.decrementYellowCardsTeam1,
                              ),
                              _buildCardCounter(
                                title: 'Rojas',
                                cardColor: Colors.red,
                                count: formState.redCardsTeam1,
                                onIncrement:
                                    formNotifier.incrementRedCardsTeam1,
                                onDecrement:
                                    formNotifier.decrementRedCardsTeam1,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // VS
                    Text(
                      'VS',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[600],
                      ),
                    ),

                    // Equipo Visitante
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.35,
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: mainColor.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.shield,
                              color: mainColor,
                              size: 20,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            partido.equipo2Nombre,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 8),
                          SizedBox(
                            width: 45,
                            child: TextFormField(
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 14),
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(2),
                              ],
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.grey[100],
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide.none,
                                ),
                                contentPadding:
                                    const EdgeInsets.symmetric(vertical: 8),
                              ),
                              onChanged: formNotifier.updateGolesEquipo2,
                            ),
                          ),
                          const SizedBox(height: 8),
                          // Tarjetas Equipo 2
                          Wrap(
                            spacing: 2,
                            runSpacing: 0,
                            alignment: WrapAlignment.center,
                            children: [
                              _buildCardCounter(
                                title: 'Amarillas',
                                cardColor: Colors.yellow,
                                count: formState.yellowCardsTeam2,
                                onIncrement:
                                    formNotifier.incrementYellowCardsTeam2,
                                onDecrement:
                                    formNotifier.decrementYellowCardsTeam2,
                              ),
                              _buildCardCounter(
                                title: 'Rojas',
                                cardColor: Colors.red,
                                count: formState.redCardsTeam2,
                                onIncrement:
                                    formNotifier.incrementRedCardsTeam2,
                                onDecrement:
                                    formNotifier.decrementRedCardsTeam2,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Campo de incidencias
                TextFormField(
                  maxLines: 2,
                  style: const TextStyle(fontSize: 13),
                  decoration: InputDecoration(
                    labelText: 'Observaciones',
                    labelStyle: TextStyle(fontSize: 13),
                    hintText:
                        'Ingrese cualquier incidencia o comentario relevante',
                    hintStyle: TextStyle(fontSize: 12),
                    filled: true,
                    fillColor: Colors.grey[100],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.all(12),
                  ),
                  onChanged: formNotifier.updateObservaciones,
                ),

                const SizedBox(height: 16),

                // Fecha del partido
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.calendar_today,
                          size: 14, color: Colors.grey[600]),
                      const SizedBox(width: 6),
                      Text(
                        '${partido.fecha.day}/${partido.fecha.month}/${partido.fecha.year}',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Botón de guardar
                SizedBox(
                  width: double.infinity,
                  height: 45,
                  child: ElevatedButton(
                    onPressed: formState.isLoading
                        ? null
                        : () async {
                            final success =
                                await formNotifier.submitResultado(partido);
                            if (success) {
                              // Actualizar la tabla de posiciones
                              if (context.mounted) {
                                await ref
                                    .read(tablaPosicionesProvider.notifier)
                                    .actualizarPosiciones(
                                      partido.torneoId,
                                      formState.golesEquipo1 >
                                              formState.golesEquipo2
                                          ? partido.equipo1
                                          : partido.equipo2,
                                      formState.golesEquipo1 <
                                              formState.golesEquipo2
                                          ? partido.equipo1
                                          : partido.equipo2,
                                      formState.golesEquipo1,
                                      formState.golesEquipo2,
                                    );
                              }
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: mainColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: formState.isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text(
                            'Guardar Resultado',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardCounter({
    required String title,
    required Color cardColor,
    required int count,
    required Function() onIncrement,
    required Function() onDecrement,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(title, style: const TextStyle(fontSize: 10)),
        SizedBox(
          height: 28,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: onDecrement,
                child: Icon(
                  Icons.remove_circle_outline,
                  size: 16,
                  color: count > 0 ? Colors.grey[600] : Colors.grey[400],
                ),
              ),
              Container(
                width: 18,
                margin: const EdgeInsets.symmetric(horizontal: 1),
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Center(
                  child: Text(
                    count.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: onIncrement,
                child: Icon(
                  Icons.add_circle_outline,
                  size: 16,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
