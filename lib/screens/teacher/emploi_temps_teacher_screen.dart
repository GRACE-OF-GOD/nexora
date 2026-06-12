import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexora/core/theme.dart';

class EmploiTempsTeacherScreen extends ConsumerWidget {
  const EmploiTempsTeacherScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    final List<String> jours = [
      'Lundi', 'Mardi', 'Mercredi', 'Jeudi', 'Vendredi', 'Samedi'
    ];

    final Map<String, List<Map<String, dynamic>>> emploiDuTemps = {
      'Lundi': [
        {'heure': '08:00 - 10:00', 'matiere': 'Mathematiques', 'classe': '6eme A', 'salle': 'Salle 12'},
        {'heure': '10:00 - 12:00', 'matiere': 'Mathematiques', 'classe': '5eme B', 'salle': 'Salle 08'},
      ],
      'Mardi': [
        {'heure': '08:00 - 10:00', 'matiere': 'Mathematiques', 'classe': '4eme A', 'salle': 'Salle 05'},
      ],
      'Mercredi': [
        {'heure': '10:00 - 12:00', 'matiere': 'Mathematiques', 'classe': '6eme B', 'salle': 'Salle 12'},
      ],
      'Jeudi': [
        {'heure': '08:00 - 10:00', 'matiere': 'Mathematiques', 'classe': '5eme A', 'salle': 'Salle 10'},
        {'heure': '14:00 - 16:00', 'matiere': 'Mathematiques', 'classe': '3eme A', 'salle': 'Salle 15'},
      ],
      'Vendredi': [
        {'heure': '10:00 - 12:00', 'matiere': 'Mathematiques', 'classe': '4eme B', 'salle': 'Salle 07'},
      ],
      'Samedi': [],
    };

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mon emploi du temps'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: jours.length,
        itemBuilder: (context, index) {
          final jour = jours[index];
          final cours = emploiDuTemps[jour] ?? [];

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 8, top: 8),
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  jour,
                  style: theme.textTheme.titleLarge!.copyWith(
                    color: AppColors.white,
                    fontSize: 14,
                  ),
                ),
              ),
              if (cours.isEmpty)
                Padding(
                  padding: const EdgeInsets.only(left: 16, bottom: 8),
                  child: Text(
                    'Pas de cours',
                    style: theme.textTheme.bodyMedium!.copyWith(
                      color: Colors.grey,
                    ),
                  ),
                )
              else
                ...cours.map((cours) => Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(12),
                        leading: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.schedule,
                            color: AppColors.primary,
                            size: 20,
                          ),
                        ),
                        title: Text(
                          cours['matiere'],
                          style: theme.textTheme.titleLarge!
                              .copyWith(fontSize: 15),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(cours['heure'],
                                style: theme.textTheme.bodyMedium),
                            Text(
                              '${cours['classe']} - ${cours['salle']}',
                              style: theme.textTheme.bodyMedium!.copyWith(
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )),
              const SizedBox(height: 8),
            ],
          );
        },
      ),
    );
  }
}