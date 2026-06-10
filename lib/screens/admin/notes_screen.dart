 import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexora/core/theme.dart';
import 'package:nexora/models/note_model.dart';
import 'package:nexora/models/eleve_model.dart';
import 'package:nexora/models/classe_model.dart';
import 'package:nexora/models/matiere_model.dart';

class NotesScreen extends ConsumerStatefulWidget {
  const NotesScreen({super.key});

  @override
  ConsumerState<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends ConsumerState<NotesScreen> {
  ClasseModel? _selectedClasse;
  MatiereModel? _selectedMatiere;
  String _typeEvaluation = 'Devoir';

  final List<ClasseModel> _classes = [
    ClasseModel(id: '1', libelle: 'CP1', niveau: 'Primaire', anneeScolaire: '2024-2025'),
    ClasseModel(id: '2', libelle: 'CM2', niveau: 'Primaire', anneeScolaire: '2024-2025'),
    ClasseModel(id: '3', libelle: '6eme A', niveau: 'Secondaire', anneeScolaire: '2024-2025'),
    ClasseModel(id: '4', libelle: '5eme B', niveau: 'Secondaire', anneeScolaire: '2024-2025'),
    ClasseModel(id: '5', libelle: '3eme A', niveau: 'Secondaire', anneeScolaire: '2024-2025'),
    ClasseModel(id: '6', libelle: 'Terminale A', niveau: 'Secondaire', anneeScolaire: '2024-2025'),
    ClasseModel(id: '7', libelle: 'Licence 1', niveau: 'Universitaire', anneeScolaire: '2024-2025'),
    ClasseModel(id: '8', libelle: 'Licence 2', niveau: 'Universitaire', anneeScolaire: '2024-2025'),
    ClasseModel(id: '9', libelle: 'Master 1', niveau: 'Universitaire', anneeScolaire: '2024-2025'),
    ClasseModel(id: '10', libelle: 'Master 2', niveau: 'Universitaire', anneeScolaire: '2024-2025'),
  ];

  final List<MatiereModel> _matieres = [
    MatiereModel(id: '1', libelle: 'Mathematiques', coefficient: 4),
    MatiereModel(id: '2', libelle: 'Francais', coefficient: 4),
    MatiereModel(id: '3', libelle: 'Anglais', coefficient: 3),
    MatiereModel(id: '4', libelle: 'Sciences', coefficient: 3),
    MatiereModel(id: '5', libelle: 'Histoire-Geographie', coefficient: 2),
    MatiereModel(id: '6', libelle: 'Physique-Chimie', coefficient: 3),
    MatiereModel(id: '7', libelle: 'Informatique', coefficient: 2),
  ];

  final List<EleveModel> _elevesClasse = [
    EleveModel(id: '1', matricule: 'NEX001', nom: 'Koffi', prenom: 'Kossi', sexe: 'M', dateNaissance: '2005-03-15', telephone: '90000001', adresse: 'Lome', idClasse: '1', libelleClasse: '6eme A'),
    EleveModel(id: '2', matricule: 'NEX002', nom: 'Ama', prenom: 'Akosua', sexe: 'F', dateNaissance: '2006-07-20', telephone: '90000002', adresse: 'Lome', idClasse: '1', libelleClasse: '6eme A'),
    EleveModel(id: '3', matricule: 'NEX003', nom: 'Agbo', prenom: 'Kofi', sexe: 'M', dateNaissance: '2005-11-10', telephone: '90000003', adresse: 'Lome', idClasse: '1', libelleClasse: '6eme A'),
    EleveModel(id: '4', matricule: 'NEX004', nom: 'Mensah', prenom: 'Afi', sexe: 'F', dateNaissance: '2006-01-05', telephone: '90000004', adresse: 'Lome', idClasse: '1', libelleClasse: '6eme A'),
  ];

  final Map<String, TextEditingController> _noteControllers = {};
  final List<NoteModel> _notesSaisies = [];

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
      _noteControllers[eleve.id] = TextEditingController();
    }
  }

  @override
  void dispose() {
    for (final controller in _noteControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  double _calculerMoyenne() {
    final notes = _noteControllers.values
        .map((c) => double.tryParse(c.text) ?? 0)
        .where((n) => n > 0)
        .toList();
    if (notes.isEmpty) return 0;
    return notes.reduce((a, b) => a + b) / notes.length;
  }

  Color _getNoteColor(double note) {
    if (note >= 14) return const Color(0xFF388E3C);
    if (note >= 10) return AppColors.primary;
    if (note >= 7) return const Color(0xFFF57C00);
    return AppColors.error;
  }

  String _getMention(double note) {
    if (note >= 16) return 'Tres Bien';
    if (note >= 14) return 'Bien';
    if (note >= 12) return 'Assez Bien';
    if (note >= 10) return 'Passable';
    return 'Insuffisant';
  }

  void _enregistrerNotes() {
    if (_selectedClasse == null || _selectedMatiere == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez selectionner une classe et une matiere'),
        ),
      );
      return;
    }

    bool hasNotes = false;
    for (final eleve in _elevesClasse) {
      final valeur = double.tryParse(_noteControllers[eleve.id]?.text ?? '');
      if (valeur != null) {
        if (valeur < 0 || valeur > 20) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('La note de ${eleve.fullName} doit etre entre 0 et 20'),
            ),
          );
          return;
        }
        hasNotes = true;
      }
    }

    if (!hasNotes) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez saisir au moins une note')),
      );
      return;
    }

    setState(() {
      _notesSaisies.clear();
      for (final eleve in _elevesClasse) {
        final valeur = double.tryParse(_noteControllers[eleve.id]?.text ?? '');
        if (valeur != null) {
          _notesSaisies.add(NoteModel(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            valeur: valeur,
            typeEvaluation: _typeEvaluation,
            dateEvaluation: DateTime.now().toString().substring(0, 10),
            idEleve: eleve.id,
            nomEleve: eleve.nom,
            prenomEleve: eleve.prenom,
            idMatiere: _selectedMatiere!.id,
            libelleMatiere: _selectedMatiere!.libelle,
          ));
        }
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${_notesSaisies.length} note(s) enregistree(s) avec succes'),
        backgroundColor: const Color(0xFF388E3C),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final moyenne = _calculerMoyenne();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestion des Notes'),
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
            DropdownButtonFormField<MatiereModel>(
              value: _selectedMatiere,
              decoration: const InputDecoration(
                labelText: 'Matiere',
                prefixIcon: Icon(Icons.book_outlined),
              ),
              items: _matieres.map((m) {
                return DropdownMenuItem(
                  value: m,
                  child: Text('${m.libelle} (Coef. ${m.coefficient})'),
                );
              }).toList(),
              onChanged: (v) => setState(() => _selectedMatiere = v),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _typeEvaluation,
              decoration: const InputDecoration(
                labelText: 'Type evaluation',
                prefixIcon: Icon(Icons.assignment_outlined),
              ),
              items: const [
                DropdownMenuItem(value: 'Devoir', child: Text('Devoir')),
                DropdownMenuItem(value: 'Composition', child: Text('Composition')),
                DropdownMenuItem(value: 'Examen', child: Text('Examen')),
              ],
              onChanged: (v) => setState(() => _typeEvaluation = v!),
            ),
            const SizedBox(height: 24),
            Text('Saisie des notes', style: theme.textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(
              'Entrez les notes sur 20',
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _elevesClasse.length,
              itemBuilder: (context, index) {
                final eleve = _elevesClasse[index];
                final noteText = _noteControllers[eleve.id]?.text ?? '';
                final note = double.tryParse(noteText);
                final color = note != null ? _getNoteColor(note) : AppColors.primary;

                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: AppColors.primary,
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
                              Text(eleve.fullName, style: theme.textTheme.titleLarge),
                              Text(eleve.matricule, style: theme.textTheme.bodyMedium),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 80,
                          child: TextField(
                            controller: _noteControllers[eleve.id],
                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: color,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                            decoration: InputDecoration(
                              hintText: '/20',
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 8,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(color: color),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: BorderSide(color: color, width: 2),
                              ),
                            ),
                            onChanged: (v) => setState(() {}),
                          ),
                        ),
                        const SizedBox(width: 8),
                        if (note != null)
                          SizedBox(
                            width: 80,
                            child: Text(
                              _getMention(note),
                              style: TextStyle(
                                color: color,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 16),
            if (moyenne > 0)
              Card(
                color: AppColors.primary,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Moyenne de la classe',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '${moyenne.toStringAsFixed(2)} / 20',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _enregistrerNotes,
              child: const Text('Enregistrer les notes'),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}