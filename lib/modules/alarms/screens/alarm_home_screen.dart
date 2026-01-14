import 'package:flutter/material.dart';

class AlarmHomeScreen extends StatefulWidget {
  const AlarmHomeScreen({super.key});

  @override
  State<AlarmHomeScreen> createState() => _AlarmHomeScreenState();
}

class _AlarmHomeScreenState extends State<AlarmHomeScreen>
    with TickerProviderStateMixin {
  bool taken = false;
  bool isProcessing = false;

  late AnimationController _scaleController;
  late AnimationController _pulseController;
  late AnimationController _fadeController;

  late Animation<double> _scaleAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  final String alarmTime = '9:00 AM';
  final String medication = 'Amoxicilina';
  final String dosage = '1 tableta';

  @override
  void initState() {
    super.initState();

    // Scale para confirmación
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 700),
      vsync: this,
    );
    _scaleAnimation = CurvedAnimation(
      parent: _scaleController,
      curve: Curves.elasticOut,
    );

    // Pulse para el ícono de medicamento.
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    // Fade in inicial
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOutCubic,
    ));

    _fadeController.forward();
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _pulseController.dispose();
    _fadeController.dispose();
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
            letterSpacing: 0.3,
          ),
        ),
      ),
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: Column(
              children: [
                _header(),
                Expanded(
                  child: Center(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 20,
                      ),
                      child: _alarmCard(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _header() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFFFFF3E0).withOpacity(0.8),
            Colors.white,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(
                Icons.schedule_rounded,
                color: Color(0xFFF57C00),
                size: 28,
              ),
              SizedBox(width: 10),
              Text(
                "Es hora de cuidarte",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFFF57C00),
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            "No olvides tu medicamento",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: const Color(0xFFF57C00).withOpacity(0.7),
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _alarmCard() {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(maxWidth: 360),
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(
          color: const Color(0xFFFFA726),
          width: 3,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFFA726).withOpacity(0.25),
            blurRadius: 30,
            offset: const Offset(0, 10),
            spreadRadius: 0,
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ÍCONO CON ANIMACIÓN PARA QUE SE VEA MEJOR
          ScaleTransition(
            scale: _pulseAnimation,
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: [Color(0xFFFFA726), Color(0xFFF57C00)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFFFA726).withOpacity(0.4),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: const Icon(
                Icons.medication_rounded,
                size: 50,
                color: Colors.white,
              ),
            ),
          ),

          const SizedBox(height: 28),

          // HORA
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF3E0),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              alarmTime,
              style: const TextStyle(
                fontSize: 56,
                fontWeight: FontWeight.w900,
                color: Color(0xFFF57C00),
                height: 1,
                letterSpacing: 1,
              ),
            ),
          ),

          const SizedBox(height: 24),

          // MEDICAMENTO
          Text(
            medication,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w900,
              color: Color(0xFF1E3A5F),
              letterSpacing: 0.5,
            ),
          ),

          const SizedBox(height: 16),

          // DOSIS
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFFF5F7FA),
                  const Color(0xFFE8ECF1),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: const Color(0xFF1E3A5F),
                width: 2.5,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(
                  Icons.medical_services_rounded,
                  color: Color(0xFF1E3A5F),
                  size: 22,
                ),
                SizedBox(width: 10),
                Text(
                  '1 tableta',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF1E3A5F),
                    letterSpacing: 0.3,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          taken ? _confirmation() : _actionButtons(),
        ],
      ),
    );
  }

  Widget _actionButtons() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 64,
          child: Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF66BB6A), Color(0xFF4CAF50)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF66BB6A).withOpacity(0.4),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(20),
              child: InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: isProcessing ? null : _markAsTaken,
                splashColor: Colors.white.withOpacity(0.2),
                highlightColor: Colors.white.withOpacity(0.1),
                child: Center(
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
                      Icon(
                        Icons.check_circle_rounded,
                        color: Colors.white,
                        size: 28,
                      ),
                      SizedBox(width: 12),
                      Text(
                        "YA LA TOMÉ",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
        TextButton.icon(
          onPressed: isProcessing ? null : () {},
          icon: const Icon(
            Icons.alarm_off_rounded,
            color: Color(0xFF64748B),
            size: 22,
          ),
          label: const Text(
            "Posponer 10 minutos",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Color(0xFF64748B),
              letterSpacing: 0.2,
            ),
          ),
        ),
      ],
    );
  }

  Widget _confirmation() {
    return ScaleTransition(
      scale: _scaleAnimation,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: const Color(0xFFE8F5E9),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: const Color(0xFF66BB6A),
            width: 2,
          ),
        ),
        child: Column(
          children: const [
            Icon(
              Icons.check_circle_rounded,
              size: 80,
              color: Color(0xFF66BB6A),
            ),
            SizedBox(height: 16),
            Text(
              "¡Muy bien hecho!",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w900,
                color: Color(0xFF66BB6A),
                letterSpacing: 0.5,
              ),
            ),
            SizedBox(height: 8),
            Text(
              "Tu salud es lo primero",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF4CAF50),
                letterSpacing: 0.2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _markAsTaken() async {
    setState(() => isProcessing = true);
    await Future.delayed(const Duration(milliseconds: 800));
    if (!mounted) return;

    setState(() {
      taken = true;
      isProcessing = false;
    });

    _pulseController.stop();
    _scaleController.forward();
  }
}