import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData.light().copyWith(
    primaryColor: const Color.fromRGBO(0, 0, 100,
        1), // Color primario basado en el color de HeaderLoginPainter
    primaryColorDark:
        const Color.fromRGBO(0, 0, 80, 1), // Color secundario más oscuro
    primaryColorLight:
        const Color.fromRGBO(0, 0, 120, 1), // Color secundario más claro
    appBarTheme: const AppBarTheme(
      color: Color.fromRGBO(
          0, 0, 100, 1), // Establecer el color de la barra de la app
      elevation: 0, // Para eliminar la sombra en la AppBar
    ),
    scaffoldBackgroundColor: Colors.white, // Fondo de la app
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.black), // Color general del texto
      bodyMedium: TextStyle(color: Colors.black54),
      titleLarge: TextStyle(
          color: Colors.black, fontWeight: FontWeight.bold), // Para los títulos
    ),
    buttonTheme: const ButtonThemeData(
      buttonColor: Color.fromRGBO(0, 0, 100, 1), // Color de los botones
      textTheme: ButtonTextTheme.primary, // Texto del botón en color blanco
    ),
    // Otros temas específicos que quieras personalizar
  );
}
