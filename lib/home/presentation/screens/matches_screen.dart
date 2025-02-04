import 'package:flutter/material.dart';

class MatchesScreen extends StatelessWidget {
  const MatchesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      child: ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              title: Text('Partido $index'),
              subtitle: const Text('Fecha: 2022-01-01'),
              trailing: const Icon(Icons.arrow_forward_ios),
            ),
          );
        },
      ),
    );
  }
}
