import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexora/core/theme.dart';

class EmploiTempsStudentScreen extends ConsumerWidget {
  const EmploiTempsStudentScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    final List<String> jours = [
      'Lundi', 'Mardi', 'Mercredi', 'Jeudi', 'Vendredi', 'Samedi'
    ];

    final Map<String, List<Map<String, dynamic>>> emploiDuTemps = {
      'Lundi': [
        {'heure': '08:00 - 10:00', 'matiere': 'Mathematiques', 'enseignant': 'M. Agbeko', 'salle': 'Salle 12'},
        {'heure': '10:00 - 12:00', 'matiere': 'Francais', 'enseignant': 'Mme Koffi', 'salle': 'Salle 08'},
        {'heure': '14:00 - 16:00', 'matiere': 'Histoire', 'enseignant': 'M. Mensah', 'salle': 'Salle 05'},
      ],
      'Mardi': [
        {'heure': '08:00 - 10:00', 'matiere': 'Physique', 'enseignant': 'M. Amevor', 'salle': 'Salle 10'},
        {'heure': '10:00 - 12:00', 'matiere': 'Anglais', 'enseignant': 'Mme Doe', 'salle': 'Salle 03'},
      ],
      'Mercredi': [
        {'heure': '08:00 - 10:00', 'matiere': 'Mathematiques', 'enseignant': 'M. Agbeko', 'salle': 'Salle 12'},
        {'heure': '10:00 - 12:00', 'matiere': 'SVT', 'enseignant': 'Mme Dede', 'salle': 'Salle 06'},
      ],
      'Jeudi': [
        {'heure': '08:00 - 10:00', 'matiere': 'Francais', 'enseignant': 'Mme Koffi', 'salle': 'Salle 08'},
        {'heure': '14:00 - 16:00', 'matiere': 'Physique', 'enseignant': 'M. Amevor', 'salle': 'Salle 10'},
      ],
      'Vendredi': [
        {'heure': '10:00 - 12:00', 'matiere': 'Anglais', 'enseignant': 'Mme Doe', 'salle': 'Salle 03'},
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
                ...cours.map((c) => Card(
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
                          c['matiere'],
                          style: theme.textTheme.titleLarge!
                              .copyWith(fontSize: 15),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(c['heure'],
                                style: theme.textTheme.bodyMedium),
                            Text(
                              '${c['enseignant']} - ${c['salle']}',
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