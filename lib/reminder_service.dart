import 'dart:async';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:taalim_notify_app/student_model.dart';

class ReminderService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Timer? _reminderTimer;

  // Initialisation unique de ReminderService
  static Future<void> initialize(
      {required void Function(String? payload) onSelectNotification}) async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await _notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        if (response.payload != null) {
          if (response.actionId == 'view_details') {
            // Arrêter le rappel
            ReminderService.stopReminder();
            // Naviguer vers la page de détails
            onSelectNotification(response.payload);
          } else {
            onSelectNotification(response.payload);
          }
        }
      },
    );
    print("ReminderService initialized successfully.");
  }

  // Lancer les rappels périodiques
  static void startReminder(int studentId) {
    stopReminder();
    // Check if the current time is after 22:00 and before 8:00
    final now = DateTime.now();
    if (now.hour >= 22 && now.hour < 8) {
      print("ReminderService: Reminders are not allowed after 22:00.");
      return;  // break, no remiders allowed after 22:00 and before 8:00
    }

    _reminderTimer = Timer.periodic(const Duration(seconds: 10), (timer) async {
      Student student = students.firstWhere((student) => student.id == studentId);

      String message = 'Bonjour Mme Nadia! \nVotre enfant ${student.name} a manqué une séance aujourd\'hui à ${student.time}!';

      AndroidNotificationDetails reminderDetails = AndroidNotificationDetails(
        'reminder_channel',
        'Reminder Channel',
        channelDescription: 'Canal des rappels pour l’application',
        importance: Importance.high,
        priority: Priority.high,
        playSound: true,
        styleInformation: BigTextStyleInformation(
          message,
          contentTitle: '⚠️ Rappel : Absence non confirmée!',
          summaryText: 'Voir les Détails',
        ),
        actions: <AndroidNotificationAction>[
          AndroidNotificationAction(
            'view_details',
            'Voir les Détails',
          ),
        ],
      );

      NotificationDetails notificationDetails = NotificationDetails(android: reminderDetails);

      await _notificationsPlugin.show(
        1, // ID unique pour le rappel
        '⚠️ Rappel : Absence non confirmée!',
        message,
        notificationDetails,
        payload: 'details_page_${student.id}', // Inclure l'ID de l'étudiant pour la page de détails
      );
    });
  }

  static void stopReminder() {
    if (_reminderTimer != null) {
      _reminderTimer?.cancel();
      _reminderTimer = null;
      print("ReminderService: Reminders stopped.");
    }
  }
}
