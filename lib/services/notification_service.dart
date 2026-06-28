import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  final FlutterLocalNotificationsPlugin _plugin =
  FlutterLocalNotificationsPlugin();

  static const String _channelId = 'medicare_alarm_channel_v2';
  static const String _channelName = 'Recordatorios de medicamentos';
  static const String _channelDescription =
      'Alarmas para recordarte tomar tus medicamentos a tiempo';

  static const int _maxSlotsPerTreatment = 10;

  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) return;

    tzdata.initializeTimeZones();

    final location = tz.getLocation('America/Santo_Domingo');
    tz.setLocalLocation(location);

    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');

    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    await _plugin.initialize(
      const InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      ),
    );

    final androidImpl = _plugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();

    const channel = AndroidNotificationChannel(
      _channelId,
      _channelName,
      description: _channelDescription,
      importance: Importance.max,
      playSound: true,
      enableVibration: true,
    );

    await androidImpl?.createNotificationChannel(channel);

    _initialized = true;
  }

  Future<void> requestPermissions() async {
    final androidImpl = _plugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();

    await androidImpl?.requestNotificationsPermission();
    await androidImpl?.requestExactAlarmsPermission();
  }

  /// Programa todas las alarmas diarias de un tratamiento según su
  /// frecuencia (ej: "Cada 8 horas" => 3 alarmas/día), cancelando
  /// primero cualquier alarma anterior de este tratamiento.
  Future<void> scheduleRemindersForTreatment({
    required int treatmentId,
    required String medicationName,
    required String dosis,
    required String horaInicio,
    required String frecuencia,
  }) async {
    await cancelRemindersForTreatment(treatmentId);

    final int intervalHours = _parseFrecuenciaHoras(frecuencia);
    final int startMinutesOfDay = _parseHoraATotalMinutos(horaInicio);
    final int vecesAlDia = _vecesAlDia(intervalHours);

    for (int i = 0; i < vecesAlDia; i++) {
      final int totalMinutos = _slotMinutes(startMinutesOfDay, intervalHours, i);
      await _scheduleSlot(
        treatmentId: treatmentId,
        slotIndex: i,
        totalMinutos: totalMinutos,
        medicationName: medicationName,
        dosis: dosis,
      );
    }

    print("TODAS LAS ALARMAS DEL TRATAMIENTO $treatmentId PROGRAMADAS ($vecesAlDia/día)");
  }

  /// Se llama cuando el usuario marca una dosis como "Tomada" u
  /// "Omitida". Apaga la notificación de la dosis que corresponde a
  /// AHORA (la más cercana a la hora actual) y la reprograma para su
  /// siguiente ocurrencia (normalmente mañana, a la misma hora), sin
  /// afectar las demás dosis del día.
  Future<void> acknowledgeDose({
    required int treatmentId,
    required String horaInicio,
    required String frecuencia,
    required String medicationName,
    required String dosis,
  }) async {
    final int intervalHours = _parseFrecuenciaHoras(frecuencia);
    final int startMinutesOfDay = _parseHoraATotalMinutos(horaInicio);
    final int vecesAlDia = _vecesAlDia(intervalHours);

    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    final int nowMinutes = now.hour * 60 + now.minute;

    int closestSlot = 0;
    int closestDiff = 24 * 60;

    for (int i = 0; i < vecesAlDia; i++) {
      final int slotMinutes = _slotMinutes(startMinutesOfDay, intervalHours, i);
      final int diff = (slotMinutes - nowMinutes).abs();
      final int realDiff = diff < (24 * 60 - diff) ? diff : (24 * 60 - diff);

      if (realDiff < closestDiff) {
        closestDiff = realDiff;
        closestSlot = i;
      }
    }

    final int totalMinutos = _slotMinutes(startMinutesOfDay, intervalHours, closestSlot);
    final int notifId = treatmentId * 100 + closestSlot;

    // Apaga/quita la notificación de la dosis actual.
    await _plugin.cancel(notifId);

    // La reprograma para su próxima ocurrencia (mañana, misma hora),
    // sin tocar las demás dosis del tratamiento.
    await _scheduleSlot(
      treatmentId: treatmentId,
      slotIndex: closestSlot,
      totalMinutos: totalMinutos,
      medicationName: medicationName,
      dosis: dosis,
    );

    print("DOSIS RECONOCIDA: tratamiento $treatmentId, slot $closestSlot reprogramado");
  }

  /// Cancela todas las alarmas asociadas a un tratamiento (todos sus slots).
  Future<void> cancelRemindersForTreatment(int treatmentId) async {
    for (int i = 0; i < _maxSlotsPerTreatment; i++) {
      await _plugin.cancel(treatmentId * 100 + i);
    }
  }

  Future<void> cancelAll() async {
    await _plugin.cancelAll();
  }

  // --------------------------------------------------------------------
  // Helpers internos
  // --------------------------------------------------------------------

  Future<void> _scheduleSlot({
    required int treatmentId,
    required int slotIndex,
    required int totalMinutos,
    required String medicationName,
    required String dosis,
  }) async {
    final int hour = totalMinutos ~/ 60;
    final int minute = totalMinutos % 60;
    final int notifId = treatmentId * 100 + slotIndex;

    final tz.TZDateTime scheduledDate = _nextOccurrenceFromHourMinute(hour, minute);

    print("ALARMA (trat $treatmentId, slot $slotIndex) PROGRAMÁNDOSE PARA: $scheduledDate");

    await _plugin.zonedSchedule(
      notifId,
      'Hora de tu medicamento 💊',
      '$medicationName — $dosis',
      scheduledDate,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          _channelId,
          _channelName,
          channelDescription: _channelDescription,
          importance: Importance.max,
          priority: Priority.high,
          playSound: true,
          enableVibration: true,
          category: AndroidNotificationCategory.alarm,
          visibility: NotificationVisibility.public,
        ),
        iOS: DarwinNotificationDetails(
          presentSound: true,
          presentAlert: true,
          interruptionLevel: InterruptionLevel.timeSensitive,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  int _vecesAlDia(int intervalHours) {
    return (24 / intervalHours).round().clamp(1, _maxSlotsPerTreatment);
  }

  int _slotMinutes(int startMinutesOfDay, int intervalHours, int slotIndex) {
    return (startMinutesOfDay + slotIndex * intervalHours * 60) % (24 * 60);
  }

  int _parseFrecuenciaHoras(String frecuencia) {
    final match = RegExp(r'(\d+)').firstMatch(frecuencia);
    if (match == null) return 24;
    return int.tryParse(match.group(1)!) ?? 24;
  }

  int _parseHoraATotalMinutos(String horaTexto) {
    final parts = horaTexto.trim().split(' ');
    final timeParts = parts[0].split(':');

    int hour = int.parse(timeParts[0]);
    final int minute = int.parse(timeParts[1]);
    final String period = parts[1].toUpperCase();

    if (period == 'PM' && hour != 12) hour += 12;
    if (period == 'AM' && hour == 12) hour = 0;

    return hour * 60 + minute;
  }

  tz.TZDateTime _nextOccurrenceFromHourMinute(int hour, int minute) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);

    tz.TZDateTime scheduled = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );

    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }

    return scheduled;
  }
}