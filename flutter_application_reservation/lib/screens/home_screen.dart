import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Spectacles 🎭"),
      ),
      body: const Center(
        child: Text(
          "Liste des spectacles bientôt ici...",
          style: TextStyle(fontSize: 80),
        ),
      ),
    );
  }
}
