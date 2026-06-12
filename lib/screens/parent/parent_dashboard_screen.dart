 import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nexora/core/theme.dart';
import 'package:nexora/providers/auth_provider.dart';

class ParentDashboardScreen extends ConsumerWidget {
  const ParentDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final authState = ref.watch(authStateProvider);
    final user = authState.value;

    return Scaffold(
      appBar: AppBar(
        title: const Text('NEXORA'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => context.push('/settings'),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await ref.read(authStateProvider.notifier).logout();
              if (context.mounted) context.go('/login');
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(theme, user?.nom ?? ''),
              const SizedBox(height: 24),
              _buildMenuGrid(context, theme),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(ThemeData theme, String nom) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: AppColors.white.withValues(alpha: 0.2),
            child: const Icon(Icons.person, color: AppColors.white, size: 32),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Bonjour, $nom',
                  style: theme.textTheme.titleLarge!.copyWith(
                    color: AppColors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Espace Parent',
                  style: theme.textTheme.bodyMedium!.copyWith(
                    color: AppColors.white.withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuGrid(BuildContext context, ThemeData theme) {
    final items = [
      _MenuItem(label: 'Mon enfant', icon: Icons.child_care, color: AppColors.primary, onTap: () {}),
      _MenuItem(label: 'Notes', icon: Icons.grade_outlined, color: const Color(0xFF388E3C), onTap: () => context.push('/parent/notes')),
      _MenuItem(label: 'Absences', icon: Icons.event_busy_outlined, color: const Color(0xFFD32F2F), onTap: () => context.push('/parent/absences')),
      _MenuItem(label: 'Bulletins', icon: Icons.description_outlined, color: const Color(0xFF7B1FA2), onTap: () => context.push('/parent/bulletins')),
      _MenuItem(label: 'Paiements', icon: Icons.payments_outlined, color: const Color(0xFFF57C00), onTap: () {}),
      _MenuItem(label: 'Parametres', icon: Icons.settings_outlined, color: AppColors.secondary, onTap: () => context.push('/settings')),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Menu', style: theme.textTheme.titleLarge),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.2,
          ),
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];
            return _buildMenuCard(theme, item);
          },
        ),
      ],
    );
  }

  Widget _buildMenuCard(ThemeData theme, _MenuItem item) {
    return Card(
      child: InkWell(
        onTap: item.onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: item.color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(item.icon, color: item.color, size: 28),
              ),
              const SizedBox(height: 12),
              Text(
                item.label,
                style: theme.textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MenuItem {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _MenuItem({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });
}