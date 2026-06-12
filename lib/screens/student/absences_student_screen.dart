import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexora/core/theme.dart';

class AbsencesStudentScreen extends ConsumerWidget {
  const AbsencesStudentScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    final List<Map<String, dynamic>> absences = [
      {'date': '10/10/2024', 'motif': 'Maladie', 'justifiee': true},
      {'date': '15/10/2024', 'motif': '', 'justifiee': false},
      {'date': '20/10/2024', 'motif': 'Rendez-vous medical', 'justifiee': true},
    ];

    final justifiees = absences.where((a) => a['justifiee'] == true).length;
    final nonJustifiees = absences.where((a) => a['justifiee'] == false).length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mes absences'),
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildResume(theme, 'Total', '${absences.length}'),
                _buildResume(theme, 'Justifiees', '$justifiees'),
                _buildResume(theme, 'Non justifiees', '$nonJustifiees'),
              ],
            ),
          ),
          Expanded(
            child: absences.isEmpty
                ? Center(
                    child: Text(
                      'Aucune absence enregistree',
                      style: theme.textTheme.bodyLarge,
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
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
                              color: justifiee
                                  ? AppColors.success
                                  : AppColors.error,
                            ),
                          ),
                          title: Text(
                            absence['date'],
                            style: theme.textTheme.titleLarge!
                                .copyWith(fontSize: 16),
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
                                color: justifiee
                                    ? AppColors.success
                                    : AppColors.error,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildResume(ThemeData theme, String label, String valeur) {
    return Column(
      children: [
        Text(
          valeur,
          style: theme.textTheme.titleLarge!.copyWith(
            color: AppColors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: theme.textTheme.bodyMedium!.copyWith(
            color: AppColors.white.withValues(alpha: 0.8),
          ),
        ),
      ],
    );
  }
}