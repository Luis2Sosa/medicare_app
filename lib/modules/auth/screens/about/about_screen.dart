import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          color: const Color(0xFF1E3A5F),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Sobre MediCare",
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w900,
            color: Color(0xFF1E3A5F),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 28, 24, 32),
        child: Column(
          children: [
            _header(),
            const SizedBox(height: 36),

            _featureCard(
              icon: Icons.alarm_rounded,
              title: "Recordatorios inteligentes",
              desc: "Te avisa exactamente cuando debes tomar tus medicamentos.",
              color: const Color(0xFF3B82F6),
            ),
            _featureCard(
              icon: Icons.check_circle_rounded,
              title: "Control de dosis",
              desc: "Evita olvidos y duplicaciones peligrosas.",
              color: const Color(0xFF10B981),
            ),
            _featureCard(
              icon: Icons.history_rounded,
              title: "Historial médico",
              desc: "Consulta lo que ya tomaste y cuándo.",
              color: const Color(0xFFF59E0B),
            ),

            const SizedBox(height: 40),
            _backButton(context),
            const SizedBox(height: 28),
            _footer(),
          ],
        ),
      ),
    );
  }

  Widget _header() {
    return Column(
      children: const [
        Icon(Icons.medication_rounded, size: 80, color: Color(0xFF3B82F6)),
        SizedBox(height: 16),
        Text(
          "Tu salud primero",
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w900,
            color: Color(0xFF1E3A5F),
          ),
        ),
        SizedBox(height: 8),
        Text(
          "MediCare te ayuda a seguir tus tratamientos de forma segura, clara y organizada.",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 18,
            height: 1.4,
            color: Color(0xFF64748B),
          ),
        ),
      ],
    );
  }

  Widget _featureCard({
    required IconData icon,
    required String title,
    required String desc,
    required Color color,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(.12),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: color.withOpacity(.12),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, size: 34, color: color),
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF1E3A5F))),
                const SizedBox(height: 6),
                Text(desc,
                    style: const TextStyle(
                        fontSize: 16,
                        height: 1.4,
                        color: Color(0xFF64748B))),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _backButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 68,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF3B82F6),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
        ),
        onPressed: () => Navigator.pop(context),
        child: const Text(
          "Volver",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
        ),
      ),
    );
  }

  Widget _footer() {
    return const Text(
      "Sosa Tech Lab © 2025",
      style: TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: Color(0xFF94A3B8),
      ),
    );
  }
}
