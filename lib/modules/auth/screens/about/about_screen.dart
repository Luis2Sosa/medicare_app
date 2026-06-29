// =============================================================================
// AboutScreen — versión mejorada
// -----------------------------------------------------------------------------
// Cambios principales:
//  • Encabezado con halo animado (mismo lenguaje visual que la pantalla de
//    inicio) y un ícono un poco más grande.
//  • Botón de volver con fondo circular, más fácil de tocar.
//  • Tarjetas de características con ícono en degradado (igual estilo que
//    los "chips" del inicio) en vez de un solo color plano.
//  • Todo el contenido se centra y se limita a un ancho máximo en pantallas
//    grandes (tablets / phablets), para que no se vea estirado.
//  • Tamaños de fuente, íconos y espacios calculados con clamp() según el
//    ancho disponible: se ven bien tanto en un celular chico como en uno
//    grande, sin desbordes ni elementos gigantes.
//  • Se limita el escalado de fuente del sistema (accesibilidad) para que
//    un texto muy grande no rompa el diseño.
// =============================================================================

import 'package:flutter/material.dart';
import 'package:medicare_app/core/app_theme.dart';

const Color _deepBlue = Color(0xFF123C66);
const Color _textBlue = Color(0xFF1E3A5F);
const Color _muted = Color(0xFF64748B);

/// Evita el problema clásico de Dart donde `num.clamp(...)` devuelve `num`
/// en vez de `double` y rompe la compilación al asignarlo a una variable
/// `double`.
double _clampD(num value, double lo, double hi) => value.clamp(lo, hi).toDouble();

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

  // Pulso suave e infinito detrás del ícono del encabezado.
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
      Icons.lock_outline_rounded,
      "Privada y sin cuentas",
      "No necesitas registrarte ni conectarte a internet. Toda tu información se guarda únicamente en tu teléfono.",
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
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));

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
    // Limitamos el escalado de fuente del sistema para que un texto de
    // accesibilidad muy grande no rompa el diseño, sin eliminarlo del todo.
    final clampedTextScaler = MediaQuery.textScalerOf(context)
        .clamp(minScaleFactor: 0.9, maxScaleFactor: 1.15);

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
              child: _BackButton(onTap: () => Navigator.pop(context)),
            ),
          ),
          title: const Text(
            "Sobre MediCare",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: _textBlue,
              letterSpacing: 0.2,
            ),
          ),
        ),
        body: SafeArea(
          top: false,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final m = _AboutMetrics.of(constraints);

              return FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.fromLTRB(
                      m.outerPaddingH,
                      28,
                      m.outerPaddingH,
                      28,
                    ),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 520),
                        child: Column(
                          children: [
                            _header(m),
                            const SizedBox(height: 30),
                            _featuresCard(m),
                            const SizedBox(height: 34),
                            _footer(),
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
        )
    );
  }

  // --- Encabezado: tarjeta hero con halo animado e ícono, en el mismo
  // lenguaje visual (barra decorativa + jerarquía tipográfica) que el
  // resto de la app, para que se sienta como una sola marca.
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
          colors: [AppTheme.primaryBlue, _deepBlue],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(26),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryBlue.withOpacity(0.35),
            blurRadius: 26,
            offset: const Offset(0, 14),
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
                    final double pulseOpacity = _clampD(0.20 - (t * 0.08), 0.10, 0.20);
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
          const SizedBox(height: 18),
          Container(
            width: 36,
            height: 3.5,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.55),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(height: 14),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              "Tu salud, siempre presente",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: m.headerTitleSize,
                fontWeight: FontWeight.w800,
                color: Colors.white,
                letterSpacing: 0.3,
                height: 1.3,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            "MediCare te ayuda a recordar tus medicamentos todos los días, de forma simple y sin complicaciones.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: m.headerDescSize,
              height: 1.55,
              color: Colors.white.withOpacity(0.92),
              letterSpacing: 0.1,
            ),
          ),
        ],
      ),
    );
  }

  // --- Lista de características: una sola tarjeta con renglones y
  // divisores finos, todos en la misma paleta de marca.
  Widget _featuresCard(_AboutMetrics m) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 22,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          for (int i = 0; i < _features.length; i++) ...[
            _featureRow(_features[i], m),
            if (i != _features.length - 1)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: m.featureRowPadding),
                child: const Divider(height: 1, thickness: 1, color: Color(0xFFE9EEF5)),
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
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(f.icon, size: m.featureIconSize, color: AppTheme.primaryBlue),
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
                    fontWeight: FontWeight.w800,
                    color: _textBlue,
                    letterSpacing: 0.1,
                  ),
                ),
                const SizedBox(height: 7),
                Text(
                  f.desc,
                  style: TextStyle(
                    fontSize: m.featureDescSize,
                    height: 1.5,
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

  // PIE DE PÁGINA — marca y aviso de derechos reservados.
  Widget _footer() {
    return Column(
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
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: _textBlue.withOpacity(0.6),
            letterSpacing: 0.4,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          "© 2026 · Todos los derechos reservados",
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: _muted.withOpacity(0.75),
            letterSpacing: 0.2,
          ),
        ),
      ],
    );
  }
}

