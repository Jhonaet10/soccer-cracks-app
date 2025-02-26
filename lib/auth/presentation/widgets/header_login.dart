import 'package:app_project/auth/presentation/helpers/login_painter.dart';
import 'package:flutter/material.dart';

class HeaderLogin extends StatelessWidget {
  final int height;
  final int logoHeight;
  const HeaderLogin({
    required this.logoHeight,
    required this.height,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height.toDouble(),
      child: SizedBox(
        height: double.infinity,
        width: double.infinity,
        child: CustomPaint(
          painter: HeaderLoginPainter(),
          child: Center(
            child: Column(
              children: [
                SizedBox(height: logoHeight.toDouble()),
                Image.asset(
                  
                  'assets/logo.jpg',
                  width: 140,
                ),
                const Text(
                  'Bienvenido de Nuevo',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 35,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
