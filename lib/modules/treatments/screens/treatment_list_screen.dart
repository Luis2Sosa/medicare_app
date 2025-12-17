import 'package:flutter/material.dart';
import 'package:medicare_app/core/app_theme.dart';
import 'package:medicare_app/modules/treatments/screens/treatment_form_screen.dart';

class TreatmentListScreen extends StatefulWidget {
  const TreatmentListScreen({super.key});

  @override
  State<TreatmentListScreen> createState() => _TreatmentListScreenState();
}

class _TreatmentListScreenState extends State<TreatmentListScreen> {
  // TODO: Reemplazar con datos reales desde un servicio
  final List<Map<String, dynamic>> treatments = [
    // Ejemplo de datos - descomentar para probar con datos
    // {
    //   'name': 'Amoxicilina',
    //   'dosis': '1 tableta',
    //   'frecuencia': 'Cada 8 horas',
    //   'hora': '9:00 AM',
    //   'stockRemaining': 20,
    // },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Mis Tratamientos",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppTheme.primaryBlue,
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 2,
        actions: [
          if (treatments.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: _searchTreatments,
              tooltip: "Buscar",
            ),
        ],
      ),
      body: treatments.isEmpty ? _emptyState() : _treatmentsList(),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppTheme.primaryBlue,
        onPressed: _addTreatment,
        icon: const Icon(Icons.add),
        label: const Text(
          "Nuevo",
          style: TextStyle(fontWeight: FontWeight.w600),
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
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppTheme.primaryBlue.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.medication_outlined,
                size: 80,
                color: AppTheme.primaryBlue,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              "Aún no tienes tratamientos",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            const Text(
              "Agrega tu primer medicamento para\nrecibir recordatorios a tiempo",
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey,
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),

          ],
        ),
      ),
    );
  }

  Widget _treatmentsList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: treatments.length,
      itemBuilder: (context, index) {
        final treatment = treatments[index];
        return _treatmentCard(treatment, index);
      },
    );
  }

  Widget _treatmentCard(Map<String, dynamic> treatment, int index) {
    final bool lowStock = (treatment['stockRemaining'] ?? 0) < 10;

    return Dismissible(
      key: Key('treatment_$index'),
      direction: DismissDirection.endToStart,
      background: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(16),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.delete, color: Colors.white, size: 28),
      ),
      confirmDismiss: (direction) => _confirmDelete(treatment['name']),
      onDismissed: (direction) => _deleteTreatment(index),
      child: Card(
        margin: const EdgeInsets.only(bottom: 12),
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => _viewTreatmentDetails(treatment),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            treatment['name'] ?? 'Sin nombre',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "${treatment['dosis']} • ${treatment['frecuencia']}",
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit, size: 20),
                      onPressed: () => _editTreatment(treatment),
                      color: AppTheme.primaryBlue,
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.access_time,
                        size: 16,
                        color: AppTheme.primaryBlue,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "Próxima dosis: ${treatment['hora']}",
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                      const Spacer(),
                      if (lowStock)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.orange.shade100,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.warning_amber_rounded,
                                size: 14,
                                color: Colors.orange.shade700,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                "Stock bajo",
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.orange.shade700,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _addTreatment() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const TreatmentFormScreen(),
      ),
    ).then((result) {
      // TODO: Recargar lista si se agregó algo
      if (result == true) {
        setState(() {
          // Actualizar lista
        });
      }
    });
  }

  void _editTreatment(Map<String, dynamic> treatment) {
    // TODO: Navegar a formulario en modo edición
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Editando ${treatment['name']}"),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _viewTreatmentDetails(Map<String, dynamic> treatment) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                    size: 28,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    treatment['name'],
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _detailRow(Icons.local_hospital, "Dosis", treatment['dosis']),
            _detailRow(Icons.schedule, "Frecuencia", treatment['frecuencia']),
            _detailRow(Icons.access_time, "Hora", treatment['hora']),
            _detailRow(
              Icons.inventory_2,
              "Stock",
              "${treatment['stockRemaining']} tabletas",
            ),
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
    );
  }

  Widget _detailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
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

  Future<bool?> _confirmDelete(String name) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text("Eliminar tratamiento"),
        content: Text(
          "¿Estás seguro de eliminar $name?\nEsta acción no se puede deshacer.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancelar"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text("Eliminar"),
          ),
        ],
      ),
    );
  }

  void _deleteTreatment(int index) {
    final deleted = treatments[index];

    setState(() {
      treatments.removeAt(index);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("${deleted['name']} eliminado"),
        action: SnackBarAction(
          label: "Deshacer",
          onPressed: () {
            setState(() {
              treatments.insert(index, deleted);
            });
          },
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );

    // TODO: Eliminar de la base de datos
    // await TreatmentService.delete(deleted['id']);
  }

  void _searchTreatments() {
    // TODO: Implementar búsqueda
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Función de búsqueda próximamente"),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}