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
              title: "Alertas médicas automáticas",
              desc: "Notificaciones precisas para que nunca olvides una dosis.",
              color: const Color(0xFF3B82F6),
            ),
            _featureCard(
              icon: Icons.verified_user_rounded,
              title: "Control seguro de tratamientos",
              desc: "Evita errores, sobredosis y riesgos innecesarios.",
              color: const Color(0xFF10B981),
            ),
            _featureCard(
              icon: Icons.event_note_rounded,
              title: "Historial clínico personal",
              desc: "Revisa tus tomas anteriores de forma clara y confiable.",
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
    return Container(
      padding: const EdgeInsets.all(26),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF3B82F6), Color(0xFF1E40AF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        children: const [
          Icon(Icons.favorite_rounded, size: 64, color: Colors.white),
          SizedBox(height: 16),
          Text(
            "Tu salud primero",
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w900,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 10),
          Text(
            "MediCare protege tu tratamiento, evita errores y te acompaña cada día.",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              height: 1.4,
              color: Colors.white70,
            ),
          ),
        ],
      ),
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
        borderRadius: BorderRadius.circular(26),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(.18),
            blurRadius: 26,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: color.withOpacity(.12),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Icon(icon, size: 36, color: color),
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
      height: 70,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: 12,
          backgroundColor: const Color(0xFF1D4ED8),
          shadowColor: const Color(0xFF3B82F6),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(26),
          ),
        ),
        onPressed: () => Navigator.pop(context),
        child: const Text(
          "Volver",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w900,
            color: Colors.white,
            letterSpacing: .5,
          ),
        ),
      ),
    );
  }

  Widget _footer() {
    return const Text(
      "Sosa Tech Lab — Health Software",
      style: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: Color(0xFF94A3B8),
        letterSpacing: .4,
      ),
    );
  }
}
