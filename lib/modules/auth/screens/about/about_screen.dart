import 'package:flutter/material.dart';
import 'package:medicare_app/core/app_theme.dart';

const Color _deepBlue = Color(0xFF123C66);
const Color _textBlue = Color(0xFF1E3A5F);
const Color _muted = Color(0xFF64748B);

double _clampD(num value, double lo, double hi) {
  return value.clamp(lo, hi).toDouble();
}

class _FeatureData {
  final IconData icon;
  final String title;
  final String desc;

  const _FeatureData(this.icon, this.title, this.desc);
}

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen>
    with TickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeAnimation;
  late final Animation<Offset> _slideAnimation;
  late final AnimationController _haloController;

  static const List<_FeatureData> _features = [
    _FeatureData(
      Icons.notifications_active_rounded,
      "Recordatorios claros",
      "Te avisa con tiempo cuándo tomar cada medicamento, con avisos fáciles de ver y de entender.",
    ),
    _FeatureData(
      Icons.touch_app_rounded,
      "Fácil de usar",
      "Botones grandes y pasos sencillos, pensados para que cualquier persona pueda usarla sin complicaciones.",
    ),
    _FeatureData(
      Icons.block_rounded,
      "Sin anuncios ni cuenta",
      "No necesitas registrarte ni ver anuncios para usar MediCare. La experiencia es simple, directa y tranquila.",
    ),
    _FeatureData(
      Icons.calendar_month_rounded,
      "Tu historial a la mano",
      "Consulta de forma simple y ordenada los medicamentos que ya tomaste y los que tienes pendientes.",
    ),
  ];

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.08),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutCubic,
      ),
    );

    _controller.forward();

    _haloController = AnimationController(
      duration: const Duration(milliseconds: 2400),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    _haloController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final clampedTextScaler = MediaQuery.textScalerOf(context).clamp(
      minScaleFactor: 0.9,
      maxScaleFactor: 1.15,
    );

    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: clampedTextScaler),
      child: Container(
        decoration: const BoxDecoration(
          gradient: AppTheme.mainGradient,
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            scrolledUnderElevation: 0,
            elevation: 0,
            centerTitle: true,
            leading: Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Center(
                child: _BackButton(
                  onTap: () => Navigator.pop(context),
                ),
              ),
            ),
            title: const FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                "Sobre MediCare",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: _textBlue,
                  letterSpacing: 0.2,
                ),
              ),
            ),
          ),
          body: SafeArea(
            top: false,
            bottom: true,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final m = _AboutMetrics.of(constraints);
                final bottomInset = MediaQuery.of(context).padding.bottom;

                return FadeTransition(
                  opacity: _fadeAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: EdgeInsets.fromLTRB(
                        m.outerPaddingH,
                        20,
                        m.outerPaddingH,
                        24 + bottomInset,
                      ),
                      child: Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 520),
                          child: Column(
                            children: [
                              _header(m),
                              SizedBox(height: m.sectionGap),
                              _featuresCard(m),
                              SizedBox(height: m.sectionGap),
                              _footer(m),
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

  Widget _header(_AboutMetrics m) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
        m.headerPaddingH,
        m.headerPaddingTop,
        m.headerPaddingH,
        m.headerPaddingBottom,
      ),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            AppTheme.primaryBlue,
            _deepBlue,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryBlue.withOpacity(0.35),
            blurRadius: 22,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          SizedBox(
            height: m.headerIconOuter,
            width: m.headerIconOuter,
            child: Stack(
              alignment: Alignment.center,
              children: [
                AnimatedBuilder(
                  animation: _haloController,
                  builder: (context, _) {
                    final double t = _haloController.value;
                    final double pulseScale = 1.0 + (t * 0.14);
                    final double pulseOpacity =
                    _clampD(0.20 - (t * 0.08), 0.10, 0.20);

                    return Transform.scale(
                      scale: pulseScale,
                      child: Container(
                        width: m.headerIconOuter,
                        height: m.headerIconOuter,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(pulseOpacity),
                        ),
                      ),
                    );
                  },
                ),
                Container(
                  width: m.headerIconInner,
                  height: m.headerIconInner,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.22),
                  ),
                  child: Icon(
                    Icons.favorite_rounded,
                    size: m.headerIconSize,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: m.headerSmallGap),
          Container(
            width: 38,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.55),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          SizedBox(height: m.headerSmallGap),
          Text(
            "Tu salud, siempre presente",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: m.headerTitleSize,
              fontWeight: FontWeight.w900,
              color: Colors.white,
              letterSpacing: 0.2,
              height: 1.18,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            "MediCare te ayuda a recordar tus medicamentos todos los días, de forma simple y sin complicaciones.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: m.headerDescSize,
              fontWeight: FontWeight.w600,
              height: 1.45,
              color: Colors.white.withOpacity(0.92),
              letterSpacing: 0.1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _featuresCard(_AboutMetrics m) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.94),
        borderRadius: BorderRadius.circular(26),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          for (int i = 0; i < _features.length; i++) ...[
            _featureRow(_features[i], m),
            if (i != _features.length - 1)
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: m.featureRowPadding,
                ),
                child: const Divider(
                  height: 1,
                  thickness: 1,
                  color: Color(0xFFE9EEF5),
                ),
              ),
          ],
        ],
      ),
    );
  }

  Widget _featureRow(_FeatureData f, _AboutMetrics m) {
    return Padding(
      padding: EdgeInsets.all(m.featureRowPadding),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: m.featureIconBox,
            height: m.featureIconBox,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppTheme.primaryBlue.withOpacity(0.16),
                  AppTheme.primaryBlue.withOpacity(0.07),
                ],
              ),
              borderRadius: BorderRadius.circular(17),
            ),
            child: Icon(
              f.icon,
              size: m.featureIconSize,
              color: AppTheme.primaryBlue,
            ),
          ),
          SizedBox(width: m.featureGap),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  f.title,
                  style: TextStyle(
                    fontSize: m.featureTitleSize,
                    fontWeight: FontWeight.w900,
                    color: _textBlue,
                    letterSpacing: 0.1,
                    height: 1.15,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  f.desc,
                  style: TextStyle(
                    fontSize: m.featureDescSize,
                    fontWeight: FontWeight.w500,
                    height: 1.42,
                    color: _muted,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _footer(_AboutMetrics m) {
    return Padding(
      padding: EdgeInsets.only(bottom: m.footerBottomPadding),
      child: Column(
        children: [
          Container(
            width: 52,
            height: 1.5,
            decoration: BoxDecoration(
              color: _muted.withOpacity(0.25),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            "Sosa Tech Lab",
            style: TextStyle(
              fontSize: m.footerTitleSize,
              fontWeight: FontWeight.w700,
              color: _textBlue.withOpacity(0.6),
              letterSpacing: 0.4,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            "© 2026 · Todos los derechos reservados",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: m.footerDescSize,
              fontWeight: FontWeight.w500,
              color: _muted.withOpacity(0.75),
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }
}

class _BackButton extends StatefulWidget {
  final VoidCallback onTap;

  const _BackButton({
    required this.onTap,
  });

  @override
  State<_BackButton> createState() => _BackButtonState();
}

class _BackButtonState extends State<_BackButton> {
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
      label: "Volver",
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: (_) => _setPressed(true),
        onTapCancel: () => _setPressed(false),
        onTapUp: (_) => _setPressed(false),
        onTap: widget.onTap,
        child: AnimatedScale(
          scale: _pressed ? 0.92 : 1.0,
          duration: const Duration(milliseconds: 110),
          curve: Curves.easeOut,
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppTheme.primaryBlue.withOpacity(
                _pressed ? 0.18 : 0.10,
              ),
            ),
            child: const Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 18,
              color: AppTheme.primaryBlue,
            ),
          ),
        ),
      ),
    );
  }
}

class _AboutMetrics {
  final double outerPaddingH;
  final double sectionGap;
  final double headerPaddingH;
  final double headerPaddingTop;
  final double headerPaddingBottom;
  final double headerIconOuter;
  final double headerIconInner;
  final double headerIconSize;
  final double headerTitleSize;
  final double headerDescSize;
  final double headerSmallGap;
  final double featureIconBox;
  final double featureIconSize;
  final double featureTitleSize;
  final double featureDescSize;
  final double featureRowPadding;
  final double featureGap;
  final double footerTitleSize;
  final double footerDescSize;
  final double footerBottomPadding;

  const _AboutMetrics._({
    required this.outerPaddingH,
    required this.sectionGap,
    required this.headerPaddingH,
    required this.headerPaddingTop,
    required this.headerPaddingBottom,
    required this.headerIconOuter,
    required this.headerIconInner,
    required this.headerIconSize,
    required this.headerTitleSize,
    required this.headerDescSize,
    required this.headerSmallGap,
    required this.featureIconBox,
    required this.featureIconSize,
    required this.featureTitleSize,
    required this.featureDescSize,
    required this.featureRowPadding,
    required this.featureGap,
    required this.footerTitleSize,
    required this.footerDescSize,
    required this.footerBottomPadding,
  });

  factory _AboutMetrics.of(BoxConstraints constraints) {
    final double width =
    constraints.maxWidth.isFinite ? constraints.maxWidth : 390.0;
    final double height =
    constraints.maxHeight.isFinite ? constraints.maxHeight : 760.0;

    final double scale = _clampD(width / 390.0, 0.78, 1.22);
    final bool compactWidth = width < 360;
    final bool compactHeight = height < 690;

    final double headerIconOuter = compactHeight
        ? _clampD(78.0 * scale, 66.0, 88.0)
        : _clampD(90.0 * scale, 78.0, 104.0);

    return _AboutMetrics._(
      outerPaddingH: compactWidth ? 14.0 : 22.0,
      sectionGap: compactHeight ? 22.0 : 30.0,
      headerPaddingH: _clampD(24.0 * scale, 16.0, 30.0),
      headerPaddingTop: compactHeight
          ? _clampD(24.0 * scale, 18.0, 28.0)
          : _clampD(32.0 * scale, 24.0, 38.0),
      headerPaddingBottom: compactHeight
          ? _clampD(22.0 * scale, 18.0, 28.0)
          : _clampD(30.0 * scale, 22.0, 34.0),
      headerIconOuter: headerIconOuter,
      headerIconInner: headerIconOuter * 0.67,
      headerIconSize: headerIconOuter * 0.33,
      headerTitleSize: _clampD(23.0 * scale, 20.0, 27.0),
      headerDescSize: _clampD(15.0 * scale, 13.5, 17.0),
      headerSmallGap: compactHeight ? 11.0 : 15.0,
      featureIconBox: _clampD(52.0 * scale, 44.0, 60.0),
      featureIconSize: _clampD(26.0 * scale, 22.0, 30.0),
      featureTitleSize: _clampD(19.0 * scale, 17.0, 21.0),
      featureDescSize: _clampD(15.5 * scale, 14.0, 17.0),
      featureRowPadding: compactHeight
          ? _clampD(17.0 * scale, 13.0, 19.0)
          : _clampD(20.0 * scale, 15.0, 22.0),
      featureGap: compactWidth ? 11.0 : 15.0,
      footerTitleSize: compactHeight ? 14.5 : 16.0,
      footerDescSize: compactHeight ? 11.0 : 12.0,
      footerBottomPadding: compactHeight ? 4.0 : 8.0,
    );
  }
}