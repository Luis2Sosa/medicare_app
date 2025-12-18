import 'package:flutter/material.dart';
import 'package:medicare_app/core/app_theme.dart';
import 'package:medicare_app/modules/treatments/screens/treatment_form_screen.dart';

class TreatmentListScreen extends StatefulWidget {
  const TreatmentListScreen({super.key});

  @override
  State<TreatmentListScreen> createState() => _TreatmentListScreenState();
}

class _TreatmentListScreenState extends State<TreatmentListScreen> {
  /// 🔹 Lista REAL
  final List<Map<String, dynamic>> treatments = [];

  /// 🔹 Lista MOCK
  final List<Map<String, dynamic>> _mockTreatments = [
    {
      'name': 'Amoxicilina',
      'dosis': '1 tableta',
      'frecuencia': 'Cada 8 horas',
      'hora': '9:00 AM',
      'stockRemaining': 6,
    },
    {
      'name': 'Ibuprofeno',
      'dosis': '1 tableta',
      'frecuencia': 'Cada 12 horas',
      'hora': '3:00 PM',
      'stockRemaining': 14,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final data = treatments.isEmpty ? _mockTreatments : treatments;

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text(
          "Mis Medicamentos",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        backgroundColor: AppTheme.primaryBlue,
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
      ),
      body: data.isEmpty ? _emptyState() : _buildList(data),
      floatingActionButton: _addButton(),
    );
  }

  Widget _buildList(List<Map<String, dynamic>> data) {
    return Column(
      children: [
        // HEADER CON INSTRUCCIONES
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 4,
                offset: Offset(0, 2),
              )
            ],
          ),
          child: Column(
            children: [
              const Icon(
                Icons.info_outline,
                size: 32,
                color: AppTheme.primaryBlue,
              ),
              const SizedBox(height: 8),
              Text(
                "Tus medicamentos del día",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade800,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                "Toca un medicamento para ver más opciones",
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey.shade600,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),

        // LISTA
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: data.length,
            itemBuilder: (context, index) {
              return _treatmentCard(data[index], index);
            },
          ),
        ),
      ],
    );
  }

  Widget _treatmentCard(Map<String, dynamic> treatment, int index) {
    final bool lowStock = (treatment['stockRemaining'] ?? 0) < 10;

    return GestureDetector(
      onTap: () => _showOptions(treatment, index),
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: AppTheme.primaryBlue.withOpacity(0.3),
            width: 2.5,
          ),
          boxShadow: [
            BoxShadow(
              color: AppTheme.primaryBlue.withOpacity(0.15),
              blurRadius: 12,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // NOMBRE DEL MEDICAMENTO - MUY GRANDE
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryBlue.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(
                    Icons.medication,
                    size: 32,
                    color: AppTheme.primaryBlue,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    treatment['name'],
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryBlue,
                      height: 1.2,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // HORA - MUY VISIBLE
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.orange.withOpacity(0.3),
                  width: 2,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.access_time, color: Colors.orange, size: 28),
                  const SizedBox(width: 10),
                  Text(
                    treatment['hora'],
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange,
                      letterSpacing: -0.5,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // DOSIS Y FRECUENCIA - GRANDE Y CLARO
            _infoRow(
              icon: Icons.medication_liquid,
              label: "Dosis:",
              value: treatment['dosis'],
            ),

            const SizedBox(height: 10),

            _infoRow(
              icon: Icons.repeat,
              label: "Frecuencia:",
              value: treatment['frecuencia'],
            ),

            // ALERTA DE STOCK BAJO
            if (lowStock) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.red.shade300, width: 2),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.warning_rounded,
                      color: Colors.red,
                      size: 28,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "¡Stock bajo!",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                          ),
                          Text(
                            "Quedan ${treatment['stockRemaining']} tabletas",
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.red.shade700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _infoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, size: 22, color: AppTheme.primaryBlue),
        const SizedBox(width: 10),
        Text(
          label,
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            color: Colors.black54,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
        ),
      ],
    );
  }

  Widget _emptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(30),
              decoration: BoxDecoration(
                color: AppTheme.primaryBlue.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.medication_outlined,
                size: 100,
                color: AppTheme.primaryBlue,
              ),
            ),
            const SizedBox(height: 30),
            const Text(
              "Aún no tienes medicamentos",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            const Text(
              "Presiona el botón verde\npara agregar tu primer medicamento",
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _addButton() {
    return FloatingActionButton.extended(
      backgroundColor: Colors.green,
      onPressed: _addTreatment,
      icon: const Icon(Icons.add, size: 28),
      label: const Text(
        "Agregar",
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      elevation: 6,
    );
  }

  void _showOptions(Map<String, dynamic> treatment, int index) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // TÍTULO
            Text(
              treatment['name'],
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              "${treatment['dosis']} • ${treatment['hora']}",
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 28),

            // OPCIONES
            _optionButton(
              icon: Icons.edit,
              label: "Editar medicamento",
              color: AppTheme.primaryBlue,
              onTap: () {
                Navigator.pop(context);
                _editTreatment(treatment);
              },
            ),
            const SizedBox(height: 12),
            _optionButton(
              icon: Icons.delete,
              label: "Eliminar medicamento",
              color: Colors.red,
              onTap: () {
                Navigator.pop(context);
                _confirmDelete(treatment, index);
              },
            ),
            const SizedBox(height: 12),
            _optionButton(
              icon: Icons.close,
              label: "Cancelar",
              color: Colors.grey,
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _optionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, size: 24),
        label: Text(
          label,
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
    );
  }

  void _addTreatment() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const TreatmentFormScreen()),
    );
  }

  void _editTreatment(Map<String, dynamic> treatment) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Editando ${treatment['name']}"),
        behavior: SnackBarBehavior.floating,
      ),
    );
    // TODO: Navegar a formulario en modo edición
  }

  void _confirmDelete(Map<String, dynamic> treatment, int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          "¿Eliminar medicamento?",
          style: TextStyle(fontSize: 22),
        ),
        content: Text(
          "¿Estás seguro de eliminar ${treatment['name']}?\n\nEsta acción no se puede deshacer.",
          style: const TextStyle(fontSize: 16),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              "Cancelar",
              style: TextStyle(fontSize: 17),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteTreatment(index);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text(
              "Eliminar",
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  void _deleteTreatment(int index) {
    final deleted = _mockTreatments[index];

    setState(() {
      _mockTreatments.removeAt(index);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "${deleted['name']} eliminado",
          style: const TextStyle(fontSize: 16),
        ),
        action: SnackBarAction(
          label: "Deshacer",
          onPressed: () {
            setState(() {
              _mockTreatments.insert(index, deleted);
            });
          },
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}