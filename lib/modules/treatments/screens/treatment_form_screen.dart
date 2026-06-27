// =============================================================================
// TreatmentFormScreen — versión mejorada
// -----------------------------------------------------------------------------
// Cambios principales:
//  • El botón "Guardar Medicamento" tenía un riesgo real de desbordarse
//    en celulares angostos (el ícono + el texto no entraban). Ahora usa
//    FittedBox como red de seguridad y, en pantallas muy angostas,
//    muestra "Guardar" en vez del texto largo.
//  • La fila de "¿A qué hora?" ahora usa Expanded en el texto, así que
//    nunca se desborda sin importar el formato de hora.
//  • Tamaños de fuente, íconos y espacios se calculan según el ancho de
//    pantalla, con límites (clamp) para que se vea bien en cualquier
//    celular.
//  • El formulario se centra con un ancho máximo en pantallas grandes
//    (tablets).
//  • Al guardar, ahora se programa (o reprograma) automáticamente la
//    alarma real del medicamento usando NotificationService — así
//    sonará aunque el celular esté bloqueado o la app esté cerrada.
//  • Toda la lógica de negocio (validaciones, base de datos, formato de
//    hora) se mantiene igual.
// =============================================================================

import 'package:flutter/material.dart';
import 'package:medicare_app/core/app_theme.dart';
import 'package:medicare_app/core/database/app_database.dart';
import 'package:medicare_app/services/notification_service.dart';

