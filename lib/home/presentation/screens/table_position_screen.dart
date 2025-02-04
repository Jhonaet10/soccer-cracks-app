import 'package:flutter/material.dart';

class TablePositionsScreen extends StatelessWidget {
  const TablePositionsScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> equipos = [
      {
        'pos': 1,
        'club': 'Atlético Madrid',
        'pj': 18,
        'g': 12,
        'e': 5,
        'p': 1,
        'dg': 21,
        'pts': 41,
      },
      {
        'pos': 2,
        'club': 'Real Madrid',
        'pj': 18,
        'g': 12,
        'e': 4,
        'p': 2,
        'dg': 23,
        'pts': 40,
      },
      {
        'pos': 3,
        'club': 'Barcelona',
        'pj': 18,
        'g': 11,
        'e': 4,
        'p': 3,
        'dg': 20,
        'pts': 37,
      },
      {
        'pos': 4,
        'club': 'Sevilla',
        'pj': 18,
        'g': 11,
        'e': 3,
        'p': 4,
        'gf': 26,
        'gc': 16,
        'dg': 10,
        'pts': 36,
      },
      {
        'pos': 5,
        'club': 'Real Sociedad',
        'pj': 18,
        'g': 8,
        'e': 8,
        'p': 2,
        'dg': 16,
        'pts': 32,
      },
      {
        'pos': 6,
        'club': 'Villarreal',
        'pj': 18,
        'g': 6,
        'e': 13,
        'p': 2,
        'dg': 9,
        'pts': 31,
      },
      {
        'pos': 7,
        'club': 'Real Betis',
        'pj': 18,
        'g': 9,
        'e': 3,
        'p': 6,
        'dg': 0,
        'pts': 30,
      },
      {
        'pos': 8,
        'club': 'Cádiz',
        'pj': 18,
        'g': 7,
        'e': 5,
        'p': 6,
        'dg': -5,
        'pts': 26,
      }
      // Agrega más equipos aquí...
    ];

    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 20),
          const Text(
            textAlign: TextAlign.start,
            'Tabla de Posiciones',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(20),
            ),
            child: DataTable(
              dataRowColor: WidgetStateProperty.resolveWith((states) =>
                  states.contains(WidgetState.selected)
                      ? Colors.blue.withOpacity(0.1)
                      : Colors.transparent),
              headingRowColor:
                  WidgetStateProperty.all(const Color.fromRGBO(0, 0, 100, 1)),
              headingTextStyle: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              columnSpacing: 14,
              dividerThickness: 1,
              columns: const [
                DataColumn(label: Text('#')),
                DataColumn(label: Text('Club')),
                DataColumn(label: Text('PJ')),
                DataColumn(label: Text('G')),
                DataColumn(label: Text('E')),
                DataColumn(label: Text('P')),
                DataColumn(label: Text('DG')),
                DataColumn(label: Text('Pts')),
              ],
              rows: equipos.map((equipo) {
                return DataRow(
                  color: WidgetStateProperty.resolveWith((states) =>
                      equipos.indexOf(equipo) % 2 == 0
                          ? Colors.grey[100]
                          : Colors.white),
                  cells: [
                    DataCell(Text(equipo['pos'].toString())),
                    DataCell(Text(
                      equipo['club'],
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    )),
                    DataCell(Text(equipo['pj'].toString())),
                    DataCell(Text(equipo['g'].toString())),
                    DataCell(Text(equipo['e'].toString())),
                    DataCell(Text(equipo['p'].toString())),
                    DataCell(Text(equipo['dg'].toString())),
                    DataCell(Text(
                      equipo['pts'].toString(),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    )),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
