import 'package:flutter/material.dart';
import 'package:medicare_app/core/app_theme.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFB),
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF1E3A5F),
        centerTitle: true,
        elevation: 0,
        title: const Text(
          "Sobre MediCare",
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.3,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 22),
          onPressed: () => Navigator.pop(context),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            color: const Color(0xFFE8EEF2),
            height: 1,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [


              // TARJETA DE DESCRIPCIÓN
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: const Color(0xFF42A5F5).withOpacity(0.3),
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF42A5F5).withOpacity(0.08),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // ÍCONO PRINCIPAL
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFF42A5F5),
                            Color(0xFF1E88E5),
                          ],
                        ),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF42A5F5).withOpacity(0.3),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.medical_services_rounded,
                        size: 48,
                        color: Colors.white,
                      ),
                    ),

                    const SizedBox(height: 20),

                    // DESCRIPCIÓN 1
                    const Text(
                      "MediCare es una herramienta diseñada para ayudarte a mantener tus medicamentos bajo control 📋💊",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        height: 1.6,
                        color: Color(0xFF1E3A5F),
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 16),

                    // DESCRIPCIÓN 2
                    const Text(
                      "Nuestra misión es ofrecer una plataforma sencilla, clara y útil para recordarte tus tratamientos y mejorar tu bienestar.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 19,
                        height: 1.6,
                        color: Color(0xFF5B7C99),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // BENEFICIOS EN TARJETAS INDIVIDUALES
              _benefitCard(
                icon: Icons.medication_rounded,
                text: "Recordatorios exactos de medicamentos",
                color: const Color(0xFF42A5F5),
              ),
              const SizedBox(height: 14),
              _benefitCard(
                icon: Icons.access_time_rounded,
                text: "Organización clara de tus horarios",
                color: const Color(0xFF66BB6A),
              ),
              const SizedBox(height: 14),
              _benefitCard(
                icon: Icons.notifications_active_rounded,
                text: "Notificaciones fáciles de entender",
                color: const Color(0xFFFFA726),
              ),
              const SizedBox(height: 14),
              _benefitCard(
                icon: Icons.favorite_rounded,
                text: "Interfaz ideal para personas mayores",
                color: const Color(0xFFEF5350),
              ),
              const SizedBox(height: 14),
              _benefitCard(
                icon: Icons.health_and_safety_rounded,
                text: "Diseñada para cuidar de tu bienestar",
                color: const Color(0xFFAB47BC),
              ),

              const SizedBox(height: 32),

              // BOTÓN VOLVER GRANDE
              SizedBox(
                width: double.infinity,
                height: 64,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF42A5F5),
                    elevation: 6,
                    shadowColor: const Color(0xFF42A5F5).withOpacity(0.4),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    "Volver",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.3,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // FIRMA
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: const Color(0xFF42A5F5).withOpacity(0.2),
                    width: 2,
                  ),
                ),
                child: const Text(
                  "Sosa Tech Lab © 2025",
                  style: TextStyle(
                    color: Color(0xFF42A5F5),
                    fontSize: 19,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.3,
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _benefitCard({
    required IconData icon,
    required String text,
    required Color color,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 28,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 18,
                height: 1.4,
                color: Color(0xFF1E3A5F),
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}