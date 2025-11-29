import 'package:flutter/material.dart';

class AppTheme {
  // 🎨 Colores oficiales de MediCare
  static const Color primaryBlue = Color(0xFF1F4A8E);
  static const Color lightBlueTop = Color(0xFFE7F6FF);    // celeste suave
  static const Color lightBlueBottom = Color(0xFF89C7F7); // azul degradado

  // 🌈 Fondo degradado oficial
  static const LinearGradient mainGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      lightBlueTop,
      lightBlueBottom,
    ],
  );

  // 🔤 Estilos de texto
  static const TextStyle title = TextStyle(
    color: primaryBlue,
    fontSize: 28,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle subtitle = TextStyle(
    color: Colors.black87,
    fontSize: 16,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle buttonText = TextStyle(
    color: Colors.white,
    fontSize: 18,
    fontWeight: FontWeight.w600,
  );

  // 🎛 Tema general de la app
  static ThemeData themeData = ThemeData(
    useMaterial3: true,
    fontFamily: "Roboto",
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryBlue,
      brightness: Brightness.light,
    ),
    scaffoldBackgroundColor: Colors.white,
  );
}
