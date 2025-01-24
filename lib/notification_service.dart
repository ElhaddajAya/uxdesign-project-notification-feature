import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:taalim_notify_app/reminder_service.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

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
    print("NotificationService initialized successfully.");
  }

  static Future<void> showNotification() async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'main_channel',
      'Main Channel',
      channelDescription: 'Canal principal pour les notifications',
      importance: Importance.high,
      priority: Priority.high,
      playSound: true, // Active le son
      styleInformation: BigTextStyleInformation(
        'Bonjour Mme Nadia! \nVotre enfant a manqué une séance aujourd\'hui à 10h30!',
        contentTitle: '🔔 Absence détectée!',
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
        NotificationDetails(android: androidDetails);

    await _notificationsPlugin.show(
      0, // ID unique de la notification principale
      '🔔 Absence détectée!',
      'Bonjour Mme Nadia! \nVotre enfant a manqué une séance aujourd\'hui à 10h30!',
      notificationDetails,
      payload: 'details_page',
    );

    // Démarrer les rappels
    ReminderService.startReminder();
  }
}
