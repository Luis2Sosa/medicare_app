import 'package:flutter/material.dart';
import 'package:medicare_app/core/app_theme.dart';

class AlarmHomeScreen extends StatefulWidget {
  const AlarmHomeScreen({super.key});

  @override
  State<AlarmHomeScreen> createState() => _AlarmHomeScreenState();
}

class _AlarmHomeScreenState extends State<AlarmHomeScreen> {
  bool isProcessing = false;

  // TODO: Reemplazar con datos reales desde un servicio
  // Estados: 'pendiente', 'atrasada', 'completada'
  String alarmState = 'pendiente'; // Cambiar para probar: pendiente, atrasada, completada
  final String alarmTime = '9:00 AM';
  final String medication = 'Amoxicilina';
  final String dosage = '1 tableta';

  Color get stateColor {
    switch (alarmState) {
      case 'completada':
        return Colors.green;
      case 'atrasada':
        return Colors.red;
      case 'pendiente':
      default:
        return Colors.orange;
    }
  }

  IconData get stateIcon {
    switch (alarmState) {
      case 'completada':
        return Icons.check_circle;
      case 'atrasada':
        return Icons.error;
      case 'pendiente':
      default:
        return Icons.schedule;
    }
  }

  String get stateText {
    switch (alarmState) {
      case 'completada':
        return 'Tomada';
      case 'atrasada':
        return '¡Atrasada!';
      case 'pendiente':
      default:
        return 'Próxima dosis';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.notifications_active, color: AppTheme.primaryBlue),
            SizedBox(width: 8),
            Text(
              "Alarma Médica",
              style: TextStyle(
                color: AppTheme.primaryBlue,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- BLOQUE DE HORA Y MEDICAMENTO ---
              _medicationCard(),

              const SizedBox(height: 30),

              // --- AVISO DE REPOSICIÓN ---
              const Text(
                "AVISO DE REPOSICIÓN",
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.black54,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
              ),

              const SizedBox(height: 10),

              _refillCard(),

              const Spacer(),

              // --- BOTONES SEGÚN ESTADO ---
              _actionButtons(),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _medicationCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: stateColor.withOpacity(0.3),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: stateColor.withOpacity(0.15),
            blurRadius: 15,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        children: [
          // ESTADO
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: stateColor.withOpacity(0.15),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(stateIcon, size: 16, color: stateColor),
                const SizedBox(width: 6),
                Text(
                  stateText,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: stateColor,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      alarmTime,
                      style: TextStyle(
                        fontSize: 42,
                        fontWeight: FontWeight.bold,
                        color: stateColor,
                        letterSpacing: -1,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      dosage,
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.black87,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      medication,
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: stateColor.withOpacity(0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.medication,
                  size: 36,
                  color: stateColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _refillCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.warning_amber_rounded,
                  color: Colors.orange,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  "En 2 días",
                  style: TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryBlue,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Text(
            "Amoxicilina",
            style: TextStyle(
              fontSize: 18,
              color: Colors.black87,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            "Quedan 6 tabletas",
            style: TextStyle(
              fontSize: 14,
              color: Colors.black45,
            ),
          ),
          const SizedBox(height: 16),

          // --- BOTÓN VER FARMACIAS ---
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryBlue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              onPressed: _openPharmacies,
              icon: const Icon(Icons.local_pharmacy, size: 20),
              label: const Text(
                "Ver farmacias cercanas",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _actionButtons() {
    // Si ya está completada, solo mostrar mensaje
    if (alarmState == 'completada') {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.green.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.green.withOpacity(0.3)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.check_circle, color: Colors.green, size: 24),
            SizedBox(width: 12),
            Text(
              "Medicamento tomado correctamente",
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Colors.green,
              ),
            ),
          ],
        ),
      );
    }

    // Para pendiente y atrasada, mostrar botones
    return Row(
      children: [
        if (alarmState != 'atrasada') // No permitir posponer si ya está atrasada
          Expanded(
            child: SizedBox(
              height: 54,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black87,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(color: Colors.grey.shade300, width: 1.5),
                  ),
                ),
                onPressed: isProcessing ? null : _postponeAlarm,
                icon: const Icon(Icons.schedule, size: 20),
                label: const Text(
                  "Posponer",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        if (alarmState != 'atrasada') const SizedBox(width: 15),
        Expanded(
          child: SizedBox(
            height: 54,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: alarmState == 'atrasada' ? Colors.red : AppTheme.primaryBlue,
                elevation: 2,
                shadowColor: (alarmState == 'atrasada' ? Colors.red : AppTheme.primaryBlue).withOpacity(0.4),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: isProcessing ? null : _markAsTaken,
              icon: isProcessing
                  ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2.5,
                ),
              )
                  : const Icon(Icons.check_circle, size: 20),
              label: Text(
                isProcessing
                    ? "Guardando..."
                    : alarmState == 'atrasada'
                    ? "Marcar tomada"
                    : "Tomada",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _postponeAlarm() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text("Posponer alarma"),
        content: const Text("¿Cuánto tiempo quieres posponer esta alarma?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancelar"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _postponeFor(10);
            },
            child: const Text("10 min"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _postponeFor(30);
            },
            child: const Text("30 min"),
          ),
        ],
      ),
    );
  }

  void _postponeFor(int minutes) {
    _showSnackBar(
      "Alarma pospuesta $minutes minutos",
      icon: Icons.schedule,
      color: Colors.orange,
    );

    // TODO: Implementar lógica de posponer alarma
    // await AlarmService.postpone(minutes);
  }

  void _markAsTaken() async {
    setState(() => isProcessing = true);

    // Simular proceso de guardado
    await Future.delayed(const Duration(milliseconds: 800));

    if (!mounted) return;

    setState(() {
      isProcessing = false;
      alarmState = 'completada';
    });

    _showSnackBar(
      "¡Medicamento registrado!",
      icon: Icons.check_circle,
      color: Colors.green,
    );

    // TODO: Guardar en historial y actualizar estado
    // await HistoryService.addEntry(medication);
    // await AlarmService.markAsCompleted();
  }

  void _openPharmacies() {
    _showSnackBar(
      "Abriendo mapa de farmacias...",
      icon: Icons.map,
      color: AppTheme.primaryBlue,
    );

    // TODO: Abrir mapa o lista de farmacias
    // Navigator.pushNamed(context, "/pharmacies");
  }

  void _showSnackBar(String message,
      {required IconData icon, required Color color}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}