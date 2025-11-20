import 'dart:math';
import 'package:flutter/material.dart';
import '../models/spectacle_model.dart';

class SpectacleCard extends StatefulWidget {
  final Spectacle spectacle;
  const SpectacleCard({super.key, required this.spectacle});

  @override
  State<SpectacleCard> createState() => _SpectacleCardState();
}

class _SpectacleCardState extends State<SpectacleCard> with SingleTickerProviderStateMixin {
  double opacity = 0;
  Offset offset = const Offset(0, 0.06);

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 80 + Random().nextInt(240)), () {
      if (mounted) {
        setState(() {
          opacity = 1;
          offset = Offset.zero;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 450),
      opacity: opacity,
      child: AnimatedSlide(
        duration: const Duration(milliseconds: 450),
        offset: offset,
        child: _buildCard(context),
      ),
    );
  }

  Widget _buildCard(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = theme.textTheme.bodyLarge?.color;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 14),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            blurRadius: 12,
            color: theme.brightness == Brightness.dark ? Colors.black54 : Colors.black12,
            offset: const Offset(0, 6),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // IMAGE
          ClipRRect(
            borderRadius: const BorderRadius.only(topLeft: Radius.circular(14), topRight: Radius.circular(14)),
            child: Image.network(
              widget.spectacle.imageUrl,
              height: 180,
              width: double.infinity,
              fit: BoxFit.cover,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(
                  height: 180,
                  color: theme.dividerColor,
                  child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
                );
              },
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 180,
                  color: theme.dividerColor,
                  child: const Center(child: Icon(Icons.broken_image, size: 48)),
                );
              },
            ),
          ),

          // TEXT PART
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.spectacle.titre,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.calendar_today, size: 14),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        widget.spectacle.date,
                        style: TextStyle(color: Colors.grey[600], fontSize: 13),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      "${widget.spectacle.prix.toStringAsFixed(2)} €",
                      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
