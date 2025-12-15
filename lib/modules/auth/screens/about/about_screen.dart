import 'package:flutter/material.dart';
import 'package:medicare_app/core/app_theme.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: AppTheme.mainGradient,
        ),
        child: Stack(
          children: [
            // ⭐ LOGO INDEPENDIENTE
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Center(
                child: Image.asset(
                  "assets/images/medicare_logo.png",
                  width: 270, // ← MAS GRANDE
                ),
              ),
            ),

            // ⭐ CONTENIDO FIJO AGRANDADO
            Positioned(
              top: 200, // ← BAJADO UN POCO POR EL LOGO MÁS GRANDE
              left: 25,
              right: 25,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [

                  // TÍTULO
                  const Text(
                    "Sobre MediCare",
                    style: TextStyle(
                      fontSize: 25,   // ← MÁS GRANDE
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.4,
                      color: AppTheme.primaryBlue,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 10),

                  // DESCRIPCIÓN 1
                  const Text(
                    "MediCare es una herramienta diseñada para ayudarte a mantener "
                        "tus medicamentos bajo control 📋💊.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,        // ← MÁS GRANDE
                      height: 1.6,
                      color: Colors.black87,
                    ),
                  ),

                  const SizedBox(height: 12),

                  // DESCRIPCIÓN 2
                  const Text(
                    "Nuestra misión es ofrecer una plataforma sencilla, clara y útil "
                        "para recordarte tus tratamientos y mejorar tu bienestar.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,        // ← MÁS GRANDE
                      height: 1.6,
                      color: Colors.black87,
                    ),
                  ),

                  const SizedBox(height: 22),

                  // ⭐ BENEFICIOS AGRANDADOS
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      _BenefitItem(text: "💊 Recordatorios exactos de medicamentos."),
                      _BenefitItem(text: "🕒 Organización clara de tus horarios."),
                      _BenefitItem(text: "🔔 Notificaciones fáciles de entender."),
                      _BenefitItem(text: "👴 Interfaz ideal para personas mayores."),
                      _BenefitItem(text: "❤️ Diseñada para cuidar de tu bienestar."),
                    ],
                  ),

                  const SizedBox(height: 32),

                  // ⭐ BOTÓN VOLVER (MÁS GRANDE Y BONITO)
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 230,       // MÁS GRANDE
                      height: 54,       // MÁS GRANDE
                      decoration: BoxDecoration(
                        color: AppTheme.primaryBlue,
                        borderRadius: BorderRadius.circular(30),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.20),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Text(
                          "Volver",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 19,          // ← MÁS GRANDE
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 25),

                  // FIRMA AGRANDADA
                  const Text(
                    "Sosa Tech Lab © 2025",
                    style: TextStyle(
                      color: AppTheme.primaryBlue,
                      fontSize: 17,               // ← MÁS GRANDE
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.4,
                    ),
                  ),

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ⭐ ÍTEM DE BENEFICIO
class _BenefitItem extends StatelessWidget {
  final String text;
  const _BenefitItem({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 18,               // ← MÁS GRANDE
          height: 1.4,
          color: AppTheme.primaryBlue,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
