import 'dart:async';
import 'package:flutter/material.dart';
import '../services/spectacle_service.dart';
import '../services/reservation_service.dart';
import '../widgets/spectacle_card.dart';
import '../widgets/spectacle_carousel_card.dart';
import '../models/spectacle_model.dart';
import 'detail_spectacle_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  final Function(bool) onToggleTheme;
  final bool isDarkMode;

  const HomeScreen({super.key, required this.onToggleTheme, required this.isDarkMode});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

enum TriSpectacles { dateProches, dateLointaines, prixCroissant, meilleuresDates }

class _HomeScreenState extends State<HomeScreen> {
  final SpectacleService _service = SpectacleService();
  String _searchQuery = '';
  int _currentIndex = 0; // bottom nav index
  TriSpectacles _tri = TriSpectacles.dateProches;

  // pour stocker la liste une fois chargée
  List<Spectacle> _allSpectacles = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _buildSearchBar(),
        centerTitle: true,
        elevation: 2,
      ),
      drawer: _buildDrawer(),
      body: SafeArea(
        child: FutureBuilder<List<Spectacle>>(
          future: _service.getSpectacles(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return ListView.builder(
                itemCount: 6,
                itemBuilder: (context, index) => _buildShimmerCard(context),
              );
            }

            if (snapshot.hasError) {
              return Center(child: Text('Erreur: ${snapshot.error}'));
            }

            // données OK
            _allSpectacles = snapshot.data ?? [];

            // Appliquer le filtre de recherche puis le tri
            final filtered = _sortSpectacles(_filterSpectacles(_allSpectacles, _searchQuery), _tri);

            if (_currentIndex == 1) {
              return _buildTicketsList();
            } else if (_currentIndex == 2) {
              return ProfileScreen(
                isDarkMode: widget.isDarkMode,
                onToggleTheme: widget.onToggleTheme,
                onNavigateToTickets: () => setState(() => _currentIndex = 1),
              );
            }

            if (filtered.isEmpty) {
              return const Center(child: Text("Aucun spectacle trouvé."));
            }

            return _buildAccueilBody(context, filtered);
          },
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Accueil'),
          BottomNavigationBarItem(icon: Icon(Icons.confirmation_num), label: 'Tickets'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        ],
      ),
    );
  }

  // -------------------------
  // Search bar widget
  // -------------------------
  Widget _buildSearchBar() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Rechercher un spectacle, lieu, date...',
          prefixIcon: const Icon(Icons.search),
          filled: true,
          isDense: true,
          contentPadding: const EdgeInsets.all(12),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
        ),
        onChanged: (v) => setState(() => _searchQuery = v.trim()),
      ),
    );
  }

  // -------------------------
  // Drawer (menu burger)
  // -------------------------
  Drawer _buildDrawer() {
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            DrawerHeader(
              child: Row(
                children: [
                  Container(
                    width: 64, height: 64,
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.theaters, size: 36),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(child: Text('Reelax Tickets', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Accueil'),
              onTap: () {
                setState(() => _currentIndex = 0);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.confirmation_num),
              title: const Text('Mes tickets'),
              onTap: () {
                setState(() => _currentIndex = 1);
                Navigator.pop(context);
              },
            ),
            const Divider(),
            SwitchListTile(
              title: const Text('Mode sombre'),
              value: widget.isDarkMode,
              onChanged: (v) {
                widget.onToggleTheme(v);
                Navigator.pop(context);
              },
              secondary: const Icon(Icons.dark_mode),
            ),
            const Spacer(),
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('À propos'),
              onTap: () => showAboutDialog(
                context: context,
                applicationName: 'Reelax Tickets (Prototype)',
                applicationVersion: '1.0',
                children: [const Text('Prototype mobile pour le projet Fil Rouge.')],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // -------------------------
  // Accueil : hero + carousel défilant + seconde chance + liste
  // -------------------------
  Widget _buildAccueilBody(BuildContext context, List<Spectacle> filtered) {
    final isWide = MediaQuery.of(context).size.width > 600;
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(child: _buildHeroSection()),
        SliverToBoxAdapter(child: _buildTicketsCarousel(filtered)),
        SliverToBoxAdapter(child: _buildSecondeChanceSection()),
        SliverToBoxAdapter(child: _buildTriChips()),
        SliverPadding(padding: const EdgeInsets.only(top: 8)),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              final spect = filtered[index];
              return TweenAnimationBuilder<double>(
                key: ValueKey(spect.id),
                tween: Tween(begin: 0, end: 1),
                duration: Duration(milliseconds: 300 + (index * 50)),
                curve: Curves.easeOutCubic,
                builder: (context, value, child) {
                  return Opacity(
                    opacity: value,
                    child: Transform.translate(
                      offset: Offset(0, 20 * (1 - value)),
                      child: child,
                    ),
                  );
                },
                child: GestureDetector(
                  onTap: () => _openDetail(spect),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: double.infinity,
                      minHeight: isWide ? 260 : 180,
                    ),
                    child: SpectacleCard(spectacle: spect),
                  ),
                ),
              );
            },
            childCount: filtered.length,
          ),
        ),
        const SliverPadding(padding: EdgeInsets.only(bottom: 24)),
      ],
    );
  }

  Widget _buildHeroSection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Revendez et achetez\ndes vrais billets\nà un prix juste',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              height: 1.2,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            'Reelax Tickets travaille avec les organisateurs afin de sécuriser l\'achat et la revente de billets des événements les plus demandés.',
            style: TextStyle(
              fontSize: 15,
              height: 1.4,
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.85),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Text('😍', style: TextStyle(fontSize: 20)),
              const SizedBox(width: 6),
              Text(
                '+1,5 million d\'utilisateurs satisfaits',
                style: TextStyle(fontSize: 13, color: Colors.grey[700]),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text('⭐', style: TextStyle(fontSize: 20)),
              const SizedBox(width: 6),
              Text(
                '4,8/5 sur Google Avis et Trustpilot',
                style: TextStyle(fontSize: 13, color: Colors.grey[700]),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTicketsCarousel(List<Spectacle> list) {
    return SizedBox(
      height: 220,
      child: _TicketsCarousel(spectacles: list.take(10).toList(), onTap: _openDetail),
    );
  }

  Widget _buildSecondeChanceSection() {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 24, 20, 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.6),
            Theme.of(context).colorScheme.tertiaryContainer.withValues(alpha: 0.5),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tout le monde mérite une seconde chance',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Un imprévu ? Revendez gratuitement vos billets à ceux qui n\'ont pas eu la chance d\'en avoir !',
            style: TextStyle(
              fontSize: 14,
              height: 1.4,
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.9),
            ),
          ),
        ],
      ),
    );
  }

  // -------------------------
  // Chips de tri (meilleures dates, etc.)
  // -------------------------
  Widget _buildTriChips() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          _triChip('Proches', TriSpectacles.dateProches),
          const SizedBox(width: 8),
          _triChip('Lointaines', TriSpectacles.dateLointaines),
          const SizedBox(width: 8),
          _triChip('Meilleures dates', TriSpectacles.meilleuresDates),
          const SizedBox(width: 8),
          _triChip('Prix ↑', TriSpectacles.prixCroissant),
        ],
      ),
    );
  }

  Widget _triChip(String label, TriSpectacles value) {
    final selected = _tri == value;
    return FilterChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => setState(() => _tri = value),
      selectedColor: Theme.of(context).colorScheme.primaryContainer,
    );
  }

  // -------------------------
  // Filtre de recherche basique
  // -------------------------
  List<Spectacle> _filterSpectacles(List<Spectacle> all, String query) {
    if (query.isEmpty) return all;
    final q = query.toLowerCase();
    return all.where((s) {
      return s.titre.toLowerCase().contains(q)
          || s.date.toLowerCase().contains(q)
          || (s.lieu?.toLowerCase().contains(q) ?? false);
    }).toList();
  }

  // -------------------------
  // Tri : proches, lointaines, meilleures dates (week-end), prix
  // -------------------------
  List<Spectacle> _sortSpectacles(List<Spectacle> list, TriSpectacles tri) {
    final sorted = List<Spectacle>.from(list);
    switch (tri) {
      case TriSpectacles.dateProches:
        sorted.sort((a, b) {
          final da = a.dateTime ?? DateTime(9999);
          final db = b.dateTime ?? DateTime(9999);
          return da.compareTo(db);
        });
        break;
      case TriSpectacles.dateLointaines:
        sorted.sort((a, b) {
          final da = a.dateTime ?? DateTime(0);
          final db = b.dateTime ?? DateTime(0);
          return db.compareTo(da);
        });
        break;
      case TriSpectacles.prixCroissant:
        sorted.sort((a, b) => a.prix.compareTo(b.prix));
        break;
      case TriSpectacles.meilleuresDates:
        // Week-end et dates proches en premier (dans les 3 mois)
        sorted.sort((a, b) {
          final da = a.dateTime;
          final db = b.dateTime;
          if (da == null && db == null) return 0;
          if (da == null) return 1;
          if (db == null) return -1;
          final aWeekend = da.weekday == DateTime.saturday || da.weekday == DateTime.sunday;
          final bWeekend = db.weekday == DateTime.saturday || db.weekday == DateTime.sunday;
          if (aWeekend != bWeekend) return aWeekend ? -1 : 1;
          return da.compareTo(db);
        });
        break;
    }
    return sorted;
  }

  // -------------------------
  // Liste des billets réservés (onglet Tickets)
  // -------------------------
  Widget _buildTicketsList() {
    final tickets = ReservationService.reservations;
    if (tickets.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.confirmation_num_outlined, size: 64, color: Colors.grey[400]),
              const SizedBox(height: 16),
              Text(
                'Aucun ticket',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(
                'Réservez un spectacle depuis l\'accueil pour le retrouver ici.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      );
    }
    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
      itemCount: tickets.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final spect = tickets[index];
        return TweenAnimationBuilder<double>(
          key: ValueKey('ticket-${spect.id}'),
          tween: Tween(begin: 0, end: 1),
          duration: Duration(milliseconds: 280 + (index * 40)),
          curve: Curves.easeOutCubic,
          builder: (context, value, child) {
            return Opacity(
              opacity: value,
              child: Transform.translate(
                offset: Offset(0, 16 * (1 - value)),
                child: child,
              ),
            );
          },
          child: GestureDetector(
            onTap: () => _openDetail(spect),
            child: SpectacleCard(spectacle: spect),
          ),
        );
      },
    );
  }

  // -------------------------
  // Ouvrir détail (rafraîchit la liste au retour pour mettre à jour les tickets)
  // -------------------------
  void _openDetail(Spectacle s) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => DetailSpectacleScreen(spectacle: s)))
        .then((_) => setState(() {}));
  }

  // -------------------------
  // Shimmer simple
  // -------------------------
  Widget _buildShimmerCard(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark ? Colors.grey[800] : Colors.grey[300],
        borderRadius: BorderRadius.circular(16),
      ),
      height: 220,
    );
  }
}

