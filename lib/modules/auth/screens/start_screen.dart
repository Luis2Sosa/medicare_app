import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:medicare_app/core/app_theme.dart';
import 'package:medicare_app/services/notification_service.dart';

double _clampD(num value, double lo, double hi) {
  return value.clamp(lo, hi).toDouble();
}

class StartScreen extends StatefulWidget {
  const StartScreen({super.key});

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen>
    with TickerProviderStateMixin {
  late final AnimationController _controller;

  static const Color _deepBlue = Color(0xFF123C66);
  static const Color _textBlue = Color(0xFF1E3A5F);
  static const Color _softText = Color(0xFF64748B);
  static const Color _accentGreen = Color(0xFF10B981);

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 850),
      vsync: this,
    )..forward();

  }

  @override
  void dispose() {
    _controller.dispose();
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
      begin: const Offset(0, 0.04),
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
    final logoFade = _fadeFor(0.0, 0.35);
    final contentFade = _fadeFor(0.18, 0.72);
    final contentSlide = _slideFor(0.18, 0.72);
    final buttonsFade = _fadeFor(0.45, 1.0);
    final buttonsSlide = _slideFor(0.45, 1.0);

    final clampedTextScaler = MediaQuery.textScalerOf(context).clamp(
      minScaleFactor: 0.90,
      maxScaleFactor: 1.10,
    );

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
                  physics: const BouncingScrollPhysics(),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(
                        m.horizontalPadding,
                        m.topPadding,
                        m.horizontalPadding,
                        m.bottomPadding,
                      ),
                      child: Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 460),
                          child: Column(
                            children: [
                              FadeTransition(
                                opacity: logoFade,
                                child: _logoHeader(m),
                              ),

                              SizedBox(height: 20),

                              FadeTransition(
                                opacity: contentFade,
                                child: SlideTransition(
                                  position: contentSlide,
                                  child: _openContent(m),
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
                                      SizedBox(height: m.smallGap),
                                      _aboutButton(context, m),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
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

  Widget _logoHeader(_ScreenMetrics m) {
    return Column(
      children: [
        Semantics(
          label: "Logotipo de MediCare",
          child: Image.asset(
            "assets/images/medicare_logo.png",
            width: m.logoSize,
            height: m.logoSize,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              return Icon(
                Icons.medication_rounded,
                size: m.logoSize * 0.70,
                color: AppTheme.primaryBlue,
              );
            },
          ),
        ),

        const SizedBox(height: 0),

        Text(
          "MediCare",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: m.logoTitleSize,
            fontWeight: FontWeight.w900,
            color: AppTheme.primaryBlue,
            height: 1.0,
            letterSpacing: -0.6,
          ),
        ),

        const SizedBox(height: 2),

        SizedBox(
          width: 180,
          height: 30,
          child: Stack(
            alignment: Alignment.center,
            children: [
              CustomPaint(
                size: const Size(180, 30),
                painter: _HeartbeatPainter(),
              ),
              Container(
                color: Colors.transparent,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: const Icon(
                  Icons.favorite_rounded,
                  color: Colors.red,
                  size: 22,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 2),

        Text(
          "Pensada para personas mayores",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: _softText,
            fontSize: m.headerTextSize,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  Widget _openContent(_ScreenMetrics m) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(
            horizontal: m.cardPadding,
            vertical: m.cardPadding,
          ),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.84),
            borderRadius: BorderRadius.circular(34),
            border: Border.all(
              color: Colors.white.withOpacity(0.92),
              width: 1.3,
            ),
            boxShadow: [
              BoxShadow(
                color: AppTheme.primaryBlue.withOpacity(0.10),
                blurRadius: 30,
                offset: const Offset(0, 18),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Tus medicamentos,",
                style: TextStyle(
                  fontSize: m.sloganSmallSize,
                  fontWeight: FontWeight.w900,
                  color: _textBlue,
                  height: 1.10,
                  letterSpacing: -0.4,
                ),
              ),
              ShaderMask(
                shaderCallback: (bounds) => const LinearGradient(
                  colors: [
                    AppTheme.primaryBlue,
                    _accentGreen,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ).createShader(bounds),
                child: Text(
                  "siempre a tiempo",
                  style: TextStyle(
                    fontSize: m.sloganBigSize,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    height: 1.08,
                    letterSpacing: -0.6,
                  ),
                ),
              ),

              SizedBox(height: m.sectionGap),

              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 3,
                    height: m.descriptionLineHeight,
                    decoration: BoxDecoration(
                      color: _accentGreen,
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  SizedBox(width: m.smallGap),
                  Expanded(
                    child: Text(
                      "Una forma sencilla y clara de recordar cada dosis, sin pantallas complicadas.",
                      style: TextStyle(
                        fontSize: m.bodyTextSize,
                        fontWeight: FontWeight.w600,
                        color: _softText,
                        height: 1.42,
                      ),
                    ),
                  ),
                  SizedBox(width: m.smallGap),
                  Container(
                    width: m.clockBox,
                    height: m.clockBox,
                    decoration: BoxDecoration(
                      color: AppTheme.primaryBlue.withOpacity(0.08),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.alarm_rounded,
                      size: m.clockIcon,
                      color: AppTheme.primaryBlue,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        SizedBox(height: m.featureTopGap),

        _featureRow(m),
      ],
    );
  }

  Widget _featureRow(_ScreenMetrics m) {
    return Row(
      children: [
        _featureChip(
          icon: Icons.notifications_active_rounded,
          label: "Alertas\nclaras",
          m: m,
        ),
        SizedBox(width: m.chipGap),
        _featureChip(
          icon: Icons.touch_app_rounded,
          label: "Uso\nfácil",
          m: m,
        ),
        SizedBox(width: m.chipGap),
        _featureChip(
          icon: Icons.workspace_premium_rounded,
          label: "Sin\nanuncios",
          m: m,
        ),
      ],
    );
  }

  Widget _featureChip({
    required IconData icon,
    required String label,
    required _ScreenMetrics m,
  }) {
    return Expanded(
      child: Container(
        height: m.featureHeight,
        padding: EdgeInsets.symmetric(
          vertical: m.chipPaddingV,
          horizontal: m.chipPaddingH,
        ),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.80),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: AppTheme.primaryBlue.withOpacity(0.08),
            width: 1.1,
          ),
          boxShadow: [
            BoxShadow(
              color: AppTheme.primaryBlue.withOpacity(0.06),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: AppTheme.primaryBlue,
              size: m.chipIconSize,
            ),
            SizedBox(height: m.tinyGap),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: m.chipFontSize,
                fontWeight: FontWeight.w900,
                color: _textBlue,
                height: 1.12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _startButton(BuildContext context, _ScreenMetrics m) {
    return _PressableScale(
      semanticsLabel: "Comenzar. Entrar a la aplicación",
      onTap: () async {
        await NotificationService.instance.requestPermissions();

        if (!context.mounted) return;

        Navigator.pushReplacementNamed(context, "/home");
      },
      builder: (pressed) {
        return Container(
          width: double.infinity,
          height: m.buttonHeight,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                AppTheme.primaryBlue,
                _deepBlue,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(26),
            boxShadow: [
              BoxShadow(
                color: AppTheme.primaryBlue.withOpacity(
                  pressed ? 0.22 : 0.42,
                ),
                offset: Offset(0, pressed ? 5 : 14),
                blurRadius: pressed ? 14 : 28,
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.arrow_forward_rounded,
                color: Colors.white,
                size: m.buttonArrowSize,
              ),
              SizedBox(width: 12),
              Text(
                "Comenzar ahora",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: m.buttonFontSize,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.1,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _aboutButton(BuildContext context, _ScreenMetrics m) {
    return _PressableScale(
      semanticsLabel: "Acerca de MediCare",
      onTap: () => Navigator.pushNamed(context, "/about"),
      builder: (pressed) {
        return Container(
          width: double.infinity,
          height: m.aboutButtonHeight,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(pressed ? 0.58 : 0.78),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: AppTheme.primaryBlue.withOpacity(0.18),
              width: 1.2,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.info_outline_rounded,
                color: AppTheme.primaryBlue,
                size: m.aboutIconSize,
              ),
              SizedBox(width: 10),
              Text(
                "Acerca de MediCare",
                style: TextStyle(
                  color: AppTheme.primaryBlue,
                  fontSize: m.aboutTextSize,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -0.2,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _HeartbeatPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF42A5F5)
      ..strokeWidth = 2.2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final y = size.height / 2;

    final path = Path();

    // Línea izquierda
    path.moveTo(0, y);
    path.lineTo(28, y);

    // Pico ECG izquierdo
    path.lineTo(36, y - 8);
    path.lineTo(44, y + 8);
    path.lineTo(52, y);

    // Espacio para el corazón
    path.lineTo(72, y);
    path.moveTo(108, y);

    // Pico ECG derecho
    path.lineTo(128, y);
    path.lineTo(136, y - 8);
    path.lineTo(144, y + 8);
    path.lineTo(152, y);

    // Línea final
    path.lineTo(size.width, y);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

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
      setState(() {
        _pressed = value;
      });
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
          scale: _pressed ? 0.965 : 1.0,
          duration: const Duration(milliseconds: 130),
          curve: Curves.easeOut,
          child: widget.builder(_pressed),
        ),
      ),
    );
  }
}

class _ScreenMetrics {
  final double horizontalPadding;
  final double topPadding;
  final double bottomPadding;

  final double logoSize;
  final double logoTitleSize;
  final double logoSubtitleGap;
  final double headerTextSize;

  final double mainGap;
  final double appNameSize;
  final double sloganSmallSize;
  final double sloganBigSize;
  final double bodyTextSize;
  final double cardPadding;
  final double descriptionLineHeight;
  final double clockBox;
  final double clockIcon;

  final double featureTopGap;
  final double featureHeight;
  final double chipGap;
  final double chipPaddingV;
  final double chipPaddingH;
  final double chipIconSize;
  final double chipFontSize;

  final double buttonHeight;
  final double buttonFontSize;
  final double buttonArrowSize;

  final double aboutButtonHeight;
  final double aboutIconSize;
  final double aboutTextSize;

  final double sectionGap;
  final double smallGap;
  final double tinyGap;
  final double buttonSpace;

  final bool isCompactHeight;
  final bool isCompactWidth;

  const _ScreenMetrics._({
    required this.horizontalPadding,
    required this.topPadding,
    required this.bottomPadding,
    required this.logoSize,
    required this.logoTitleSize,
    required this.logoSubtitleGap,
    required this.headerTextSize,
    required this.mainGap,
    required this.appNameSize,
    required this.sloganSmallSize,
    required this.sloganBigSize,
    required this.bodyTextSize,
    required this.cardPadding,
    required this.descriptionLineHeight,
    required this.clockBox,
    required this.clockIcon,
    required this.featureTopGap,
    required this.featureHeight,
    required this.chipGap,
    required this.chipPaddingV,
    required this.chipPaddingH,
    required this.chipIconSize,
    required this.chipFontSize,
    required this.buttonHeight,
    required this.buttonFontSize,
    required this.buttonArrowSize,
    required this.aboutButtonHeight,
    required this.aboutIconSize,
    required this.aboutTextSize,
    required this.sectionGap,
    required this.smallGap,
    required this.tinyGap,
    required this.buttonSpace,
    required this.isCompactHeight,
    required this.isCompactWidth,
  });

  factory _ScreenMetrics.of(BoxConstraints constraints) {
    final width = constraints.maxWidth.isFinite ? constraints.maxWidth : 390.0;
    final height = constraints.maxHeight.isFinite ? constraints.maxHeight : 760.0;

    final widthScale = _clampD(width / 390.0, 0.82, 1.16);
    final heightScale = _clampD(height / 760.0, 0.80, 1.10);
    final scale = math.min(widthScale, heightScale);

    final isCompactHeight = height < 700;
    final isCompactWidth = width < 370;

    return _ScreenMetrics._(
      horizontalPadding: isCompactWidth ? 18 : 22,
      topPadding: isCompactHeight ? 0 : 6,
      bottomPadding: isCompactHeight ? 14 : 20,

      logoSize: _clampD((isCompactHeight ? 120 : 150) * scale, 110, 165),
      logoTitleSize: _clampD(36 * scale, 31, 43),
      logoSubtitleGap: isCompactHeight ? 8 : 12,
      headerTextSize: _clampD(15.5 * scale, 14, 18),

      mainGap: isCompactHeight ? 28 : 42,

      appNameSize: _clampD(33 * scale, 29, 39),
      sloganSmallSize: _clampD(27 * scale, 23, 31),
      sloganBigSize: _clampD(31 * scale, 27, 36),
      bodyTextSize: _clampD(16 * scale, 14.5, 18),
      cardPadding: _clampD(23 * scale, 19, 27),
      descriptionLineHeight: _clampD(72 * scale, 60, 82),
      clockBox: _clampD(74 * scale, 60, 84),
      clockIcon: _clampD(40 * scale, 34, 46),

      featureTopGap: isCompactHeight ? 14 : 20,
      featureHeight: _clampD(104 * scale, 94, 116),
      chipGap: isCompactWidth ? 8 : 12,
      chipPaddingV: _clampD(12 * scale, 10, 14),
      chipPaddingH: isCompactWidth ? 5 : 7,
      chipIconSize: _clampD(29 * scale, 25, 33),
      chipFontSize: _clampD(14.5 * scale, 13, 16),

      buttonHeight: _clampD((isCompactHeight ? 58 : 66) * scale, 54, 70),
      buttonFontSize: _clampD(20.5 * scale, 18, 23),
      buttonArrowSize: _clampD(25 * scale, 22, 28),

      aboutButtonHeight: _clampD(52 * scale, 48, 58),
      aboutIconSize: _clampD(20 * scale, 18, 22),
      aboutTextSize: _clampD(16.5 * scale, 15, 18),

      sectionGap: isCompactHeight ? 14 : 18,
      smallGap: isCompactHeight ? 10 : 13,
      tinyGap: 6,
      buttonSpace: isCompactHeight ? 24 : 34,

      isCompactHeight: isCompactHeight,
      isCompactWidth: isCompactWidth,
    );
  }
}