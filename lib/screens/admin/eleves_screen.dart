 import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexora/core/theme.dart';
import 'package:nexora/models/eleve_model.dart';
import 'package:nexora/models/classe_model.dart';

class ElevesScreen extends ConsumerStatefulWidget {
  const ElevesScreen({super.key});

  @override
  ConsumerState<ElevesScreen> createState() => _ElevesScreenState();
}

class _ElevesScreenState extends ConsumerState<ElevesScreen> {
  final _searchController = TextEditingController();
  String _searchQuery = '';

  final List<ClasseModel> _classes = [
    ClasseModel(id: '1', libelle: '6eme A', niveau: '6eme', anneeScolaire: '2024-2025'),
    ClasseModel(id: '2', libelle: '5eme B', niveau: '5eme', anneeScolaire: '2024-2025'),
    ClasseModel(id: '3', libelle: '4eme A', niveau: '4eme', anneeScolaire: '2024-2025'),
    ClasseModel(id: '4', libelle: '3eme B', niveau: '3eme', anneeScolaire: '2024-2025'),
  ];

  final List<EleveModel> _eleves = [
    EleveModel(id: '1', matricule: 'NEX001', nom: 'Koffi', prenom: 'Kossi', sexe: 'M', dateNaissance: '2005-03-15', telephone: '90000001', adresse: 'Lome', idClasse: '1', libelleClasse: '6eme A'),
    EleveModel(id: '2', matricule: 'NEX002', nom: 'Ama', prenom: 'Akosua', sexe: 'F', dateNaissance: '2006-07-20', telephone: '90000002', adresse: 'Lome', idClasse: '1', libelleClasse: '6eme A'),
    EleveModel(id: '3', matricule: 'NEX003', nom: 'Agbo', prenom: 'Kofi', sexe: 'M', dateNaissance: '2005-11-10', telephone: '90000003', adresse: 'Lome', idClasse: '2', libelleClasse: '5eme B'),
  ];

  List<EleveModel> get _filteredEleves {
    if (_searchQuery.isEmpty) return _eleves;
    return _eleves.where((e) =>
      e.fullName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
      e.matricule.toLowerCase().contains(_searchQuery.toLowerCase()) ||
      e.libelleClasse.toLowerCase().contains(_searchQuery.toLowerCase())
    ).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showAddEleveDialog() {
    showDialog(
      context: context,
      builder: (context) => _AddEleveDialog(
        classes: _classes,
        onSave: (eleve) {
          setState(() => _eleves.add(eleve));
        },
      ),
    );
  }

  void _showDeleteConfirmation(EleveModel eleve) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmer la suppression'),
        content: Text('Voulez-vous supprimer ${eleve.fullName} ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() => _eleves.removeWhere((e) => e.id == eleve.id));
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${eleve.fullName} supprime avec succes')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestion des Eleves'),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddEleveDialog,
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Ajouter', style: TextStyle(color: Colors.white)),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              onChanged: (value) => setState(() => _searchQuery = value),
              decoration: const InputDecoration(
                hintText: 'Rechercher un eleve...',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Text(
                  '${_filteredEleves.length} eleve(s) trouve(s)',
                  style: theme.textTheme.bodyMedium,
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: _filteredEleves.isEmpty
                ? Center(
                    child: Text(
                      'Aucun eleve trouve',
                      style: theme.textTheme.bodyLarge,
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _filteredEleves.length,
                    itemBuilder: (context, index) {
                      final eleve = _filteredEleves[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: AppColors.primary,
                            child: Text(
                              eleve.prenom[0].toUpperCase(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          title: Text(eleve.fullName, style: theme.textTheme.titleLarge),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Matricule: ${eleve.matricule}'),
                              Text('Classe: ${eleve.libelleClasse}'),
                              Text('Telephone: ${eleve.telephone}'),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit_outlined, color: AppColors.primary),
                                onPressed: () {},
                              ),
                              IconButton(
                                icon: Icon(Icons.delete_outlined, color: AppColors.error),
                                onPressed: () => _showDeleteConfirmation(eleve),
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
}

class _AddEleveDialog extends StatefulWidget {
  final List<ClasseModel> classes;
  final Function(EleveModel) onSave;

  const _AddEleveDialog({required this.classes, required this.onSave});

  @override
  State<_AddEleveDialog> createState() => _AddEleveDialogState();
}

class _AddEleveDialogState extends State<_AddEleveDialog> {
  final _formKey = GlobalKey<FormState>();
  final _matriculeController = TextEditingController();
  final _nomController = TextEditingController();
  final _prenomController = TextEditingController();
  final _telephoneController = TextEditingController();
  final _adresseController = TextEditingController();
  final _dateNaissanceController = TextEditingController();
  String _sexe = 'M';
  ClasseModel? _selectedClasse;

  @override
  void dispose() {
    _matriculeController.dispose();
    _nomController.dispose();
    _prenomController.dispose();
    _telephoneController.dispose();
    _adresseController.dispose();
    _dateNaissanceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Ajouter un eleve'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _matriculeController,
                decoration: const InputDecoration(labelText: 'Matricule'),
                validator: (v) => v!.isEmpty ? 'Champ obligatoire' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _nomController,
                decoration: const InputDecoration(labelText: 'Nom'),
                validator: (v) => v!.isEmpty ? 'Champ obligatoire' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _prenomController,
                decoration: const InputDecoration(labelText: 'Prenom'),
                validator: (v) => v!.isEmpty ? 'Champ obligatoire' : null,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _sexe,
                decoration: const InputDecoration(labelText: 'Sexe'),
                items: const [
                  DropdownMenuItem(value: 'M', child: Text('Masculin')),
                  DropdownMenuItem(value: 'F', child: Text('Feminin')),
                ],
                onChanged: (v) => setState(() => _sexe = v!),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _dateNaissanceController,
                decoration: const InputDecoration(
                  labelText: 'Date de naissance',
                  hintText: 'JJ/MM/AAAA',
                  prefixIcon: Icon(Icons.calendar_today_outlined),
                ),
                readOnly: true,
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: DateTime(2005),
                    firstDate: DateTime(1990),
                    lastDate: DateTime.now(),
                  );
                  if (date != null) {
                    _dateNaissanceController.text =
                        '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
                  }
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _telephoneController,
                decoration: const InputDecoration(labelText: 'Telephone'),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _adresseController,
                decoration: const InputDecoration(labelText: 'Adresse'),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<ClasseModel>(
                value: _selectedClasse,
                decoration: const InputDecoration(labelText: 'Classe'),
                items: widget.classes.map((classe) {
                  return DropdownMenuItem(
                    value: classe,
                    child: Text(classe.libelle),
                  );
                }).toList(),
                onChanged: (v) => setState(() => _selectedClasse = v),
                validator: (v) => v == null ? 'Veuillez choisir une classe' : null,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Annuler'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              final newEleve = EleveModel(
                id: DateTime.now().millisecondsSinceEpoch.toString(),
                matricule: _matriculeController.text,
                nom: _nomController.text,
                prenom: _prenomController.text,
                sexe: _sexe,
                dateNaissance: _dateNaissanceController.text,
                telephone: _telephoneController.text,
                adresse: _adresseController.text,
                idClasse: _selectedClasse!.id,
                libelleClasse: _selectedClasse!.libelle,
              );
              widget.onSave(newEleve);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Eleve ajoute avec succes')),
              );
            }
          },
          child: const Text('Enregistrer'),
        ),
      ],
    );
  }
}