import 'package:flutter/material.dart';
import 'package:medicare_app/core/app_theme.dart';
import 'package:medicare_app/modules/home/main_nav_screen.dart';

class TreatmentFormScreen extends StatefulWidget {
  const TreatmentFormScreen({super.key});

  @override
  State<TreatmentFormScreen> createState() => _TreatmentFormScreenState();
}

class _TreatmentFormScreenState extends State<TreatmentFormScreen> {
  String dosis = "1 tableta";
  String frecuencia = "Cada 8 horas";
  TimeOfDay? selectedTime;

  final TextEditingController nameCtrl = TextEditingController();

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
                          child: TextField(
                            controller: nameCtrl,
                            style: const TextStyle(fontSize: 18),
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: "Ej: Amoxicilina",
                            ),
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
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                  const Icon(Icons.access_time,
                                      color: AppTheme.primaryBlue),
                                ],
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 30),
                        // 🔒 Escaneo por código de barras (FASE 2)
                        //_scanButton(),

                        const SizedBox(height: 120), // 👈 espacio extra
                      ],
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

  // LABEL
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

  // CARD[ajuste]
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

  // SELECTOR
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

  // PICK TIME
  Future<void> _pickTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (time != null) {
      setState(() => selectedTime = time);
    }
  }

  // ESCANEO
  Widget _scanButton() {
    return Container(
      height: 58,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white.withOpacity(0.3),
        border: Border.all(color: AppTheme.primaryBlue, width: 2),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.qr_code_scanner,
              color: AppTheme.primaryBlue, size: 26),
          SizedBox(width: 10),
          Text(
            "Escanear código de barras",
            style: TextStyle(
              color: AppTheme.primaryBlue,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          )
        ],
      ),
    );
  }

  // GUARDAR
  Widget _saveButton() {
    return GestureDetector(
      onTap: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const MainNavScreen()),
        );
      },
      child: Container(
        height: 58,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF1F4BAE), Color(0xFF2A60D4)],
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
        child: const Center(
          child: Text(
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
