import 'package:flutter/material.dart';
import '../services/spectacle_service.dart';
import '../widgets/spectacle_card.dart';
import '../models/spectacle_model.dart';
import 'detail_spectacle_screen.dart';

class HomeScreen extends StatefulWidget {
  final Function(bool) onToggleTheme;
  final bool isDarkMode;

  const HomeScreen({super.key, required this.onToggleTheme, required this.isDarkMode});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final SpectacleService _service = SpectacleService();
  String _searchQuery = '';
  int _currentIndex = 0; // bottom nav index

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

            // Appliquer le filtre de recherche
            final filtered = _filterSpectacles(_allSpectacles, _searchQuery);

            // Si on veut d'autres onglets via bottom nav (placeholder)
            if (_currentIndex == 1) {
              return Center(child: Text('Mes tickets (placeholder)'));
            } else if (_currentIndex == 2) {
              return Center(child: Text('Profil (placeholder)'));
            }

            if (filtered.isEmpty) {
              return const Center(child: Text("Aucun spectacle trouvé."));
            }

            return LayoutBuilder(builder: (context, constraints) {
              // adapt card height selon largeur
              final isWide = constraints.maxWidth > 600;
              return ListView.separated(
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: filtered.length,
                separatorBuilder: (context, index) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final spect = filtered[index];
                  return GestureDetector(
                    onTap: () => _openDetail(spect),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: double.infinity,
                        minHeight: isWide ? 260 : 180,
                      ),
                      child: SpectacleCard(spectacle: spect),
                    ),
                  );
                },
              );
            });
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
  // Filtre de recherche basique
  // -------------------------
  List<Spectacle> _filterSpectacles(List<Spectacle> all, String query) {
    if (query.isEmpty) return all;
    final q = query.toLowerCase();
    return all.where((s) {
      return s.titre.toLowerCase().contains(q)
          || s.date.toLowerCase().contains(q)
          || s.imageUrl.toLowerCase().contains(q);
    }).toList();
  }

  // -------------------------
  // Ouvrir détail
  // -------------------------
  void _openDetail(Spectacle s) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => DetailSpectacleScreen(spectacle: s)));
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
