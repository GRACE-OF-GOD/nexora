import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexora/core/theme.dart';

class BulletinsParentScreen extends ConsumerWidget {
  const BulletinsParentScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    final List<Map<String, dynamic>> bulletins = [
      {
        'trimestre': '1er Trimestre',
        'moyenne': '14.5',
        'rang': 3,
        'mention': 'Bien',
        'date': 'Decembre 2024',
      },
      {
        'trimestre': '2eme Trimestre',
        'moyenne': '15.2',
        'rang': 2,
        'mention': 'Bien',
        'date': 'Mars 2025',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bulletins de mon enfant'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: bulletins.length,
        itemBuilder: (context, index) {
          final bulletin = bulletins[index];
          final moyenne = double.parse(bulletin['moyenne']);
          final color = moyenne >= 14
              ? AppColors.success
              : moyenne >= 10
                  ? const Color(0xFFF57C00)
                  : AppColors.error;

          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        bulletin['trimestre'],
                        style: theme.textTheme.titleLarge,
                      ),
                      Text(
                        bulletin['date'],
                        style: theme.textTheme.bodyMedium,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _buildStat(
                          theme,
                          'Moyenne',
                          bulletin['moyenne'],
                          color,
                        ),
                      ),
                      Expanded(
                        child: _buildStat(
                          theme,
                          'Rang',
                          '${bulletin['rang']}eme',
                          AppColors.primary,
                        ),
                      ),
                      Expanded(
                        child: _buildStat(
                          theme,
                          'Mention',
                          bulletin['mention'],
                          color,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.download_outlined),
                      label: const Text('Telecharger PDF'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.primary,
                        side: const BorderSide(color: AppColors.primary),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildStat(ThemeData theme, String label, String valeur, Color color) {
    return Column(
      children: [
        Text(
          valeur,
          style: theme.textTheme.titleLarge!.copyWith(
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: theme.textTheme.bodyMedium,
        ),
      ],
    );
  }
}