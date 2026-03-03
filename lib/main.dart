import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'package:flutter/services.dart';
=======
>>>>>>> 0b27c079cf8b9a58e434594887fafe3da769a182
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'start_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
<<<<<<< HEAD
  
  // Lock orientation to portrait for better consistency across devices
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
=======
>>>>>>> 0b27c079cf8b9a58e434594887fafe3da769a182
  await MobileAds.instance.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gems Hunter',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
<<<<<<< HEAD
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.greenAccent,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFF0F0F13),
=======
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.greenAccent),
        useMaterial3: true,
>>>>>>> 0b27c079cf8b9a58e434594887fafe3da769a182
      ),
      home: const StartPage(),
    );
  }
}
