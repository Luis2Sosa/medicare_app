import 'package:flutter/material.dart';
import 'package:medicare_app/core/app_theme.dart';
import 'package:medicare_app/core/database/app_database.dart';
import 'package:medicare_app/services/notification_service.dart';

double _clampD(num value, double lo, double hi) =>
    value.clamp(lo, hi).toDouble();

class TreatmentFormScreen extends StatefulWidget {
  final Map<String, dynamic>? treatment;

  const TreatmentFormScreen({
    super.key,
    this.treatment,
  });

  @override
  State<TreatmentFormScreen> createState() => _TreatmentFormScreenState();
}

class _TreatmentFormScreenState extends State<TreatmentFormScreen> {
  final _formKey = GlobalKey<FormState>();

  String dosis = "1 tableta";
  String frecuencia = "Cada 8 horas";
  TimeOfDay? selectedTime;

  int cantidad = 0;

  final TextEditingController nameCtrl = TextEditingController();
  final TextEditingController cantidadCtrl = TextEditingController();

  int? treatmentId;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    if (widget.treatment != null) {
      nameCtrl.text = widget.treatment!['name'];
      treatmentId = widget.treatment!['id'];
      dosis = widget.treatment!['dosis'];
      frecuencia = widget.treatment!['frecuencia'];
      cantidad = widget.treatment!['cantidad'] ?? 10;
      cantidadCtrl.text = cantidad.toString();

      final hora = widget.treatment!['hora'];
      if (hora is String) {
        selectedTime = _parseTimeOfDay(hora);
      }
    }
  }

  @override
  void dispose() {
    nameCtrl.dispose();
    cantidadCtrl.dispose();
    super.dispose();
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
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            backgroundColor: Colors.white,
            foregroundColor: const Color(0xFF1E3A5F),
            centerTitle: true,
            elevation: 0,
            title: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                treatmentId == null ? "Agregar Medicamento" : "Editar Medicamento",
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.3,
                ),
              ),
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 22),
              onPressed: () => Navigator.pop(context),
            ),
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

                final bottomSafe = MediaQuery.of(context).padding.bottom;
                final keyboard = MediaQuery.of(context).viewInsets.bottom;

                return SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  keyboardDismissBehavior:
                  ScrollViewKeyboardDismissBehavior.onDrag,
                  padding: EdgeInsets.fromLTRB(
                    r.pagePadding,
                    r.topPadding,
                    r.pagePadding,
                    r.bottomPadding + bottomSafe + (keyboard > 0 ? 16 : 0),
                  ),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: r.maxContentWidth,
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: Container(
                                padding: EdgeInsets.all(r.headerIconPadding),
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xFF42A5F5),
                                      Color(0xFF1E88E5),
                                    ],
                                  ),
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFF42A5F5)
                                          .withOpacity(0.3),
                                      blurRadius: 12,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  Icons.medication_rounded,
                                  size: r.headerIconSize,
                                  color: Colors.white,
                                ),
                              ),
                            ),

                            SizedBox(height: r.smallGap),

                            Center(
                              child: Text(
                                "Completa los datos",
                                style: TextStyle(
                                  fontSize: r.font(19),
                                  color: const Color(0xFF5B7C99),
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),

                            SizedBox(height: r.sectionGap),

                            _label("Nombre del medicamento", r),
                            SizedBox(height: r.labelGap),
                            _inputCard(
                              r: r,
                              child: TextFormField(
                                controller: nameCtrl,
                                style: TextStyle(
                                  fontSize: r.font(20.5),
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFF1E3A5F),
                                ),
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Ej: Amoxicilina",
                                  hintStyle: TextStyle(
                                    fontSize: r.font(18.5),
                                    color: const Color(0xFFB0BEC5),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return "Ingresa el nombre del medicamento";
                                  }
                                  return null;
                                },
                              ),
                            ),

                            SizedBox(height: r.sectionGap),

                            _label("¿Cuánto tomar?", r),
                            SizedBox(height: r.labelGap),
                            _segmentSelector(
                              items: const ["1 tableta", "2 tabletas", "Media"],
                              selected: dosis,
                              onSelect: (v) => setState(() => dosis = v),
                              r: r,
                            ),

                            SizedBox(height: r.sectionGap),

                            _label("¿Cada cuánto?", r),
                            SizedBox(height: r.labelGap),
                            _segmentSelector(
                              items: const [
                                "Cada 4 horas",
                                "Cada 6 horas",
                                "Cada 8 horas",
                                "Cada 12 horas",
                                "Cada 24 horas",
                              ],
                              selected: frecuencia,
                              onSelect: (v) => setState(() => frecuencia = v),
                              r: r,
                            ),

                            SizedBox(height: r.sectionGap),

                            _label("¿Cuántas pastillas tienes? (opcional)", r),
                            SizedBox(height: r.labelGap),
                            _inputCard(
                              r: r,
                              child: TextFormField(
                                controller: cantidadCtrl,
                                keyboardType: TextInputType.number,
                                style: TextStyle(
                                  fontSize: r.font(20.5),
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFF1E3A5F),
                                ),
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Ej: 6",
                                  hintStyle: TextStyle(
                                    fontSize: r.font(18.5),
                                    color: const Color(0xFFB0BEC5),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return null;
                                  }

                                  if (int.tryParse(value.trim()) == null) {
                                    return "Solo números";
                                  }

                                  return null;
                                },
                                onChanged: (value) {
                                  cantidad = int.tryParse(value.trim()) ?? 0;
                                },
                              ),
                            ),

                            SizedBox(height: r.sectionGap),

                            _label("¿A qué hora?", r),
                            SizedBox(height: r.labelGap),
                            _inputCard(
                              r: r,
                              child: InkWell(
                                onTap: _pickTime,
                                borderRadius: BorderRadius.circular(18),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 4,
                                    vertical: r.timeFieldVerticalPadding,
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          selectedTime == null
                                              ? "Seleccionar hora"
                                              : _formatTime(selectedTime!),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: r.font(20.5),
                                            fontWeight: FontWeight.w700,
                                            color: selectedTime == null
                                                ? const Color(0xFFB0BEC5)
                                                : const Color(0xFF1E3A5F),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Container(
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFFFA726),
                                          borderRadius:
                                          BorderRadius.circular(12),
                                        ),
                                        child: Icon(
                                          Icons.touch_app_rounded,
                                          color: Colors.white,
                                          size: r.scale(25),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),

                            SizedBox(height: r.sectionGap),

                            _saveButton(r),

                            SizedBox(height: r.afterButtonGap),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  TimeOfDay? _parseTimeOfDay(String horaTexto) {
    try {
      final parts = horaTexto.trim().split(' ');
      final timeParts = parts[0].split(':');

      int hour = int.parse(timeParts[0]);
      final int minute = int.parse(timeParts[1]);
      final String period = parts.length > 1 ? parts[1].toUpperCase() : 'AM';

      if (period == 'PM' && hour != 12) hour += 12;
      if (period == 'AM' && hour == 12) hour = 0;

      return TimeOfDay(hour: hour, minute: minute);
    } catch (_) {
      return null;
    }
  }

  String _formatTime(TimeOfDay time) {
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }

  Future<void> _pickTime() async {
    int hour = selectedTime?.hourOfPeriod ?? TimeOfDay.now().hourOfPeriod;
    if (hour == 0) hour = 12;

    int minute = selectedTime?.minute ?? TimeOfDay.now().minute;
    minute = ((minute / 5).ceil() * 5) % 60;

    String period =
    (selectedTime ?? TimeOfDay.now()).period == DayPeriod.am ? 'AM' : 'PM';

    final result = await showModalBottomSheet<TimeOfDay>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            TimeOfDay buildTime() {
              int finalHour = hour;

              if (period == 'PM' && finalHour != 12) finalHour += 12;
              if (period == 'AM' && finalHour == 12) finalHour = 0;

              return TimeOfDay(hour: finalHour, minute: minute);
            }

            return SafeArea(
              top: false,
              bottom: true,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final compactHeight = constraints.maxHeight < 690;

                  return SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Container(
                      padding: EdgeInsets.fromLTRB(
                        18,
                        compactHeight ? 14 : 18,
                        18,
                        compactHeight ? 18 : 24,
                      ),
                      decoration: const BoxDecoration(
                        color: Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(30),
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 52,
                            height: 5,
                            decoration: BoxDecoration(
                              color: const Color(0xFFD0D7DE),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          SizedBox(height: compactHeight ? 14 : 18),
                          Text(
                            "Seleccionar hora",
                            style: TextStyle(
                              fontSize: compactHeight ? 22 : 24,
                              fontWeight: FontWeight.w900,
                              color: const Color(0xFF1E3A5F),
                            ),
                          ),
                          SizedBox(height: compactHeight ? 16 : 22),

                          Row(
                            children: [
                              Expanded(
                                child: _timeColumn(
                                  title: "Hora",
                                  value: hour.toString().padLeft(2, '0'),
                                  compact: compactHeight,
                                  onAdd: () {
                                    setModalState(() {
                                      hour = hour == 12 ? 1 : hour + 1;
                                    });
                                  },
                                  onRemove: () {
                                    setModalState(() {
                                      hour = hour == 1 ? 12 : hour - 1;
                                    });
                                  },
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: _timeColumn(
                                  title: "Minutos",
                                  value: minute.toString().padLeft(2, '0'),
                                  compact: compactHeight,
                                  onAdd: () {
                                    setModalState(() {
                                      minute = (minute + 5) % 60;
                                    });
                                  },
                                  onRemove: () {
                                    setModalState(() {
                                      minute =
                                      (minute - 5) < 0 ? 55 : minute - 5;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: compactHeight ? 14 : 18),

                          Row(
                            children: [
                              Expanded(
                                child: _periodButton(
                                  text: "AM",
                                  selected: period == "AM",
                                  compact: compactHeight,
                                  onTap: () {
                                    setModalState(() => period = "AM");
                                  },
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: _periodButton(
                                  text: "PM",
                                  selected: period == "PM",
                                  compact: compactHeight,
                                  onTap: () {
                                    setModalState(() => period = "PM");
                                  },
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: compactHeight ? 18 : 24),

                          SizedBox(
                            width: double.infinity,
                            height: compactHeight ? 54 : 58,
                            child: ElevatedButton.icon(
                              onPressed: () {
                                Navigator.pop(context, buildTime());
                              },
                              icon: const Icon(
                                Icons.check_circle_rounded,
                                size: 26,
                              ),
                              label: const FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  "Usar esta hora",
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF10B981),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          },
        );
      },
    );

    if (result != null) {
      setState(() => selectedTime = result);
    }
  }

  Widget _timeColumn({
    required String title,
    required String value,
    required VoidCallback onAdd,
    required VoidCallback onRemove,
    required bool compact,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 10 : 14,
        vertical: compact ? 12 : 16,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: const Color(0xFFD7EAFB),
          width: 2,
        ),
      ),
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: compact ? 15 : 17,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF64748B),
            ),
          ),
          SizedBox(height: compact ? 4 : 8),
          IconButton(
            onPressed: onAdd,
            icon: const Icon(Icons.keyboard_arrow_up_rounded),
            iconSize: compact ? 34 : 40,
            color: const Color(0xFF1976D2),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: compact ? 34 : 40,
              fontWeight: FontWeight.w900,
              color: const Color(0xFF1E3A5F),
            ),
          ),
          IconButton(
            onPressed: onRemove,
            icon: const Icon(Icons.keyboard_arrow_down_rounded),
            iconSize: compact ? 34 : 40,
            color: const Color(0xFF1976D2),
          ),
        ],
      ),
    );
  }

  Widget _periodButton({
    required String text,
    required bool selected,
    required VoidCallback onTap,
    required bool compact,
  }) {
    return SizedBox(
      height: compact ? 52 : 58,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor:
          selected ? const Color(0xFF1976D2) : Colors.white,
          foregroundColor:
          selected ? Colors.white : const Color(0xFF1976D2),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
            side: const BorderSide(
              color: Color(0xFF1976D2),
              width: 2,
            ),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: compact ? 19 : 21,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }

  Widget _label(String text, _Responsive r) {
    return Text(
      text,
      style: TextStyle(
        fontSize: r.font(19.5),
        color: const Color(0xFF1E3A5F),
        fontWeight: FontWeight.w900,
        letterSpacing: 0.2,
      ),
    );
  }

  Widget _inputCard({
    required Widget child,
    required _Responsive r,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: r.inputHorizontalPadding,
        vertical: r.inputVerticalPadding,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFF42A5F5).withOpacity(0.3),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF42A5F5).withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _segmentSelector({
    required List<String> items,
    required String selected,
    required Function(String) onSelect,
    required _Responsive r,
  }) {
    return Column(
      children: items.map((e) {
        final isSelected = e == selected;

        return Padding(
          padding: EdgeInsets.only(bottom: r.segmentBottomMargin),
          child: InkWell(
            onTap: () => onSelect(e),
            borderRadius: BorderRadius.circular(18),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                vertical: r.segmentVerticalPadding,
                horizontal: 8,
              ),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFF42A5F5) : Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: const Color(0xFF42A5F5),
                  width: isSelected ? 3 : 2,
                ),
              ),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (isSelected)
                      Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Icon(
                          Icons.check_circle_rounded,
                          color: Colors.white,
                          size: r.scale(23),
                        ),
                      ),
                    Text(
                      e,
                      style: TextStyle(
                        fontSize: r.font(18),
                        color: isSelected
                            ? Colors.white
                            : const Color(0xFF42A5F5),
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Future<void> _saveTreatment() async {
    if (!_formKey.currentState!.validate()) {
      _showSnackBar("Completa todos los campos", isError: true);
      return;
    }

    if (selectedTime == null) {
      _showSnackBar("Selecciona una hora de alarma", isError: true);
      return;
    }

    setState(() => isLoading = true);

    try {
      final String horaFormateada = _formatTime(selectedTime!);
      final String nombreFinal = _capitalize(nameCtrl.text.trim());

      final treatment = {
        'id': treatmentId,
        'name': nombreFinal,
        'dosis': dosis,
        'frecuencia': frecuencia,
        'hora': horaFormateada,
        'cantidad': cantidad,
      };

      int finalId;

      if (treatmentId == null) {
        finalId = await AppDatabase.instance.insertTreatment(treatment);
      } else {
        await AppDatabase.instance.updateTreatment(treatment);
        finalId = treatmentId!;
      }

      try {
        await NotificationService.instance.scheduleRemindersForTreatment(
          treatmentId: finalId,
          medicationName: nombreFinal,
          dosis: dosis,
          horaInicio: horaFormateada,
          frecuencia: frecuencia,
        );
      } catch (e) {
        debugPrint("Error programando notificación: $e");
      }

      if (!mounted) return;

      _showSnackBar("¡Medicamento guardado!", isError: false);

      await Future.delayed(const Duration(seconds: 1));

      if (!mounted) return;

      Navigator.pop(context, true);
    } catch (e) {
      debugPrint("Error guardando medicamento: $e");

      if (!mounted) return;

      _showSnackBar("Error al guardar el medicamento", isError: true);
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  String _capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }

  void _showSnackBar(String message, {required bool isError}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ),
        ),
        backgroundColor:
        isError ? const Color(0xFFEF5350) : const Color(0xFF66BB6A),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Widget _saveButton(_Responsive r) {
    final String label = r.compactWidth ? "Guardar" : "Guardar Medicamento";

    return SizedBox(
      width: double.infinity,
      height: r.saveButtonHeight,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF66BB6A),
          elevation: 8,
          shadowColor: const Color(0xFF66BB6A).withOpacity(0.4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          disabledBackgroundColor: Colors.grey,
        ),
        onPressed: isLoading ? null : _saveTreatment,
        child: isLoading
            ? SizedBox(
          width: r.scale(28),
          height: r.scale(28),
          child: const CircularProgressIndicator(
            color: Colors.white,
            strokeWidth: 4,
          ),
        )
            : FittedBox(
          fit: BoxFit.scaleDown,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.save_rounded, size: r.scale(27)),
              const SizedBox(width: 12),
              Text(
                label,
                style: TextStyle(
                  fontSize: r.font(20),
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
        ),
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

  double get pagePadding => compactWidth ? 14 : scale(22);

  double get topPadding => compactHeight ? 14 : scale(20);

  double get bottomPadding => compactHeight ? 22 : scale(30);

  double get smallGap => compactHeight ? 12 : 16;

  double get sectionGap => compactHeight ? 21 : 28;

  double get labelGap => compactHeight ? 8 : 10;

  double get afterButtonGap => compactHeight ? 10 : 20;

  double get headerIconPadding => compactHeight ? scale(11) : scale(14);

  double get headerIconSize => compactHeight ? scale(32) : scale(38);

  double get inputHorizontalPadding => compactWidth ? 16 : 20;

  double get inputVerticalPadding => compactHeight ? 6 : 8;

  double get timeFieldVerticalPadding => compactHeight ? 14 : 18;

  double get segmentBottomMargin => compactHeight ? 9 : 12;

  double get segmentVerticalPadding => compactHeight ? scale(13) : scale(16);

  double get saveButtonHeight => compactHeight ? scale(56) : scale(64);

  static double _clamp(double value, double min, double max) {
    if (value < min) return min;
    if (value > max) return max;
    return value;
  }
}