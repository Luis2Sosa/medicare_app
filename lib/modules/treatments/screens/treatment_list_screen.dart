import 'package:flutter/material.dart';
import 'package:medicare_app/core/app_theme.dart';
import 'package:medicare_app/core/database/app_database.dart';
import 'package:medicare_app/modules/treatments/screens/treatment_form_screen.dart';
import 'package:medicare_app/services/notification_service.dart';

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

  String _getNextDoseTime(Map<String, dynamic> treatment) {
    final String hora = treatment['hora'] ?? '12:00 AM';
    final String frecuencia = treatment['frecuencia'] ?? 'Cada 24 horas';

    final int startMinutes = _parseHoraATotalMinutos(hora);
    final int intervalHours = _parseFrecuenciaHoras(frecuencia);
    final int intervalMinutes = intervalHours * 60;

    final now = DateTime.now();
    final int nowMinutes = now.hour * 60 + now.minute;

    int nextMinutes = startMinutes;

    for (int i = 0; i < 10; i++) {
      if (nextMinutes > nowMinutes) {
        return _formatMinutesToTime(nextMinutes);
      }

      nextMinutes = (startMinutes + ((i + 1) * intervalMinutes)) % (24 * 60);
    }

    return _formatMinutesToTime(startMinutes);
  }

  int _parseFrecuenciaHoras(String frecuencia) {
    final match = RegExp(r'(\d+)').firstMatch(frecuencia);
    if (match == null) return 24;
    return int.tryParse(match.group(1)!) ?? 24;
  }

  int _parseHoraATotalMinutos(String horaTexto) {
    final parts = horaTexto.trim().split(' ');
    final timeParts = parts[0].split(':');

    int hour = int.parse(timeParts[0]);
    final int minute = int.parse(timeParts[1]);
    final String period = parts.length > 1 ? parts[1].toUpperCase() : 'AM';

    if (period == 'PM' && hour != 12) hour += 12;
    if (period == 'AM' && hour == 12) hour = 0;

    return hour * 60 + minute;
  }

  String _formatMinutesToTime(int totalMinutes) {
    int hour24 = totalMinutes ~/ 60;
    final int minute = totalMinutes % 60;

    final String period = hour24 >= 12 ? 'PM' : 'AM';
    int hour12 = hour24 % 12;

    if (hour12 == 0) hour12 = 12;

    return '$hour12:${minute.toString().padLeft(2, '0')} $period';
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 400;
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
        body: isLoading
            ? _buildLoadingState()
            : (data.isEmpty
            ? _emptyState(isSmallScreen)
            : _buildList(data, isSmallScreen)),
        floatingActionButton: _addButton(),
      ),
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: CircularProgressIndicator(
        color: Color(0xFF42A5F5),
        strokeWidth: 4,
      ),
    );
  }

  Widget _buildList(List<Map<String, dynamic>> data, bool isSmallScreen) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(
            horizontal: isSmallScreen ? 16 : 20,
            vertical: isSmallScreen ? 12 : 16,
          ),
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
              Text(
                "Recuerda tomar tu medicamento",
                style: TextStyle(
                  fontSize: isSmallScreen ? 18 : 22,
                  fontWeight: FontWeight.w900,
                  color: const Color(0xFF1E3A5F),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                "${data.length} ${data.length == 1 ? 'pendiente para hoy' : 'pendientes para hoy'}",
                style: TextStyle(
                  fontSize: isSmallScreen ? 16 : 20,
                  color: const Color(0xFF5B7C99),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.fromLTRB(
              isSmallScreen ? 16 : 20,
              isSmallScreen ? 12 : 16,
              isSmallScreen ? 16 : 20,
              isSmallScreen ? 12 : 20,
            ),
            itemCount: data.length,
            itemBuilder: (context, index) {
              return _treatmentCard(data[index], index, isSmallScreen);
            },
          ),
        ),
      ],
    );
  }

  Widget _treatmentCard(
      Map<String, dynamic> treatment,
      int index,
      bool isSmallScreen,
      ) {
    final String nextDoseTime = _getNextDoseTime(treatment);

    return Container(
      margin: EdgeInsets.only(bottom: isSmallScreen ? 14 : 18),
      padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F9FC),
        borderRadius: BorderRadius.circular(26),
        border: Border.all(
          color: const Color(0xFF64B5F6),
          width: 2.2,
        ),

      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: isSmallScreen ? 54 : 64,
                height: isSmallScreen ? 54 : 64,
                decoration: BoxDecoration(
                  color: const Color(0xFFE3F2FD),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Icon(
                  Icons.medication_rounded,
                  color: const Color(0xFF1976D2),
                  size: isSmallScreen ? 30 : 36,
                ),
              ),
              SizedBox(width: isSmallScreen ? 12 : 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      treatment['name'] ?? 'Medicamento',
                      style: TextStyle(
                        fontSize: isSmallScreen ? 22 : 26,
                        fontWeight: FontWeight.w900,
                        color: const Color(0xFF1E3A5F),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      treatment['dosis'] ?? '1 tableta',
                      style: TextStyle(
                        fontSize: isSmallScreen ? 15 : 17,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              InkWell(
                borderRadius: BorderRadius.circular(14),
                onTap: () => _showOptions(treatment, index, isSmallScreen),
                child: Container(
                  padding: EdgeInsets.all(isSmallScreen ? 8 : 10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE3F2FD),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    Icons.more_horiz_rounded,
                    color: const Color(0xFF1976D2),
                    size: isSmallScreen ? 22 : 26,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: isSmallScreen ? 18 : 22),

          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              horizontal: isSmallScreen ? 16 : 18,
              vertical: isSmallScreen ? 14 : 16,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFFFFF3E0),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: const Color(0xFFFFB74D),
                width: 1.5,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: isSmallScreen ? 42 : 48,
                  height: isSmallScreen ? 42 : 48,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFF9800),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.access_time_rounded,
                    color: Colors.white,
                    size: isSmallScreen ? 24 : 28,
                  ),
                ),
                SizedBox(width: isSmallScreen ? 12 : 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Próxima toma",
                        style: TextStyle(
                          fontSize: isSmallScreen ? 14 : 16,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFFB45309),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        nextDoseTime,
                        style: TextStyle(
                          fontSize: isSmallScreen ? 26 : 30,
                          fontWeight: FontWeight.w900,
                          color: const Color(0xFF1E3A5F),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: isSmallScreen ? 12 : 14),

          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE3F2FD),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.repeat_rounded,
                        color: Color(0xFF1976D2),
                        size: 22,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          treatment['frecuencia'] ?? 'Cada 8 horas',
                          style: TextStyle(
                            fontSize: isSmallScreen ? 14 : 16,
                            fontWeight: FontWeight.w800,
                            color: const Color(0xFF1565C0),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  "Quedan ${treatment['cantidad'] ?? 0}",
                  style: TextStyle(
                    fontSize: isSmallScreen ? 14 : 16,
                    fontWeight: FontWeight.w900,
                    color: const Color(0xFF1E3A5F),
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: isSmallScreen ? 14 : 18),

          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: isSmallScreen ? 48 : 54,
                  child: ElevatedButton.icon(
                    onPressed: () => _markAsTaken(treatment),
                    icon: const Icon(Icons.check_circle_rounded),
                    label: const Text("Tomado"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF10B981),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      textStyle: TextStyle(
                        fontSize: isSmallScreen ? 15 : 17,
                        fontWeight: FontWeight.w900,
                      ),
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
                  height: isSmallScreen ? 48 : 54,
                  child: ElevatedButton.icon(
                    onPressed: () => _markAsSkipped(treatment),
                    icon: const Icon(Icons.cancel_rounded),
                    label: const Text("Omitir"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFEF5350),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      textStyle: TextStyle(
                        fontSize: isSmallScreen ? 15 : 17,
                        fontWeight: FontWeight.w900,
                      ),
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
    );
  }

  Widget _emptyState(bool isSmallScreen) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(isSmallScreen ? 24 : 40),
          child: Column(
            children: [
              SizedBox(height: isSmallScreen ? 40 : 60),
              Container(
                padding: EdgeInsets.all(isSmallScreen ? 32 : 44),
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
                      color: const Color(0xFF64B5F6).withOpacity(0.18),
                      blurRadius: 22,
                      offset: const Offset(0, 10),
                    ),

                  ],
                ),
                child: Icon(
                  Icons.medical_services_rounded,
                  size: isSmallScreen ? 70 : 100,
                  color: const Color(0xFF42A5F5),
                ),
              ),
              SizedBox(height: isSmallScreen ? 28 : 40),
              Text(
                "¡Vamos a empezar!",
                style: TextStyle(
                  fontSize: isSmallScreen ? 24 : 30,
                  fontWeight: FontWeight.w900,
                  color: const Color(0xFF1E3A5F),
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: isSmallScreen ? 12 : 16),
              Text(
                "Agrega tu primer medicamento\npara comenzar tu seguimiento",
                style: TextStyle(
                  fontSize: isSmallScreen ? 16 : 20,
                  color: const Color(0xFF5B7C99),
                  fontWeight: FontWeight.w600,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: isSmallScreen ? 40 : 60),
            ],
          ),
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
        ),
      ),
      elevation: 8,
    );
  }

  void _showOptions(
      Map<String, dynamic> treatment,
      int index,
      bool isSmallScreen,
      ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Color(0xFFF8FAFC),
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        padding: EdgeInsets.all(isSmallScreen ? 20 : 28),
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
            SizedBox(height: isSmallScreen ? 16 : 24),
            Text(
              treatment['name'] ?? 'Medicamento',
              style: TextStyle(
                fontSize: isSmallScreen ? 22 : 28,
                fontWeight: FontWeight.w900,
                color: const Color(0xFF1E3A5F),
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: isSmallScreen ? 6 : 8),
            Text(
              "${treatment['dosis']} • Próxima toma: ${_getNextDoseTime(treatment)}",
              style: TextStyle(
                fontSize: isSmallScreen ? 16 : 19,
                color: const Color(0xFF5B7C99),
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: isSmallScreen ? 24 : 32),
            _optionButton(
              icon: Icons.edit_rounded,
              label: "Editar",
              color: const Color(0xFF42A5F5),
              isSmallScreen: isSmallScreen,
              onTap: () {
                Navigator.pop(context);
                _editTreatment(treatment);
              },
            ),
            SizedBox(height: isSmallScreen ? 10 : 14),
            _optionButton(
              icon: Icons.delete_rounded,
              label: "Eliminar",
              color: const Color(0xFFEF5350),
              isSmallScreen: isSmallScreen,
              onTap: () {
                Navigator.pop(context);
                _confirmDelete(treatment, index);
              },
            ),
            SizedBox(height: isSmallScreen ? 10 : 14),
            _optionButton(
              icon: Icons.close_rounded,
              label: "Cancelar",
              color: const Color(0xFF90A4AE),
              isSmallScreen: isSmallScreen,
              onTap: () => Navigator.pop(context),
            ),
            SizedBox(height: isSmallScreen ? 8 : 12),
          ],
        ),
      ),
    );
  }

  Widget _optionButton({
    required IconData icon,
    required String label,
    required Color color,
    required bool isSmallScreen,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: double.infinity,
      height: isSmallScreen ? 50 : 64,
      child: ElevatedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, size: isSmallScreen ? 22 : 28),
        label: Text(
          label,
          style: TextStyle(
            fontSize: isSmallScreen ? 16 : 20,
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
    final isSmallScreen = MediaQuery.of(context).size.width < 400;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Text(
          "¿Eliminar?",
          style: TextStyle(
            fontSize: isSmallScreen ? 24 : 28,
            fontWeight: FontWeight.w900,
            color: const Color(0xFF1E3A5F),
          ),
          textAlign: TextAlign.center,
        ),
        content: Text(
          "¿Seguro que quieres eliminar ${treatment['name']}?",
          style: TextStyle(
            fontSize: isSmallScreen ? 16 : 19,
            color: const Color(0xFF5B7C99),
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("No"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteTreatment(index);
            },
            child: const Text("Sí, eliminar"),
          ),
        ],
      ),
    );
  }

  void _deleteTreatment(int index) async {
    final deleted = treatments[index];

    await AppDatabase.instance.deleteTreatment(deleted['id']);

    try {
      await NotificationService.instance.cancelRemindersForTreatment(
        deleted['id'] as int,
      );
    } catch (e) {
      debugPrint("Error cancelando alarma: $e");
    }

    await _loadTreatments();

    if (!mounted) return;

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

      try {
        await NotificationService.instance.cancelRemindersForTreatment(
          treatment['id'] as int,
        );
      } catch (e) {
        debugPrint("Error cancelando alarma: $e");
      }
    } else {
      final updatedTreatment = {
        'id': treatment['id'],
        'name': treatment['name'],
        'dosis': treatment['dosis'],
        'frecuencia': treatment['frecuencia'],
        'hora': treatment['hora'],
        'cantidad': nuevaCantidad,
      };

      await AppDatabase.instance.updateTreatment(updatedTreatment);

      try {
        await NotificationService.instance.acknowledgeDose(
          treatmentId: treatment['id'] as int,
          horaInicio: treatment['hora'] as String,
          frecuencia: treatment['frecuencia'] as String,
          medicationName: treatment['name'] as String,
          dosis: treatment['dosis'] as String,
        );
      } catch (e) {
        debugPrint("Error reconociendo dosis: $e");
      }
    }

    await _loadTreatments();

    if (!mounted) return;

    setState(() {});

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          nuevaCantidad == 0
              ? "${treatment['name']} completado"
              : "¡Buen trabajo! Quedan $nuevaCantidad",
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

  void _markAsSkipped(Map<String, dynamic> treatment) async {
    final now = DateTime.now();

    final historyItem = {
      'medicamento': treatment['name'],
      'dosis': treatment['dosis'],
      'fecha': '${now.day}/${now.month}/${now.year}',
      'hora': treatment['hora'],
      'tomado': 0,
    };

    await AppDatabase.instance.insertHistory(historyItem);

    try {
      await NotificationService.instance.acknowledgeDose(
        treatmentId: treatment['id'] as int,
        horaInicio: treatment['hora'] as String,
        frecuencia: treatment['frecuencia'] as String,
        medicationName: treatment['name'] as String,
        dosis: treatment['dosis'] as String,
      );
    } catch (e) {
      debugPrint("Error reconociendo dosis: $e");
    }

    await _loadTreatments();

    if (!mounted) return;

    setState(() {});

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          "Dosis omitida. Sonará en la próxima toma.",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        backgroundColor: Color(0xFFEF5350),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}