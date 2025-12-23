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
        foregroundColor: const Color(0xFF1E3A5F),
        centerTitle: true,
        elevation: 0,
        title: const Text(
          "Mi Alarma",
          style: TextStyle(
            fontSize: 26,
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
            // HEADER MÁS GRANDE Y CLARO
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 24),
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
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: taken
                            ? [const Color(0xFF66BB6A), const Color(0xFF4CAF50)]
                            : [const Color(0xFFFFA726), const Color(0xFFF57C00)],
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: (taken ? const Color(0xFF66BB6A) : const Color(0xFFFFA726))
                              .withOpacity(0.4),
                          blurRadius: 16,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Icon(
                      taken ? Icons.check_circle_rounded : Icons.schedule_rounded,
                      size: 44,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    taken ? "¡Excelente trabajo!" : "Es hora de cuidarte",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      color: taken ? const Color(0xFF388E3C) : const Color(0xFFEF6C00),
                      letterSpacing: 0.3,
                    ),
                  ),
                ],
              ),
            ),

            // CARD CENTRAL
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
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
      constraints: const BoxConstraints(maxWidth: 420),
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: taken
              ? const Color(0xFF66BB6A)
              : const Color(0xFFFFA726),
          width: 3,
        ),
        boxShadow: [
          BoxShadow(
            color: (taken ? const Color(0xFF66BB6A) : const Color(0xFFFFA726))
                .withOpacity(0.2),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ÍCONO MEDICAMENTO MÁS GRANDE
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: taken
                    ? [const Color(0xFF66BB6A), const Color(0xFF4CAF50)]
                    : [const Color(0xFFFFA726), const Color(0xFFF57C00)],
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: (taken ? const Color(0xFF66BB6A) : const Color(0xFFFFA726))
                      .withOpacity(0.4),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: const Icon(
              Icons.medication_rounded,
              size: 72,
              color: Colors.white,
            ),
          ),

          const SizedBox(height: 32),

          // ✅ HORA GIGANTE Y MUY VISIBLE
          Text(
            alarmTime,
            style: TextStyle(
              fontSize: 80,
              fontWeight: FontWeight.w900,
              color: taken ? const Color(0xFF66BB6A) : const Color(0xFFFFA726),
              letterSpacing: -2,
              height: 1,
            ),
          ),

          const SizedBox(height: 24),

          // ✅ MEDICAMENTO MÁS GRANDE
          Text(
            medication,
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w900,
              color: Color(0xFF1E3A5F),
              letterSpacing: 0.3,
            ),
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 16),

          // ✅ DOSIS MÁS GRANDE Y CLARA
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F7FA),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: const Color(0xFF1E3A5F),
                width: 2,
              ),
            ),
            child: Text(
              dosage,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: Color(0xFF1E3A5F),
                letterSpacing: 0.2,
              ),
            ),
          ),

          const SizedBox(height: 36),

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
        // ✅ BOTÓN PRINCIPAL MÁS GRANDE
        SizedBox(
          width: double.infinity,
          height: 72,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF66BB6A),
              elevation: 8,
              shadowColor: const Color(0xFF66BB6A).withOpacity(0.5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            onPressed: isProcessing ? null : _markAsTaken,
            child: isProcessing
                ? const SizedBox(
              width: 32,
              height: 32,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 4,
              ),
            )
                : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.check_circle_rounded, size: 40),
                SizedBox(width: 16),
                Text(
                  "YA LA TOMÉ",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 16),

        // ✅ BOTÓN SECUNDARIO MÁS GRANDE
        SizedBox(
          width: double.infinity,
          height: 60,
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFF5B7C99),
              side: const BorderSide(color: Color(0xFF5B7C99), width: 2.5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
            ),
            onPressed: isProcessing ? null : _postponeAlarm,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.access_time_rounded, size: 28),
                SizedBox(width: 12),
                Text(
                  "Recordar después",
                  style: TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.w800,
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
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFE8F5E9), Color(0xFFC8E6C9)],
              ),
              shape: BoxShape.circle,
              border: Border.all(
                color: const Color(0xFF66BB6A),
                width: 4,
              ),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF66BB6A).withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: const Icon(
              Icons.check_circle_rounded,
              size: 80,
              color: Color(0xFF66BB6A),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            "¡Muy bien hecho!",
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w900,
              color: Color(0xFF66BB6A),
              letterSpacing: 0.3,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            "Tu salud es lo primero",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: Color(0xFF4CAF50),
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
            Icon(Icons.check_circle, color: Colors.white, size: 32),
            SizedBox(width: 16),
            Expanded(
              child: Text(
                "¡Excelente! Sigue así",
                style: TextStyle(fontSize: 19, fontWeight: FontWeight.w800),
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF66BB6A),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: const EdgeInsets.all(20),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      ),
    );
  }

  void _postponeAlarm() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        contentPadding: const EdgeInsets.all(32),
        title: const Text(
          "¿Cuánto tiempo?",
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w900,
            color: Color(0xFF1E3A5F),
          ),
          textAlign: TextAlign.center,
        ),
        content: const Text(
          "¿En cuánto tiempo quieres que te recordemos?",
          style: TextStyle(
            fontSize: 20,
            color: Color(0xFF5B7C99),
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
        actionsAlignment: MainAxisAlignment.center,
        actionsPadding: const EdgeInsets.only(bottom: 16, left: 16, right: 16),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            ),
            child: const Text(
              "Cancelar",
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.w700,
                color: Color(0xFF90A4AE),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _postponeFor(10);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFFA726),
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: const Text(
              "10 minutos",
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _postponeFor(30);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFFA726),
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: const Text(
              "30 minutos",
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.w900,
              ),
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
            const Icon(Icons.schedule, color: Colors.white, size: 32),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                "Te recordaremos en $minutes minutos",
                style: const TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFFFFA726),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: const EdgeInsets.all(20),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      ),
    );
  }
}