import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:medicare_app/core/app_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool hasRatedApp = false;

  static const String _ratedKey = 'hasRatedMediCare';

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();

    if (!mounted) return;

    setState(() {
      hasRatedApp = prefs.getBool(_ratedKey) ?? false;
    });
  }

  Future<void> _rateApp() async {
    final prefs = await SharedPreferences.getInstance();

    const packageName = 'com.sosatechlab.medicare_app';

    final playStoreUri = Uri.parse('market://details?id=$packageName');

    final webUri = Uri.parse(
      'https://play.google.com/store/apps/details?id=$packageName',
    );

    try {
      if (await canLaunchUrl(playStoreUri)) {
        await launchUrl(playStoreUri);
      } else {
        await launchUrl(
          webUri,
          mode: LaunchMode.externalApplication,
        );
      }

      await prefs.setBool(_ratedKey, true);

      if (!mounted) return;

      setState(() {
        hasRatedApp = true;
      });
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'No se pudo abrir Google Play. Inténtalo más tarde.',
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: AppTheme.mainGradient,
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final r = _Responsive(constraints.maxWidth);

              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: EdgeInsets.fromLTRB(
                  r.scale(16),
                  r.scale(16),
                  r.scale(16),
                  r.scale(18),
                ),
                child: Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: r.maxContentWidth,
                    ),
                    child: Column(
                      children: [
                        _header(context, r),
                        SizedBox(height: r.scale(14)),

                        _settingsCard(
                          icon: Icons.notifications_active_rounded,
                          iconColor: const Color(0xFF1976D2),
                          iconBackground: const Color(0xFFE3F2FD),
                          title: 'Recordatorios',
                          subtitle:
                          'Recibirás avisos cuando sea hora de tomar tus medicamentos.',
                          r: r,
                        ),

                        _settingsCard(
                          icon: Icons.volume_up_rounded,
                          iconColor: const Color(0xFF1976D2),
                          iconBackground: const Color(0xFFE3F2FD),
                          title: 'Sonido',
                          subtitle:
                          'Las alertas usan el sonido configurado en tu teléfono.',
                          r: r,
                        ),

                        _settingsCard(
                          icon: Icons.lock_rounded,
                          iconColor: const Color(0xFF1976D2),
                          iconBackground: const Color(0xFFE3F2FD),
                          title: 'Privacidad',
                          subtitle:
                          'Tus medicamentos se guardan solo en este dispositivo.',
                          r: r,
                        ),

                        _exitCard(context, r),

                        SizedBox(height: r.scale(8)),

                        hasRatedApp
                            ? _thanksBanner(r)
                            : _rateAppBanner(r),
                      ],
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

  Widget _header(BuildContext context, _Responsive r) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: r.scale(14),
        vertical: r.scale(14),
      ),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.72),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: const Color(0xFFD7EAFB),
          width: 1.4,
        ),
      ),
      child: Row(
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              width: r.scale(44),
              height: r.scale(44),
              decoration: BoxDecoration(
                color: const Color(0xFFE3F2FD),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                Icons.arrow_back_rounded,
                color: const Color(0xFF1976D2),
                size: r.scale(25),
              ),
            ),
          ),

          SizedBox(width: r.scale(12)),

          Expanded(
            child: Text(
              'Configuración',
              style: TextStyle(
                fontSize: r.font(28),
                fontWeight: FontWeight.w900,
                color: const Color(0xFF1E3A5F),
                letterSpacing: -0.2,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _settingsCard({
    required IconData icon,
    required Color iconColor,
    required Color iconBackground,
    required String title,
    required String subtitle,
    required _Responsive r,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: r.scale(10)),
      padding: EdgeInsets.all(r.scale(14)),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: const Color(0xFFD7EAFB),
          width: 1.7,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.055),
            blurRadius: 16,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: r.scale(48),
            height: r.scale(48),
            decoration: BoxDecoration(
              color: iconBackground,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: r.scale(27),
            ),
          ),

          SizedBox(width: r.scale(12)),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: r.font(19),
                    fontWeight: FontWeight.w900,
                    color: const Color(0xFF1E3A5F),
                  ),
                ),
                SizedBox(height: r.scale(3)),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: r.font(14),
                    height: 1.3,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF64748B),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _exitCard(BuildContext context, _Responsive r) {
    return Container(
      margin: EdgeInsets.only(bottom: r.scale(10)),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(22),
          onTap: () {
            SystemNavigator.pop();
          },
          child: Container(
            padding: EdgeInsets.all(r.scale(14)),
            decoration: BoxDecoration(
              color: const Color(0xFFFFFBFB),
              borderRadius: BorderRadius.circular(22),
              border: Border.all(
                color: const Color(0xFFFFCDD2),
                width: 1.7,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.055),
                  blurRadius: 16,
                  offset: const Offset(0, 7),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: r.scale(48),
                  height: r.scale(48),
                  decoration: const BoxDecoration(
                    color: Color(0xFFFFEBEE),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.logout_rounded,
                    color: const Color(0xFFE53935),
                    size: r.scale(27),
                  ),
                ),

                SizedBox(width: r.scale(12)),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Salir',
                        style: TextStyle(
                          fontSize: r.font(19),
                          fontWeight: FontWeight.w900,
                          color: const Color(0xFF1E3A5F),
                        ),
                      ),
                      SizedBox(height: r.scale(3)),
                      Text(
                        'Cerrar MediCare',
                        style: TextStyle(
                          fontSize: r.font(14),
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                ),

                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: const Color(0xFF94A3B8),
                  size: r.scale(17),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _rateAppBanner(_Responsive r) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(r.scale(16)),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.76),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Colors.white.withOpacity(0.95),
          width: 1.4,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.055),
            blurRadius: 16,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            '⭐⭐⭐⭐⭐',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: r.font(22),
              letterSpacing: 1.8,
            ),
          ),

          SizedBox(height: r.scale(8)),

          Text(
            '¿Te gusta MediCare?',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: r.font(20),
              fontWeight: FontWeight.w900,
              color: const Color(0xFF1E3A5F),
            ),
          ),

          SizedBox(height: r.scale(5)),

          Text(
            'Tu opinión nos ayuda a mejorar.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: r.font(14),
              height: 1.3,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF64748B),
            ),
          ),

          SizedBox(height: r.scale(12)),

          SizedBox(
            width: double.infinity,
            height: r.scale(48),
            child: ElevatedButton.icon(
              onPressed: _rateApp,
              icon: Icon(
                Icons.star_rate_rounded,
                size: r.scale(20),
              ),
              label: Text(
                'Calificar aplicación',
                style: TextStyle(
                  fontSize: r.font(16),
                  fontWeight: FontWeight.w900,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1976D2),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _thanksBanner(_Responsive r) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(r.scale(16)),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.76),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Colors.white.withOpacity(0.95),
          width: 1.4,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.055),
            blurRadius: 16,
            offset: const Offset(0, 7),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(
            Icons.favorite_rounded,
            color: const Color(0xFFE53935),
            size: r.scale(38),
          ),

          SizedBox(height: r.scale(8)),

          Text(
            '¡Muchas gracias!',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: r.font(20),
              fontWeight: FontWeight.w900,
              color: const Color(0xFF1E3A5F),
            ),
          ),

          SizedBox(height: r.scale(5)),

          Text(
            'Gracias por apoyar MediCare.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: r.font(14),
              height: 1.3,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF64748B),
            ),
          ),

          SizedBox(height: r.scale(10)),

          Container(
            padding: EdgeInsets.symmetric(
              horizontal: r.scale(12),
              vertical: r.scale(8),
            ),
            decoration: BoxDecoration(
              color: const Color(0xFFE8F8F1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.check_circle_rounded,
                  color: const Color(0xFF10B981),
                  size: r.scale(20),
                ),
                SizedBox(width: r.scale(6)),
                Text(
                  'Aplicación calificada',
                  style: TextStyle(
                    fontSize: r.font(14),
                    fontWeight: FontWeight.w900,
                    color: const Color(0xFF10B981),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Responsive {
  final double width;

  const _Responsive(this.width);

  bool get isTablet => width >= 600;

  double get maxContentWidth => isTablet ? 520 : double.infinity;

  double get _factor => _clamp(width / 390, 0.86, 1.16);

  double scale(double base) => base * _factor;

  double font(double base) {
    final eased = 1 + (_factor - 1) * 0.55;
    return base * _clamp(eased, 0.9, 1.12);
  }

  static double _clamp(double value, double min, double max) {
    if (value < min) return min;
    if (value > max) return max;
    return value;
  }
}