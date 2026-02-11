import 'package:flutter/material.dart';

/// Contenu de l'onglet Profil : en-tête + listes d’entrées qui mènent ailleurs.
class ProfileScreen extends StatelessWidget {
  final bool isDarkMode;
  final Function(bool) onToggleTheme;
  final VoidCallback? onNavigateToTickets;

  const ProfileScreen({
    super.key,
    required this.isDarkMode,
    required this.onToggleTheme,
    this.onNavigateToTickets,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildProfileHeader(context),
          const SizedBox(height: 28),
          _buildSectionTitle(context, 'Mon compte'),
          _buildCard(
            context,
            children: [
              _profileTile(
                context,
                icon: Icons.person_outline,
                title: 'Mes informations',
                subtitle: 'Nom, email, mot de passe',
                onTap: () => _showPlaceholder(context, 'Mes informations'),
              ),
              _divider(context),
              _profileTile(
                context,
                icon: Icons.confirmation_num_outlined,
                title: 'Mes tickets',
                subtitle: 'Voir mes réservations',
                onTap: onNavigateToTickets ?? () => _showPlaceholder(context, 'Mes tickets'),
              ),
              _divider(context),
              _profileTile(
                context,
                icon: Icons.payment_outlined,
                title: 'Paiement & facturation',
                subtitle: 'Moyens de paiement, factures',
                onTap: () => _showPlaceholder(context, 'Paiement & facturation'),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildSectionTitle(context, 'Préférences'),
          _buildCard(
            context,
            children: [
              _profileTile(
                context,
                icon: Icons.notifications_outlined,
                title: 'Notifications',
                subtitle: 'Alertes, rappels de spectacle',
                onTap: () => _showPlaceholder(context, 'Notifications'),
              ),
              _divider(context),
              SwitchListTile(
                secondary: Icon(Icons.dark_mode_outlined, color: Theme.of(context).colorScheme.onSurface),
                title: const Text('Mode sombre'),
                subtitle: const Text('Thème clair / sombre'),
                value: isDarkMode,
                onChanged: onToggleTheme,
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildSectionTitle(context, 'Aide & à propos'),
          _buildCard(
            context,
            children: [
              _profileTile(
                context,
                icon: Icons.help_outline,
                title: 'Aide',
                subtitle: 'FAQ, nous contacter',
                onTap: () => _showPlaceholder(context, 'Aide'),
              ),
              _divider(context),
              _profileTile(
                context,
                icon: Icons.info_outline,
                title: 'À propos',
                subtitle: 'Reelax Tickets v1.0',
                onTap: () => showAboutDialog(
                  context: context,
                  applicationName: 'Reelax Tickets',
                  applicationVersion: '1.0',
                  applicationIcon: Icon(Icons.confirmation_num, color: Theme.of(context).colorScheme.primary),
                  children: [
                    const Text('Revendez et achetez des vrais billets à un prix juste.'),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildCard(
            context,
            children: [
              _profileTile(
                context,
                icon: Icons.logout,
                title: 'Déconnexion',
                subtitle: 'Se déconnecter du compte',
                onTap: () => _showPlaceholder(context, 'Déconnexion'),
                titleColor: Theme.of(context).colorScheme.error,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context) {
    return Center(
      child: Column(
        children: [
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: 1),
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeOutCubic,
            builder: (context, value, child) {
              return Opacity(
                opacity: value,
                child: Transform.scale(
                  scale: value,
                  child: child,
                ),
              );
            },
            child: CircleAvatar(
              radius: 48,
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              child: Icon(
                Icons.person,
                size: 52,
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Mon profil',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'utilisateur@reelax-tickets.fr',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w600,
          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.8),
        ),
      ),
    );
  }

  Widget _buildCard(BuildContext context, {required List<Widget> children}) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.black45
                : Colors.black12,
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget _profileTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Color? titleColor,
  }) {
    return ListTile(
      leading: Icon(icon, color: titleColor ?? Theme.of(context).colorScheme.primary),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: titleColor ?? Theme.of(context).colorScheme.onSurface,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
        ),
      ),
      trailing: Icon(
        Icons.chevron_right,
        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5),
      ),
      onTap: onTap,
    );
  }

  Widget _divider(BuildContext context) {
    return Divider(
      height: 1,
      indent: 56,
      color: Theme.of(context).dividerColor,
    );
  }

  void _showPlaceholder(BuildContext context, String label) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$label — à venir')),
    );
  }
}
