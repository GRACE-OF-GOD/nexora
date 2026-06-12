import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexora/core/theme.dart';

class NotesParentScreen extends ConsumerWidget {
  const NotesParentScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    final List<Map<String, dynamic>> notes = [
      {'matiere': 'Mathematiques', 'note': '15.5', 'type': 'Devoir', 'date': '10/10/2024'},
      {'matiere': 'Francais', 'note': '13.0', 'type': 'Composition', 'date': '12/10/2024'},
      {'matiere': 'Physique', 'note': '17.0', 'type': 'Devoir', 'date': '15/10/2024'},
      {'matiere': 'Histoire', 'note': '11.5', 'type': 'Examen', 'date': '18/10/2024'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notes de mon enfant'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
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
                  Text(note['type'], style: theme.textTheme.bodyMedium),
                  Text(note['date'], style: theme.textTheme.bodyMedium),
                ],
              ),
              trailing: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  valeur >= 14
                      ? 'Bien'
                      : valeur >= 10
                          ? 'Passable'
                          : 'Insuffisant',
                  style: TextStyle(
                    color: color,
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