// =============================================================================
// StartScreen — versión mejorada
// -----------------------------------------------------------------------------
// Cambios principales respecto a la versión anterior:
//  • Logo más grande, con halo animado (pulso suave) y respaldo si la imagen
//    no carga (no se rompe si falta el asset).
//  • Eslogan con mejor jerarquía tipográfica y un sutil "glow" en la frase
//    destacada.
//  • Tarjetas de confianza ("chips") con más profundidad: degradado, sombra e
//    íconos con fondo en degradado.
//  • Botón principal con micro-interacción (se "hunde" levemente al tocar +
//    vibración táctil) y subtítulo opcional cuando hay espacio suficiente.
//  • Todas las medidas se calculan con una clase _ScreenMetrics que usa
//    clamp() en cada valor: nunca habrá overflow ni elementos gigantes o
//    minúsculos, sin importar el tamaño del celular (chico, mediano, grande).
//  • Se limita el "textScaler" del sistema (accesibilidad) para que un texto
//    de letra muy grande no rompa el diseño.
//  • FittedBox en los textos clave como red de seguridad adicional.
// =============================================================================

import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:medicare_app/core/app_theme.dart';

/// Helper para evitar el problema clásico de Dart donde `num.clamp(...)`
/// devuelve `num` en vez de `double` y rompe la compilación al asignarlo
/// a una variable `double`. Centralizarlo aquí hace el resto del código
/// más simple y a prueba de errores de tipo.
double _clampD(num value, double lo, double hi) => value.clamp(lo, hi).toDouble();

