import 'package:flutter/material.dart';
import 'package:medicare_app/core/app_theme.dart';

class TreatmentFormScreen extends StatefulWidget {
  const TreatmentFormScreen({super.key});

  @override
  State<TreatmentFormScreen> createState() => _TreatmentFormScreenState();
}

class _TreatmentFormScreenState extends State<TreatmentFormScreen> {
  final _formKey = GlobalKey<FormState>();

  String dosis = "1 tableta";
  String frecuencia = "Cada 8 horas";
  TimeOfDay? selectedTime;

  final TextEditingController nameCtrl = TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    nameCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppTheme.mainGradient,
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22),
            child: Column(
              children: [
                // 👉 FORMULARIO (SCROLL)
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(height: 10),

                          Image.asset(
                            "assets/images/medicare_logo.png",
                            width: 160,
                          ),

                          const SizedBox(height: 10),

                          const Text(
                            "Registrar tratamiento",
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.primaryBlue,
                            ),
                          ),

                          const SizedBox(height: 6),

                          const Text(
                            "Añade tus medicamentos fácilmente",
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.black54,
                            ),
                          ),

                          const SizedBox(height: 20),

                          _label("Nombre del medicamento"),
                          _inputCard(
                            child: TextFormField(
                              controller: nameCtrl,
                              style: const TextStyle(fontSize: 18),
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: "Ej: Amoxicilina",
                              ),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return "Por favor ingresa el nombre del medicamento";
                                }
                                return null;
                              },
                            ),
                          ),

                          const SizedBox(height: 25),

                          _label("Dosis"),
                          _segmentSelector(
                            items: ["1 tableta", "2 tabletas", "Media tableta"],
                            selected: dosis,
                            onSelect: (v) => setState(() => dosis = v),
                          ),

                          const SizedBox(height: 25),

                          _label("Frecuencia"),
                          _segmentSelector(
                            items: [
                              "Cada 8 horas",
                              "Cada 12 horas",
                              "Cada 24 horas",
                            ],
                            selected: frecuencia,
                            onSelect: (v) => setState(() => frecuencia = v),
                          ),

                          const SizedBox(height: 25),

                          _label("Hora de alarma"),
                          _inputCard(
                            child: GestureDetector(
                              onTap: _pickTime,
                              child: Container(
                                padding:
                                const EdgeInsets.symmetric(vertical: 14),
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      selectedTime == null
                                          ? "Seleccionar hora"
                                          : "${selectedTime!.hour}:${selectedTime!.minute.toString().padLeft(2, '0')}",
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: selectedTime == null
                                            ? Colors.grey
                                            : Colors.black87,
                                      ),
                                    ),
                                    const Icon(Icons.access_time,
                                        color: AppTheme.primaryBlue),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 120),
                        ],
                      ),
                    ),
                  ),
                ),

                // 👉 BOTÓN FIJO
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _saveButton(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _label(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 20,
          color: AppTheme.primaryBlue,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _inputCard({required Widget child}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
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
  }) {
    return Row(
      children: items.map((e) {
        final isSelected = e == selected;
        return Expanded(
          child: GestureDetector(
            onTap: () => onSelect(e),
            child: Container(
              height: 50,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                color: isSelected ? AppTheme.primaryBlue : Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppTheme.primaryBlue, width: 1.8),
                boxShadow: [
                  if (isSelected)
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 10,
                    )
                ],
              ),
              child: Center(
                child: Text(
                  e,
                  style: TextStyle(
                    fontSize: 15,
                    color: isSelected ? Colors.white : AppTheme.primaryBlue,
                    fontWeight:
                    isSelected ? FontWeight.bold : FontWeight.w600,
                  ),
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
    );

    if (time != null) {
      setState(() => selectedTime = time);
    }
  }

  void _saveTreatment() async {
    // Validar formulario
    if (!_formKey.currentState!.validate()) {
      _showSnackBar("Por favor completa todos los campos", isError: true);
      return;
    }

    // Validar hora seleccionada
    if (selectedTime == null) {
      _showSnackBar("Por favor selecciona una hora de alarma", isError: true);
      return;
    }

    setState(() => isLoading = true);

    // Simular guardado (aquí irían tus servicios de guardado real)
    await Future.delayed(const Duration(milliseconds: 800));

    // TODO: Aquí guardarías los datos:
    // final treatment = Treatment(
    //   name: nameCtrl.text.trim(),
    //   dosis: dosis,
    //   frecuencia: frecuencia,
    //   alarmTime: selectedTime!,
    // );
    // await TreatmentService.save(treatment);

    if (!mounted) return;

    setState(() => isLoading = false);

    _showSnackBar("¡Tratamiento guardado exitosamente!", isError: false);

    // Navegar después de 1 segundo
    await Future.delayed(const Duration(seconds: 1));

    if (!mounted) return;

    Navigator.pushReplacementNamed(context, "/home");
  }

  void _showSnackBar(String message, {required bool isError}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Widget _saveButton() {
    return GestureDetector(
      onTap: isLoading ? null : _saveTreatment,
      child: Container(
        height: 58,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isLoading
                ? [Colors.grey, Colors.grey.shade400]
                : [const Color(0xFF1F4BAE), const Color(0xFF2A60D4)],
          ),
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Center(
          child: isLoading
              ? const SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 3,
            ),
          )
              : const Text(
            "Guardar",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}