import 'package:flutter/material.dart';
import 'package:medicare_app/core/app_theme.dart';
import 'package:medicare_app/core/database/app_database.dart';

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
    await NotificationService.instance.requestPermissions();
  } catch (e) {
    debugPrint("Error iniciando notificaciones: $e");
  }

  try {
    final treatments = await AppDatabase.instance.getTreatments();

    for (final t in treatments) {
      try {
        await NotificationService.instance.scheduleRemindersForTreatment(
          treatmentId: t['id'] as int,
          medicationName: t['name'] as String,
          dosis: t['dosis'] as String,
          horaInicio: t['hora'] as String,
          frecuencia: t['frecuencia'] as String,
        );
      } catch (e) {
        debugPrint("Error reprogramando alarma: $e");
      }
    }
  } catch (e) {
    debugPrint("Error leyendo tratamientos guardados: $e");
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