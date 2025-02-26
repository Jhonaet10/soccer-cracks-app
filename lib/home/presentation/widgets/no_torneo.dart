import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NoTorneoWidget extends StatelessWidget {
  const NoTorneoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20),
        Image.asset('assets/logo.jpg', width: 200),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 30),
          child: Text(
            textAlign: TextAlign.center,
            'Aún no tienes registrado un Torneo',
            style: TextStyle(
              color: Color.fromRGBO(0, 0, 0, 1),
              fontSize: 30,
            ),
          ),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            context.push('/create-championship');
          },
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Text('Crear Torneo', style: TextStyle(fontSize: 20)),
          ),
        ),
      ],
    );
  }
}
