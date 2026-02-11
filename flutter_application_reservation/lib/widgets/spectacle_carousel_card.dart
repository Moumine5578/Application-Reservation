import 'package:flutter/material.dart';
import '../models/spectacle_model.dart';

/// Carte compacte pour le carousel horizontal (défilement des billets).
class SpectacleCarouselCard extends StatelessWidget {
  final Spectacle spectacle;
  final int index;

  const SpectacleCarouselCard({super.key, required this.spectacle, this.index = 0});

  static const double cardWidth = 280;
  static const double imageHeight = 140;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 400 + (index * 80)),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(30 * (1 - value), 0),
            child: child,
          ),
        );
      },
      child: Container(
        width: cardWidth,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              blurRadius: 12,
              color: theme.brightness == Brightness.dark ? Colors.black54 : Colors.black26,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
              child: Image.network(
                spectacle.imageUrl,
                height: imageHeight,
                width: cardWidth,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  height: imageHeight,
                  width: cardWidth,
                  color: theme.dividerColor,
                  child: const Icon(Icons.broken_image, size: 40),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    spectacle.titre,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.calendar_today, size: 12),
                      const SizedBox(width: 4),
                      Text(spectacle.date, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                      const Spacer(),
                      Text(
                        "${spectacle.prix.toStringAsFixed(0)} €",
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
