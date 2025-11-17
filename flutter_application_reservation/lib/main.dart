import 'package:flutter/material.dart';
import 'screens/home_screen.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Billetterie Mobile',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,           // ⭐ Active Material Design 3
        colorSchemeSeed: Colors.blue, // ⭐ Génère un thème automatiquement
      ),
      home:const HomeScreen(),
    );
  }
}
