import 'package:flutter/material.dart';
import 'package:medicare_app/core/app_theme.dart';

class AlarmHomeScreen extends StatefulWidget {
  const AlarmHomeScreen({super.key});

  @override
  State<AlarmHomeScreen> createState() => _AlarmHomeScreenState();
}

class _AlarmHomeScreenState extends State<AlarmHomeScreen> {
  bool taken = false;

  final String alarmTime = '9:00 AM';
  final String medication = 'Amoxicilina';
  final String dosage = '1 tableta';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: AppTheme.primaryBlue,
        foregroundColor: Colors.white,
        centerTitle: true,
        title: const Text(
          "Mi Alarma",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _alarmCard(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _alarmCard() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            alarmTime,
            style: const TextStyle(
              fontSize: 64,
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            medication,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            dosage,
            style: const TextStyle(
              fontSize: 22,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 32),

          if (!taken)
            SizedBox(
              width: double.infinity,
              height: 72,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                onPressed: () {
                  setState(() => taken = true);
                },
                child: const Text(
                  "YA LA TOMÉ",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

          if (taken) ...[
            const SizedBox(height: 16),
            const Icon(Icons.check_circle,
                size: 60, color: Colors.green),
            const SizedBox(height: 12),
            const Text(
              "Medicamento tomado",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
          ]
        ],
      ),
    );
  }
}
