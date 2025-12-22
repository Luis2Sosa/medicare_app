import 'package:flutter/material.dart';
import 'package:medicare_app/core/app_theme.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  static final List<Map<String, dynamic>> historyData = [
    {
      'medicamento': 'Amoxicilina',
      'fecha': '24 de abril',
      'hora': '9:00 AM',
      'tomado': true,
    },
    {
      'medicamento': 'Ibuprofeno',
      'fecha': '24 de abril',
      'hora': '2:00 PM',
      'tomado': true,
    },
    {
      'medicamento': 'Amoxicilina',
      'fecha': '24 de abril',
      'hora': '5:00 PM',
      'tomado': false,
    },
    {
      'medicamento': 'Loratadina',
      'fecha': '23 de abril',
      'hora': '9:00 PM',
      'tomado': true,
    },
    {
      'medicamento': 'Amoxicilina',
      'fecha': '23 de abril',
      'hora': '9:00 AM',
      'tomado': true,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final tomados = historyData.where((e) => e['tomado'] == true).length;
    final omitidos = historyData.length - tomados;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF1E3A5F),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Mi Historial",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 26,
            letterSpacing: 0.3,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            color: Colors.grey.shade200,
            height: 1,
          ),
        ),
      ),
      body: historyData.isEmpty ? _emptyState() : _buildList(tomados, omitidos),
    );
  }

  Widget _buildList(int tomados, int omitidos) {
    return Column(
      children: [
        // RESUMEN MÁS GRANDE Y CLARO
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue.shade50, Colors.white],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Column(
            children: [
              const Text(
                "Tu seguimiento",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1E3A5F),
                  letterSpacing: 0.3,
                ),
              ),
              const SizedBox(height: 18),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _statBadge(
                    icon: Icons.check_circle_rounded,
                    count: tomados,
                    label: "Tomados",
                    color: const Color(0xFF10B981),
                  ),
                  const SizedBox(width: 20),
                  _statBadge(
                    icon: Icons.cancel_rounded,
                    count: omitidos,
                    label: "Omitidos",
                    color: const Color(0xFFEF4444),
                  ),
                ],
              ),
            ],
          ),
        ),

        // LISTA CON ESPACIADO GENEROSO
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: historyData.length,
            itemBuilder: (context, index) {
              return _historyCard(historyData[index]);
            },
          ),
        ),
      ],
    );
  }

  Widget _statBadge({
    required IconData icon,
    required int count,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: color,
          width: 3,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.15),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 40),
          const SizedBox(height: 8),
          Text(
            count.toString(),
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w900,
              color: color,
              height: 1,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: color,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }

  Widget _historyCard(Map<String, dynamic> item) {
    final bool tomado = item['tomado'] ?? false;
    final Color mainColor = tomado ? const Color(0xFF10B981) : const Color(0xFFEF4444);

    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: mainColor.withOpacity(0.3),
          width: 2.5,
        ),
        boxShadow: [
          BoxShadow(
            color: mainColor.withOpacity(0.08),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              // ÍCONO GRANDE Y CLARO
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: mainColor,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: mainColor.withOpacity(0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(
                  tomado ? Icons.check_rounded : Icons.close_rounded,
                  color: Colors.white,
                  size: 36,
                ),
              ),

              const SizedBox(width: 18),

              // NOMBRE DEL MEDICAMENTO MÁS GRANDE
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item['medicamento'],
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E3A5F),
                        letterSpacing: 0.2,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      item['fecha'],
                      style: TextStyle(
                        fontSize: 17,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // HORA MÁS PROMINENTE
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color(0xFFFBBF24).withOpacity(0.15),
                  const Color(0xFFF59E0B).withOpacity(0.08),
                ],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: const Color(0xFFF59E0B),
                width: 2,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.access_time_rounded,
                  size: 28,
                  color: Color(0xFFD97706),
                ),
                const SizedBox(width: 12),
                Text(
                  item['hora'],
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFD97706),
                    letterSpacing: 0.3,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 14),

          // ESTADO MÁS CLARO
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: mainColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: mainColor.withOpacity(0.4),
                width: 2,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  tomado ? Icons.check_circle : Icons.cancel,
                  color: mainColor,
                  size: 24,
                ),
                const SizedBox(width: 10),
                Text(
                  tomado ? "MEDICAMENTO TOMADO" : "NO SE TOMÓ",
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w900,
                    color: mainColor,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _emptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(40),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue.shade100, Colors.blue.shade50],
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.shade200.withOpacity(0.5),
                    blurRadius: 24,
                    offset: const Offset(0, 8),
                  )
                ],
              ),
              child: const Icon(
                Icons.history_outlined,
                size: 100,
                color: Color(0xFF1E3A5F),
              ),
            ),
            const SizedBox(height: 40),
            const Text(
              "Sin historial aún",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E3A5F),
                letterSpacing: 0.3,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Text(
              "Aquí verás el registro de\ntus medicamentos",
              style: TextStyle(
                fontSize: 20,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}