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
  ];

  @override
  Widget build(BuildContext context) {
    final tomados = historyData.where((e) => e['tomado'] == true).length;
    final omitidos = historyData.length - tomados;

    return Container(
      decoration: const BoxDecoration(
        gradient: AppTheme.mainGradient,
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.white,
          foregroundColor: const Color(0xFF1E3A5F),
          elevation: 0,
          centerTitle: true,
          title: const Text(
            "Historial",
            style: TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 27,
            ),
          ),
        ),
        body: historyData.isEmpty
            ? _emptyState()
            : _buildList(tomados, omitidos),
      ),
    );
  }

  Widget _buildList(int tomados, int omitidos) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 14),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.45),
          ),
          child: Row(
            children: [
              _statBadge(
                icon: Icons.check_circle_rounded,
                count: tomados,
                label: "Tomados",
                color: const Color(0xFF10B981),
              ),
              const SizedBox(width: 12),
              _statBadge(
                icon: Icons.cancel_rounded,
                count: omitidos,
                label: "Omitidos",
                color: const Color(0xFFEF4444),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 90),
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
    return Expanded(
      child: Container(
        height: 86,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.92),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: color.withOpacity(0.55),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.12),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 34),
            const SizedBox(width: 12),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  count.toString(),
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w900,
                    color: color,
                    height: 1,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    color: color,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _historyCard(Map<String, dynamic> item) {
    final bool tomado = item['tomado'] ?? false;
    final Color mainColor =
    tomado ? const Color(0xFF10B981) : const Color(0xFFEF4444);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: mainColor.withOpacity(0.45),
          width: 2.2,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1E3A5F).withOpacity(0.08),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 58,
                height: 58,
                decoration: BoxDecoration(
                  color: mainColor,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  tomado ? Icons.check_rounded : Icons.close_rounded,
                  color: Colors.white,
                  size: 34,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item['medicamento'],
                      style: const TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF1E3A5F),
                        height: 1.1,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      item['fecha'],
                      style: const TextStyle(
                        fontSize: 18,
                        color: Color(0xFF5B7C99),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF3E0),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: const Color(0xFFFF9800),
                width: 2,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.access_time_rounded,
                  size: 27,
                  color: Color(0xFFF57C00),
                ),
                const SizedBox(width: 10),
                Text(
                  item['hora'],
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFFF57C00),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 11),
            decoration: BoxDecoration(
              color: mainColor.withOpacity(0.10),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: mainColor.withOpacity(0.45),
                width: 2,
              ),
            ),
            child: Text(
              tomado ? "MEDICAMENTO TOMADO" : "NO SE TOMÓ",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w900,
                color: mainColor,
                letterSpacing: 0.2,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _emptyState() {
    return Center(
      child: Container(
        margin: const EdgeInsets.all(28),
        padding: const EdgeInsets.all(26),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.94),
          borderRadius: BorderRadius.circular(26),
          border: Border.all(
            color: const Color(0xFF42A5F5),
            width: 2,
          ),
        ),
        child: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.history_rounded,
              size: 76,
              color: Color(0xFF1E3A5F),
            ),
            SizedBox(height: 18),
            Text(
              "Sin historial aún",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w900,
                color: Color(0xFF1E3A5F),
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),
            Text(
              "Aquí aparecerán tus medicamentos tomados u omitidos.",
              style: TextStyle(
                fontSize: 18,
                color: Color(0xFF5B7C99),
                fontWeight: FontWeight.w700,
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}