import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:medicare_app/main.dart'; // Asegura importar tu main.dart para ver alarmCallback
import 'package:timezone/data/latest_all.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  NotificationService._();

  static final NotificationService instance = NotificationService._();

  final FlutterLocalNotificationsPlugin _plugin =
  FlutterLocalNotificationsPlugin();

  static const String _channelId = 'medicare_reminder_channel_v1';
  static const String _channelName = 'Recordatorios de medicamentos';
  static const String _channelDescription =
      'Notificaciones para recordarte tomar tus medicamentos';

  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) return;

    tzdata.initializeTimeZones();

    final location = tz.getLocation('America/Santo_Domingo');
    tz.setLocalLocation(location);

    const androidSettings = AndroidInitializationSettings(
      'ic_notification',
    );

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

    debugPrint('NOTIFICACIONES INICIALIZADAS CORRECTAMENTE');
  }

  /// ---------------------------------------------------------------------
  /// FLUJO COMPLETO DE PERMISOS PARA EL USUARIO
  /// ---------------------------------------------------------------------
  Future<void> requestNotificationsPermission() async {
    final androidImpl =
    _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();

    final bool? notificationPermission =
    await androidImpl?.requestNotificationsPermission();
    debugPrint('PERMISO NOTIFICACIONES: $notificationPermission');
  }

  Future<void> requestExactAlarmPermission(BuildContext context) async {
    final androidImpl =
    _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();

    final bool yaTienePermisoPuntual =
        await androidImpl?.canScheduleExactNotifications() ?? false;

    if (yaTienePermisoPuntual) {
      debugPrint('PERMISO PUNTUAL: YA CONCEDIDO, NO SE PIDE DE NUEVO');
      return;
    }

    if (!context.mounted) return;
    final bool? quiereActivarlo = await _mostrarExplicacionPermisoPuntual(
      context,
    );

    if (quiereActivarlo != true) {
      debugPrint('USUARIO DECLINÓ ACTIVAR NOTIFICACIONES PUNTUALES');
      return;
    }

    final bool? resultadoSolicitud =
    await androidImpl?.requestExactAlarmsPermission();
    debugPrint('RESULTADO SOLICITUD PERMISO PUNTUAL: $resultadoSolicitud');

    final bool quedoConcedido =
        await androidImpl?.canScheduleExactNotifications() ?? false;
    debugPrint('¿PERMISO PUNTUAL QUEDÓ CONCEDIDO?: $quedoConcedido');
  }

  Future<bool?> _mostrarExplicacionPermisoPuntual(
      BuildContext context,
      ) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Notificaciones puntuales'),
          content: const Text(
            'Para que tus recordatorios de medicamento lleguen '
                'exactamente a la hora indicada, Android necesita un '
                'permiso adicional.\n\n'
                'Te vamos a llevar a una pantalla de Ajustes: solo activa '
                'el interruptor que dice "Permitir" y regresa a la app.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Ahora no'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: const Text('Continuar'),
            ),
          ],
        );
      },
    );
  }

  Future<bool> tienePermisoNotificacionPuntual() async {
    final androidImpl =
    _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    return await androidImpl?.canScheduleExactNotifications() ?? false;
  }

  /// ---------------------------------------------------------------------
  /// PROGRAMACIÓN DE RECORDATORIOS (ACTUALIZADO A ALARM MANAGER)
  /// ---------------------------------------------------------------------

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

    debugPrint(
      'NOTIFICACIÓN DEL TRATAMIENTO $treatmentId PROGRAMADA PARA $horaInicio',
    );
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

    debugPrint('DOSIS RECONOCIDA. PRÓXIMA NOTIFICACIÓN: $horaInicio');
  }

  Future<void> cancelRemindersForTreatment(int treatmentId) async {
    // Cancela tanto el hilo del AlarmManager como la notificación local por si acaso
    await AndroidAlarmManager.cancel(treatmentId);
    await _plugin.cancel(treatmentId);
    debugPrint('NOTIFICACIÓN Y ALARMA CANCELADAS PARA TRATAMIENTO $treatmentId');
  }

  Future<void> cancelAll() async {
    await _plugin.cancelAll();
    debugPrint('TODAS LAS NOTIFICACIONES FUERON CANCELADAS');
  }

  /// 🔥 NUEVO MÉTODO: Invocado por la función global 'alarmCallback' en main.dart
  /// Lanza la alerta en la pantalla de inmediato sin evaluar tiempos diferidos
  Future<void> showImmediateNotification({
    required int id,
    required String title,
    required String body,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      _channelId,
      _channelName,
      channelDescription: _channelDescription,
      icon: 'ic_notification',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
      category: AndroidNotificationCategory.reminder,
      visibility: NotificationVisibility.public,
    );

    const iosDetails = DarwinNotificationDetails(
      presentSound: true,
      presentAlert: true,
    );

    await _plugin.show(
      id,
      title,
      body,
      const NotificationDetails(android: androidDetails, iOS: iosDetails),
    );
    debugPrint('PINTANDO NOTIFICACIÓN INMEDIATA EN PANTALLA');
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

    debugPrint('HORA RECIBIDA: $hora');
    debugPrint('HORA CONVERTIDA: $hour:$minute');
    debugPrint('NOTIFICACIÓN NATIVA SOLICITADA PARA: $scheduledDate');

    // Convertimos de TZDateTime a un DateTime estándar requerido por el AlarmManager
    final DateTime targetDateTime = DateTime(
      scheduledDate.year,
      scheduledDate.month,
      scheduledDate.day,
      scheduledDate.hour,
      scheduledDate.minute,
    );

    // 🔥 SOLUCIÓN FINAL: Delegamos el control de la app al reloj nativo de Android.
    // wakeup: true obliga a despertar el hardware del teléfono aunque esté suspendido sin cable USB.
    // exact: true garantiza precisión absoluta al milisegundo.
    final bool programadoExitoso = await AndroidAlarmManager.oneShotAt(
      targetDateTime,
      treatmentId,
      alarmCallback, // Llama a la función raíz del main.dart
      exact: true,
      wakeup: true,
      rescheduleOnReboot: true,
    );

    if (programadoExitoso) {
      debugPrint('SISTEMA OPERATIVO ASIGNÓ ALARMA EXITOSAMENTE MEDIANTE ALARM_MANAGER');
    } else {
      debugPrint('ERROR CRÍTICO: El reloj del sistema rechazó la alarma');
    }
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

    if (!scheduled.isAfter(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }

    return scheduled;
  }
}