double _clampD(num value, double lo, double hi) => value.clamp(lo, hi).toDouble();

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

  int cantidad = 10;

  final TextEditingController nameCtrl = TextEditingController();
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
    }
  }

  @override
  void dispose() {
    nameCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
          title: const FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              "Agregar Medicamento",
              style: TextStyle(
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
          child: LayoutBuilder(
            builder: (context, constraints) {
              final double s = _clampD(constraints.maxWidth / 390.0, 0.82, 1.25);
              final bool compactW = constraints.maxWidth < 360;

              return Column(
                children: [
                  // FORMULARIO CON SCROLL
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                      padding: EdgeInsets.all(compactW ? 18 : 24),
                      child: Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 560),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // HEADER COMPACTO
                                Center(
                                  child: Container(
                                    padding: EdgeInsets.all(_clampD(14 * s, 12, 16)),
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
                                          color: const Color(0xFF42A5F5).withOpacity(0.3),
                                          blurRadius: 12,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: Icon(
                                      Icons.medication_rounded,
                                      size: _clampD(38 * s, 32, 42),
                                      color: Colors.white,
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 16),

                                Center(
                                  child: Text(
                                    "Completa los datos",
                                    style: TextStyle(
                                      fontSize: _clampD(19 * s, 17, 20),
                                      color: const Color(0xFF5B7C99),
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 28),

                                // NOMBRE DEL MEDICAMENTO
                                _label("Nombre del medicamento", s),
                                const SizedBox(height: 10),
                                _inputCard(
                                  child: TextFormField(
                                    controller: nameCtrl,
                                    style: TextStyle(
                                      fontSize: _clampD(21 * s, 18, 22),
                                      fontWeight: FontWeight.w700,
                                      color: const Color(0xFF1E3A5F),
                                    ),
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "Ej: Amoxicilina",
                                      hintStyle: TextStyle(
                                        fontSize: _clampD(19 * s, 17, 20),
                                        color: const Color(0xFFB0BEC5),
                                        fontWeight: FontWeight.w500,
                                      ),
                                      contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 4,
                                        vertical: 4,
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

                                const SizedBox(height: 28),

                                // DOSIS
                                _label("¿Cuánto tomar?", s),
                                const SizedBox(height: 12),
                                _segmentSelector(
                                  items: ["1 tableta", "2 tabletas", "Media"],
                                  selected: dosis,
                                  onSelect: (v) => setState(() => dosis = v),
                                  s: s,
                                ),

                                const SizedBox(height: 28),

                                // FRECUENCIA
                                _label("¿Cada cuánto?", s),
                                const SizedBox(height: 12),
                                _segmentSelector(
                                  items: [
                                    "Cada 4 horas",
                                    "Cada 6 horas",
                                    "Cada 8 horas",
                                    "Cada 12 horas",
                                    "Cada 24 horas",
                                  ],
                                  selected: frecuencia,
                                  onSelect: (v) => setState(() => frecuencia = v),
                                  s: s,
                                ),

                                const SizedBox(height: 28),

                                _label("¿Cuántas pastillas tienes? (opcional)", s),
                                const SizedBox(height: 10),

                                _inputCard(
                                  child: TextFormField(
                                    keyboardType: TextInputType.number,
                                    style: TextStyle(
                                      fontSize: _clampD(21 * s, 18, 22),
                                      fontWeight: FontWeight.w700,
                                      color: const Color(0xFF1E3A5F),
                                    ),
                                    decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "Ej: 6",
                                      hintStyle: TextStyle(
                                        fontSize: _clampD(19 * s, 17, 20),
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

                                const SizedBox(height: 28),

                                // HORA DE ALARMA
                                _label("¿A qué hora?", s),
                                const SizedBox(height: 10),
                                _inputCard(
                                  child: InkWell(
                                    onTap: _pickTime,
                                    borderRadius: BorderRadius.circular(18),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 4,
                                        vertical: 18,
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          // Expanded + ellipsis: nunca se
                                          // desborda, sin importar el
                                          // formato de hora.
                                          Expanded(
                                            child: Text(
                                              selectedTime == null
                                                  ? "Seleccionar hora"
                                                  : _formatTime(selectedTime!),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontSize: _clampD(21 * s, 18, 22),
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
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                            child: Icon(
                                              Icons.access_time_rounded,
                                              color: Colors.white,
                                              size: _clampD(26 * s, 22, 28),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 80),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  // BOTÓN FIJO GRANDE
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                      compactW ? 18 : 24,
                      0,
                      compactW ? 18 : 24,
                      20,
                    ),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 560),
                        child: _saveButton(s, compactW),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  String _formatTime(TimeOfDay time) {
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }

  Widget _label(String text, double s) {
    return Text(
      text,
      style: TextStyle(
        fontSize: _clampD(20 * s, 18, 22),
        color: const Color(0xFF1E3A5F),
        fontWeight: FontWeight.w900,
        letterSpacing: 0.2,
      ),
    );
  }

  Widget _inputCard({required Widget child}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
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
          )
        ],
      ),
      child: child,
    );
  }

  Widget _segmentSelector({
    required List<String> items,
    required String selected,
    required Function(String) onSelect,
    required double s,
  }) {
    return Column(
      children: items.map((e) {
        final isSelected = e == selected;
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: InkWell(
            onTap: () => onSelect(e),
            borderRadius: BorderRadius.circular(18),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: _clampD(16 * s, 14, 18)),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFF42A5F5) : Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: const Color(0xFF42A5F5),
                  width: isSelected ? 3 : 2,
                ),
                boxShadow: [
                  if (isSelected)
                    BoxShadow(
                      color: const Color(0xFF42A5F5).withOpacity(0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    )
                ],
              ),
              // FittedBox: si el texto más largo ("Cada 24 horas" + el
              // ícono de check) no entra en pantallas muy angostas, se
              // reduce solo en vez de desbordarse.
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
                          size: _clampD(24 * s, 20, 26),
                        ),
                      ),
                    Text(
                      e,
                      style: TextStyle(
                        fontSize: _clampD(18 * s, 16, 20),
                        color: isSelected ? Colors.white : const Color(0xFF42A5F5),
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

  Future<void> _pickTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            timePickerTheme: TimePickerThemeData(
              // Aumentar tamaño de texto en el picker
              hourMinuteTextStyle: const TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.w900,
              ),
              helpTextStyle: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (time != null) {
      setState(() => selectedTime = time);
    }
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
        await NotificationService.instance.scheduleReminder(
          id: finalId,
          medicationName: nombreFinal,
          dosis: dosis,
          horaTexto: horaFormateada,
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

    return text[0].toUpperCase() +
        text.substring(1).toLowerCase();
  }

  void _showSnackBar(String message, {required bool isError}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              isError ? Icons.error_outline : Icons.check_circle,
              color: Colors.white,
              size: 28,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: isError ? const Color(0xFFEF5350) : const Color(0xFF66BB6A),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        margin: const EdgeInsets.all(20),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      ),
    );
  }

  Widget _saveButton(double s, bool compactW) {
    // En pantallas angostas usamos un texto más corto para que nunca
    // le falte espacio; en pantallas normales, el texto completo.
    final String label = compactW ? "Guardar" : "Guardar Medicamento";

    return SizedBox(
      width: double.infinity,
      height: _clampD(64 * s, 58, 70),
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
          width: _clampD(30 * s, 26, 32),
          height: _clampD(30 * s, 26, 32),
          child: const CircularProgressIndicator(
            color: Colors.white,
            strokeWidth: 4,
          ),
        )
        // FittedBox: red de seguridad final — el ícono y el texto
        // nunca se desbordan, sin importar el ancho del celular.
            : FittedBox(
          fit: BoxFit.scaleDown,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.save_rounded, size: _clampD(28 * s, 24, 30)),
              const SizedBox(width: 12),
              Text(
                label,
                style: TextStyle(
                  fontSize: _clampD(20 * s, 18, 22),
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