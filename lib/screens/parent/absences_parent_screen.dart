import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexora/core/theme.dart';

class AbsencesParentScreen extends ConsumerWidget {
  const AbsencesParentScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    final List<Map<String, dynamic>> absences = [
      {'date': '10/10/2024', 'motif': 'Maladie', 'justifiee': true},
      {'date': '15/10/2024', 'motif': '', 'justifiee': false},
      {'date': '20/10/2024', 'motif': 'Rendez-vous medical', 'justifiee': true},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Absences de mon enfant'),
      ),
      body: absences.isEmpty
          ? Center(
              child: Text(
                'Aucune absence enregistree',
                style: theme.textTheme.bodyLarge,
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: absences.length,
              itemBuilder: (context, index) {
                final absence = absences[index];
                final justifiee = absence['justifiee'] as bool;

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    leading: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: justifiee
                            ? AppColors.success.withValues(alpha: 0.1)
                            : AppColors.error.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        justifiee
                            ? Icons.check_circle_outline
                            : Icons.cancel_outlined,
                        color: justifiee ? AppColors.success : AppColors.error,
                      ),
                    ),
                    title: Text(
                      absence['date'],
                      style: theme.textTheme.titleLarge!.copyWith(fontSize: 16),
                    ),
                    subtitle: Text(
                      absence['motif'].isEmpty
                          ? 'Aucun motif'
                          : absence['motif'],
                      style: theme.textTheme.bodyMedium,
                    ),
                    trailing: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: justifiee
                            ? AppColors.success.withValues(alpha: 0.1)
                            : AppColors.error.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        justifiee ? 'Justifiee' : 'Non justifiee',
                        style: TextStyle(
                          color:
                              justifiee ? AppColors.success : AppColors.error,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}