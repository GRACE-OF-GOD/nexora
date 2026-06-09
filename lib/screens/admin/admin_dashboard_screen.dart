 import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nexora/core/theme.dart';
import 'package:nexora/models/dashboard_model.dart';
import 'package:nexora/providers/auth_provider.dart';

class AdminDashboardScreen extends ConsumerWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final stats = DashboardStats(
      totalEleves: 320,
      totalEnseignants: 24,
      totalClasses: 12,
      totalAbsences: 8,
      totalRevenus: 4500000,
      tauxReussite: 87.5,
    );

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'NEXORA',
              style: theme.textTheme.titleLarge!.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text('Tableau de bord', style: theme.textTheme.bodyMedium),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await ref.read(authStateProvider.notifier).logout();
              context.go('/login');
            },
          ),
        ],
      ),
      drawer: _buildDrawer(context, theme),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Bonjour, Administrateur', style: theme.textTheme.headlineMedium),
            const SizedBox(height: 4),
            Text('Vue generale du systeme', style: theme.textTheme.bodyMedium),
            const SizedBox(height: 24),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.3,
              children: [
                _buildStatCard(theme, 'Eleves', stats.totalEleves.toString(), Icons.school_outlined, AppColors.primary),
                _buildStatCard(theme, 'Enseignants', stats.totalEnseignants.toString(), Icons.person_outlined, AppColors.secondary),
                _buildStatCard(theme, 'Classes', stats.totalClasses.toString(), Icons.class_outlined, const Color(0xFF388E3C)),
                _buildStatCard(theme, 'Absences', stats.totalAbsences.toString(), Icons.event_busy_outlined, const Color(0xFFD32F2F)),
                _buildStatCard(theme, 'Revenus (FCFA)', '${stats.totalRevenus ~/ 1000}K', Icons.payments_outlined, const Color(0xFF7B1FA2)),
                _buildStatCard(theme, 'Taux reussite', '${stats.tauxReussite}%', Icons.trending_up_outlined, const Color(0xFFF57C00)),
              ],
            ),
            const SizedBox(height: 24),
            Text('Acces rapide', style: theme.textTheme.titleLarge),
            const SizedBox(height: 12),
            _buildQuickAccessGrid(context, theme),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(ThemeData theme, String title, String value, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 8),
            Text(
              value,
              style: theme.textTheme.headlineMedium!.copyWith(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(title, style: theme.textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickAccessGrid(BuildContext context, ThemeData theme) {
    final items = [
      {'title': 'Eleves', 'icon': Icons.school_outlined, 'route': '/admin/eleves'},
      {'title': 'Enseignants', 'icon': Icons.person_outlined, 'route': '/admin/enseignants'},
      {'title': 'Classes', 'icon': Icons.class_outlined, 'route': '/admin/classes'},
      {'title': 'Matieres', 'icon': Icons.book_outlined, 'route': '/admin/matieres'},
      {'title': 'Notes', 'icon': Icons.grade_outlined, 'route': '/admin/notes'},
      {'title': 'Absences', 'icon': Icons.event_busy_outlined, 'route': '/admin/absences'},
      {'title': 'Bulletins', 'icon': Icons.description_outlined, 'route': '/admin/bulletins'},
      {'title': 'Paiements', 'icon': Icons.payments_outlined, 'route': '/admin/paiements'},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 0.9,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return InkWell(
          onTap: () => context.go(item['route'] as String),
          borderRadius: BorderRadius.circular(12),
          child: Card(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(item['icon'] as IconData, color: AppColors.primary, size: 28),
                const SizedBox(height: 8),
                Text(
                  item['title'] as String,
                  style: theme.textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDrawer(BuildContext context, ThemeData theme) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(color: AppColors.primary),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Icon(Icons.account_circle, size: 48, color: Colors.white),
                const SizedBox(height: 8),
                Text(
                  'Administrateur',
                  style: theme.textTheme.titleLarge!.copyWith(color: Colors.white),
                ),
                Text(
                  'admin@nexora.com',
                  style: theme.textTheme.bodyMedium!.copyWith(color: Colors.white70),
                ),
              ],
            ),
          ),
          _buildDrawerItem(context, Icons.dashboard_outlined, 'Tableau de bord', route: '/admin'),
          _buildDrawerItem(context, Icons.school_outlined, 'Eleves', route: '/admin/eleves'),
          _buildDrawerItem(context, Icons.person_outlined, 'Enseignants', route: '/admin/enseignants'),
          _buildDrawerItem(context, Icons.class_outlined, 'Classes', route: '/admin/classes'),
          _buildDrawerItem(context, Icons.payments_outlined, 'Paiements', route: '/admin/paiements'),
          _buildDrawerItem(context, Icons.settings_outlined, 'Parametres', route: '/admin/parametres'),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(BuildContext context, IconData icon, String title, {String route = '/admin'}) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primary),
      title: Text(title),
      onTap: () {
        Navigator.pop(context);
        context.go(route);
      },
    );
  }
}