import 'package:flutter/material.dart';
import 'package:medicare_app/core/app_theme.dart';

class AlarmHomeScreen extends StatefulWidget {
  const AlarmHomeScreen({super.key});

  @override
  State<AlarmHomeScreen> createState() => _AlarmHomeScreenState();
}

class _AlarmHomeScreenState extends State<AlarmHomeScreen> with SingleTickerProviderStateMixin {
  bool taken = false;
  bool isProcessing = false;
  late AnimationController _animController;
  late Animation<double> _scaleAnimation;

  final String alarmTime = '9:00 AM';
  final String medication = 'Amoxicilina';
  final String dosage = '1 tableta';

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _scaleAnimation = CurvedAnimation(
      parent: _animController,
      curve: Curves.elasticOut,
    );
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF5B7C99),
        centerTitle: true,
        elevation: 0,
        title: const Text(
          "Mi Alarma",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.3,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            color: const Color(0xFFE8EEF2),
            height: 1,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // HEADER CÁLIDO
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: taken
                      ? [const Color(0xFFE8F5E9), Colors.white]
                      : [const Color(0xFFFFF3E0), Colors.white],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: taken
                            ? [const Color(0xFF81C784), const Color(0xFF66BB6A)]
                            : [const Color(0xFFFFB74D), const Color(0xFFFFA726)],
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: (taken ? const Color(0xFF81C784) : const Color(0xFFFFB74D))
                              .withOpacity(0.4),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Icon(
                      taken ? Icons.check_circle_rounded : Icons.schedule_rounded,
                      size: 28,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    taken ? "¡Excelente trabajo!" : "Es hora de cuidarte",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: taken ? const Color(0xFF388E3C) : const Color(0xFFEF6C00),
                      letterSpacing: 0.2,
                    ),
                  ),
                ],
              ),
            ),

            // CARD CENTRAL
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  child: _alarmCard(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _alarmCard() {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(maxWidth: 400),
      padding: const EdgeInsets.all(26),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: taken
              ? const Color(0xFFC8E6C9)
              : const Color(0xFFFFE0B2),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: (taken ? const Color(0xFF81C784) : const Color(0xFFFFB74D))
                .withOpacity(0.15),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ÍCONO MEDICAMENTO
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: taken
                    ? [const Color(0xFF81C784), const Color(0xFF66BB6A)]
                    : [const Color(0xFFFFB74D), const Color(0xFFFFA726)],
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: (taken ? const Color(0xFF81C784) : const Color(0xFFFFB74D))
                      .withOpacity(0.4),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: const Icon(
              Icons.medication_rounded,
              size: 52,
              color: Colors.white,
            ),
          ),

          const SizedBox(height: 24),

          // HORA GRANDE
          Text(
            alarmTime,
            style: TextStyle(
              fontSize: 64,
              fontWeight: FontWeight.bold,
              color: taken ? const Color(0xFF66BB6A) : const Color(0xFFFFA726),
              letterSpacing: -2,
              height: 1,
            ),
          ),

          const SizedBox(height: 18),

          // MEDICAMENTO
          Text(
            medication,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Color(0xFF5B7C99),
              letterSpacing: 0.2,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 12),

          // DOSIS
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 11),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F7FA),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: const Color(0xFFE0E7ED),
                width: 1.5,
              ),
            ),
            child: Text(
              dosage,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Color(0xFF5B7C99),
              ),
            ),
          ),

          const SizedBox(height: 28),

          // BOTÓN O CONFIRMACIÓN
          if (!taken)
            _buildActionButton()
          else
            _buildConfirmation(),
        ],
      ),
    );
  }

  Widget _buildActionButton() {
    return Column(
      children: [
        // BOTÓN PRINCIPAL
        SizedBox(
          width: double.infinity,
          height: 64,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF66BB6A),
              elevation: 4,
              shadowColor: const Color(0xFF81C784).withOpacity(0.5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
            ),
            onPressed: isProcessing ? null : _markAsTaken,
            child: isProcessing
                ? const SizedBox(
              width: 28,
              height: 28,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 3,
              ),
            )
                : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.check_circle_rounded, size: 32),
                SizedBox(width: 14),
                Text(
                  "YA LA TOMÉ",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 12),

        // BOTÓN SECUNDARIO
        SizedBox(
          width: double.infinity,
          height: 52,
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFF7A8E9E),
              side: const BorderSide(color: Color(0xFFE0E7ED), width: 2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            onPressed: isProcessing ? null : _postponeAlarm,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.access_time_rounded, size: 24),
                SizedBox(width: 10),
                Text(
                  "Recordar después",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildConfirmation() {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFE8F5E9), Color(0xFFC8E6C9)],
              ),
              shape: BoxShape.circle,
              border: Border.all(
                color: const Color(0xFF81C784),
                width: 3,
              ),
            ),
            child: const Icon(
              Icons.check_circle_rounded,
              size: 64,
              color: Color(0xFF66BB6A),
            ),
          ),
          const SizedBox(height: 18),
          const Text(
            "¡Muy bien hecho!",
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Color(0xFF66BB6A),
              letterSpacing: 0.2,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "Tu salud es lo primero",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF81C784),
            ),
          ),
        ],
      ),
    );
  }

  void _markAsTaken() async {
    setState(() => isProcessing = true);

    await Future.delayed(const Duration(milliseconds: 800));

    if (!mounted) return;

    setState(() {
      isProcessing = false;
      taken = true;
    });

    _animController.forward();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: const [
            Icon(Icons.check_circle, color: Colors.white, size: 26),
            SizedBox(width: 14),
            Expanded(
              child: Text(
                "¡Excelente! Sigue así",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF66BB6A),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  void _postponeAlarm() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          "¿Cuánto tiempo?",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        content: const Text(
          "¿En cuánto tiempo quieres que te recordemos?",
          style: TextStyle(fontSize: 17),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancelar", style: TextStyle(fontSize: 17)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _postponeFor(10);
            },
            child: const Text(
              "10 minutos",
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _postponeFor(30);
            },
            child: const Text(
              "30 minutos",
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  void _postponeFor(int minutes) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.schedule, color: Colors.white, size: 26),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                "Te recordaremos en $minutes minutos",
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFFFFA726),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }
}