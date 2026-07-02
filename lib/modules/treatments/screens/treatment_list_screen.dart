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
    return treatment['proximaHora'] ?? treatment['hora'] ?? '12:00 AM';
  }

  String _calculateNextDoseTime(Map<String, dynamic> treatment) {
    final String currentTime =
        treatment['proximaHora'] ?? treatment['hora'] ?? '12:00 AM';

    final String frecuencia = treatment['frecuencia'] ?? 'Cada 24 horas';

    final int currentMinutes = _parseHoraATotalMinutos(currentTime);
    final int intervalMinutes = _parseFrecuenciaMinutos(frecuencia);

    final int nextMinutes = (currentMinutes + intervalMinutes) % (24 * 60);

    return _formatMinutesToTime(nextMinutes);
  }

  int _parseFrecuenciaMinutos(String frecuencia) {
    final match = RegExp(r'(\d+)').firstMatch(frecuencia);
    final int number = match == null ? 24 : int.tryParse(match.group(1)!) ?? 24;

    final lower = frecuencia.toLowerCase();

    if (lower.contains('minuto')) return number;
    if (lower.contains('día') || lower.contains('dia')) return number * 24 * 60;
    if (lower.contains('semana')) return number * 7 * 24 * 60;

    return number * 60;
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
    final clampedTextScaler = MediaQuery.textScalerOf(context).clamp(
      minScaleFactor: 0.9,
      maxScaleFactor: 1.12,
    );

    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaler: clampedTextScaler),
      child: Container(
        decoration: const BoxDecoration(
          gradient: AppTheme.mainGradient,
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: const FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                "Mis Medicamentos",
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 26,
                  letterSpacing: 0.3,
                ),
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
          body: SafeArea(
            top: false,
            bottom: true,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final r = _Responsive(
                  width: constraints.maxWidth,
                  height: constraints.maxHeight,
                );

                if (isLoading) {
                  return _buildLoadingState();
                }

                if (treatments.isEmpty) {
                  return _emptyState(r);
                }

                return _buildList(treatments, r);
              },
            ),
          ),
          floatingActionButton: _addButton(),
        ),
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

  Widget _buildList(List<Map<String, dynamic>> data, _Responsive r) {
    final bottomSafe = MediaQuery.of(context).padding.bottom;

    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(
            horizontal: r.pagePadding,
            vertical: r.headerPadding,
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
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: r.font(21),
                  fontWeight: FontWeight.w900,
                  color: const Color(0xFF1E3A5F),
                  height: 1.15,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                "${data.length} ${data.length == 1 ? 'pendiente para hoy' : 'pendientes para hoy'}",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: r.font(18.5),
                  color: const Color(0xFF5B7C99),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.fromLTRB(
              r.pagePadding,
              r.listTopPadding,
              r.pagePadding,
              r.listBottomPadding + bottomSafe + 74,
            ),
            itemCount: data.length,
            itemBuilder: (context, index) {
              return _treatmentCard(data[index], index, r);
            },
          ),
        ),
      ],
    );
  }

  Widget _treatmentCard(
      Map<String, dynamic> treatment,
      int index,
      _Responsive r,
      ) {
    final String nextDoseTime = _getNextDoseTime(treatment);

    return Container(
      margin: EdgeInsets.only(bottom: r.cardBottomMargin),
      padding: EdgeInsets.all(r.cardPadding),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F9FC),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: const Color(0xFF64B5F6),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.045),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: r.mainIconBox,
                height: r.mainIconBox,
                decoration: BoxDecoration(
                  color: const Color(0xFFE3F2FD),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Icon(
                  Icons.medication_rounded,
                  color: const Color(0xFF1976D2),
                  size: r.mainIconSize,
                ),
              ),
              SizedBox(width: r.scale(12)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      treatment['name'] ?? 'Medicamento',
                      style: TextStyle(
                        fontSize: r.font(24),
                        fontWeight: FontWeight.w900,
                        color: const Color(0xFF1E3A5F),
                        height: 1.12,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      treatment['dosis'] ?? '1 tableta',
                      style: TextStyle(
                        fontSize: r.font(16),
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
                onTap: () => _showOptions(treatment, index, r),
                child: Container(
                  padding: EdgeInsets.all(r.optionIconPadding),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE3F2FD),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    Icons.more_horiz_rounded,
                    color: const Color(0xFF1976D2),
                    size: r.scale(25),
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: r.cardSectionGap),

          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              horizontal: r.nextDosePaddingH,
              vertical: r.nextDosePaddingV,
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
                  width: r.clockIconBox,
                  height: r.clockIconBox,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFF9800),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.access_time_rounded,
                    color: Colors.white,
                    size: r.clockIconSize,
                  ),
                ),
                SizedBox(width: r.scale(12)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Próxima toma",
                        style: TextStyle(
                          fontSize: r.font(15),
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFFB45309),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        nextDoseTime,
                        style: TextStyle(
                          fontSize: r.font(28),
                          fontWeight: FontWeight.w900,
                          color: const Color(0xFF1E3A5F),
                          height: 1.08,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: r.smallGap),

          Row(
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: r.infoPaddingH,
                    vertical: r.infoPaddingV,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE3F2FD),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.repeat_rounded,
                        color: const Color(0xFF1976D2),
                        size: r.scale(21),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          treatment['frecuencia'] ?? 'Cada 8 horas',
                          style: TextStyle(
                            fontSize: r.font(15),
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
                padding: EdgeInsets.symmetric(
                  horizontal: r.infoPaddingH,
                  vertical: r.infoPaddingV,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  (treatment['cantidad'] ?? 0) > 0
                      ? "Quedan ${treatment['cantidad']}"
                      : "En uso",
                  style: TextStyle(
                    fontSize: r.font(15),
                    fontWeight: FontWeight.w900,
                    color: const Color(0xFF1E3A5F),
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: r.buttonGap),

          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: r.actionButtonHeight,
                  child: ElevatedButton.icon(
                    onPressed: () => _markAsTaken(treatment),
                    icon: Icon(
                      Icons.check_circle_rounded,
                      size: r.scale(21),
                    ),
                    label: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        "Tomado",
                        style: TextStyle(
                          fontSize: r.font(16),
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF10B981),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: SizedBox(
                  height: r.actionButtonHeight,
                  child: ElevatedButton.icon(
                    onPressed: () => _markAsSkipped(treatment),
                    icon: Icon(
                      Icons.cancel_rounded,
                      size: r.scale(21),
                    ),
                    label: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        "Omitir",
                        style: TextStyle(
                          fontSize: r.font(16),
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFEF5350),
                      foregroundColor: Colors.white,
                      elevation: 0,
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

  Widget _emptyState(_Responsive r) {
    final bottomSafe = MediaQuery.of(context).padding.bottom;

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.fromLTRB(
        r.pagePadding,
        r.topEmptyPadding,
        r.pagePadding,
        r.bottomPadding + bottomSafe + 74,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: r.maxContentWidth),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(r.emptyIconPadding),
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
                  size: r.emptyIconSize,
                  color: const Color(0xFF42A5F5),
                ),
              ),
              SizedBox(height: r.emptyGap),
              Text(
                "¡Vamos a empezar!",
                style: TextStyle(
                  fontSize: r.font(28),
                  fontWeight: FontWeight.w900,
                  color: const Color(0xFF1E3A5F),
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: r.scale(12)),
              Text(
                "Agrega tu primer medicamento\npara comenzar tu seguimiento",
                style: TextStyle(
                  fontSize: r.font(18),
                  color: const Color(0xFF5B7C99),
                  fontWeight: FontWeight.w600,
                  height: 1.45,
                ),
                textAlign: TextAlign.center,
              ),
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
      icon: const Icon(Icons.add_rounded, size: 30),
      label: const Text(
        "Agregar",
        style: TextStyle(
          fontSize: 19,
          fontWeight: FontWeight.w900,
        ),
      ),
      elevation: 8,
    );
  }

  void _showOptions(
      Map<String, dynamic> treatment,
      int index,
      _Responsive r,
      ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        final bottomSafe = MediaQuery.of(context).padding.bottom;

        return SafeArea(
          top: false,
          bottom: true,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Container(
              decoration: const BoxDecoration(
                color: Color(0xFFF8FAFC),
                borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
              ),
              padding: EdgeInsets.fromLTRB(
                r.sheetPadding,
                r.sheetPadding,
                r.sheetPadding,
                r.sheetPadding + bottomSafe,
              ),
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
                  SizedBox(height: r.sheetGap),
                  Text(
                    treatment['name'] ?? 'Medicamento',
                    style: TextStyle(
                      fontSize: r.font(25),
                      fontWeight: FontWeight.w900,
                      color: const Color(0xFF1E3A5F),
                      height: 1.15,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: r.scale(6)),
                  Text(
                    "${treatment['dosis']} • Próxima toma: ${_getNextDoseTime(treatment)}",
                    style: TextStyle(
                      fontSize: r.font(17),
                      color: const Color(0xFF5B7C99),
                      fontWeight: FontWeight.w700,
                      height: 1.3,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: r.sheetGap),
                  _optionButton(
                    icon: Icons.edit_rounded,
                    label: "Editar",
                    color: const Color(0xFF42A5F5),
                    r: r,
                    onTap: () {
                      Navigator.pop(context);
                      _editTreatment(treatment);
                    },
                  ),
                  SizedBox(height: r.scale(10)),
                  _optionButton(
                    icon: Icons.delete_rounded,
                    label: "Eliminar",
                    color: const Color(0xFFEF5350),
                    r: r,
                    onTap: () {
                      Navigator.pop(context);
                      _confirmDelete(treatment, index);
                    },
                  ),
                  SizedBox(height: r.scale(10)),
                  _optionButton(
                    icon: Icons.close_rounded,
                    label: "Cancelar",
                    color: const Color(0xFF90A4AE),
                    r: r,
                    onTap: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _optionButton({
    required IconData icon,
    required String label,
    required Color color,
    required _Responsive r,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: double.infinity,
      height: r.sheetButtonHeight,
      child: ElevatedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, size: r.scale(25)),
        label: Text(
          label,
          style: TextStyle(
            fontSize: r.font(18),
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
    final width = MediaQuery.of(context).size.width;
    final isSmallScreen = width < 400;

    showDialog(
      context: context,
      builder: (context) => Dialog(
        insetPadding: EdgeInsets.symmetric(
          horizontal: isSmallScreen ? 18 : 32,
        ),
        backgroundColor: Colors.transparent,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Container(
            padding: EdgeInsets.fromLTRB(
              isSmallScreen ? 18 : 24,
              isSmallScreen ? 18 : 24,
              isSmallScreen ? 18 : 24,
              isSmallScreen ? 18 : 22,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFFFFFFFF),
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.16),
                  blurRadius: 22,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: isSmallScreen ? 60 : 72,
                  height: isSmallScreen ? 60 : 72,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFFE4E6),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.delete_rounded,
                    color: const Color(0xFFDC2626),
                    size: isSmallScreen ? 34 : 42,
                  ),
                ),
                SizedBox(height: isSmallScreen ? 12 : 16),
                Text(
                  "Eliminar medicamento",
                  style: TextStyle(
                    fontSize: isSmallScreen ? 21 : 25,
                    fontWeight: FontWeight.w900,
                    color: const Color(0xFF1E3A5F),
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: isSmallScreen ? 10 : 14),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                    horizontal: isSmallScreen ? 12 : 16,
                    vertical: isSmallScreen ? 12 : 14,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: const Color(0xFFE2E8F0),
                      width: 1.2,
                    ),
                  ),
                  child: Text(
                    treatment['name'] ?? 'Medicamento',
                    style: TextStyle(
                      fontSize: isSmallScreen ? 18 : 22,
                      fontWeight: FontWeight.w900,
                      color: const Color(0xFF1E3A5F),
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(height: isSmallScreen ? 10 : 14),
                Text(
                  "Esta acción no se puede deshacer.",
                  style: TextStyle(
                    fontSize: isSmallScreen ? 15.5 : 18,
                    color: const Color(0xFF64748B),
                    fontWeight: FontWeight.w700,
                    height: 1.3,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: isSmallScreen ? 18 : 24),
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        height: isSmallScreen ? 48 : 52,
                        child: ElevatedButton(
                          onPressed: () => Navigator.pop(context),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFE2E8F0),
                            foregroundColor: const Color(0xFF334155),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: Text(
                            "Cancelar",
                            style: TextStyle(
                              fontSize: isSmallScreen ? 15.5 : 18,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: SizedBox(
                        height: isSmallScreen ? 48 : 52,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            _deleteTreatment(index);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFDC2626),
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: Text(
                            "Eliminar",
                            style: TextStyle(
                              fontSize: isSmallScreen ? 15.5 : 18,
                              fontWeight: FontWeight.w900,
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

    final String currentDoseTime = _getNextDoseTime(treatment);
    final String nextDoseTime = _calculateNextDoseTime(treatment);

    final bool controlaCantidad = (treatment['cantidad'] ?? 0) > 0;

    int cantidadActual = treatment['cantidad'] ?? 0;
    int descuento = 1;

    if (treatment['dosis'] == "2 tabletas") {
      descuento = 2;
    } else if (treatment['dosis'] == "Media") {
      descuento = 1;
    }

    int nuevaCantidad = cantidadActual;

    if (controlaCantidad) {
      nuevaCantidad -= descuento;

      if (nuevaCantidad < 0) {
        nuevaCantidad = 0;
      }
    }

    final historyItem = {
      'medicamento': treatment['name'],
      'dosis': treatment['dosis'],
      'fecha': '${now.day}/${now.month}/${now.year}',
      'hora': currentDoseTime,
      'tomado': 1,
    };

    await AppDatabase.instance.insertHistory(historyItem);

    if (controlaCantidad && nuevaCantidad == 0) {
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
        'proximaHora': nextDoseTime,
        'cantidad': nuevaCantidad,
      };

      await AppDatabase.instance.updateTreatment(updatedTreatment);

      try {
        await NotificationService.instance.acknowledgeDose(
          treatmentId: treatment['id'] as int,
          horaInicio: nextDoseTime,
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

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          nuevaCantidad == 0
              ? "${treatment['name']} completado"
              : "¡Buen trabajo! Próxima toma: $nextDoseTime",
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

    final String currentDoseTime = _getNextDoseTime(treatment);
    final String nextDoseTime = _calculateNextDoseTime(treatment);

    final historyItem = {
      'medicamento': treatment['name'],
      'dosis': treatment['dosis'],
      'fecha': '${now.day}/${now.month}/${now.year}',
      'hora': currentDoseTime,
      'tomado': 0,
    };

    await AppDatabase.instance.insertHistory(historyItem);

    final updatedTreatment = {
      'id': treatment['id'],
      'name': treatment['name'],
      'dosis': treatment['dosis'],
      'frecuencia': treatment['frecuencia'],
      'hora': treatment['hora'],
      'proximaHora': nextDoseTime,
      'cantidad': treatment['cantidad'] ?? 0,
    };

    await AppDatabase.instance.updateTreatment(updatedTreatment);

    try {
      await NotificationService.instance.acknowledgeDose(
        treatmentId: treatment['id'] as int,
        horaInicio: nextDoseTime,
        frecuencia: treatment['frecuencia'] as String,
        medicationName: treatment['name'] as String,
        dosis: treatment['dosis'] as String,
      );
    } catch (e) {
      debugPrint("Error reconociendo dosis: $e");
    }

    await _loadTreatments();

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "Dosis omitida. Próxima toma: $nextDoseTime",
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

class _Responsive {
  final double width;
  final double height;

  const _Responsive({
    required this.width,
    required this.height,
  });

  bool get isTablet => width >= 600;
  bool get compactWidth => width < 360;
  bool get compactHeight => height < 680;

  double get maxContentWidth => isTablet ? 560 : double.infinity;

  double get _factor => _clamp(width / 390, 0.82, 1.16);

  double scale(double base) => base * _factor;

  double font(double base) {
    final eased = 1 + (_factor - 1) * 0.50;
    return base * _clamp(eased, 0.88, 1.10);
  }

  double get pagePadding => compactWidth ? 14 : scale(20);

  double get headerPadding => compactHeight ? scale(11) : scale(15);

  double get listTopPadding => compactHeight ? scale(11) : scale(16);

  double get listBottomPadding => compactHeight ? scale(20) : scale(26);

  double get bottomPadding => compactHeight ? scale(20) : scale(26);

  double get topEmptyPadding => compactHeight ? scale(42) : scale(60);

  double get cardPadding => compactHeight ? scale(14) : scale(18);

  double get cardBottomMargin => compactHeight ? scale(13) : scale(17);

  double get cardSectionGap => compactHeight ? scale(16) : scale(21);

  double get smallGap => compactHeight ? scale(10) : scale(13);

  double get buttonGap => compactHeight ? scale(12) : scale(16);

  double get mainIconBox => compactHeight ? scale(50) : scale(60);

  double get mainIconSize => compactHeight ? scale(28) : scale(34);

  double get optionIconPadding => compactHeight ? scale(8) : scale(10);

  double get nextDosePaddingH => compactWidth ? scale(13) : scale(16);

  double get nextDosePaddingV => compactHeight ? scale(12) : scale(15);

  double get clockIconBox => compactHeight ? scale(40) : scale(47);

  double get clockIconSize => compactHeight ? scale(23) : scale(27);

  double get infoPaddingH => compactWidth ? scale(11) : scale(14);

  double get infoPaddingV => compactHeight ? scale(10) : scale(12);

  double get actionButtonHeight => compactHeight ? scale(47) : scale(53);

  double get emptyIconPadding => compactHeight ? scale(30) : scale(42);

  double get emptyIconSize => compactHeight ? scale(68) : scale(96);

  double get emptyGap => compactHeight ? scale(24) : scale(38);

  double get sheetPadding => compactHeight ? scale(18) : scale(24);

  double get sheetGap => compactHeight ? scale(16) : scale(22);

  double get sheetButtonHeight => compactHeight ? scale(50) : scale(60);

  static double _clamp(double value, double min, double max) {
    if (value < min) return min;
    if (value > max) return max;
    return value;
  }
}