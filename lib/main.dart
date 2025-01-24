import 'package:flutter/material.dart';
import 'package:taalim_notify_app/details_page.dart';
import 'package:taalim_notify_app/notification_service.dart';
import 'package:taalim_notify_app/reminder_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.initialize(onSelectNotification: _onSelectNotification);
  await ReminderService.initialize(onSelectNotification: _onSelectNotification);
  runApp(const MyApp());
}

void _onSelectNotification(String? payload) {
  // Gère l'action de clic sur la notification
  print("Notification clicked with payload: $payload");

  if (payload == 'details_page') {
    ReminderService.stopReminder(); // Arrête les rappels
    
    // Si le payload est "details_page", naviguer vers la page des détails
    MyApp.navigatorKey.currentState?.push(
      MaterialPageRoute(builder: (context) => DetailsPage()),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // Déclare une clé de navigation globale
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey, // Ajoute la clé de navigation
      debugShowCheckedModeBanner: false,
      title: 'TAALIM Notify',
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'TAALIM Notify',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue[700],
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: ElevatedButton(
          child: const Text("Send Notification"),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue[700],
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            textStyle: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            elevation: 4,
            shadowColor: Colors.blue[900],
          ),
          onPressed: () {
            NotificationService.showNotification();
          },
        ),
      ),
    );
  }
}