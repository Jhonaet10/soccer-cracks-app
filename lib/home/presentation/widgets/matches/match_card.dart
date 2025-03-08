import 'package:flutter/material.dart';
import 'package:app_project/home/domain/entities/partido_detalle.dart';
import 'package:app_project/home/presentation/widgets/matches/register_result_modal.dart';
import 'package:intl/intl.dart';

class MatchCard extends StatelessWidget {
  static const mainColor = Color.fromRGBO(0, 0, 100, 1);
  final PartidoDetalle partido;
  final bool canEditResults;

  const MatchCard({
    super.key,
    required this.partido,
    this.canEditResults = true,
  });

  void _showRegisterResultModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: RegisterResultModal(partido: partido),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isFinished = partido.estado == 'Finalizado';
    final List<String>? scores =
        isFinished ? partido.resultado?.split('-') : null;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          // Estado del partido
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: isFinished ? Colors.green.shade50 : Colors.orange.shade50,
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(15)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  isFinished ? Icons.check_circle : Icons.schedule,
                  size: 14,
                  color: isFinished
                      ? Colors.green.shade700
                      : Colors.orange.shade700,
                ),
                const SizedBox(width: 4),
                Text(
                  partido.estado,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: isFinished
                        ? Colors.green.shade700
                        : Colors.orange.shade700,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              children: [
                // Equipos y resultado
                Row(
                  children: [
                    // Equipo 1
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 40,
                            height: 40,
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
                          const SizedBox(width: 10),
                          Flexible(
                            child: Text(
                              partido.equipo1Nombre,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Resultado
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        color: isFinished ? mainColor : Colors.grey[100],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: isFinished
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  scores![0],
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                                const Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 8),
                                  child: Text(
                                    '-',
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                                Text(
                                  scores[1],
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                              ],
                            )
                          : const Text(
                              'VS',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.black54,
                              ),
                            ),
                    ),
                    // Equipo 2
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 40,
                            height: 40,
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
                          const SizedBox(width: 10),
                          Flexible(
                            child: Text(
                              partido.equipo2Nombre,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                // Fecha y botón de registro
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.calendar_today,
                          size: 16,
                          color: Colors.grey,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          DateFormat('dd/MM/yyyy').format(partido.fecha),
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    if (canEditResults && !isFinished)
                      TextButton.icon(
                        onPressed: () => _showRegisterResultModal(context),
                        icon: const Icon(Icons.edit, size: 16),
                        label: const Text('Registrar Resultado'),
                        style: TextButton.styleFrom(
                          foregroundColor: mainColor,
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: const BorderSide(color: mainColor),
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
