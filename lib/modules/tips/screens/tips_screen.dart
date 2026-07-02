import 'package:flutter/material.dart';
import 'package:medicare_app/core/app_theme.dart';

class TipsScreen extends StatelessWidget {
  const TipsScreen({super.key});

  static const List<_HealthTip> _tips = [
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

  static const List<String> _weekDays = [
    'Lunes', 'Martes', 'Miércoles', 'Jueves', 'Viernes', 'Sábado', 'Domingo',
  ];

  static const List<String> _months = [
    'enero', 'febrero', 'marzo', 'abril', 'mayo', 'junio',
    'julio', 'agosto', 'septiembre', 'octubre', 'noviembre', 'diciembre',
  ];

  int _todayIndex(DateTime now) {
    final startOfYear = DateTime(now.year, 1, 1);
    final dayNumber = now.difference(startOfYear).inDays;
    return dayNumber % _tips.length;
  }

  String _todayText(DateTime now) {
    return '${_weekDays[now.weekday - 1]}, ${now.day} de ${_months[now.month - 1]}';
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final tip = _tips[_todayIndex(now)];
    final dateText = _todayText(now);

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
          body: SafeArea(
            top: true,
            bottom: true,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final r = _Responsive(
                  width: constraints.maxWidth,
                  height: constraints.maxHeight,
                );

                final bottomSafe = MediaQuery.of(context).padding.bottom;

                return SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.fromLTRB(
                    r.pagePadding,
                    r.topPadding,
                    r.pagePadding,
                    r.bottomPadding + bottomSafe,
                  ),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: r.maxContentWidth,
                      ),
                      child: Column(
                        children: [
                          _topHeader(r),
                          SizedBox(height: r.gap),
                          _summaryCard(r, dateText),
                          SizedBox(height: r.gap),
                          _tipCard(tip, r),
                          SizedBox(height: r.gap),
                          _settingsButton(context, r),
                          SizedBox(height: r.smallGap),
                          _footerText(r),
                        ],
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

  Widget _topHeader(_Responsive r) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: r.scale(14),
        vertical: r.headerVerticalPadding,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.72),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: const Color(0xFFD7EAFB),
          width: 1.4,
        ),
      ),
      child: Column(
        children: [
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              'Consejos de salud',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: r.font(29),
                fontWeight: FontWeight.w900,
                color: const Color(0xFF1E3A5F),
                letterSpacing: -0.3,
              ),
            ),
          ),
          SizedBox(height: r.scale(4)),
          Text(
            'Un consejo nuevo cada día',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: r.font(15.5),
              fontWeight: FontWeight.w800,
              color: const Color(0xFF64748B),
            ),
          ),
        ],
      ),
    );
  }

  Widget _summaryCard(_Responsive r, String dateText) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(r.cardPadding),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F9FC),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: const Color(0xFF64B5F6),
          width: 1.6,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF64B5F6).withOpacity(0.12),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: r.summaryIconBox,
            height: r.summaryIconBox,
            decoration: const BoxDecoration(
              color: Color(0xFFE3F2FD),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.favorite_rounded,
              color: const Color(0xFF1976D2),
              size: r.summaryIconSize,
            ),
          ),
          SizedBox(width: r.scale(12)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  dateText,
                  style: TextStyle(
                    fontSize: r.font(17.5),
                    fontWeight: FontWeight.w900,
                    color: const Color(0xFF1E3A5F),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: r.scale(4)),
                Text(
                  'Cuida tu salud con pequeños pasos.',
                  style: TextStyle(
                    fontSize: r.font(14.5),
                    height: 1.25,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF64748B),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _tipCard(_HealthTip tip, _Responsive r) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 250),
      child: Container(
        key: ValueKey(tip.title),
        width: double.infinity,
        padding: EdgeInsets.fromLTRB(
          r.tipCardHorizontalPadding,
          r.tipCardVerticalPadding,
          r.tipCardHorizontalPadding,
          r.tipCardVerticalPadding,
        ),
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(26),
          border: Border.all(
            color: const Color(0xFFD7EAFB),
            width: 1.6,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 16,
              offset: const Offset(0, 7),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              width: r.tipIconBox,
              height: r.tipIconBox,
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
                    blurRadius: 14,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Icon(
                tip.icon,
                size: r.tipIconSize,
                color: const Color(0xFF1976D2),
              ),
            ),
            SizedBox(height: r.scale(14)),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: r.scale(12),
                vertical: r.scale(7),
              ),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF3E0),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: const Color(0xFFFFB74D),
                  width: 1.3,
                ),
              ),
              child: Text(
                'Consejo del día',
                style: TextStyle(
                  fontSize: r.font(13.5),
                  fontWeight: FontWeight.w900,
                  color: const Color(0xFFB45309),
                ),
              ),
            ),
            SizedBox(height: r.scale(12)),
            Text(
              tip.title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: r.font(26),
                fontWeight: FontWeight.w900,
                color: const Color(0xFF1E3A5F),
                letterSpacing: -0.3,
                height: 1.12,
              ),
            ),
            SizedBox(height: r.scale(10)),
            Text(
              tip.message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: r.font(18),
                height: 1.32,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF334155),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _settingsButton(BuildContext context, _Responsive r) {
    return SizedBox(
      width: double.infinity,
      height: r.buttonHeight,
      child: ElevatedButton.icon(
        onPressed: () {
          Navigator.pushNamed(context, '/settings');
        },
        icon: Icon(
          Icons.settings_rounded,
          size: r.scale(22),
        ),
        label: Text(
          'Configuración',
          style: TextStyle(
            fontSize: r.font(17.5),
            fontWeight: FontWeight.w900,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: const Color(0xFF1976D2),
          elevation: 2,
          shadowColor: Colors.black26,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
            side: const BorderSide(
              color: Color(0xFFD7EAFB),
              width: 1.6,
            ),
          ),
        ),
      ),
    );
  }

  Widget _footerText(_Responsive r) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: r.scale(14),
        vertical: r.scale(11),
      ),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.58),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Text(
        'Recuerda seguir siempre las indicaciones de tu médico.',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: r.font(13.5),
          height: 1.28,
          fontWeight: FontWeight.w800,
          color: const Color(0xFF64748B),
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

  double get maxContentWidth => isTablet ? 520 : double.infinity;

  double get _factor => _clamp(width / 390, 0.82, 1.14);

  double scale(double base) => base * _factor;

  double font(double base) {
    final eased = 1 + (_factor - 1) * 0.50;
    return base * _clamp(eased, 0.88, 1.10);
  }

  double get pagePadding => compactWidth ? 14 : scale(16);

  double get topPadding => compactHeight ? 10 : scale(16);

  double get bottomPadding => compactHeight ? 18 : scale(24);

  double get gap => compactHeight ? scale(11) : scale(14);

  double get smallGap => compactHeight ? scale(8) : scale(12);

  double get headerVerticalPadding => compactHeight ? scale(11) : scale(14);

  double get cardPadding => compactHeight ? scale(13) : scale(16);

  double get summaryIconBox => compactHeight ? scale(46) : scale(52);

  double get summaryIconSize => compactHeight ? scale(26) : scale(30);

  double get tipCardHorizontalPadding => compactWidth ? scale(14) : scale(18);

  double get tipCardVerticalPadding => compactHeight ? scale(16) : scale(20);

  double get tipIconBox => compactHeight ? scale(76) : scale(92);

  double get tipIconSize => compactHeight ? scale(42) : scale(52);

  double get buttonHeight => compactHeight ? scale(50) : scale(54);

  static double _clamp(double value, double min, double max) {
    if (value < min) return min;
    if (value > max) return max;
    return value;
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