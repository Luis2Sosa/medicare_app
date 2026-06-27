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

  static const String _soundKey = 'soundEnabled';
  static const String _vibrationKey = 'vibrationEnabled';
  static const String _ratedKey = 'hasRatedMediCare';

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      soundEnabled = prefs.getBool(_soundKey) ?? true;
      vibrationEnabled = prefs.getBool(_vibrationKey) ?? true;
      hasRatedApp = prefs.getBool(_ratedKey) ?? false;
    });
  }

  Future<void> _saveSoundPreference(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_soundKey, value);

    if (vibrationEnabled) {
      _triggerVibration();
    }
  }

  Future<void> _saveVibrationPreference(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_vibrationKey, value);

    if (value) {
      _triggerVibration();
    }
  }

  Future<void> _triggerVibration() async {
    try {
      await HapticFeedback.lightImpact();
    } catch (e) {
      // Vibration not available
    }
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
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 400;

    return Container(
      decoration: const BoxDecoration(
        gradient: AppTheme.mainGradient,
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              isSmallScreen ? 16 : 22,
              isSmallScreen ? 16 : 24,
              isSmallScreen ? 16 : 22,
              isSmallScreen ? 16 : 22,
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    _backButton(context, isSmallScreen),
                    SizedBox(width: isSmallScreen ? 10 : 14),
                    Expanded(
                      child: Text(
                        'Configuración',
                        style: TextStyle(
                          fontSize: isSmallScreen ? 24 : 30,
                          fontWeight: FontWeight.w900,
                          color: const Color(0xFF1E3A5F),
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: isSmallScreen ? 20 : 28),

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
                        isSmallScreen: isSmallScreen,
                        onChanged: (value) {
                          setState(() {
                            soundEnabled = value;
                          });
                          _saveSoundPreference(value);
                        },
                      ),

                      _switchCard(
                        icon: Icons.vibration_rounded,
                        title: 'Vibración',
                        subtitle: vibrationEnabled
                            ? 'Vibración activada'
                            : 'Vibración desactivada',
                        value: vibrationEnabled,
                        isSmallScreen: isSmallScreen,
                        onChanged: (value) {
                          setState(() {
                            vibrationEnabled = value;
                          });
                          _saveVibrationPreference(value);
                        },
                      ),

                      _exitCard(context, isSmallScreen),

                      SizedBox(height: isSmallScreen ? 6 : 8),

                      _privacyInfoCard(isSmallScreen),

                      SizedBox(height: isSmallScreen ? 16 : 22),

                      hasRatedApp
                          ? _thanksBanner(isSmallScreen)
                          : _rateAppBanner(context, isSmallScreen),
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

  Widget _backButton(BuildContext context, bool isSmallScreen) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        width: isSmallScreen ? 40 : 48,
        height: isSmallScreen ? 40 : 48,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: const Color(0xFFD7EAFB),
            width: 2,
          ),
        ),
        child: Icon(
          Icons.arrow_back_rounded,
          color: const Color(0xFF1976D2),
          size: isSmallScreen ? 20 : 28,
        ),
      ),
    );
  }

  Widget _switchCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required bool isSmallScreen,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: isSmallScreen ? 12 : 16),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: isSmallScreen ? 14 : 18,
            vertical: isSmallScreen ? 14 : 18,
          ),
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
                width: isSmallScreen ? 44 : 54,
                height: isSmallScreen ? 44 : 54,
                decoration: const BoxDecoration(
                  color: Color(0xFFE3F2FD),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: const Color(0xFF1976D2),
                  size: isSmallScreen ? 22 : 30,
                ),
              ),
              SizedBox(width: isSmallScreen ? 12 : 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: isSmallScreen ? 17 : 21,
                        fontWeight: FontWeight.w900,
                        color: const Color(0xFF1E3A5F),
                      ),
                    ),
                    SizedBox(height: isSmallScreen ? 3 : 5),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: isSmallScreen ? 13 : 16,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ),
              Transform.scale(
                scale: isSmallScreen ? 0.8 : 1.0,
                child: Switch(
                  value: value,
                  activeColor: const Color(0xFF1976D2),
                  onChanged: onChanged,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _exitCard(BuildContext context, bool isSmallScreen) {
    return Container(
      margin: EdgeInsets.only(bottom: isSmallScreen ? 12 : 16),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: () {
            SystemNavigator.pop();
          },
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: isSmallScreen ? 14 : 18,
              vertical: isSmallScreen ? 14 : 18,
            ),
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
                  width: isSmallScreen ? 44 : 54,
                  height: isSmallScreen ? 44 : 54,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFFEBEE),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.logout_rounded,
                    color: const Color(0xFFE53935),
                    size: isSmallScreen ? 22 : 30,
                  ),
                ),
                SizedBox(width: isSmallScreen ? 12 : 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Salir',
                        style: TextStyle(
                          fontSize: isSmallScreen ? 17 : 21,
                          fontWeight: FontWeight.w900,
                          color: const Color(0xFF1E3A5F),
                        ),
                      ),
                      SizedBox(height: isSmallScreen ? 3 : 5),
                      Text(
                        'Salir de MediCare',
                        style: TextStyle(
                          fontSize: isSmallScreen ? 13 : 16,
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
                  size: isSmallScreen ? 16 : 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _privacyInfoCard(bool isSmallScreen) {
    return Container(
      padding: EdgeInsets.all(isSmallScreen ? 14 : 18),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.70),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.85),
          width: 1.5,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.lock_rounded,
            color: const Color(0xFF1976D2),
            size: isSmallScreen ? 22 : 28,
          ),
          SizedBox(width: isSmallScreen ? 10 : 14),
          Expanded(
            child: Text(
              'Tus medicamentos se guardan de forma local en este dispositivo.',
              style: TextStyle(
                fontSize: isSmallScreen ? 14 : 16,
                height: 1.35,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF1E3A5F),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _rateAppBanner(BuildContext context, bool isSmallScreen) {
    return Container(
      padding: EdgeInsets.all(isSmallScreen ? 14 : 18),
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
          Text(
            '⭐⭐⭐⭐⭐',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: isSmallScreen ? 20 : 26,
              letterSpacing: 2,
            ),
          ),
          SizedBox(height: isSmallScreen ? 8 : 10),
          Text(
            '¿Qué te parece MediCare?',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: isSmallScreen ? 16 : 20,
              fontWeight: FontWeight.w900,
              color: const Color(0xFF1E3A5F),
            ),
          ),
          SizedBox(height: isSmallScreen ? 6 : 8),
          Text(
            'Tu opinión nos ayuda a mejorar y a que más personas descubran la aplicación.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: isSmallScreen ? 13 : 15,
              height: 1.35,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF64748B),
            ),
          ),
          SizedBox(height: isSmallScreen ? 12 : 16),
          SizedBox(
            width: double.infinity,
            height: isSmallScreen ? 42 : 48,
            child: ElevatedButton.icon(
              onPressed: _rateApp,
              icon: Icon(
                Icons.star_rate_rounded,
                size: isSmallScreen ? 16 : 20,
              ),
              label: Text(
                'Calificar aplicación',
                style: TextStyle(
                  fontSize: isSmallScreen ? 14 : 16,
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

  Widget _thanksBanner(bool isSmallScreen) {
    return Container(
      padding: EdgeInsets.all(isSmallScreen ? 14 : 18),
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
          Icon(
            Icons.favorite_rounded,
            color: const Color(0xFFE53935),
            size: isSmallScreen ? 36 : 46,
          ),
          SizedBox(height: isSmallScreen ? 8 : 10),
          Text(
            '¡Muchas gracias!',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: isSmallScreen ? 18 : 22,
              fontWeight: FontWeight.w900,
              color: const Color(0xFF1E3A5F),
            ),
          ),
          SizedBox(height: isSmallScreen ? 6 : 8),
          Text(
            'Gracias por apoyar MediCare. Tu valoración nos ayuda a seguir mejorando la aplicación.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: isSmallScreen ? 13 : 15,
              height: 1.35,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF64748B),
            ),
          ),
          SizedBox(height: isSmallScreen ? 10 : 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.check_circle_rounded,
                color: const Color(0xFF10B981),
                size: isSmallScreen ? 20 : 24,
              ),
              SizedBox(width: isSmallScreen ? 6 : 8),
              Text(
                'Aplicación calificada',
                style: TextStyle(
                  fontSize: isSmallScreen ? 14 : 16,
                  fontWeight: FontWeight.w900,
                  color: const Color(0xFF10B981),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}