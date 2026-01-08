import 'package:flutter/material.dart';

class AlarmHomeScreen extends StatefulWidget {
  const AlarmHomeScreen({super.key});

  @override
  State<AlarmHomeScreen> createState() => _AlarmHomeScreenState();
}

class _AlarmHomeScreenState extends State<AlarmHomeScreen>
    with SingleTickerProviderStateMixin {
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
        centerTitle: true,
        elevation: 0,
        title: const Text(
          "Mi Alarma",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            color: Color(0xFF1E3A5F),
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            _header(),
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  child: _alarmCard(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ───────────────── HEADER ─────────────────
  Widget _header() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFFFF3E0), Colors.white],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.schedule_rounded, color: Color(0xFFF57C00)),
          SizedBox(width: 8),
          Text(
            "Es hora de cuidarte",
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w800,
              color: Color(0xFFF57C00),
            ),
          ),
        ],
      ),
    );
  }

  // ───────────────── CARD CENTRAL ALARMA ─────────────────
  Widget _alarmCard() {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(maxWidth: 320), // 👈 MÁS PEQUEÑA
      padding: const EdgeInsets.all(18), // 👈 MENOS PADDING
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: const Color(0xFFFFA726), width: 3),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFFA726).withOpacity(0.2),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ÍCONO
          Container(
            padding: const EdgeInsets.all(18),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [Color(0xFFFFA726), Color(0xFFF57C00)],
              ),
            ),
            child: const Icon(
              Icons.medication_rounded,
              size: 56,
              color: Colors.white,
            ),
          ),

          const SizedBox(height: 20),

          // HORA
          Text(
            alarmTime,
            style: const TextStyle(
              fontSize: 64, // 👈 REDUCIDA
              fontWeight: FontWeight.w900,
              color: Color(0xFFFFA726),
              height: 1,
            ),
          ),

          const SizedBox(height: 16),

          // MEDICAMENTO
          Text(
            medication,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 26, // 👈 REDUCIDA
              fontWeight: FontWeight.w900,
              color: Color(0xFF1E3A5F),
            ),
          ),

          const SizedBox(height: 12),

          // DOSIS
          Container(
            padding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 10), // 👈
            decoration: BoxDecoration(
              color: const Color(0xFFF5F7FA),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFF1E3A5F), width: 2),
            ),
            child: const Text(
              '1 tableta',
              style: TextStyle(
                fontSize: 20, // 👈 REDUCIDA
                fontWeight: FontWeight.w800,
                color: Color(0xFF1E3A5F),
              ),
            ),
          ),

          const SizedBox(height: 24),

          taken ? _confirmation() : _actionButtons(),
        ],
      ),
    );
  }

  // ───────────────── BOTONES ─────────────────
  Widget _actionButtons() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 60,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF66BB6A),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
            ),
            onPressed: isProcessing ? null : _markAsTaken,
            child: const Text(
              "YA LA TOMÉ",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ───────────────── CONFIRMACIÓN ─────────────────
  Widget _confirmation() {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: Column(
        children: const [
          Icon(Icons.check_circle_rounded,
              size: 80, color: Color(0xFF66BB6A)),
          SizedBox(height: 12),
          Text(
            "¡Muy bien hecho!",
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w900,
              color: Color(0xFF66BB6A),
            ),
          ),
        ],
      ),
    );
  }

  // ───────────────── LÓGICA ─────────────────
  void _markAsTaken() async {
    setState(() => isProcessing = true);
    await Future.delayed(const Duration(milliseconds: 600));
    if (!mounted) return;

    setState(() {
      taken = true;
      isProcessing = false;
    });

    _animController.forward();
  }
}
