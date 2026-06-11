import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nexora/core/theme.dart';
import 'package:nexora/providers/auth_provider.dart';
import 'package:nexora/providers/theme_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDarkMode = ref.watch(themeProvider);
    final authState = ref.watch(authStateProvider);
    final user = authState.value;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Parametres'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildProfilCard(theme, user?.nom ?? '', user?.prenom ?? '', user?.role ?? ''),
              const SizedBox(height: 24),
              _buildSection(
                theme,
                titre: 'Apparence',
                enfants: [
                  SwitchListTile(
                    title: Text('Mode sombre', style: theme.textTheme.bodyLarge),
                    subtitle: Text(
                      isDarkMode ? 'Actif' : 'Inactif',
                      style: theme.textTheme.bodyMedium,
                    ),
                    secondary: Icon(
                      isDarkMode ? Icons.dark_mode : Icons.light_mode,
                      color: AppColors.primary,
                    ),
                    value: isDarkMode,
                    activeColor: AppColors.primary,
                    onChanged: (_) {
                      ref.read(themeProvider.notifier).toggleTheme();
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildSection(
                theme,
                titre: 'Compte',
                enfants: [
                  ListTile(
                    leading: const Icon(Icons.person_outlined, color: AppColors.primary),
                    title: Text('Modifier le profil', style: theme.textTheme.bodyLarge),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {},
                  ),
                  ListTile(
                    leading: const Icon(Icons.lock_outlined, color: AppColors.primary),
                    title: Text('Changer le mot de passe', style: theme.textTheme.bodyLarge),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {},
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildSection(
                theme,
                titre: 'Application',
                enfants: [
                  ListTile(
                    leading: const Icon(Icons.info_outlined, color: AppColors.primary),
                    title: Text('Version', style: theme.textTheme.bodyLarge),
                    trailing: Text('1.0.0', style: theme.textTheme.bodyMedium),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () async {
                    await ref.read(authStateProvider.notifier).logout();
                    if (context.mounted) context.go('/login');
                  },
                  icon: const Icon(Icons.logout),
                  label: const Text('Se deconnecter'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.error,
                    foregroundColor: AppColors.white,
                    minimumSize: const Size(double.infinity, 52),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfilCard(ThemeData theme, String nom, String prenom, String role) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            CircleAvatar(
              radius: 32,
              backgroundColor: AppColors.primary.withValues(alpha: 0.1),
              child: const Icon(Icons.person, color: AppColors.primary, size: 36),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '$prenom $nom',
                    style: theme.textTheme.titleLarge,
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      role,
                      style: theme.textTheme.bodyMedium!.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(ThemeData theme, {required String titre, required List<Widget> enfants}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            titre,
            style: theme.textTheme.titleLarge!.copyWith(
              fontSize: 14,
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Card(
          child: Column(children: enfants),
        ),
      ],
    );
  }
}