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
    _HealthTip(Icons.wb_sunny_rounded, 'Toma aire fresco', 'Si puedes, sal unos minutos a tomar aire fresca en un lugar seguro.'),
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
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 400;

    final tip = tips[todayIndex];

    return Container(
      decoration: const BoxDecoration(
        gradient: AppTheme.mainGradient,
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.fromLTRB(
              isSmallScreen ? 16 : 22,
              isSmallScreen ? 28 : 40,
              isSmallScreen ? 16 : 22,
              isSmallScreen ? 16 : 22,
            ),
            child: Column(
              children: [
                Text(
                  'Consejos de salud',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: isSmallScreen ? 24 : 30,
                    fontWeight: FontWeight.w900,
                    color: const Color(0xFF1E3A5F),
                  ),
                ),
                SizedBox(height: isSmallScreen ? 6 : 8),
                Text(
                  'Un consejo nuevo cada día',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: isSmallScreen ? 14 : 18,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF64748B),
                  ),
                ),
                SizedBox(height: isSmallScreen ? 20 : 28),

                // TIP CARD
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(isSmallScreen ? 20 : 28),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(34),
                    border: Border.all(
                      color: const Color(0xFFD7EAFB),
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.07),
                        blurRadius: 24,
                        offset: const Offset(0, 12),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // ICON
                      Container(
                        padding: EdgeInsets.all(isSmallScreen ? 16 : 24),
                        decoration: const BoxDecoration(
                          color: Color(0xFFE3F2FD),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          tip.icon,
                          size: isSmallScreen ? 60 : 82,
                          color: const Color(0xFF1976D2),
                        ),
                      ),
                      SizedBox(height: isSmallScreen ? 20 : 28),

                      // TITLE
                      Text(
                        tip.title,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: isSmallScreen ? 24 : 32,
                          fontWeight: FontWeight.w900,
                          color: const Color(0xFF1E3A5F),
                        ),
                      ),
                      SizedBox(height: isSmallScreen ? 16 : 22),

                      // MESSAGE
                      Text(
                        tip.message,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: isSmallScreen ? 16 : 24,
                          height: 1.38,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF334155),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: isSmallScreen ? 12 : 12),

                // SETTINGS BUTTON
                _settingsButton(context, isSmallScreen),

                SizedBox(height: isSmallScreen ? 12 : 16),

                // FOOTER TEXT
                Padding(
                  padding: EdgeInsets.only(
                    bottom: isSmallScreen ? 16 : 25,
                  ),
                  child: Text(
                    'Recuerda seguir siempre las indicaciones de tu médico.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: isSmallScreen ? 13 : 16,
                      height: 1.3,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF64748B),
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

  Widget _settingsButton(BuildContext context, bool isSmallScreen) {
    return SizedBox(
      width: double.infinity,
      height: isSmallScreen ? 48 : 58,
      child: ElevatedButton.icon(
        onPressed: () {
          Navigator.pushNamed(context, '/settings');
        },
        icon: Icon(
          Icons.settings_rounded,
          size: isSmallScreen ? 20 : 26,
        ),
        label: Text(
          'Configuración',
          style: TextStyle(
            fontSize: isSmallScreen ? 16 : 20,
            fontWeight: FontWeight.w800,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: const Color(0xFF1976D2),
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