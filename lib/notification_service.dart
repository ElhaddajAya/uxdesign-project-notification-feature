import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // Initialisation des notifications
  static Future<void> initialize(
      {required void Function(String? payload) onSelectNotification}) async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher'); // Icône par défaut

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await _notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        if (response.payload != null) {
          onSelectNotification(response.payload);
        }
      },
    );
  }

  // Envoi de la notification
  static Future<void> showNotification() async {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'main_channel', // ID du canal
      'Main Channel', // Nom du canal
      channelDescription: 'Canal principal pour les notifications',
      importance: Importance.max,
      priority: Priority.high,
      styleInformation: BigTextStyleInformation(
        'Bonjour Madame Nadia! \nVotre enfant a manqué une scéance aujourd\'hui à 10h30!',
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

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
    );

    await _notificationsPlugin.show(
      0, // ID unique de la notification
      '🔔 Absence détectée!', // Titre de la notification
      'Bonjour Madame Nadia! \nVotre enfant a manqué une scéance aujourd\'hui à 10h30!', // Aperçu
      notificationDetails,
      payload: 'details_page', // Payload pour navigation
    );
  }
}
