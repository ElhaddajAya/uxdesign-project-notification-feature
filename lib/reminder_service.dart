import 'dart:async';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

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
  static void startReminder() {
    stopReminder(); // Arrêter tout rappel précédent
    print("ReminderService: Starting reminders every 10 seconds");

    _reminderTimer = Timer.periodic(const Duration(seconds: 10), (timer) async {
      print("ReminderService: Sending reminder notification");

      const AndroidNotificationDetails reminderDetails = AndroidNotificationDetails(
        'reminder_channel',
        'Reminder Channel',
        channelDescription: 'Canal des rappels pour l’application',
        importance: Importance.high,
        priority: Priority.high,
        playSound: true, // Active le son
        styleInformation: BigTextStyleInformation(
          'Bonjour Mme Nadia! \nVotre enfant a manqué une séance aujourd\'hui à 10h30!',
          contentTitle: '⚠️ Rappel : Absence non confirmée!',
          summaryText: 'Voir les Détails',
        ),
        actions: <AndroidNotificationAction>[
        AndroidNotificationAction(
          'view_details', // Identifiant unique de l'action
          'Voir les Détails', // Titre du bouton
        ),
      ],
      );

      const NotificationDetails notificationDetails =
          NotificationDetails(android: reminderDetails);

      await _notificationsPlugin.show(
        1, // ID unique pour le rappel
        '⚠️ Rappel : Absence non confirmée!',
        'Bonjour Mme Nadia! \nVotre enfant a manqué une séance aujourd\'hui à 10h30!',
        notificationDetails,
        payload: 'details_page', // Action sur clic
      );
    });
  }

  // Arrêter les rappels
  static void stopReminder() {
    if (_reminderTimer != null) {
      _reminderTimer?.cancel();
      _reminderTimer = null;
      print("ReminderService: Reminders stopped.");
    }
  }
}
