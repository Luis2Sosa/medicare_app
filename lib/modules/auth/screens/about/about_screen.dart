import 'package:flutter/material.dart';
import 'package:medicare_app/core/app_theme.dart';

const Color _deepBlue = Color(0xFF123C66);
const Color _textBlue = Color(0xFF1E3A5F);
const Color _muted = Color(0xFF64748B);

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

class _AboutScreenState extends State<AboutScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

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
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7FAFD),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          color: AppTheme.primaryBlue,
          tooltip: "Volver",
          onPressed: () => Navigator.pop(context),
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
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(22, 28, 22, 28),
            child: Column(
              children: [
                _header(),
                const SizedBox(height: 30),
                _featuresCard(),
                const SizedBox(height: 34),
                _footer(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- Encabezado: tarjeta hero con halo e ícono, en el mismo
  // lenguaje visual (barra decorativa + jerarquía tipográfica) que
  // el resto de la app, para que se sienta como una sola marca.
  Widget _header() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(26, 34, 26, 30),
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
            height: 92,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 92,
                  height: 92,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.14),
                  ),
                ),
                Container(
                  width: 62,
                  height: 62,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.22),
                  ),
                  child: const Icon(
                    Icons.favorite_rounded,
                    size: 30,
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
          const Text(
            "Tu salud, siempre presente",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              letterSpacing: 0.3,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            "MediCare te ayuda a recordar tus medicamentos todos los días, de forma simple y sin complicaciones.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15.5,
              height: 1.55,
              color: Colors.white.withOpacity(0.92),
              letterSpacing: 0.1,
            ),
          ),
        ],
      ),
    );
  }

  // --- Lista de características: una sola tarjeta con renglones
  // y divisores finos, todos en la misma paleta de marca (en vez de
  // cuatro tarjetas sueltas con colores distintos cada una).
  Widget _featuresCard() {
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
            _featureRow(_features[i]),
            if (i != _features.length - 1)
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Divider(height: 1, thickness: 1, color: Color(0xFFE9EEF5)),
              ),
          ],
        ],
      ),
    );
  }

  Widget _featureRow(_FeatureData f) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: AppTheme.primaryBlue.withOpacity(0.10),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(f.icon, size: 27, color: AppTheme.primaryBlue),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  f.title,
                  style: const TextStyle(
                    fontSize: 19.5,
                    fontWeight: FontWeight.w800,
                    color: _textBlue,
                    letterSpacing: 0.1,
                  ),
                ),
                const SizedBox(height: 7),
                Text(
                  f.desc,
                  style: const TextStyle(
                    fontSize: 16,
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