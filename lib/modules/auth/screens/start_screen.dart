import 'package:flutter/material.dart';
import 'package:medicare_app/core/app_theme.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({super.key});

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  // Tonos derivados del azul de marca, solo para profundidad
  // (gradiente del botón principal y sombra de color).
  static const Color _deepBlue = Color(0xFF123C66);
  static const Color _textBlue = Color(0xFF1E3A5F);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1400),
      vsync: this,
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // --- Helpers de animación escalonada ---------------------------------

  Animation<double> _fadeFor(double start, double end) {
    return CurvedAnimation(
      parent: _controller,
      curve: Interval(start, end, curve: Curves.easeOut),
    );
  }

  Animation<Offset> _slideFor(double start, double end) {
    return Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Interval(start, end, curve: Curves.easeOutCubic),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final logoFade = _fadeFor(0.0, 0.45);
    final logoScale = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: const Interval(0.0, 0.45, curve: Curves.easeOutBack)),
    );
    final sloganFade = _fadeFor(0.20, 0.62);
    final sloganSlide = _slideFor(0.20, 0.62);
    final chipsFade = _fadeFor(0.38, 0.78);
    final chipsSlide = _slideFor(0.38, 0.78);
    final buttonsFade = _fadeFor(0.55, 1.0);
    final buttonsSlide = _slideFor(0.55, 1.0);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppTheme.mainGradient,
        ),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: IntrinsicHeight(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 16),
                      child: Column(
                        children: [
                          const SizedBox(height: 4),

                          // LOGO con halo decorativo detrás
                          FadeTransition(
                            opacity: logoFade,
                            child: ScaleTransition(
                              scale: logoScale,
                              child: _logoWithHalo(),
                            ),
                          ),

                          const SizedBox(height: 2),

                          // SLOGAN
                          FadeTransition(
                            opacity: sloganFade,
                            child: SlideTransition(
                              position: sloganSlide,
                              child: _slogan(),
                            ),
                          ),

                          const SizedBox(height: 24),

                          // CHIPS DE CONFIANZA (altura pareja entre los tres)
                          FadeTransition(
                            opacity: chipsFade,
                            child: SlideTransition(
                              position: chipsSlide,
                              child: _trustChips(),
                            ),
                          ),

                          const SizedBox(height: 120),

                          // BOTONES
                          FadeTransition(
                            opacity: buttonsFade,
                            child: SlideTransition(
                              position: buttonsSlide,
                              child: Column(
                                children: [
                                  _startButton(context),
                                  const SizedBox(height: 14),
                                  _aboutBanner(context),
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(height: 30),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  // --- Secciones ---------------------------------------------------------

  Widget _logoWithHalo() {
    return SizedBox(
      height: 210,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 220,
            height: 220,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  Colors.white.withOpacity(0.65),
                  Colors.white.withOpacity(0.0),
                ],
              ),
            ),
          ),
          Semantics(
            label: "Logotipo de MediCare",
            child: Image.asset(
              "assets/images/medicare_logo.png",
              width: 220,
            ),
          ),
        ],
      ),
    );
  }

  // Encabezado tipo "hero": barra decorativa + título en dos pesos
  // de fuente, en vez de un solo bloque de texto en negrita plano.
  Widget _slogan() {
    return Column(
      children: [
        Container(
          width: 40,
          height: 4,
          decoration: BoxDecoration(
            color: AppTheme.primaryBlue.withOpacity(0.55),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(height: 14),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              children: [
                TextSpan(
                  text: "Tu recordatorio de medicamentos,\n",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: _textBlue.withOpacity(0.85),
                    height: 1.45,
                    letterSpacing: 0.1,
                  ),
                ),
                TextSpan(
                  text: "siempre a tiempo",
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w800,
                    color: AppTheme.primaryBlue,
                    height: 1.45,
                    letterSpacing: 0.1,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _trustChips() {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _chip(icon: Icons.notifications_active_rounded, label: "Recordatorios"),
          const SizedBox(width: 12),
          _chip(icon: Icons.touch_app_rounded, label: "Fácil de usar"),
          const SizedBox(width: 12),
          _chip(icon: Icons.shield_rounded, label: "Seguro y\nprivado"),
        ],
      ),
    );
  }

  Widget _chip({required IconData icon, required String label}) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 6),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.55),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.white.withOpacity(0.7), width: 1),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppTheme.primaryBlue.withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: AppTheme.primaryBlue, size: 21),
            ),
            const SizedBox(height: 9),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: _textBlue,
                height: 1.25,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // BOTÓN COMENZAR — acción principal, gradiente + sombra de color.
  Widget _startButton(BuildContext context) {
    return Semantics(
      button: true,
      label: "Comenzar. Entrar a la aplicación sin necesidad de registro",
      child: Container(
        width: double.infinity,
        constraints: const BoxConstraints(maxWidth: 340),
        height: 78,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppTheme.primaryBlue, _deepBlue],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: AppTheme.primaryBlue.withOpacity(0.38),
              offset: const Offset(0, 10),
              blurRadius: 22,
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(22),
          child: InkWell(
            borderRadius: BorderRadius.circular(22),
            onTap: () {
              Navigator.pushReplacementNamed(context, "/home");
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.18),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.medication_rounded,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 14),
                  const Flexible(
                    child: Text(
                      "Comenzar",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 23,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    Icons.arrow_forward_rounded,
                    color: Colors.white.withOpacity(0.9),
                    size: 22,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // BANNER SOBRE MEDICARE — mismo lenguaje visual que los chips
  // (tarjeta clara, borde sutil), pero a tamaño de banner secundario
  // para que no compita con el botón principal.
  Widget _aboutBanner(BuildContext context) {
    return Semantics(
      button: true,
      label: "Sobre MediCare. Ver información de la aplicación",
      child: Container(
        width: double.infinity,
        constraints: const BoxConstraints(maxWidth: 340),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.55),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.white.withOpacity(0.7), width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(18),
          child: InkWell(
            borderRadius: BorderRadius.circular(18),
            onTap: () {
              Navigator.pushNamed(context, "/about");
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 18),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: AppTheme.primaryBlue.withOpacity(0.12),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.info_outline_rounded,
                      color: AppTheme.primaryBlue,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    "Sobre MediCare",
                    style: TextStyle(
                      color: AppTheme.primaryBlue,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}