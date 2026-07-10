import 'package:flutter/material.dart';
import 'package:medicare_app/core/app_theme.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart'; // 🔥 Importación necesaria

// 🔵 IMPORTS DE PANTALLAS
import 'package:medicare_app/modules/auth/screens/start_screen.dart';
import 'package:medicare_app/modules/auth/screens/about/about_screen.dart';
import 'package:medicare_app/modules/treatments/screens/treatment_form_screen.dart';
import 'package:medicare_app/modules/home/main_nav_screen.dart';
import 'package:medicare_app/modules/tips/settings/settings_screen.dart';
import 'package:medicare_app/services/notification_service.dart';

// 🔥 ESTA FUNCIÓN TIENE QUE SER GLOBAL (Afuera de cualquier clase)
// El sistema operativo Android la llamará de forma independiente cuando suene el reloj
@pragma('vm:entry-point')
void alarmCallback() async {
  WidgetsFlutterBinding.ensureInitialized();

  debugPrint("¡ALERTA CRÍTICA!: El reloj del sistema operativo despertó a MediCare");

  // Inicializa el servicio de notificaciones en este hilo aislado
  await NotificationService.instance.init();

  // Lanza la alerta en la pantalla de inmediato
  await NotificationService.instance.showImmediateNotification(
    id: 999,
    title: 'Hora de tu medicamento 💊',
    body: 'Es momento de tomar la dosis programada para tu tratamiento.',
  );
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Inicializa el motor del AlarmManager nativo
    await AndroidAlarmManager.initialize();

    await NotificationService.instance.init();

    // Solo pedimos aquí el permiso normal de notificaciones
    await NotificationService.instance.requestNotificationsPermission();
  } catch (e) {
    debugPrint("Error iniciando servicios básicos: $e");
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