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
                      _infoCard(
                        icon: Icons.notifications_active_rounded,
                        iconColor: const Color(0xFF1976D2),
                        iconBackground: const Color(0xFFE3F2FD),
                        title: 'Recordatorios activos',
                        subtitle:
                        'MediCare enviará notificaciones cuando sea hora de tomar tus medicamentos.',
                        isSmallScreen: isSmallScreen,
                      ),

                      _infoCard(
                        icon: Icons.volume_up_rounded,
                        iconColor: const Color(0xFF1976D2),
                        iconBackground: const Color(0xFFE3F2FD),
                        title: 'Sonido del teléfono',
                        subtitle:
                        'Las notificaciones usan el sonido configurado en tu dispositivo.',
                        isSmallScreen: isSmallScreen,
                      ),

                      _infoCard(
                        icon: Icons.lock_rounded,
                        iconColor: const Color(0xFF1976D2),
                        iconBackground: const Color(0xFFE3F2FD),
                        title: 'Privacidad',
                        subtitle:
                        'Tus medicamentos se guardan de forma local en este dispositivo.',
                        isSmallScreen: isSmallScreen,
                      ),

                      _exitCard(context, isSmallScreen),

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

  Widget _infoCard({
    required IconData icon,
    required Color iconColor,
    required Color iconBackground,
    required String title,
    required String subtitle,
    required bool isSmallScreen,
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: isSmallScreen ? 44 : 54,
                height: isSmallScreen ? 44 : 54,
                decoration: BoxDecoration(
                  color: iconBackground,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: iconColor,
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
                    SizedBox(height: isSmallScreen ? 4 : 6),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: isSmallScreen ? 13 : 16,
                        height: 1.35,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF64748B),
                      ),
                    ),
                  ],
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
                    color: Color(0xFFE53935),
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