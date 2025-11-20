import 'package:flutter/material.dart';
import '../models/spectacle_model.dart';

class DetailSpectacleScreen extends StatelessWidget {
  final Spectacle spectacle;
  const DetailSpectacleScreen({super.key, required this.spectacle});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(spectacle.titre, maxLines: 1, overflow: TextOverflow.ellipsis),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // image
            Hero(
              tag: 'spect-${spectacle.id}',
              child: Image.network(
                spectacle.imageUrl,
                height: 260,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (c, e, s) => Container(
                  height: 260,
                  color: Theme.of(context).dividerColor,
                  child: const Center(child: Icon(Icons.broken_image, size: 48)),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(spectacle.titre, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.calendar_today),
                      const SizedBox(width: 8),
                      Text(spectacle.date),
                      const SizedBox(width: 16),
                      const Icon(Icons.monetization_on),
                      const SizedBox(width: 8),
                      Text("${spectacle.prix.toStringAsFixed(2)} €"),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Description',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Description de démonstration. Ici tu pourras afficher le résumé, la durée, les artistes, le lieu, etc. Pour le prototype, ce texte est statique.",
                    style: TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () {
                        // placeholder
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Réservation non implémentée (prototype).')));
                      },
                      child: const Text('Réserver'),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
