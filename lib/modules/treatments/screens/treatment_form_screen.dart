import 'package:flutter/material.dart';
import 'package:medicare_app/core/app_theme.dart';
import 'package:medicare_app/core/database/app_database.dart';

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
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 400;

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
          title: Text(
            "Agregar Medicamento",
            style: TextStyle(
              fontSize: isSmallScreen ? 20 : 24,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.3,
            ),
          ),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              size: isSmallScreen ? 18 : 22,
            ),
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
          child: Column(
            children: [
              // FORMULARIO CON SCROLL
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  keyboardDismissBehavior:
                  ScrollViewKeyboardDismissBehavior.onDrag,
                  padding: EdgeInsets.all(isSmallScreen ? 16 : 24),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // HEADER COMPACTO
                        Center(
                          child: Container(
                            padding: EdgeInsets.all(isSmallScreen ? 10 : 14),
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
                              size: isSmallScreen ? 32 : 40,
                              color: Colors.white,
                            ),
                          ),
                        ),

                        SizedBox(height: isSmallScreen ? 12 : 16),

                        Center(
                          child: Text(
                            "Completa los datos",
                            style: TextStyle(
                              fontSize: isSmallScreen ? 16 : 20,
                              color: const Color(0xFF5B7C99),
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),

                        SizedBox(height: isSmallScreen ? 20 : 28),

                        // NOMBRE DEL MEDICAMENTO
                        _label("Nombre del medicamento", isSmallScreen),
                        SizedBox(height: isSmallScreen ? 8 : 10),
                        _inputCard(
                          isSmallScreen: isSmallScreen,
                          child: TextFormField(
                            controller: nameCtrl,
                            style: TextStyle(
                              fontSize: isSmallScreen ? 18 : 22,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF1E3A5F),
                            ),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Ej: Amoxicilina",
                              hintStyle: TextStyle(
                                fontSize: isSmallScreen ? 16 : 20,
                                color: const Color(0xFFB0BEC5),
                                fontWeight: FontWeight.w500,
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: isSmallScreen ? 2 : 4,
                                vertical: isSmallScreen ? 2 : 4,
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

                        SizedBox(height: isSmallScreen ? 20 : 28),

                        // DOSIS
                        _label("¿Cuánto tomar?", isSmallScreen),
                        SizedBox(height: isSmallScreen ? 10 : 12),
                        _segmentSelector(
                          items: ["1 tableta", "2 tabletas", "Media"],
                          selected: dosis,
                          isSmallScreen: isSmallScreen,
                          onSelect: (v) => setState(() => dosis = v),
                        ),

                        SizedBox(height: isSmallScreen ? 20 : 28),

                        // FRECUENCIA
                        _label("¿Cada cuánto?", isSmallScreen),
                        SizedBox(height: isSmallScreen ? 10 : 12),
                        _segmentSelector(
                          items: [
                            "Cada 4 horas",
                            "Cada 6 horas",
                            "Cada 8 horas",
                            "Cada 12 horas",
                            "Cada 24 horas",
                          ],
                          selected: frecuencia,
                          isSmallScreen: isSmallScreen,
                          onSelect: (v) => setState(() => frecuencia = v),
                        ),

                        SizedBox(height: isSmallScreen ? 20 : 28),

                        _label("¿Cuántas pastillas tienes? (opcional)",
                            isSmallScreen),
                        SizedBox(height: isSmallScreen ? 8 : 10),

                        _inputCard(
                          isSmallScreen: isSmallScreen,
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            style: TextStyle(
                              fontSize: isSmallScreen ? 18 : 22,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF1E3A5F),
                            ),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Ej: 6",
                              hintStyle: TextStyle(
                                fontSize: isSmallScreen ? 16 : 20,
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

                        SizedBox(height: isSmallScreen ? 20 : 28),

                        // HORA DE ALARMA
                        _label("¿A qué hora?", isSmallScreen),
                        SizedBox(height: isSmallScreen ? 8 : 10),
                        _inputCard(
                          isSmallScreen: isSmallScreen,
                          child: InkWell(
                            onTap: _pickTime,
                            borderRadius: BorderRadius.circular(18),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: isSmallScreen ? 2 : 4,
                                vertical: isSmallScreen ? 12 : 18,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    selectedTime == null
                                        ? "Seleccionar hora"
                                        : _formatTime(selectedTime!),
                                    style: TextStyle(
                                      fontSize: isSmallScreen ? 18 : 22,
                                      fontWeight: FontWeight.w700,
                                      color: selectedTime == null
                                          ? const Color(0xFFB0BEC5)
                                          : const Color(0xFF1E3A5F),
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.all(
                                        isSmallScreen ? 6 : 8),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFFFA726),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Icon(
                                      Icons.access_time_rounded,
                                      color: Colors.white,
                                      size: isSmallScreen ? 22 : 28,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: isSmallScreen ? 40 : 80),
                      ],
                    ),
                  ),
                ),
              ),

              // BOTÓN FIJO GRANDE
              Padding(
                padding: EdgeInsets.fromLTRB(
                  isSmallScreen ? 16 : 24,
                  0,
                  isSmallScreen ? 16 : 24,
                  isSmallScreen ? 14 : 20,
                ),
                child: _saveButton(isSmallScreen),
              ),
            ],
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

  Widget _label(String text, bool isSmallScreen) {
    return Text(
      text,
      style: TextStyle(
        fontSize: isSmallScreen ? 18 : 22,
        color: const Color(0xFF1E3A5F),
        fontWeight: FontWeight.w900,
        letterSpacing: 0.2,
      ),
    );
  }

  Widget _inputCard({
    required Widget child,
    required bool isSmallScreen,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isSmallScreen ? 16 : 20,
        vertical: isSmallScreen ? 6 : 8,
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
          )
        ],
      ),
      child: child,
    );
  }

  Widget _segmentSelector({
    required List<String> items,
    required String selected,
    required bool isSmallScreen,
    required Function(String) onSelect,
  }) {
    return Column(
      children: items.map((e) {
        final isSelected = e == selected;
        return Padding(
          padding: EdgeInsets.only(bottom: isSmallScreen ? 10 : 12),
          child: InkWell(
            onTap: () => onSelect(e),
            borderRadius: BorderRadius.circular(18),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                vertical: isSmallScreen ? 14 : 18,
              ),
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (isSelected)
                    Padding(
                      padding: EdgeInsets.only(right: isSmallScreen ? 8 : 10),
                      child: Icon(
                        Icons.check_circle_rounded,
                        color: Colors.white,
                        size: isSmallScreen ? 22 : 28,
                      ),
                    ),
                  Text(
                    e,
                    style: TextStyle(
                      fontSize: isSmallScreen ? 16 : 20,
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

  void _saveTreatment() async {
    if (!_formKey.currentState!.validate()) {
      _showSnackBar("Completa todos los campos", isError: true);
      return;
    }

    if (selectedTime == null) {
      _showSnackBar("Selecciona una hora de alarma", isError: true);
      return;
    }

    setState(() => isLoading = true);

    final treatment = {
      'id': treatmentId,
      'name': _capitalize(nameCtrl.text.trim()),
      'dosis': dosis,
      'frecuencia': frecuencia,
      'hora': _formatTime(selectedTime!),
      'cantidad': cantidad,
    };

    if (treatmentId == null) {
      await AppDatabase.instance.insertTreatment(treatment);
    } else {
      await AppDatabase.instance.updateTreatment(treatment);
    }

    if (!mounted) return;

    setState(() => isLoading = false);

    _showSnackBar("¡Medicamento guardado!", isError: false);

    await Future.delayed(const Duration(seconds: 1));

    if (!mounted) return;

    Navigator.pop(context, true);
  }

  String _capitalize(String text) {
    if (text.isEmpty) return text;

    return text[0].toUpperCase() + text.substring(1).toLowerCase();
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
        backgroundColor:
        isError ? const Color(0xFFEF5350) : const Color(0xFF66BB6A),
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

  Widget _saveButton(bool isSmallScreen) {
    return SizedBox(
      width: double.infinity,
      height: isSmallScreen ? 54 : 68,
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
            ? const SizedBox(
          width: 32,
          height: 32,
          child: CircularProgressIndicator(
            color: Colors.white,
            strokeWidth: 4,
          ),
        )
            : Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.save_rounded,
              size: isSmallScreen ? 24 : 32,
            ),
            SizedBox(width: isSmallScreen ? 10 : 14),
            Text(
              "Guardar Medicamento",
              style: TextStyle(
                fontSize: isSmallScreen ? 16 : 22,
                fontWeight: FontWeight.w900,
                letterSpacing: 0.3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}