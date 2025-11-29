import 'package:flutter/material.dart';
import 'package:medicare_app/core/app_theme.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [

          // =====================================================
          // 🔵 FONDO CON DEGRADADO
          // =====================================================
          Container(
            decoration: const BoxDecoration(
              gradient: AppTheme.mainGradient,
            ),
          ),

          // =====================================================
          // 🔵 LOGO INDEPENDIENTE (NO AFECTA NADA DEL LAYOUT)
          // =====================================================
          Positioned(
            top: 50,
            left: 0,
            right: 0,
            child: Center(
              child: Image.asset(
                "assets/images/medicare_logo.png",
                width: 600,
              ),
            ),
          ),

          // =====================================================
          // 🔵 SLOGAN EN LETRA CURSIVA (AZUL)
          // =====================================================
          Positioned(
            top: 370,
            left: 0,
            right: 0,
            child: const Center(
              child: Text(
                "Tu recordatorio médico, siempre a tiempo.",
                style: TextStyle(
                  fontSize: 18,
                  fontStyle: FontStyle.italic, // ← AQUÍ EL CAMBIO
                  fontWeight: FontWeight.w500,
                  color: AppTheme.primaryBlue,
                ),
              ),
            ),
          ),

          // =====================================================
          // 🔵 BOTONES CENTRADOS
          // =====================================================
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                const SizedBox(height: 380),

                // 🟩 BOTÓN GOOGLE PREMIUM (CENTRADO)
                _googleButton(),

                const SizedBox(height: 35),

                // 🔘 BOTÓN SOBRE MEDICARE (MEJORADO)
                _aboutButton(context),

              ],
            ),
          ),
        ],
      ),
    );
  }

  // =====================================================
  // 🔵 BOTÓN GOOGLE PREMIUM (ICONO A LA IZQUIERDA)
  // =====================================================
  Widget _googleButton() {
    return Container(
      width: 330,
      height: 58,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            offset: const Offset(0, 3),
            blurRadius: 8,
          ),
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(30),
        onTap: () {},
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center, // ← CENTRADO REAL
          children: [
            Image.asset(
              "assets/images/google.png",
              width: 26,
            ),
            const SizedBox(width: 12),
            const Text(
              "Entrar con Google",
              style: TextStyle(
                color: Colors.black87,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // =====================================================
// 🔵 BOTÓN SOBRE MEDICARE (EMBELLECIDO + onTap)
// =====================================================
  Widget _aboutButton(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(30),
      onTap: () {
        Navigator.pushNamed(context, "/about");
      },
      child: Container(
        width: 260,
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30), // ← MÁS PREMIUM
          border: Border.all(
            color: AppTheme.primaryBlue,
            width: 2,                       // ← MÁS DEFINIDO
          ),
          color: Colors.white.withOpacity(0.10), // ← SUAVE FONDO TRANSPARENTE
        ),
        child: const Center(
          child: Text(
            "Sobre MediCare",
            style: TextStyle(
              color: AppTheme.primaryBlue,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }


}
