import 'package:flutter/material.dart';
import 'package:medicare_app/core/app_theme.dart';

// 🔵 IMPORTS DE PANTALLAS
import 'package:medicare_app/modules/auth/screens/start_screen.dart';
import 'package:medicare_app/modules/auth/screens/about/about_screen.dart';
import 'package:medicare_app/modules/treatments/screens/treatment_form_screen.dart';
import 'package:medicare_app/modules/home/main_nav_screen.dart';
import 'package:medicare_app/modules/tips/settings/settings_screen.dart';
import 'package:medicare_app/services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await NotificationService.instance.init();
    // Solo pedimos aquí el permiso normal de notificaciones (el diálogo
    // estándar de Android). El permiso puntual (que necesita mostrar un
    // diálogo explicativo con context) se pide más adelante, en
    // start_screen.dart, cuando ya hay una pantalla construida.
    await NotificationService.instance.requestNotificationsPermission();
  } catch (e) {
    debugPrint("Error iniciando notificaciones: $e");
  }

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
      routes: {
        "/about": (context) => const AboutScreen(),
        "/treatment_form": (context) => const TreatmentFormScreen(),
        "/home": (context) => const MainNavScreen(initialIndex: 0),
        "/settings": (context) => const SettingsScreen(),
      },
      home: const StartScreen(),
    );
  }
}