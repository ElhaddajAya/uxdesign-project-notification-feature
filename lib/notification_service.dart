import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:taalim_notify_app/reminder_service.dart';
import 'package:taalim_notify_app/student_model.dart';

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
    Student student = Student.random();

    String message = 'Bonjour Mme Nadia! \nVotre enfant ${student.name} a manqué une séance aujourd\'hui à ${student.time}!';
    String contentTitle = '🔔 Absence détectée!';

    final AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'main_channel',
      'Main Channel',
      channelDescription: 'Canal principal pour les notifications',
      importance: Importance.high,
      priority: Priority.high,
      playSound: true,
      styleInformation: BigTextStyleInformation(
        message,
        contentTitle: contentTitle,
        summaryText: 'Voir les Détails',
      ),
      actions: <AndroidNotificationAction>[
        AndroidNotificationAction(
          'view_details',
          'Voir les Détails',
        ),
      ],
    );

    final NotificationDetails notificationDetails = NotificationDetails(android: androidDetails);

    await _notificationsPlugin.show(
      0, 
      contentTitle,
      message,
      notificationDetails,
      payload: 'details_page_${student.id}', 
    );

    // Démarrer les rappels
    ReminderService.startReminder(student.id); 
  }

}
