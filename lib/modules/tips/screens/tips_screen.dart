import 'package:flutter/material.dart';
import 'package:medicare_app/core/app_theme.dart';

class TipsScreen extends StatelessWidget {
  const TipsScreen({super.key});

  final List<_HealthTip> tips = const [
    _HealthTip(Icons.water_drop_rounded, 'Toma agua', 'Toma agua durante el día, aunque no tengas sed. Mantenerte hidratado ayuda a tu cuerpo a funcionar mejor.'),
    _HealthTip(Icons.medication_rounded, 'Medicamentos a tiempo', 'Toma tus medicamentos a la hora indicada. Usa esta app como apoyo para no olvidar tus tratamientos.'),
    _HealthTip(Icons.directions_walk_rounded, 'Camina con cuidado', 'Camina unos minutos al día si tu médico te lo permite. Hazlo despacio y con zapatos seguros.'),
    _HealthTip(Icons.restaurant_rounded, 'Come a tus horas', 'Comer a tus horas ayuda a mantener energía y evita debilidad durante el día.'),
    _HealthTip(Icons.bedtime_rounded, 'Descansa bien', 'Dormir bien ayuda a tu cuerpo a recuperarse y mejora tu ánimo.'),
    _HealthTip(Icons.lightbulb_rounded, 'Casa iluminada', 'Mantén tu casa bien iluminada, especialmente de noche, para evitar tropiezos o caídas.'),
    _HealthTip(Icons.health_and_safety_rounded, 'No te automediques', 'No tomes medicamentos nuevos sin consultar con un médico o farmacéutico.'),
    _HealthTip(Icons.calendar_month_rounded, 'Anota tus citas', 'Escribe tus citas médicas en un calendario o pídele ayuda a un familiar para recordarlas.'),
    _HealthTip(Icons.warning_rounded, 'Revisa vencimientos', 'Revisa la fecha de vencimiento de tus medicamentos antes de tomarlos.'),
    _HealthTip(Icons.favorite_rounded, 'Cuida tu corazón', 'Controla tu presión si tu médico te lo indicó y sigue sus recomendaciones.'),
    _HealthTip(Icons.family_restroom_rounded, 'Mantente acompañado', 'Habla con familiares o personas de confianza. Conversar también ayuda a tu bienestar.'),
    _HealthTip(Icons.chair_rounded, 'Levántate despacio', 'Levántate poco a poco de la cama o la silla para evitar mareos.'),
    _HealthTip(Icons.list_alt_rounded, 'Lista de medicinas', 'Ten una lista escrita con los medicamentos que tomas y sus horarios.'),
    _HealthTip(Icons.clean_hands_rounded, 'Lava tus manos', 'Lávate las manos con frecuencia, especialmente antes de comer y después de salir.'),
    _HealthTip(Icons.home_rounded, 'Evita obstáculos', 'Mantén los pasillos libres de objetos para caminar con más seguridad.'),
    _HealthTip(Icons.local_hospital_rounded, 'Consulta síntomas', 'Si sientes algo extraño después de tomar un medicamento, consulta a un profesional.'),
    _HealthTip(Icons.spa_rounded, 'Respira tranquilo', 'Toma unos minutos para respirar profundo y relajarte durante el día.'),
    _HealthTip(Icons.no_food_rounded, 'Cuida la sal', 'Evita el exceso de sal si tu médico te lo ha recomendado.'),
    _HealthTip(Icons.phone_rounded, 'Emergencias cerca', 'Ten cerca los números de emergencia y el contacto de un familiar.'),
    _HealthTip(Icons.inventory_2_rounded, 'Guarda bien tus medicinas', 'Guarda los medicamentos lejos del calor, la humedad y el alcance de niños.'),
    _HealthTip(Icons.access_time_rounded, 'Respeta los horarios', 'Tomar tus medicamentos a la misma hora cada día ayuda a que el tratamiento funcione mejor.'),
    _HealthTip(Icons.visibility_rounded, 'Lee las indicaciones', 'Lee bien las instrucciones del medicamento o pide ayuda si las letras son pequeñas.'),
    _HealthTip(Icons.medical_information_rounded, 'Chequeos médicos', 'Haz tus chequeos médicos de rutina aunque te sientas bien.'),
    _HealthTip(Icons.elderly_rounded, 'Muévete despacio', 'No camines con prisa. Lo importante es moverte con seguridad.'),
    _HealthTip(Icons.local_drink_rounded, 'Agua cerca', 'Mantén un vaso o botella de agua cerca para recordar hidratarte.'),
    _HealthTip(Icons.sentiment_satisfied_rounded, 'Cuida tu ánimo', 'Si te sientes triste o solo, habla con alguien de confianza. No estás solo.'),
    _HealthTip(Icons.healing_rounded, 'No suspendas tratamientos', 'No dejes un medicamento sin hablar primero con tu médico.'),
    _HealthTip(Icons.wb_sunny_rounded, 'Toma aire fresco', 'Si puedes, sal unos minutos a tomar aire fresco en un lugar seguro.'),
    _HealthTip(Icons.check_circle_rounded, 'Celebra tus avances', 'Cada día que cuidas tu salud es un logro importante.'),
    _HealthTip(Icons.volunteer_activism_rounded, 'Cuídate con amor', 'Tu salud es valiosa. Cuidarte cada día también es una forma de quererte.'),
  ];

  int get todayIndex {
    final now = DateTime.now();
    final startOfYear = DateTime(now.year, 1, 1);
    final dayNumber = now.difference(startOfYear).inDays;
    return dayNumber % tips.length;
  }

  @override
  Widget build(BuildContext context) {
    final tip = tips[todayIndex];

    return Container(
      decoration: const BoxDecoration(
        gradient: AppTheme.mainGradient,
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(22, 40, 22, 22),
            child: Column(
              children: [
                const Text(
                  'Consejos de salud',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF1E3A5F),
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Un consejo nuevo cada día',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF64748B),
                  ),
                ),
                const SizedBox(height: 28),

                Expanded(
                  child: Center(
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(28),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(34),
                        border: Border.all(
                          color: const Color(0xFFD7EAFB),
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.07),
                            blurRadius: 24,
                            offset: const Offset(0, 12),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(24),
                            decoration: const BoxDecoration(
                              color: Color(0xFFE3F2FD),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              tip.icon,
                              size: 82,
                              color: const Color(0xFF1976D2),
                            ),
                          ),
                          const SizedBox(height: 28),
                          Text(
                            tip.title,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFF1E3A5F),
                            ),
                          ),
                          const SizedBox(height: 22),
                          Text(
                            tip.message,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 24,
                              height: 1.38,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF334155),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                _settingsButton(context),

                const SizedBox(height: 16),

                const Padding(
                  padding: EdgeInsets.only(bottom: 25),
                  child: Text(
                    'Recuerda seguir siempre las indicaciones de tu médico.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      height: 1.3,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF64748B),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _settingsButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 58,
      child: ElevatedButton.icon(
        onPressed: () {
          Navigator.pushNamed(context, '/settings');
        },
        icon: const Icon(
          Icons.settings_rounded,
          size: 26,
        ),
        label: const Text(
          'Configuración',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Color(0xFF1976D2),
          elevation: 4,
          shadowColor: Colors.black26,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
            side: const BorderSide(
              color: Color(0xFFD7EAFB),
              width: 2,
            ),
          ),
        ),
      ),
    );
  }
}

class _HealthTip {
  final IconData icon;
  final String title;
  final String message;

  const _HealthTip(
      this.icon,
      this.title,
      this.message,
      );
}