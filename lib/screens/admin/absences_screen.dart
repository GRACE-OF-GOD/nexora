import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexora/core/theme.dart';
import 'package:nexora/models/absence_model.dart';
import 'package:nexora/models/eleve_model.dart';
import 'package:nexora/models/classe_model.dart';

class AbsencesScreen extends ConsumerStatefulWidget {
  const AbsencesScreen({super.key});

  @override
  ConsumerState<AbsencesScreen> createState() => _AbsencesScreenState();
}

class _AbsencesScreenState extends ConsumerState<AbsencesScreen> {
  ClasseModel? _selectedClasse;
  String _dateSelectionnee = DateTime.now().toString().substring(0, 10);

  final List<ClasseModel> _classes = [
    ClasseModel(id: '1', libelle: 'CP1', niveau: 'Primaire', anneeScolaire: '2024-2025'),
    ClasseModel(id: '2', libelle: 'CM2', niveau: 'Primaire', anneeScolaire: '2024-2025'),
    ClasseModel(id: '3', libelle: '6eme A', niveau: 'Secondaire', anneeScolaire: '2024-2025'),
    ClasseModel(id: '4', libelle: '5eme B', niveau: 'Secondaire', anneeScolaire: '2024-2025'),
    ClasseModel(id: '5', libelle: '3eme A', niveau: 'Secondaire', anneeScolaire: '2024-2025'),
    ClasseModel(id: '6', libelle: 'Terminale A', niveau: 'Secondaire', anneeScolaire: '2024-2025'),
    ClasseModel(id: '7', libelle: 'Licence 1', niveau: 'Universitaire', anneeScolaire: '2024-2025'),
    ClasseModel(id: '8', libelle: 'Master 1', niveau: 'Universitaire', anneeScolaire: '2024-2025'),
  ];

  final List<EleveModel> _elevesClasse = [
    EleveModel(id: '1', matricule: 'NEX001', nom: 'Koffi', prenom: 'Kossi', sexe: 'M', dateNaissance: '2005-03-15', telephone: '90000001', adresse: 'Lome', idClasse: '1', libelleClasse: '6eme A'),
    EleveModel(id: '2', matricule: 'NEX002', nom: 'Ama', prenom: 'Akosua', sexe: 'F', dateNaissance: '2006-07-20', telephone: '90000002', adresse: 'Lome', idClasse: '1', libelleClasse: '6eme A'),
    EleveModel(id: '3', matricule: 'NEX003', nom: 'Agbo', prenom: 'Kofi', sexe: 'M', dateNaissance: '2005-11-10', telephone: '90000003', adresse: 'Lome', idClasse: '1', libelleClasse: '6eme A'),
    EleveModel(id: '4', matricule: 'NEX004', nom: 'Mensah', prenom: 'Afi', sexe: 'F', dateNaissance: '2006-01-05', telephone: '90000004', adresse: 'Lome', idClasse: '1', libelleClasse: '6eme A'),
  ];

  final Map<String, bool> _presences = {};
  final Map<String, TextEditingController> _motifControllers = {};
  final List<AbsenceModel> _absencesEnregistrees = [];

  Color _getNiveauColor(String niveau) {
    switch (niveau) {
      case 'Primaire':
        return const Color(0xFF388E3C);
      case 'Secondaire':
        return AppColors.primary;
      case 'Universitaire':
        return const Color(0xFF7B1FA2);
      default:
        return AppColors.primary;
    }
  }

  @override
  void initState() {
    super.initState();
    for (final eleve in _elevesClasse) {
      _presences[eleve.id] = true;
      _motifControllers[eleve.id] = TextEditingController();
    }
  }

  @override
  void dispose() {
    for (final controller in _motifControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  int get _nombreAbsents =>
      _presences.values.where((present) => !present).length;

  int get _nombrePresents =>
      _presences.values.where((present) => present).length;

  void _enregistrerAbsences() {
    if (_selectedClasse == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez selectionner une classe')),
      );
      return;
    }

    setState(() {
      _absencesEnregistrees.clear();
      for (final eleve in _elevesClasse) {
        if (_presences[eleve.id] == false) {
          _absencesEnregistrees.add(AbsenceModel(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            dateAbsence: _dateSelectionnee,
            motif: _motifControllers[eleve.id]?.text ?? '',
            justifiee: _motifControllers[eleve.id]?.text.isNotEmpty ?? false,
            idEleve: eleve.id,
            nomEleve: eleve.nom,
            prenomEleve: eleve.prenom,
          ));
        }
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '$_nombreAbsents absence(s) enregistree(s) — Les parents seront notifies',
        ),
        backgroundColor: const Color(0xFF388E3C),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestion des Absences'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Selections', style: theme.textTheme.titleLarge),
            const SizedBox(height: 16),
            DropdownButtonFormField<ClasseModel>(
              value: _selectedClasse,
              decoration: const InputDecoration(
                labelText: 'Classe',
                prefixIcon: Icon(Icons.class_outlined),
              ),
              items: _classes.map((c) {
                return DropdownMenuItem(
                  value: c,
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: _getNiveauColor(c.niveau),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          c.niveau[0],
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(c.libelle),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (v) => setState(() => _selectedClasse = v),
            ),
            const SizedBox(height: 12),
            InkWell(
              onTap: () async {
                final date = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2024),
                  lastDate: DateTime.now(),
                );
                if (date != null) {
                  setState(() {
                    _dateSelectionnee = date.toString().substring(0, 10);
                  });
                }
              },
              child: InputDecorator(
                decoration: const InputDecoration(
                  labelText: 'Date',
                  prefixIcon: Icon(Icons.calendar_today_outlined),
                ),
                child: Text(_dateSelectionnee),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: Card(
                    color: const Color(0xFF388E3C),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        children: [
                          Text(
                            '$_nombrePresents',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Text(
                            'Presents',
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Card(
                    color: AppColors.error,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        children: [
                          Text(
                            '$_nombreAbsents',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Text(
                            'Absents',
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text('Liste des eleves', style: theme.textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(
              'Cochez les absents',
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _elevesClasse.length,
              itemBuilder: (context, index) {
                final eleve = _elevesClasse[index];
                final isPresent = _presences[eleve.id] ?? true;

                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  color: isPresent ? null : AppColors.error.withOpacity(0.05),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: isPresent
                                  ? const Color(0xFF388E3C)
                                  : AppColors.error,
                              radius: 20,
                              child: Text(
                                eleve.prenom[0].toUpperCase(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    eleve.fullName,
                                    style: theme.textTheme.titleLarge,
                                  ),
                                  Text(
                                    eleve.matricule,
                                    style: theme.textTheme.bodyMedium,
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              children: [
                                Text(
                                  isPresent ? 'Present' : 'Absent',
                                  style: TextStyle(
                                    color: isPresent
                                        ? const Color(0xFF388E3C)
                                        : AppColors.error,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Switch(
                                  value: isPresent,
                                  activeColor: const Color(0xFF388E3C),
                                  inactiveThumbColor: AppColors.error,
                                  onChanged: (value) {
                                    setState(() => _presences[eleve.id] = value);
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                        if (!isPresent) ...[
                          const SizedBox(height: 8),
                          TextField(
                            controller: _motifControllers[eleve.id],
                            decoration: const InputDecoration(
                              hintText: 'Motif de l absence (optionnel)',
                              prefixIcon: Icon(Icons.note_outlined),
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _enregistrerAbsences,
              child: const Text('Enregistrer et notifier les parents'),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}