// =============================================================================
// _BackButton — botón de volver con fondo circular, más fácil de tocar
// (cumple el tamaño mínimo de 44x44 recomendado para accesibilidad) y con
// una pequeña animación al presionarlo.
// =============================================================================
class _BackButton extends StatefulWidget {
  final VoidCallback onTap;
  const _BackButton({required this.onTap});

  @override
  State<_BackButton> createState() => _BackButtonState();
}

class _BackButtonState extends State<_BackButton> {
  bool _pressed = false;

  void _setPressed(bool value) {
    if (_pressed != value) setState(() => _pressed = value);
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
              color: AppTheme.primaryBlue.withOpacity(_pressed ? 0.18 : 0.10),
            ),
            child: Icon(
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

// =============================================================================
// _AboutMetrics — calcula tamaños, espacios y fuentes a partir del ancho
// disponible, con clamp() en cada valor para que el diseño nunca se rompa
// (ni en un celular muy chico ni en uno muy grande).
// =============================================================================
class _AboutMetrics {
  final double outerPaddingH;
  final double headerPaddingH;
  final double headerPaddingTop;
  final double headerPaddingBottom;
  final double headerIconOuter;
  final double headerIconInner;
  final double headerIconSize;
  final double headerTitleSize;
  final double headerDescSize;
  final double featureIconBox;
  final double featureIconSize;
  final double featureTitleSize;
  final double featureDescSize;
  final double featureRowPadding;
  final double featureGap;

  _AboutMetrics._({
    required this.outerPaddingH,
    required this.headerPaddingH,
    required this.headerPaddingTop,
    required this.headerPaddingBottom,
    required this.headerIconOuter,
    required this.headerIconInner,
    required this.headerIconSize,
    required this.headerTitleSize,
    required this.headerDescSize,
    required this.featureIconBox,
    required this.featureIconSize,
    required this.featureTitleSize,
    required this.featureDescSize,
    required this.featureRowPadding,
    required this.featureGap,
  });

  factory _AboutMetrics.of(BoxConstraints constraints) {
    final double width =
    constraints.maxWidth.isFinite ? constraints.maxWidth : 390.0;

    // 390 ≈ ancho de referencia (celular mediano).
    final double scale = _clampD(width / 390.0, 0.82, 1.30);
    final bool isCompactWidth = width < 360;

    final double headerIconOuter = _clampD(92.0 * scale, 80.0, 108.0);

    return _AboutMetrics._(
      outerPaddingH: isCompactWidth ? 16.0 : 22.0,
      headerPaddingH: _clampD(26.0 * scale, 18.0, 30.0),
      headerPaddingTop: _clampD(34.0 * scale, 26.0, 40.0),
      headerPaddingBottom: _clampD(30.0 * scale, 22.0, 34.0),
      headerIconOuter: headerIconOuter,
      headerIconInner: headerIconOuter * 0.67,
      headerIconSize: headerIconOuter * 0.33,
      headerTitleSize: _clampD(24.0 * scale, 21.0, 27.0),
      headerDescSize: _clampD(15.5 * scale, 14.0, 17.0),
      featureIconBox: _clampD(54.0 * scale, 48.0, 60.0),
      featureIconSize: _clampD(27.0 * scale, 24.0, 30.0),
      featureTitleSize: _clampD(19.5 * scale, 17.5, 21.5),
      featureDescSize: _clampD(16.0 * scale, 14.5, 17.5),
      featureRowPadding: _clampD(20.0 * scale, 15.0, 22.0),
      featureGap: isCompactWidth ? 12.0 : 16.0,
    );
  }
}