class StartScreen extends StatefulWidget {
  const StartScreen({super.key});

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen>
    with TickerProviderStateMixin {
  late final AnimationController _controller;
  late final AnimationController _haloController;

  static const Color _deepBlue = Color(0xFF123C66);
  static const Color _deepestBlue = Color(0xFF0A2540);
  static const Color _textBlue = Color(0xFF1E3A5F);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..forward();

    // Pulso suave e infinito detrás del logo.
    _haloController = AnimationController(
      duration: const Duration(milliseconds: 2600),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    _haloController.dispose();
    super.dispose();
  }

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
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(start, end, curve: Curves.easeOutCubic),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final logoFade = _fadeFor(0.0, 0.45);
    final logoScale = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.45, curve: Curves.easeOutBack),
      ),
    );

    final sloganFade = _fadeFor(0.20, 0.62);
    final sloganSlide = _slideFor(0.20, 0.62);
    final chipsFade = _fadeFor(0.38, 0.78);
    final chipsSlide = _slideFor(0.38, 0.78);
    final buttonsFade = _fadeFor(0.55, 1.0);
    final buttonsSlide = _slideFor(0.55, 1.0);

    // Si el usuario tiene activado un tamaño de letra del sistema muy
    // grande (accesibilidad), lo limitamos un poco para que el diseño
    // no se rompa, sin quitarle del todo el ajuste.
    final clampedTextScaler = MediaQuery.textScalerOf(context)
        .clamp(minScaleFactor: 0.9, maxScaleFactor: 1.15);

    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: clampedTextScaler),
      child: Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: AppTheme.mainGradient,
          ),
          child: SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final m = _ScreenMetrics.of(constraints);

                return SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  child: ConstrainedBox(
                    constraints:
                    BoxConstraints(minHeight: constraints.maxHeight),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: m.horizontalPadding,
                        vertical: 16,
                      ),
                      child: Column(
                        children: [
                          SizedBox(height: m.isCompactHeight ? 0 : 6),

                          FadeTransition(
                            opacity: logoFade,
                            child: ScaleTransition(
                              scale: logoScale,
                              child: _logoWithHalo(m),
                            ),
                          ),

                          SizedBox(height: m.isCompactHeight ? 0 : 4),

                          FadeTransition(
                            opacity: sloganFade,
                            child: SlideTransition(
                              position: sloganSlide,
                              child: _slogan(m),
                            ),
                          ),

                          SizedBox(height: m.gapMedium),

                          FadeTransition(
                            opacity: chipsFade,
                            child: SlideTransition(
                              position: chipsSlide,
                              child: _trustChips(m),
                            ),
                          ),

                          SizedBox(height: m.buttonSpace),

                          FadeTransition(
                            opacity: buttonsFade,
                            child: SlideTransition(
                              position: buttonsSlide,
                              child: Column(
                                children: [
                                  _startButton(context, m),
                                  const SizedBox(height: 14),
                                  _aboutBanner(context, m),
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(height: 24),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------
  // LOGO
  // ---------------------------------------------------------------------
  Widget _logoWithHalo(_ScreenMetrics m) {
    return SizedBox(
      height: m.logoBoxHeight,
      width: double.infinity,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Halo animado: pulso suave e infinito.
          AnimatedBuilder(
            animation: _haloController,
            builder: (context, _) {
              final double t = _haloController.value; // 0..1
              final double haloScale = 1.0 + (t * 0.12);
              final double haloOpacity = _clampD(0.55 - (t * 0.18), 0.30, 0.65);
              return Transform.scale(
                scale: haloScale,
                child: Container(
                  width: m.logoSize,
                  height: m.logoSize,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        Colors.white.withOpacity(haloOpacity),
                        Colors.white.withOpacity(0.0),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),

          // Sombra azul suave detrás del logo para darle profundidad.
          Container(
            width: m.logoSize * 0.78,
            height: m.logoSize * 0.78,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppTheme.primaryBlue.withOpacity(0.18),
                  blurRadius: 30,
                  spreadRadius: 2,
                ),
              ],
            ),
          ),

          Semantics(
            label: "Logotipo de MediCare",
            child: Image.asset(
              "assets/images/medicare_logo.png",
              width: m.logoSize,
              fit: BoxFit.contain,
              // Si por algún motivo el asset no carga, no se rompe la
              // pantalla: se muestra un ícono de respaldo.
              errorBuilder: (context, error, stackTrace) {
                return Icon(
                  Icons.medication_rounded,
                  size: m.logoSize * 0.6,
                  color: AppTheme.primaryBlue,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------
  // ESLOGAN
  // ---------------------------------------------------------------------
  Widget _slogan(_ScreenMetrics m) {
    return Column(
      children: [
        Container(
          width: 44,
          height: 4,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppTheme.primaryBlue.withOpacity(0.15),
                AppTheme.primaryBlue.withOpacity(0.65),
                AppTheme.primaryBlue.withOpacity(0.15),
              ],
            ),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(height: 16),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: m.isCompactWidth ? 4 : 10),
          // FittedBox = red de seguridad extra: si por algún motivo el
          // texto no entra en el ancho disponible, se reduce solo en vez
          // de desbordarse.
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "Tu recordatorio de medicamentos,\n",
                    style: TextStyle(
                      fontSize: m.sloganSmallSize,
                      fontWeight: FontWeight.w600,
                      color: _textBlue.withOpacity(0.85),
                      height: 1.35,
                      letterSpacing: 0.1,
                    ),
                  ),
                  TextSpan(
                    text: "siempre a tiempo",
                    style: TextStyle(
                      fontSize: m.sloganBigSize,
                      fontWeight: FontWeight.w800,
                      color: AppTheme.primaryBlue,
                      height: 1.35,
                      letterSpacing: 0.1,
                      shadows: [
                        Shadow(
                          color: AppTheme.primaryBlue.withOpacity(0.25),
                          blurRadius: 18,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------
  // CHIPS DE CONFIANZA
  // ---------------------------------------------------------------------
  Widget _trustChips(_ScreenMetrics m) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _chip(
            icon: Icons.notifications_active_rounded,
            label: "Recordatorios",
            m: m,
          ),
          SizedBox(width: m.chipGap),
          _chip(
            icon: Icons.touch_app_rounded,
            label: "Fácil de usar",
            m: m,
          ),
          SizedBox(width: m.chipGap),
          _chip(
            icon: Icons.shield_rounded,
            label: "Seguro y\nprivado",
            m: m,
          ),
        ],
      ),
    );
  }

  Widget _chip({
    required IconData icon,
    required String label,
    required _ScreenMetrics m,
  }) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: m.chipPaddingV,
          horizontal: m.chipPaddingH,
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white.withOpacity(0.65),
              Colors.white.withOpacity(0.42),
            ],
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withOpacity(0.75), width: 1),
          boxShadow: [
            BoxShadow(
              color: AppTheme.primaryBlue.withOpacity(0.08),
              blurRadius: 14,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: m.chipIconBox,
              height: m.chipIconBox,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppTheme.primaryBlue.withOpacity(0.18),
                    AppTheme.primaryBlue.withOpacity(0.08),
                  ],
                ),
              ),
              child: Icon(icon, color: AppTheme.primaryBlue, size: m.chipIconSize),
            ),
            SizedBox(height: m.isCompactHeight ? 6 : 9),
            Text(
              label,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: m.chipFontSize,
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

  // ---------------------------------------------------------------------
  // BOTÓN PRINCIPAL
  // ---------------------------------------------------------------------
  Widget _startButton(BuildContext context, _ScreenMetrics m) {
    return _PressableScale(
      semanticsLabel:
      "Comenzar. Entrar a la aplicación sin necesidad de registro",
      onTap: () => Navigator.pushReplacementNamed(context, "/home"),
      builder: (pressed) {
        return Container(
          width: double.infinity,
          constraints: BoxConstraints(maxWidth: m.buttonMaxWidth),
          height: m.buttonHeight,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppTheme.primaryBlue, _deepBlue, _deepestBlue],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(22),
            boxShadow: [
              BoxShadow(
                color: AppTheme.primaryBlue.withOpacity(pressed ? 0.22 : 0.40),
                offset: Offset(0, pressed ? 4 : 12),
                blurRadius: pressed ? 14 : 26,
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: m.isCompactWidth ? 16 : 22),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: m.buttonIconBox,
                  height: m.buttonIconBox,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.18),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.medication_rounded,
                    color: Colors.white,
                    size: m.buttonIconBox * 0.55,
                  ),
                ),
                const SizedBox(width: 14),
                Flexible(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          "Comenzar",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: m.buttonFontSize,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.2,
                          ),
                        ),
                      ),
                      if (m.showButtonSubtitle)
                        Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Text(
                            "Sin registro · acceso inmediato",
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.78),
                              fontSize: m.buttonSubtitleSize,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Icon(
                  Icons.arrow_forward_rounded,
                  color: Colors.white.withOpacity(0.9),
                  size: m.isCompactWidth ? 21 : 22,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ---------------------------------------------------------------------
  // BANNER "SOBRE MEDICARE"
  // ---------------------------------------------------------------------
  Widget _aboutBanner(BuildContext context, _ScreenMetrics m) {
    return _PressableScale(
      semanticsLabel: "Sobre MediCare. Ver información de la aplicación",
      onTap: () => Navigator.pushNamed(context, "/about"),
      builder: (pressed) {
        return Container(
          width: double.infinity,
          constraints: BoxConstraints(maxWidth: m.buttonMaxWidth),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(pressed ? 0.45 : 0.55),
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
          child: Padding(
            padding: EdgeInsets.symmetric(
              vertical: m.isCompactWidth ? 13 : 14,
              horizontal: m.isCompactWidth ? 14 : 18,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: m.isCompactWidth ? 34.0 : 36.0,
                  height: m.isCompactWidth ? 34.0 : 36.0,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryBlue.withOpacity(0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.info_outline_rounded,
                    color: AppTheme.primaryBlue,
                    size: m.isCompactWidth ? 19.0 : 20.0,
                  ),
                ),
                const SizedBox(width: 12),
                Flexible(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      "Sobre MediCare",
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: AppTheme.primaryBlue,
                        fontSize: m.isCompactWidth ? 15.0 : 16.0,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// =============================================================================
// _PressableScale
// -----------------------------------------------------------------------------
// Botón/banner con feedback táctil: se "hunde" levemente (escala) al
// presionarlo y vibra un poco (haptic feedback). No depende de InkWell, así
// que funciona igual de bien sobre cualquier fondo o degradado.
// =============================================================================
class _PressableScale extends StatefulWidget {
  final Widget Function(bool pressed) builder;
  final VoidCallback onTap;
  final String? semanticsLabel;

  const _PressableScale({
    required this.builder,
    required this.onTap,
    this.semanticsLabel,
  });

  @override
  State<_PressableScale> createState() => _PressableScaleState();
}

class _PressableScaleState extends State<_PressableScale> {
  bool _pressed = false;

  void _setPressed(bool value) {
    if (_pressed != value) {
      setState(() => _pressed = value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: widget.semanticsLabel,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: (_) => _setPressed(true),
        onTapCancel: () => _setPressed(false),
        onTapUp: (_) => _setPressed(false),
        onTap: () {
          HapticFeedback.mediumImpact();
          widget.onTap();
        },
        child: AnimatedScale(
          scale: _pressed ? 0.96 : 1.0,
          duration: const Duration(milliseconds: 120),
          curve: Curves.easeOut,
          child: widget.builder(_pressed),
        ),
      ),
    );
  }
}

// =============================================================================
// _ScreenMetrics
// -----------------------------------------------------------------------------
// Calcula TODAS las medidas (tamaños, separaciones, fuentes) a partir del
// ancho y alto disponibles, usando clamp() en cada valor. Esto garantiza que
// el diseño nunca se vea roto, ni en un celular muy chico (p. ej. iPhone SE,
// 320px de ancho) ni en uno muy grande (p. ej. Pro Max o un phablet), ni en
// pantallas con poca altura disponible (modo split-screen, teclado abierto,
// barra de navegación gigante, etc.).
// =============================================================================
class _ScreenMetrics {
  final double horizontalPadding;
  final double logoSize;
  final double logoBoxHeight;
  final double sloganSmallSize;
  final double sloganBigSize;
  final double chipGap;
  final double chipPaddingV;
  final double chipPaddingH;
  final double chipIconBox;
  final double chipIconSize;
  final double chipFontSize;
  final double buttonHeight;
  final double buttonMaxWidth;
  final double buttonFontSize;
  final double buttonSubtitleSize;
  final double buttonIconBox;
  final bool showButtonSubtitle;
  final double gapMedium;
  final double buttonSpace;
  final bool isCompactHeight;
  final bool isCompactWidth;

  _ScreenMetrics._({
    required this.horizontalPadding,
    required this.logoSize,
    required this.logoBoxHeight,
    required this.sloganSmallSize,
    required this.sloganBigSize,
    required this.chipGap,
    required this.chipPaddingV,
    required this.chipPaddingH,
    required this.chipIconBox,
    required this.chipIconSize,
    required this.chipFontSize,
    required this.buttonHeight,
    required this.buttonMaxWidth,
    required this.buttonFontSize,
    required this.buttonSubtitleSize,
    required this.buttonIconBox,
    required this.showButtonSubtitle,
    required this.gapMedium,
    required this.buttonSpace,
    required this.isCompactHeight,
    required this.isCompactWidth,
  });

  factory _ScreenMetrics.of(BoxConstraints constraints) {
    final double width =
    constraints.maxWidth.isFinite ? constraints.maxWidth : 390.0;
    final double height =
    constraints.maxHeight.isFinite ? constraints.maxHeight : 760.0;

    // 390 x 760 ≈ tamaño de referencia (celular mediano). A partir de ahí
    // escalamos hacia arriba o abajo, siempre dentro de límites seguros.
    final double widthScale = _clampD(width / 390.0, 0.80, 1.30);
    final double heightScale = _clampD(height / 760.0, 0.70, 1.20);
    final double scale = math.min(widthScale, heightScale);

    final bool isCompactHeight = height < 680;
    final bool isCompactWidth = width < 360;

    double logoSize = _clampD(250.0 * scale, 175.0, 305.0);
    if (isCompactHeight) logoSize *= 0.85;

    final double buttonHeight =
    _clampD((isCompactHeight ? 74.0 : 84.0) * scale, 64.0, 90.0);
    final bool showButtonSubtitle = buttonHeight >= 76 && !isCompactWidth;

    final double safeScale = _clampD(scale, 0.85, 1.15);

    return _ScreenMetrics._(
      horizontalPadding: isCompactWidth ? 16.0 : 26.0,
      logoSize: logoSize,
      logoBoxHeight: logoSize + 26.0,
      sloganSmallSize: _clampD(18.0 * scale, 15.5, 20.5),
      sloganBigSize: _clampD(23.0 * scale, 20.0, 27.0),
      chipGap: isCompactWidth ? 8.0 : 12.0,
      chipPaddingV: (isCompactHeight ? 11.0 : 16.0) * safeScale,
      chipPaddingH: isCompactWidth ? 4.0 : 6.0,
      chipIconBox: (isCompactWidth ? 36.0 : 42.0) * safeScale,
      chipIconSize: (isCompactWidth ? 19.0 : 22.0) * safeScale,
      chipFontSize: _clampD((isCompactWidth ? 11.0 : 12.5) * scale, 10.5, 14.0),
      buttonHeight: buttonHeight,
      buttonMaxWidth: _clampD(340.0 * scale, 280.0, 420.0),
      buttonFontSize: _clampD(22.0 * scale, 19.0, 25.0),
      buttonSubtitleSize: _clampD(11.0 * scale, 10.0, 12.5),
      buttonIconBox: (isCompactWidth ? 40.0 : 46.0) * safeScale,
      showButtonSubtitle: showButtonSubtitle,
      gapMedium: isCompactHeight ? 16.0 : 26.0,
      buttonSpace: (isCompactHeight ? 36.0 : 70.0) * _clampD(heightScale, 0.75, 1.0),
      isCompactHeight: isCompactHeight,
      isCompactWidth: isCompactWidth,
    );
  }
}