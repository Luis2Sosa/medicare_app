import 'package:flutter/material.dart';
import 'package:medicare_app/core/app_theme.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              const SizedBox(height: 10),

              // 🔵 TÍTULO
              const Text(
                "Historial de tratamientos",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.primaryBlue,
                ),
              ),

              const SizedBox(height: 20),

              // 🟦 LISTA DE TRATAMIENTOS (EJEMPLO)
              Expanded(
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  children: [
                    _historyCard(
                      medicamento: "Amoxicilina",
                      dosis: "1 tableta, cada 8 horas",
                      fecha: "24 de abril – 30 de abril",
                    ),
                    _historyCard(
                      medicamento: "Ibuprofeno",
                      dosis: "1 tableta, cada 12 horas",
                      fecha: "10 de mayo – 17 de mayo",
                    ),
                    _historyCard(
                      medicamento: "Loratadina",
                      dosis: "1 diaria",
                      fecha: "1 de marzo – 15 de marzo",
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

  // 🟦 TARJETA PREMIUM
  Widget _historyCard({
    required String medicamento,
    required String dosis,
    required String fecha,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            medicamento,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppTheme.primaryBlue,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            dosis,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            fecha,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
}
