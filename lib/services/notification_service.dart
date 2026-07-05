import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
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
  /// Pide SOLO el permiso normal de notificaciones (el diálogo estándar
  /// de Android). No necesita BuildContext, así que es seguro llamarlo
  /// desde main() antes de runApp(), donde todavía no existe ningún
  /// widget en pantalla.
  ///
  /// Esto reemplaza al viejo requestPermissions() para el caso de
  /// main.dart. NO pide el permiso puntual (SCHEDULE_EXACT_ALARM) aquí,
  /// porque ese sí necesita mostrar un diálogo explicativo con context,
  /// y en main() todavía no hay ninguna pantalla construida.
  Future<void> requestNotificationsPermission() async {
    final androidImpl =
    _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();

    final bool? notificationPermission =
    await androidImpl?.requestNotificationsPermission();
    debugPrint('PERMISO NOTIFICACIONES: $notificationPermission');
  }

  /// Pide el permiso puntual (SCHEDULE_EXACT_ALARM) con un diálogo
  /// explicativo previo. SÍ necesita BuildContext, así que solo se debe
  /// llamar desde un widget ya construido — por ejemplo el botón
  /// "Comenzar ahora" de tu pantalla de bienvenida.
  ///
  /// Al usuario solo le hablamos de "notificaciones puntuales" — nunca
  /// de "alarmas", aunque por debajo Android sí llame así al permiso.
  Future<void> requestExactAlarmPermission(BuildContext context) async {
    final androidImpl =
    _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();

    // Si el usuario ya tiene el permiso puntual concedido, no lo
    // molestamos con la pantalla de Ajustes.
    final bool yaTienePermisoPuntual =
        await androidImpl?.canScheduleExactNotifications() ?? false;

    if (yaTienePermisoPuntual) {
      debugPrint('PERMISO PUNTUAL: YA CONCEDIDO, NO SE PIDE DE NUEVO');
      return;
    }

    // Explicamos ANTES de mandarlo a Ajustes, en lenguaje simple.
    if (!context.mounted) return;
    final bool? quiereActivarlo = await _mostrarExplicacionPermisoPuntual(
      context,
    );

    if (quiereActivarlo != true) {
      debugPrint('USUARIO DECLINÓ ACTIVAR NOTIFICACIONES PUNTUALES');
      return;
    }

    // Esto abre la pantalla de Ajustes de Android. El usuario debe
    // activar el switch manualmente; no hay diálogo emergente posible
    // aquí, es una limitación del sistema operativo, no de tu app.
    final bool? resultadoSolicitud =
    await androidImpl?.requestExactAlarmsPermission();
    debugPrint('RESULTADO SOLICITUD PERMISO PUNTUAL: $resultadoSolicitud');

    // Verificamos el estado real después de que el usuario regresó.
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

  /// Llama esto en cualquier pantalla (ej. Ajustes de la app) para saber
  /// si debes mostrar un aviso de "tus recordatorios pueden llegar tarde".
  Future<bool> tienePermisoNotificacionPuntual() async {
    final androidImpl =
    _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    return await androidImpl?.canScheduleExactNotifications() ?? false;
  }

  /// ---------------------------------------------------------------------
  /// PROGRAMACIÓN DE RECORDATORIOS
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
    await _plugin.cancel(treatmentId);
    debugPrint('NOTIFICACIÓN CANCELADA PARA TRATAMIENTO $treatmentId');
  }

  Future<void> cancelAll() async {
    await _plugin.cancelAll();
    debugPrint('TODAS LAS NOTIFICACIONES FUERON CANCELADAS');
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
    debugPrint('NOTIFICACIÓN PROGRAMÁNDOSE PARA: $scheduledDate');

    // ESTA ES LA LÍNEA QUE FALTABA EN EL ARCHIVO ORIGINAL. Sin esta
    // verificación, el código asumía "exactAllowWhileIdle" siempre,
    // incluso cuando el usuario instaló desde Google Play y el permiso
    // SCHEDULE_EXACT_ALARM viene denegado por defecto en Android 13+
    // (comportamiento documentado de Android, no un bug de tu app).
    // Resultado: zonedSchedule() se ejecutaba sin lanzar error, pero
    // Android descartaba la notificación en segundo plano porque no
    // tenía autorización real para el modo exacto.
    final androidImpl =
    _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();

    // CLAVE: verificamos el permiso ANTES de decidir el modo.
    // Si el usuario nunca activó el permiso puntual, usamos el modo
    // inexacto: la notificación SIEMPRE llega, aunque pueda demorar
    // algunos minutos en dispositivos en reposo profundo. Esto evita
    // el caso que reportaste: "no llega, nunca, en silencio total".
    final bool puedeProgramarPuntual =
        await androidImpl?.canScheduleExactNotifications() ?? false;

    final AndroidScheduleMode modo = puedeProgramarPuntual
        ? AndroidScheduleMode.exactAllowWhileIdle
        : AndroidScheduleMode.inexactAllowWhileIdle;

    debugPrint(
      '¿PERMISO PUNTUAL CONCEDIDO?: $puedeProgramarPuntual → MODO: $modo',
    );

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
          category: AndroidNotificationCategory.reminder,
          visibility: NotificationVisibility.public,
        ),
        iOS: DarwinNotificationDetails(
          presentSound: true,
          presentAlert: true,
        ),
      ),
      androidScheduleMode: modo,
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
    );

    debugPrint('NOTIFICACIÓN PROGRAMADA CORRECTAMENTE');
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