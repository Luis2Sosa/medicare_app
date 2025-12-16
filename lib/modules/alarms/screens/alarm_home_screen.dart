import 'package:flutter/material.dart';
import 'package:medicare_app/core/app_theme.dart';

class AlarmHomeScreen extends StatefulWidget {
  const AlarmHomeScreen({super.key});

  @override
  State<AlarmHomeScreen> createState() => _AlarmHomeScreenState();
}

class _AlarmHomeScreenState extends State<AlarmHomeScreen> {
  bool isProcessing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
                ),
              ),

              const SizedBox(height: 10),

              _refillCard(),

              const Spacer(),

              // --- BOTONES POSPONER / TOMADA ---
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
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "9:00 AM",
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryBlue,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  "1 tableta",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  "Amoxicilina",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.primaryBlue.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.medication,
              size: 32,
              color: AppTheme.primaryBlue,
            ),
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
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
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
                  color: Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.warning_amber_rounded,
                  color: Colors.orange,
                  size: 20,
                ),
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: Text(
                  "En 2 días",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryBlue,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            "Amoxicilina",
            style: TextStyle(
              fontSize: 18,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            "Quedan 6 tabletas",
            style: TextStyle(
              fontSize: 14,
              color: Colors.black38,
            ),
          ),
          const SizedBox(height: 14),

          // --- BOTÓN VER FARMACIAS ---
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryBlue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: _openPharmacies,
              icon: const Icon(Icons.local_pharmacy, size: 20),
              label: const Text(
                "Ver farmacias cercanas",
                style: TextStyle(
                  fontSize: 17,
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
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey.shade200,
              foregroundColor: Colors.black87,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: isProcessing ? null : _postponeAlarm,
            icon: const Icon(Icons.schedule, size: 20),
            label: const Text(
              "Posponer",
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryBlue,
              padding: const EdgeInsets.symmetric(vertical: 16),
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
                strokeWidth: 2,
              ),
            )
                : const Icon(Icons.check_circle, size: 20),
            label: Text(
              isProcessing ? "Guardando..." : "Tomada",
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
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

    setState(() => isProcessing = false);

    _showSnackBar(
      "¡Medicamento registrado!",
      icon: Icons.check_circle,
      color: Colors.green,
    );

    // TODO: Guardar en historial y actualizar estado
    // await HistoryService.addEntry(medication);
    // await AlarmService.markAsCompleted();

    // Opcional: navegar o actualizar UI
    // Navigator.pushReplacementNamed(context, "/home");
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

  void _showSnackBar(String message, {required IconData icon, required Color color}) {
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