/// Carousel horizontal avec défilement automatique des billets.
class _TicketsCarousel extends StatefulWidget {
  final List<Spectacle> spectacles;
  final void Function(Spectacle) onTap;

  const _TicketsCarousel({required this.spectacles, required this.onTap});

  @override
  State<_TicketsCarousel> createState() => _TicketsCarouselState();
}

class _TicketsCarouselState extends State<_TicketsCarousel> {
  late ScrollController _controller;
  Timer? _timer;
  static const double _cardWidth = SpectacleCarouselCard.cardWidth + 12;

  @override
  void initState() {
    super.initState();
    _controller = ScrollController();
    if (widget.spectacles.length > 1) {
      _timer = Timer.periodic(const Duration(seconds: 3), (_) => _scrollToNext());
    }
  }

  void _scrollToNext() {
    if (!_controller.hasClients || widget.spectacles.length <= 1) return;
    final max = _controller.position.maxScrollExtent;
    final current = _controller.offset;
    final next = current + _cardWidth;
    if (next >= max - 10) {
      _controller.animateTo(0, duration: const Duration(milliseconds: 400), curve: Curves.easeInOut);
    } else {
      _controller.animateTo(next, duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.spectacles.isEmpty) {
      return const SizedBox.shrink();
    }
    return ListView.builder(
      controller: _controller,
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: widget.spectacles.length,
      itemBuilder: (context, index) {
        final s = widget.spectacles[index];
        return GestureDetector(
          onTap: () => widget.onTap(s),
          child: SpectacleCarouselCard(spectacle: s, index: index),
        );
      },
    );
  }
}
