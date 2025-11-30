import 'package:flutter/material.dart';
import 'package:medicare_app/core/app_theme.dart';

// 🔵 IMPORTS CORRECTOS DE CADA MÓDULO
import 'package:medicare_app/modules/treatments/screens/treatment_form_screen.dart';
import 'package:medicare_app/modules/alarms/screens/alarm_home_screen.dart';
import 'package:medicare_app/modules/history/screens/history_screen.dart';

class MainNavScreen extends StatefulWidget {
  const MainNavScreen({super.key});

  @override
  State<MainNavScreen> createState() => _MainNavScreenState();
}

class _MainNavScreenState extends State<MainNavScreen> {
  int index = 0;

  // ❌ No puede ser const porque los widgets no son const
  final screens = [
    TreatmentFormScreen(),
    AlarmHomeScreen(),
    HistoryScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[index],

      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 10,
              offset: const Offset(0, -3),
            )
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: index,
          elevation: 0,
          backgroundColor: Colors.white,
          selectedItemColor: AppTheme.primaryBlue,
          unselectedItemColor: Colors.grey,

          onTap: (i) => setState(() => index = i),

          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.add_circle_outline),
              label: "Tratamientos",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.alarm),
              label: "Alarma",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.history),
              label: "Historial",
            ),
          ],
        ),
      ),
    );
  }
}
