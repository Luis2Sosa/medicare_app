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

  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) return;

    tzdata.initializeTimeZones();

    final location = tz.getLocation('America/Santo_Domingo');
    tz.setLocalLocation(location);

    const androidSettings =
    AndroidInitializationSettings('@drawable/ic_notification');

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

    final androidImpl =
    _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();

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
    final androidImpl =
    _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();

    await androidImpl?.requestNotificationsPermission();
    await androidImpl?.requestExactAlarmsPermission();
  }

  Future<void> scheduleRemindersForTreatment({
    required int treatmentId,
    required String medicationName,
    required String dosis,
    required String horaInicio,
    required String frecuencia,
  }) async {
    await cancelRemindersForTreatment(treatmentId);

    await _scheduleSingleReminder(
      treatmentId: treatmentId,
      hora: horaInicio,
      medicationName: medicationName,
      dosis: dosis,
    );

    print("ALARMA DEL TRATAMIENTO $treatmentId PROGRAMADA PARA $horaInicio");
  }

  Future<void> acknowledgeDose({
    required int treatmentId,
    required String horaInicio,
    required String frecuencia,
    required String medicationName,
    required String dosis,
  }) async {
    await cancelRemindersForTreatment(treatmentId);

    await _scheduleSingleReminder(
      treatmentId: treatmentId,
      hora: horaInicio,
      medicationName: medicationName,
      dosis: dosis,
    );

    print("DOSIS RECONOCIDA. PRÓXIMA ALARMA: $horaInicio");
  }

  Future<void> cancelRemindersForTreatment(int treatmentId) async {
    await _plugin.cancel(treatmentId);
  }

  Future<void> cancelAll() async {
    await _plugin.cancelAll();
  }

  Future<void> _scheduleSingleReminder({
    required int treatmentId,
    required String hora,
    required String medicationName,
    required String dosis,
  }) async {
    final int totalMinutos = _parseHoraATotalMinutos(hora);
    final int hour = totalMinutos ~/ 60;
    final int minute = totalMinutos % 60;

    final tz.TZDateTime scheduledDate =
    _nextOccurrenceFromHourMinute(hour, minute);

    print("ALARMA PROGRAMÁNDOSE PARA: $scheduledDate");

    await _plugin.zonedSchedule(
      treatmentId,
      'Hora de tu medicamento 💊',
      '$medicationName — $dosis',
      scheduledDate,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          _channelId,
          _channelName,
          channelDescription: _channelDescription,
          icon: 'ic_notification',
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

  int _parseHoraATotalMinutos(String horaTexto) {
    final parts = horaTexto.trim().split(' ');
    final timeParts = parts[0].split(':');

    int hour = int.parse(timeParts[0]);
    final int minute = int.parse(timeParts[1]);
    final String period = parts.length > 1 ? parts[1].toUpperCase() : 'AM';

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