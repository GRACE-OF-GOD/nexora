import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexora/core/theme.dart';

class NotesStudentScreen extends ConsumerWidget {
  const NotesStudentScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    final List<Map<String, dynamic>> notes = [
      {'matiere': 'Mathematiques', 'note': '15.5', 'type': 'Devoir', 'date': '10/10/2024', 'coefficient': '3'},
      {'matiere': 'Francais', 'note': '13.0', 'type': 'Composition', 'date': '12/10/2024', 'coefficient': '2'},
      {'matiere': 'Physique', 'note': '17.0', 'type': 'Devoir', 'date': '15/10/2024', 'coefficient': '2'},
      {'matiere': 'Histoire', 'note': '11.5', 'type': 'Examen', 'date': '18/10/2024', 'coefficient': '1'},
      {'matiere': 'Anglais', 'note': '14.0', 'type': 'Devoir', 'date': '20/10/2024', 'coefficient': '2'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mes notes'),
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
                _buildResume(theme, 'Moyenne', '14.2'),
                _buildResume(theme, 'Rang', '3eme'),
                _buildResume(theme, 'Matieres', '5'),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: notes.length,
              itemBuilder: (context, index) {
                final note = notes[index];
                final valeur = double.parse(note['note']);
                final color = valeur >= 14
                    ? AppColors.success
                    : valeur >= 10
                        ? const Color(0xFFF57C00)
                        : AppColors.error;

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    leading: Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          note['note'],
                          style: TextStyle(
                            color: color,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                    title: Text(
                      note['matiere'],
                      style: theme.textTheme.titleLarge!.copyWith(fontSize: 16),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text(
                          '${note['type']} - ${note['date']}',
                          style: theme.textTheme.bodyMedium,
                        ),
                        Text(
                          'Coefficient : ${note['coefficient']}',
                          style: theme.textTheme.bodyMedium!.copyWith(
                            color: AppColors.primary,
                          ),
                        ),
                      ],
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