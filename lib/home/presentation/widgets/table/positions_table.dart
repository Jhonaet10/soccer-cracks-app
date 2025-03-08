import 'package:flutter/material.dart';
import 'package:app_project/home/domain/entities/tabla_posicion.dart';

class PositionsTable extends StatelessWidget {
  static const mainColor = Color.fromRGBO(0, 0, 100, 1);
  final List<TablaPosicion> tablaPosiciones;

  const PositionsTable({
    super.key,
    required this.tablaPosiciones,
  });

  List<TablaPosicion> _ordenarTabla(List<TablaPosicion> tabla) {
    return List<TablaPosicion>.from(tabla)
      ..sort((a, b) {
        // Primero ordenar por puntos
        if (a.pts != b.pts) {
          return b.pts.compareTo(a.pts); // Orden descendente
        }
        // Si tienen los mismos puntos, ordenar por diferencia de goles
        return b.dg.compareTo(a.dg); // Orden descendente
      });
  }

  @override
  Widget build(BuildContext context) {
    final tablaOrdenada = _ordenarTabla(tablaPosiciones);

    return Container(
      margin: const EdgeInsets.all(20),
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
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            headingRowHeight: 50,
            dataRowHeight: 60,
            horizontalMargin: 20,
            columnSpacing: 30,
            headingRowColor: MaterialStateProperty.all(mainColor),
            columns: const [
              DataColumn(
                label: Text(
                  'Pos',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              DataColumn(
                label: Text(
                  'Equipo',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              DataColumn(
                label: Text(
                  'PJ',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              DataColumn(
                label: Text(
                  'G',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              DataColumn(
                label: Text(
                  'E',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              DataColumn(
                label: Text(
                  'P',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              DataColumn(
                label: Text(
                  'DG',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              DataColumn(
                label: Text(
                  'Pts',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
            rows: tablaOrdenada.asMap().entries.map((entry) {
              final index = entry.key;
              final equipo = entry.value;
              final isTopThree = index < 3;
              final backgroundColor =
                  index % 2 == 0 ? Colors.grey[50] : Colors.white;

              return DataRow(
                color: MaterialStateProperty.all(backgroundColor),
                cells: [
                  DataCell(
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: isTopThree
                            ? _getPositionColor(index)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Text(
                        (index + 1).toString(),
                        style: TextStyle(
                          color: isTopThree ? Colors.white : Colors.black87,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  DataCell(
                    Row(
                      children: [
                        Container(
                          width: 35,
                          height: 35,
                          decoration: BoxDecoration(
                            color: mainColor.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.shield,
                            color: mainColor,
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          equipo.nombreEquipo!,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  DataCell(Text(equipo.pj.toString())),
                  DataCell(Text(equipo.g.toString())),
                  DataCell(Text(equipo.e.toString())),
                  DataCell(Text(equipo.p.toString())),
                  DataCell(Text(equipo.dg.toString())),
                  DataCell(
                    Text(
                      equipo.pts.toString(),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Color _getPositionColor(int position) {
    switch (position) {
      case 0:
        return Colors.amber[700]!;
      case 1:
        return Colors.grey[700]!;
      case 2:
        return Colors.brown[700]!;
      default:
        return Colors.transparent;
    }
  }
}
