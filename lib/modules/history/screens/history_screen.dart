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
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF2E5C8A),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Mi Historial",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
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
        // RESUMEN COMPACTO
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
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
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2E5C8A),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _statBadge(
                    icon: Icons.check_circle_rounded,
                    count: tomados,
                    label: "OK",
                    color: Colors.green,
                  ),
                  const SizedBox(width: 16),
                  _statBadge(
                    icon: Icons.cancel_rounded,
                    count: omitidos,
                    label: "NO",
                    color: Colors.red,
                  ),
                ],
              ),
            ],
          ),
        ),

        // LISTA
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                count.toString(),
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: color,
                  height: 1,
                ),
              ),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _historyCard(Map<String, dynamic> item) {
    final bool tomado = item['tomado'] ?? false;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: tomado
              ? [Colors.white, Colors.green.shade50.withOpacity(0.3)]
              : [Colors.white, Colors.red.shade50.withOpacity(0.3)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: tomado ? Colors.green.shade200 : Colors.red.shade200,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: (tomado ? Colors.green : Colors.red).withOpacity(0.12),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              // ÍCONO
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: tomado
                        ? [Colors.green.shade400, Colors.green.shade600]
                        : [Colors.red.shade400, Colors.red.shade600],
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: (tomado ? Colors.green : Colors.red).withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Icon(
                  tomado ? Icons.check_rounded : Icons.close_rounded,
                  color: Colors.white,
                  size: 24,
                ),
              ),

              const SizedBox(width: 14),

              // NOMBRE
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item['medicamento'],
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2E5C8A),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item['fecha'],
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

              // BADGE
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: tomado ? Colors.green : Colors.red,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: (tomado ? Colors.green : Colors.red).withOpacity(0.3),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Text(
                  tomado ? "✓" : "✗",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // HORA
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.orange.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.orange.shade200,
                width: 1.5,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.access_time_rounded,
                  size: 18,
                  color: Colors.orange.shade700,
                ),
                const SizedBox(width: 8),
                Text(
                  item['hora'],
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange.shade800,
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
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue.shade100, Colors.blue.shade50],
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.blue.shade200.withOpacity(0.5),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  )
                ],
              ),
              child: const Icon(
                Icons.history_outlined,
                size: 80,
                color: Color(0xFF2E5C8A),
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              "Sin historial aún",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2E5C8A),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              "Aquí verás el registro de\ntus medicamentos",
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
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