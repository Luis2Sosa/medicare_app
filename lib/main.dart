import 'package:flutter/material.dart';
import 'package:medicare_app/core/app_theme.dart';

// 🔵 IMPORTS DE PANTALLAS
import 'package:medicare_app/modules/auth/screens/start_screen.dart';
import 'package:medicare_app/modules/auth/screens/about/about_screen.dart';
import 'package:medicare_app/modules/treatments/screens/treatment_form_screen.dart';
import 'package:medicare_app/modules/home/main_nav_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MediCareApp());
}

class MediCareApp extends StatelessWidget {
  const MediCareApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MediCare',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.themeData,

      // 🔵 RUTAS REGISTRADAS
      routes: {
        "/about": (context) => const AboutScreen(),
        "/treatment_form": (context) => const TreatmentFormScreen(),
        "/home_nav": (context) => const MainNavScreen(),    // ← AGREGADA
      },

      // 🔵 PANTALLA INICIAL
      home: const StartScreen(),
    );
  }
}


