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
  bool soundEnabled = true;
  bool vibrationEnabled = true;
  bool hasRatedApp = false;

  static const String _ratedKey = 'hasRatedMediCare';

  @override
  void initState() {
    super.initState();
    _loadRatedState();
  }

  Future<void> _loadRatedState() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      hasRatedApp = prefs.getBool(_ratedKey) ?? false;
    });
  }

  Future<void> _rateApp() async {
    final prefs = await SharedPreferences.getInstance();

    const packageName = 'com.sosatechlab.medicare_app';

    final playStoreUri = Uri.parse(
      'market://details?id=$packageName',
    );

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
          child: Padding(
            padding: const EdgeInsets.fromLTRB(22, 24, 22, 22),
            child: Column(
              children: [
                Row(
                  children: [
                    _backButton(context),
                    const SizedBox(width: 14),
                    const Expanded(
                      child: Text(
                        'Configuración',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF1E3A5F),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 28),

                Expanded(
                  child: ListView(
                    children: [
                      _switchCard(
                        icon: Icons.volume_up_rounded,
                        title: 'Sonido',
                        subtitle: soundEnabled
                            ? 'Sonido activado'
                            : 'Sonido desactivado',
                        value: soundEnabled,
                        onChanged: (value) {
                          setState(() {
                            soundEnabled = value;
                          });
                        },
                      ),

                      _switchCard(
                        icon: Icons.vibration_rounded,
                        title: 'Vibración',
                        subtitle: vibrationEnabled
                            ? 'Vibración activada'
                            : 'Vibración desactivada',
                        value: vibrationEnabled,
                        onChanged: (value) {
                          setState(() {
                            vibrationEnabled = value;
                          });
                        },
                      ),

                      _exitCard(context),

                      const SizedBox(height: 8),

                      _privacyInfoCard(),

                      const SizedBox(height: 22),

                      hasRatedApp
                          ? _thanksBanner()
                          : _rateAppBanner(context),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _backButton(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: const Color(0xFFD7EAFB),
            width: 2,
          ),
        ),
        child: const Icon(
          Icons.arrow_back_rounded,
          color: Color(0xFF1976D2),
          size: 28,
        ),
      ),
    );
  }

  Widget _switchCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: const Color(0xFFD7EAFB),
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.06),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 54,
                height: 54,
                decoration: const BoxDecoration(
                  color: Color(0xFFE3F2FD),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: const Color(0xFF1976D2),
                  size: 30,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF1E3A5F),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ),
              Switch(
                value: value,
                activeColor: const Color(0xFF1976D2),
                onChanged: onChanged,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _exitCard(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: () {
            SystemNavigator.pop();
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: const Color(0xFFD7EAFB),
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 16,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 54,
                  height: 54,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFFEBEE),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.logout_rounded,
                    color: Color(0xFFE53935),
                    size: 30,
                  ),
                ),
                const SizedBox(width: 16),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Salir',
                        style: TextStyle(
                          fontSize: 21,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF1E3A5F),
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        'Salir de MediCare',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Color(0xFF94A3B8),
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _privacyInfoCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.70),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.85),
          width: 1.5,
        ),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.lock_rounded,
            color: Color(0xFF1976D2),
            size: 28,
          ),
          SizedBox(width: 14),
          Expanded(
            child: Text(
              'Tus medicamentos se guardan de forma local en este dispositivo.',
              style: TextStyle(
                fontSize: 16,
                height: 1.35,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1E3A5F),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _rateAppBanner(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.72),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.90),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          const Text(
            '⭐⭐⭐⭐⭐',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 26,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            '¿Qué te parece MediCare?',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w900,
              color: Color(0xFF1E3A5F),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Tu opinión nos ayuda a mejorar y a que más personas descubran la aplicación.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              height: 1.35,
              fontWeight: FontWeight.w700,
              color: Color(0xFF64748B),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Esta función estará disponible cuando MediCare sea publicada en Google Play.',
                    ),
                    duration: Duration(seconds: 3),
                  ),
                );
              },
              icon: const Icon(
                Icons.star_rate_rounded,
                size: 20,
              ),
              label: const Text(
                'Calificar aplicación',
                style: TextStyle(
                  fontSize: 16,
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

  Widget _thanksBanner() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.72),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.90),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: const Column(
        children: [
          Icon(
            Icons.favorite_rounded,
            color: Color(0xFFE53935),
            size: 46,
          ),
          SizedBox(height: 10),
          Text(
            '¡Muchas gracias!',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              color: Color(0xFF1E3A5F),
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Gracias por apoyar MediCare. Tu valoración nos ayuda a seguir mejorando la aplicación.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              height: 1.35,
              fontWeight: FontWeight.w700,
              color: Color(0xFF64748B),
            ),
          ),
          SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.check_circle_rounded,
                color: Color(0xFF10B981),
                size: 24,
              ),
              SizedBox(width: 8),
              Text(
                'Aplicación calificada',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF10B981),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}