import 'package:flutter/material.dart';
import 'package:medicare_app/core/app_theme.dart';
import 'package:medicare_app/core/database/app_database.dart';
import 'package:medicare_app/modules/treatments/screens/treatment_form_screen.dart';


class TreatmentListScreen extends StatefulWidget {
  const TreatmentListScreen({super.key});

  @override
  State<TreatmentListScreen> createState() => _TreatmentListScreenState();
}

class _TreatmentListScreenState extends State<TreatmentListScreen> {
  List<Map<String, dynamic>> treatments = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTreatments();
  }

  Future<void> _loadTreatments() async {
    final data = await AppDatabase.instance.getTreatments();

    if (!mounted) return;

    setState(() {
      treatments = data;
      isLoading = false;
    });
  }


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
    final data = treatments;

    return Container(
      decoration: const BoxDecoration(
        gradient: AppTheme.mainGradient,
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text(
            "Mis Medicamentos",
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 26,
              letterSpacing: 0.3,
            ),
          ),
          backgroundColor: Colors.white,
          foregroundColor: const Color(0xFF1E3A5F),
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
      ),
    );
  }

  Widget _buildList(List<Map<String, dynamic>> data) {
    return Column(
      children: [
        // HEADER COMPACTO
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    "Recuerda tomar tu medicamento",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF1E3A5F),
                      letterSpacing: 0.2,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    "${data.length} ${data.length == 1 ? 'pendiente para hoy' : 'pendientes para hoy'}",
                    style: const TextStyle(
                      fontSize: 20,
                      color: Color(0xFF5B7C99),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        // LISTA CON MÁS ESPACIO
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
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
        margin: const EdgeInsets.only(bottom: 18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: const Color(0xFF42A5F5),
            width: 2.5,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF42A5F5).withOpacity(0.12),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(24),
          child: InkWell(
            borderRadius: BorderRadius.circular(24),
            onTap: () => _showOptions(treatment, index),
            child: Padding(
              padding: const EdgeInsets.all(22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // HEADER CON NOMBRE MÁS GRANDE
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              Color(0xFF42A5F5),
                              Color(0xFF1E88E5),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(18),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF42A5F5).withOpacity(0.3),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.medication_rounded,
                          size: 36,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: 18),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // ✅ NOMBRE MUCHO MÁS GRANDE
                            Text(
                              treatment['name'],
                              style: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.w900,
                                color: Color(0xFF1E3A5F),
                                letterSpacing: 0.2,
                                height: 1.2,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 6),
                            // ✅ DOSIS MÁS GRANDE Y NEGRA
                            Text(
                              treatment['dosis'],
                              style: const TextStyle(
                                fontSize: 19,
                                color: Color(0xFF1E3A5F),
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE3F2FD),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: const Color(0xFF42A5F5),
                            width: 1.5,
                          ),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.settings,
                              size: 18,
                              color: Color(0xFF1565C0),
                            ),
                            SizedBox(width: 6),
                            Text(
                              "Opciones",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF1565C0),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // ✅ HORA MÁS GRANDE Y PROMINENTE
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 14,
                    ),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          Color(0xFFFFA726),
                          Color(0xFFF57C00),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFFFA726).withOpacity(0.35),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.access_time_rounded,
                          color: Colors.white,
                          size: 32,
                        ),
                        const SizedBox(width: 14),
                        Text(
                          treatment['hora'],
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                            letterSpacing: -0.5,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // ✅ FRECUENCIA MÁS GRANDE
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE3F2FD),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: const Color(0xFF42A5F5),
                        width: 2,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.repeat_rounded,
                          size: 26,
                          color: Color(0xFF1E88E5),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            treatment['frecuencia'],
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF1565C0),
                              letterSpacing: 0.2,
                            ),
                          ),
                        ),

                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: const Color(0xFF42A5F5),
                              width: 1.5,
                            ),
                          ),
                          child: Text(
                            "Quedan ${treatment['cantidad'] ?? 0}",
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFF1565C0),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 58,
                          child: ElevatedButton.icon(
                            onPressed: () => _markAsTaken(treatment),
                            icon: const Icon(
                              Icons.check_circle_rounded,
                              size: 28,
                            ),
                            label: const Text(
                              "Tomado",
                              style: TextStyle(
                                fontSize: 19,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF10B981),
                              foregroundColor: Colors.white,
                              elevation: 5,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18),
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(width: 12),

                      Expanded(
                        child: SizedBox(
                          height: 58,
                          child: ElevatedButton.icon(
                            onPressed: () => _markAsSkipped(treatment),
                            icon: const Icon(
                              Icons.cancel_rounded,
                              size: 28,
                            ),
                            label: const Text(
                              "Omitir",
                              style: TextStyle(
                                fontSize: 19,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFEF5350),
                              foregroundColor: Colors.white,
                              elevation: 5,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
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
              padding: const EdgeInsets.all(44),
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
                    blurRadius: 24,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: const Icon(
                Icons.medical_services_rounded,
                size: 100,
                color: Color(0xFF42A5F5),
              ),
            ),
            const SizedBox(height: 40),
            const Text(
              "¡Vamos a empezar!",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w900,
                color: Color(0xFF1E3A5F),
                letterSpacing: 0.3,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            const Text(
              "Agrega tu primer medicamento\npara comenzar tu seguimiento",
              style: TextStyle(
                fontSize: 20,
                color: Color(0xFF5B7C99),
                fontWeight: FontWeight.w600,
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
      icon: const Icon(Icons.add_rounded, size: 32),
      label: const Text(
        "Agregar",
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w900,
          letterSpacing: 0.3,
        ),
      ),
      elevation: 8,
    );
  }

  void _showOptions(Map<String, dynamic> treatment, int index) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 50,
              height: 5,
              decoration: BoxDecoration(
                color: const Color(0xFFE0E7ED),
                borderRadius: BorderRadius.circular(3),
              ),
            ),
            const SizedBox(height: 24),
            // ✅ NOMBRE MÁS GRANDE EN EL MODAL
            Text(
              treatment['name'],
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w900,
                color: Color(0xFF1E3A5F),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              "${treatment['dosis']} • ${treatment['hora']}",
              style: const TextStyle(
                fontSize: 19,
                color: Color(0xFF5B7C99),
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 32),
            _optionButton(
              icon: Icons.edit_rounded,
              label: "Editar",
              color: const Color(0xFF42A5F5),
              onTap: () {
                Navigator.pop(context);
                _editTreatment(treatment);
              },
            ),
            const SizedBox(height: 14),
            _optionButton(
              icon: Icons.delete_rounded,
              label: "Eliminar",
              color: const Color(0xFFEF5350),
              onTap: () {
                Navigator.pop(context);
                _confirmDelete(treatment, index);
              },
            ),
            const SizedBox(height: 14),
            _optionButton(
              icon: Icons.close_rounded,
              label: "Cancelar",
              color: const Color(0xFF90A4AE),
              onTap: () => Navigator.pop(context),
            ),
            const SizedBox(height: 12),
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
      height: 64,
      child: ElevatedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, size: 28),
        label: Text(
          label,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w900,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          elevation: 4,
          shadowColor: color.withOpacity(0.4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
      ),
    );
  }

  void _addTreatment() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const TreatmentFormScreen()),
    );

    if (result == true) {
      await _loadTreatments();
    }
  }

  void _editTreatment(Map<String, dynamic> treatment) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => TreatmentFormScreen(treatment: treatment),
      ),
    );

    if (result == true) {
      await _loadTreatments();
    }
  }

  void _confirmDelete(Map<String, dynamic> treatment, int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        contentPadding: const EdgeInsets.fromLTRB(28, 28, 28, 40),
        title: const Text(
          "¿Eliminar?",
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w900,
            color: Color(0xFF1E3A5F),
          ),
          textAlign: TextAlign.center,
        ),
        content: Text(
          "¿Seguro que quieres eliminar ${treatment['name']}?",
          style: const TextStyle(
            fontSize: 19,
            color: Color(0xFF5B7C99),
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            ),
            child: const Text(
              "No",
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.w700,
                color: Color(0xFF90A4AE),
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteTreatment(index);
            },
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xFFEF5350),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            ),
            child: const Text(
              "Sí, eliminar",
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _deleteTreatment(int index) async {
    final deleted = treatments[index];

    await AppDatabase.instance.deleteTreatment(deleted['id']);

    await _loadTreatments();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "${deleted['name']} eliminado",
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
        ),
        backgroundColor: const Color(0xFF66BB6A),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _markAsTaken(Map<String, dynamic> treatment) async {
    final now = DateTime.now();

    int cantidadActual = treatment['cantidad'] ?? 0;

    int descuento = 1;

    if (treatment['dosis'] == "2 tabletas") {
      descuento = 2;
    } else if (treatment['dosis'] == "Media") {
      descuento = 1;
    }

    int nuevaCantidad = cantidadActual - descuento;

    if (nuevaCantidad < 0) {
      nuevaCantidad = 0;
    }

    final nuevaHora = _calculateNextTime(
      treatment['hora'],
      treatment['frecuencia'],
    );

    final historyItem = {
      'medicamento': treatment['name'],
      'dosis': treatment['dosis'],
      'fecha': '${now.day}/${now.month}/${now.year}',
      'hora': treatment['hora'],
      'tomado': 1,
    };

    await AppDatabase.instance.insertHistory(historyItem);

    if (nuevaCantidad == 0) {
      await AppDatabase.instance.deleteTreatment(treatment['id']);
    } else {
      final updatedTreatment = {
        'id': treatment['id'],
        'name': treatment['name'],
        'dosis': treatment['dosis'],
        'frecuencia': treatment['frecuencia'],
        'hora': nuevaHora,
        'cantidad': nuevaCantidad,
      };

      await AppDatabase.instance.updateTreatment(updatedTreatment);
    }

    await _loadTreatments();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          nuevaCantidad == 0
              ? "${treatment['name']} completado"
              : "Próxima toma: $nuevaHora",
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        backgroundColor: const Color(0xFF10B981),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  String _calculateNextTime(String currentTime, String frecuencia) {
    int hoursToAdd = 8;

    if (frecuencia == "Cada 4 horas") {
      hoursToAdd = 4;
    } else if (frecuencia == "Cada 6 horas") {
      hoursToAdd = 6;
    } else if (frecuencia == "Cada 8 horas") {
      hoursToAdd = 8;
    } else if (frecuencia == "Cada 12 horas") {
      hoursToAdd = 12;
    } else if (frecuencia == "Cada 24 horas") {
      hoursToAdd = 24;
    }

    final parts = currentTime.split(' ');
    final timeParts = parts[0].split(':');

    int hour = int.parse(timeParts[0]);
    int minute = int.parse(timeParts[1]);
    final period = parts[1];

    if (period == 'PM' && hour != 12) {
      hour += 12;
    }

    if (period == 'AM' && hour == 12) {
      hour = 0;
    }

    final baseTime = DateTime(2026, 1, 1, hour, minute);
    final nextTime = baseTime.add(Duration(hours: hoursToAdd));

    final newHour24 = nextTime.hour;
    final newMinute = nextTime.minute.toString().padLeft(2, '0');

    final newPeriod = newHour24 >= 12 ? 'PM' : 'AM';
    int newHour12 = newHour24 % 12;

    if (newHour12 == 0) {
      newHour12 = 12;
    }

    return '$newHour12:$newMinute $newPeriod';
  }

  void _markAsSkipped(Map<String, dynamic> treatment) async {
    final now = DateTime.now();

    final nuevaHora = _calculateNextTime(
      treatment['hora'],
      treatment['frecuencia'],
    );

    final historyItem = {
      'medicamento': treatment['name'],
      'dosis': treatment['dosis'],
      'fecha': '${now.day}/${now.month}/${now.year}',
      'hora': treatment['hora'],
      'tomado': 0,
    };

    await AppDatabase.instance.insertHistory(historyItem);

    final updatedTreatment = {
      'id': treatment['id'],
      'name': treatment['name'],
      'dosis': treatment['dosis'],
      'frecuencia': treatment['frecuencia'],
      'hora': nuevaHora,
      'cantidad': treatment['cantidad'],
    };

    await AppDatabase.instance.updateTreatment(updatedTreatment);

    await _loadTreatments();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "Omitido. Próxima toma: $nuevaHora",
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        backgroundColor: const Color(0xFFEF5350),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
