import 'package:flutter/material.dart';
import 'package:medicare_app/core/app_theme.dart';
import 'package:medicare_app/modules/treatments/screens/treatment_form_screen.dart';

class TreatmentListScreen extends StatefulWidget {
  const TreatmentListScreen({super.key});

  @override
  State<TreatmentListScreen> createState() => _TreatmentListScreenState();
}

class _TreatmentListScreenState extends State<TreatmentListScreen> {
  final List<Map<String, dynamic>> treatments = [];

  final List<Map<String, dynamic>> _mockTreatments = [
    {
      'name': 'Amoxicilina',
      'dosis': '1 tableta',
      'frecuencia': 'Cada 8 horas',
      'hora': '9:00 AM',
    },
    {
      'name': 'Ibuprofeno',
      'dosis': '1 tableta',
      'frecuencia': 'Cada 12 horas',
      'hora': '3:00 PM',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final data = treatments.isEmpty ? _mockTreatments : treatments;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFB),
      appBar: AppBar(
        title: const Text(
          "Mis Medicamentos",
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 22,
            letterSpacing: 0.3,
          ),
        ),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF5B7C99),
        centerTitle: true,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            color: const Color(0xFFE8EEF2),
            height: 1,
          ),
        ),
      ),
      body: data.isEmpty ? _emptyState() : _buildList(data),
      floatingActionButton: _addButton(),
    );
  }

  Widget _buildList(List<Map<String, dynamic>> data) {
    return Column(
      children: [
        // SALUDO CÁLIDO
        Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color(0xFFE3F2FD),
                Colors.white.withOpacity(0.9),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFF81C784),
                      const Color(0xFF66BB6A),
                    ],
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF81C784).withOpacity(0.4),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.favorite_rounded,
                  size: 32,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 14),
              const Text(
                "¡Tu salud, nuestra prioridad!",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF5B7C99),
                  letterSpacing: 0.2,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 6),
              Text(
                "${data.length} ${data.length == 1 ? 'medicamento' : 'medicamentos'} para hoy",
                style: const TextStyle(
                  fontSize: 16,
                  color: Color(0xFF7A8E9E),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),

        // LISTA
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
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
    return GestureDetector(
      onTap: () => _showOptions(treatment, index),
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: const Color(0xFFE0E7ED),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF5B7C99).withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          child: InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: () => _showOptions(treatment, index),
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // HEADER
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xFF64B5F6),
                              Color(0xFF42A5F5),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF42A5F5).withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.medication_rounded,
                          size: 28,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              treatment['name'],
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF5B7C99),
                                letterSpacing: 0.2,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              treatment['dosis'],
                              style: const TextStyle(
                                fontSize: 15,
                                color: Color(0xFF8A9BAD),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.chevron_right_rounded,
                        color: const Color(0xFFB0BEC5),
                        size: 28,
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // HORA
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFFFFB74D),
                          Color(0xFFFFA726),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFFFB74D).withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.access_time_rounded,
                          color: Colors.white,
                          size: 22,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          treatment['hora'],
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: -0.3,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),

                  // FRECUENCIA
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE3F2FD),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: const Color(0xFFBBDEFB),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.repeat_rounded,
                          size: 20,
                          color: Color(0xFF42A5F5),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          treatment['frecuencia'],
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF1976D2),
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
      ),
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
              padding: const EdgeInsets.all(36),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFFE3F2FD),
                    Color(0xFFBBDEFB),
                  ],
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF64B5F6).withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: const Icon(
                Icons.medical_services_rounded,
                size: 80,
                color: Color(0xFF42A5F5),
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              "¡Vamos a empezar!",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Color(0xFF5B7C99),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            const Text(
              "Agrega tu primer medicamento\npara comenzar tu seguimiento",
              style: TextStyle(
                fontSize: 17,
                color: Color(0xFF8A9BAD),
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
      backgroundColor: const Color(0xFF66BB6A),
      onPressed: _addTreatment,
      icon: const Icon(Icons.add_rounded, size: 28),
      label: const Text(
        "Agregar",
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.3,
        ),
      ),
      elevation: 6,
    );
  }

  void _showOptions(Map<String, dynamic> treatment, int index) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFFE0E7ED),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              treatment['name'],
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF5B7C99),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            Text(
              "${treatment['dosis']} • ${treatment['hora']}",
              style: const TextStyle(
                fontSize: 16,
                color: Color(0xFF8A9BAD),
              ),
            ),
            const SizedBox(height: 28),
            _optionButton(
              icon: Icons.edit_rounded,
              label: "Editar",
              color: const Color(0xFF42A5F5),
              onTap: () {
                Navigator.pop(context);
                _editTreatment(treatment);
              },
            ),
            const SizedBox(height: 12),
            _optionButton(
              icon: Icons.delete_rounded,
              label: "Eliminar",
              color: const Color(0xFFEF5350),
              onTap: () {
                Navigator.pop(context);
                _confirmDelete(treatment, index);
              },
            ),
            const SizedBox(height: 12),
            _optionButton(
              icon: Icons.close_rounded,
              label: "Cancelar",
              color: const Color(0xFF90A4AE),
              onTap: () => Navigator.pop(context),
            ),
            const SizedBox(height: 8),
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
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          elevation: 0,
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
        backgroundColor: const Color(0xFF42A5F5),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _confirmDelete(Map<String, dynamic> treatment, int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          "¿Eliminar?",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        content: Text(
          "¿Seguro que quieres eliminar ${treatment['name']}?",
          style: const TextStyle(fontSize: 17),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              "No",
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteTreatment(index);
            },
            style: TextButton.styleFrom(foregroundColor: const Color(0xFFEF5350)),
            child: const Text(
              "Sí, eliminar",
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  void _deleteTreatment(int index) {
    final deleted = _mockTreatments[index];
    setState(() => _mockTreatments.removeAt(index));

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "${deleted['name']} eliminado",
          style: const TextStyle(fontSize: 16),
        ),
        backgroundColor: const Color(0xFF66BB6A),
        action: SnackBarAction(
          label: "Deshacer",
          textColor: Colors.white,
          onPressed: () {
            setState(() => _mockTreatments.insert(index, deleted));
          },
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}