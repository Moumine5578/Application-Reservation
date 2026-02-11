import 'package:flutter/material.dart';
import '../models/spectacle_model.dart';
import '../services/reservation_service.dart';

class DetailSpectacleScreen extends StatefulWidget {
  final Spectacle spectacle;
  const DetailSpectacleScreen({super.key, required this.spectacle});

  @override
  State<DetailSpectacleScreen> createState() => _DetailSpectacleScreenState();
}

class _DetailSpectacleScreenState extends State<DetailSpectacleScreen>
    with TickerProviderStateMixin {
  bool _reserve = false;
  late AnimationController _notifController;
  late AnimationController _contentController;
  late Animation<double> _notifScale;
  late Animation<double> _notifOpacity;
  late Animation<double> _contentFade;

  @override
  void initState() {
    super.initState();
    _reserve = ReservationService.isReserved(widget.spectacle.id);
    _notifController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _notifScale = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _notifController, curve: Curves.elasticOut),
    );
    _notifOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _notifController, curve: Curves.easeIn),
    );

    _contentController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _contentFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _contentController, curve: Curves.easeOut),
    );
    _contentController.forward();
  }

  @override
  void dispose() {
    _notifController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _reserver() async {
    if (_reserve) return;
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Confirmer la réservation'),
        content: const Text('Vous êtes sûr ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Annuler'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Confirmer'),
          ),
        ],
      ),
    );
    if (confirm != true || !mounted) return;
    ReservationService.add(widget.spectacle);
    setState(() => _reserve = true);
    _notifController.forward();
    Future.delayed(const Duration(milliseconds: 2500), () {
      if (mounted) _notifController.reverse();
    });
  }

  @override
  Widget build(BuildContext context) {
    final spectacle = widget.spectacle;
    return Scaffold(
      appBar: AppBar(
        title: Text(spectacle.titre, maxLines: 1, overflow: TextOverflow.ellipsis),
      ),
      body: Stack(
        children: [
          FadeTransition(
            opacity: _contentFade,
            child: SingleChildScrollView(
              child: Column(
                children: [
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
                        Text(
                          spectacle.titre,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (spectacle.lieu != null) ...[
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              const Icon(Icons.place, size: 18),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  spectacle.lieu!,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
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
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          "Description de démonstration. Ici tu pourras afficher le résumé, la durée, les artistes, le lieu, etc. Pour le prototype, ce texte est statique.",
                          style: TextStyle(fontSize: 14),
                        ),
                        const SizedBox(height: 20),
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          child: SizedBox(
                            width: double.infinity,
                            height: 52,
                            child: ElevatedButton.icon(
                              onPressed: _reserve ? null : _reserver,
                              icon: Icon(_reserve ? Icons.check_circle : Icons.confirmation_num),
                              label: Text(_reserve ? 'Réservé' : 'Réserver'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: _reserve
                                    ? Colors.green
                                    : Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Notification animée "C'est réservé !"
          IgnorePointer(
            child: Center(
              child: AnimatedBuilder(
                animation: _notifController,
                builder: (context, child) {
                  return Opacity(
                    opacity: _notifOpacity.value,
                    child: Transform.scale(
                      scale: _notifScale.value,
                      child: Material(
                        color: Colors.transparent,
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 24),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 20,
                          ),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surface,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 20,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.check_circle,
                                color: Colors.green,
                                size: 40,
                              ),
                              const SizedBox(width: 16),
                              const Text(
                                "C'est réservé !",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
