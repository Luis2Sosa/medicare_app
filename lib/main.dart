import 'package:flutter/material.dart';
import 'package:medicare_app/core/app_theme.dart';
import 'package:medicare_app/modules/auth/screens/start_screen.dart';

import 'modules/auth/screens/about/about_screen.dart'; // ← IMPORTANTE

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

      // 🔵 ESTA ERA LA PIEZA QUE FALTABA
      routes: {
        "/about": (context) => const AboutScreen(),
      },

      home: const StartScreen(),
    );
  }
}
