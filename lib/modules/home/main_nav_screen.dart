import 'package:flutter/material.dart';
import 'package:medicare_app/core/app_theme.dart';
import 'package:medicare_app/modules/treatments/screens/treatment_list_screen.dart';


// 🔵 IMPORTS DE CADA MÓDULO
import 'package:medicare_app/modules/treatments/screens/treatment_list_screen.dart';
import 'package:medicare_app/modules/alarms/screens/alarm_home_screen.dart';
import 'package:medicare_app/modules/history/screens/history_screen.dart';

class MainNavScreen extends StatefulWidget {
  final int initialIndex;

  const MainNavScreen({
    super.key,
    this.initialIndex = 0,
  });

  @override
  State<MainNavScreen> createState() => _MainNavScreenState();
}

class _MainNavScreenState extends State<MainNavScreen> {
  late int index;

  final List<Widget> screens = const [
    TreatmentListScreen(),
    AlarmHomeScreen(),
    HistoryScreen(),
  ];

  @override
  void initState() {
    super.initState();
    index = widget.initialIndex;
  }

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
            ),
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
              icon: Icon(Icons.medication),
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
