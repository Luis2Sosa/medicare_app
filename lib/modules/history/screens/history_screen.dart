import 'package:flutter/material.dart';
import 'package:medicare_app/core/app_theme.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  String selectedFilter = "Todos"; // Todos, Completados, Omitidos

  // TODO: Reemplazar con datos reales desde un servicio
  final List<Map<String, dynamic>> historyData = [
    {
      'medicamento': 'Amoxicilina',
      'dosis': '1 tableta',
      'frecuencia': 'Cada 8 horas',
      'fechaInicio': '24 de abril',
      'fechaFin': '30 de abril',
      'tomasTotales': 21,
      'tomasCompletadas': 21,
      'estado': 'Completado',
    },
    {
      'medicamento': 'Ibuprofeno',
      'dosis': '1 tableta',
      'frecuencia': 'Cada 12 horas',
      'fechaInicio': '10 de mayo',
      'fechaFin': '17 de mayo',
      'tomasTotales': 14,
      'tomasCompletadas': 12,
      'estado': 'Completado',
    },
    {
      'medicamento': 'Loratadina',
      'dosis': '1 tableta',
      'frecuencia': '1 diaria',
      'fechaInicio': '1 de marzo',
      'fechaFin': '15 de marzo',
      'tomasTotales': 15,
      'tomasCompletadas': 14,
      'estado': 'Completado',
    },
  ];

  List<Map<String, dynamic>> get filteredHistory {
    if (selectedFilter == "Todos") return historyData;
    if (selectedFilter == "Completados") {
      return historyData
          .where((item) =>
      item['tomasCompletadas'] == item['tomasTotales'])
          .toList();
    }
    if (selectedFilter == "Omitidos") {
      return historyData
          .where((item) =>
      item['tomasCompletadas'] < item['tomasTotales'])
          .toList();
    }
    return historyData;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // HEADER
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryBlue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.history,
                          color: AppTheme.primaryBlue,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Text(
                          "Historial",
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primaryBlue,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.filter_list),
                        onPressed: _showFilterOptions,
                        color: AppTheme.primaryBlue,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _statisticsRow(),
                ],
              ),
            ),

            // FILTROS
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: _filterChips(),
            ),

            // LISTA
            Expanded(
              child: filteredHistory.isEmpty
                  ? _emptyState()
                  : ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                physics: const BouncingScrollPhysics(),
                itemCount: filteredHistory.length,
                itemBuilder: (context, index) {
                  return _historyCard(filteredHistory[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _statisticsRow() {
    final totalTreatments = historyData.length;
    final totalDoses = historyData.fold<int>(
        0, (sum, item) => sum + (item['tomasTotales'] as int));
    final completedDoses = historyData.fold<int>(
        0, (sum, item) => sum + (item['tomasCompletadas'] as int));
    final adherence =
    totalDoses > 0 ? (completedDoses / totalDoses * 100).round() : 0;

    return Row(
      children: [
        _statBox("Tratamientos", "$totalTreatments", Icons.medication),
        const SizedBox(width: 12),
        _statBox("Adherencia", "$adherence%", Icons.trending_up),
        const SizedBox(width: 12),
        _statBox("Tomas", "$completedDoses/$totalDoses", Icons.check_circle),
      ],
    );
  }

  Widget _statBox(String label, String value, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppTheme.primaryBlue.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppTheme.primaryBlue.withOpacity(0.1),
          ),
        ),
        child: Column(
          children: [
            Icon(icon, size: 20, color: AppTheme.primaryBlue),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryBlue,
              ),
            ),
            Text(
              label,
              style: const TextStyle(
                fontSize: 11,
                color: Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _filterChips() {
    return Row(
      children: [
        _filterChip("Todos"),
        const SizedBox(width: 8),
        _filterChip("Completados"),
        const SizedBox(width: 8),
        _filterChip("Omitidos"),
      ],
    );
  }

  Widget _filterChip(String label) {
    final isSelected = selectedFilter == label;
    return GestureDetector(
      onTap: () => setState(() => selectedFilter = label),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryBlue : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppTheme.primaryBlue : Colors.grey.shade300,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : Colors.black87,
          ),
        ),
      ),
    );
  }

  Widget _historyCard(Map<String, dynamic> item) {
    final completed = item['tomasCompletadas'] as int;
    final total = item['tomasTotales'] as int;
    final percentage = (completed / total * 100).round();
    final isComplete = completed == total;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => _showDetailModal(item),
          child: Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryBlue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.medication,
                        color: AppTheme.primaryBlue,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item['medicamento'],
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.primaryBlue,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            "${item['dosis']} • ${item['frecuencia']}",
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      isComplete ? Icons.check_circle : Icons.warning_amber,
                      color: isComplete ? Colors.green : Colors.orange,
                      size: 28,
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    const Icon(Icons.calendar_today,
                        size: 14, color: Colors.grey),
                    const SizedBox(width: 6),
                    Text(
                      "${item['fechaInicio']} – ${item['fechaFin']}",
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                // BARRA DE PROGRESO
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Adherencia: $percentage%",
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        Text(
                          "$completed/$total tomas",
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        value: completed / total,
                        minHeight: 8,
                        backgroundColor: Colors.grey.shade200,
                        color: isComplete ? Colors.green : AppTheme.primaryBlue,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
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
            Icon(
              Icons.history_outlined,
              size: 80,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              selectedFilter == "Todos"
                  ? "No hay tratamientos en el historial"
                  : "No hay tratamientos $selectedFilter",
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey.shade600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  void _showDetailModal(Map<String, dynamic> item) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.4,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) => Padding(
          padding: const EdgeInsets.all(24),
          child: ListView(
            controller: scrollController,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryBlue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.medication,
                      color: AppTheme.primaryBlue,
                      size: 32,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item['medicamento'],
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          item['estado'],
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.green.shade700,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              _detailRow(Icons.medication_liquid, "Dosis", item['dosis']),
              _detailRow(Icons.schedule, "Frecuencia", item['frecuencia']),
              _detailRow(Icons.event, "Inicio", item['fechaInicio']),
              _detailRow(Icons.event, "Fin", item['fechaFin']),
              _detailRow(Icons.check_circle, "Tomas completadas",
                  "${item['tomasCompletadas']}/${item['tomasTotales']}"),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.primaryBlue,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    "Cerrar",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _detailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppTheme.primaryBlue),
          const SizedBox(width: 12),
          Text(
            "$label:",
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Colors.black54,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 15,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showFilterOptions() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text("Opciones de filtro"),
        content: const Text(
            "Usa los chips debajo del título para filtrar tratamientos por estado."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Entendido"),
          ),
        ],
      ),
    );
  }
}