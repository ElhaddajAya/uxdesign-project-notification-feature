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
  print("Notification clicked with payload: $payload");

  if (payload != null && payload.startsWith('details_page_')) {
    int studentId = int.parse(payload.split('_')[2]);

    // Arrêter les rappels
    ReminderService.stopReminder();

    // Assurez-vous que la navigation est déclenchée après le rendu de l'UI
    WidgetsBinding.instance.addPostFrameCallback((_) {
      MyApp.navigatorKey.currentState?.push(
        MaterialPageRoute(
          builder: (context) => DetailsPage(studentId: studentId),
        ),
      );
    });
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
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
   
    // Configure l'AnimationController
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2), // Durée de l'animation
    );

    // Configure l'animation de zoom progressif
    _scaleAnimation = Tween<double>(begin: 0.3, end: 1.5)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    // Démarrer l'animation
    _controller.forward();

    // Redirection après 3 secondes
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const MyHomePage()),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: ScaleTransition(
          scale: _scaleAnimation, // Animation d'échelle
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/app_icon.png', height: 150),
              const SizedBox(height: 20),
              const Text(
                'TAALIM Notify',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueGrey,
                ),
              ),
            ],
          ),
        ),
      ),
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'TAALIM Notify',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        backgroundColor: Colors.blue[700],
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/app_icon.png', height: 150),
            const SizedBox(height: 20),
            Text(
              'Bienvenue à TAALIM Notify',
              style: TextStyle(
                fontSize: 20, 
                fontWeight: FontWeight.bold, 
                color: Colors.blueGrey.shade700,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(
          Icons.notifications, 
          color: Colors.white,
        ),
        backgroundColor: const Color(0xFF1976D2),
        onPressed: () {
          NotificationService.showNotification();
        },
      ),
    );
  }
}