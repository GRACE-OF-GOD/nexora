 import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexora/core/theme.dart';
import 'package:nexora/models/classe_model.dart';

class ClassesScreen extends ConsumerStatefulWidget {
  const ClassesScreen({super.key});

  @override
  ConsumerState<ClassesScreen> createState() => _ClassesScreenState();
}

class _ClassesScreenState extends ConsumerState<ClassesScreen> {
  final _searchController = TextEditingController();
  String _searchQuery = '';
  String _filtreNiveau = 'Tous';

  final List<ClasseModel> _classes = [
    ClasseModel(id: '1', libelle: 'CP1', niveau: 'Primaire', anneeScolaire: '2024-2025'),
    ClasseModel(id: '2', libelle: 'CM2', niveau: 'Primaire', anneeScolaire: '2024-2025'),
    ClasseModel(id: '3', libelle: '6eme A', niveau: 'Secondaire', anneeScolaire: '2024-2025'),
    ClasseModel(id: '4', libelle: '3eme B', niveau: 'Secondaire', anneeScolaire: '2024-2025'),
    ClasseModel(id: '5', libelle: 'Terminale A', niveau: 'Secondaire', anneeScolaire: '2024-2025'),
    ClasseModel(id: '6', libelle: 'Licence 1', niveau: 'Universitaire', anneeScolaire: '2024-2025'),
    ClasseModel(id: '7', libelle: 'Master 2', niveau: 'Universitaire', anneeScolaire: '2024-2025'),
  ];

  final List<String> _niveaux = ['Tous', 'Primaire', 'Secondaire', 'Universitaire'];

  List<ClasseModel> get _filteredClasses {
    return _classes.where((c) {
      final matchSearch = _searchQuery.isEmpty ||
          c.libelle.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          c.niveau.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchNiveau = _filtreNiveau == 'Tous' || c.niveau == _filtreNiveau;
      return matchSearch && matchNiveau;
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showAddClasseDialog() {
    showDialog(
      context: context,
      builder: (context) => _AddClasseDialog(
        onSave: (classe) {
          setState(() => _classes.add(classe));
        },
      ),
    );
  }

  void _showDeleteConfirmation(ClasseModel classe) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmer la suppression'),
        content: Text('Voulez-vous supprimer la classe ${classe.libelle} ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() => _classes.removeWhere((c) => c.id == classe.id));
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Classe ${classe.libelle} supprimee avec succes')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );
  }

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
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestion des Classes'),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddClasseDialog,
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
                hintText: 'Rechercher une classe...',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          SizedBox(
            height: 40,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _niveaux.length,
              itemBuilder: (context, index) {
                final niveau = _niveaux[index];
                final isSelected = _filtreNiveau == niveau;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(niveau),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() => _filtreNiveau = niveau);
                    },
                    selectedColor: AppColors.primary,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : null,
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Text(
                  '${_filteredClasses.length} classe(s) trouvee(s)',
                  style: theme.textTheme.bodyMedium,
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: _filteredClasses.isEmpty
                ? Center(
                    child: Text(
                      'Aucune classe trouvee',
                      style: theme.textTheme.bodyLarge,
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _filteredClasses.length,
                    itemBuilder: (context, index) {
                      final classe = _filteredClasses[index];
                      final color = _getNiveauColor(classe.niveau);
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: color,
                            child: Text(
                              classe.niveau[0].toUpperCase(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          title: Text(classe.libelle, style: theme.textTheme.titleLarge),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Niveau: ${classe.niveau}'),
                              Text('Annee scolaire: ${classe.anneeScolaire}'),
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
                                onPressed: () => _showDeleteConfirmation(classe),
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

class _AddClasseDialog extends StatefulWidget {
  final Function(ClasseModel) onSave;

  const _AddClasseDialog({required this.onSave});

  @override
  State<_AddClasseDialog> createState() => _AddClasseDialogState();
}

class _AddClasseDialogState extends State<_AddClasseDialog> {
  final _formKey = GlobalKey<FormState>();
  final _libelleController = TextEditingController();
  final _anneeScolaireController = TextEditingController();
  String _categorieNiveau = 'Primaire';
  String _niveau = 'CP1';

  final Map<String, List<String>> _niveauxParCategorie = {
    'Primaire': ['CP1', 'CP2', 'CE1', 'CE2', 'CM1', 'CM2'],
    'Secondaire': ['6eme', '5eme', '4eme', '3eme', '2nde', '1ere', 'Terminale'],
    'Universitaire': ['Licence 1', 'Licence 2', 'Licence 3', 'Master 1', 'Master 2', 'Doctorat'],
  };

  @override
  void dispose() {
    _libelleController.dispose();
    _anneeScolaireController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final niveauxDisponibles = _niveauxParCategorie[_categorieNiveau]!;

    return AlertDialog(
      title: const Text('Ajouter une classe'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _libelleController,
                decoration: const InputDecoration(
                  labelText: 'Libelle',
                  hintText: 'ex: 6eme A, Licence 1 Info',
                ),
                validator: (v) => v!.isEmpty ? 'Champ obligatoire' : null,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _categorieNiveau,
                decoration: const InputDecoration(labelText: 'Categorie'),
                items: const [
                  DropdownMenuItem(value: 'Primaire', child: Text('Primaire')),
                  DropdownMenuItem(value: 'Secondaire', child: Text('Secondaire')),
                  DropdownMenuItem(value: 'Universitaire', child: Text('Universitaire')),
                ],
                onChanged: (v) {
                  setState(() {
                    _categorieNiveau = v!;
                    _niveau = _niveauxParCategorie[v]!.first;
                  });
                },
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _niveau,
                decoration: const InputDecoration(labelText: 'Niveau'),
                items: niveauxDisponibles.map((n) {
                  return DropdownMenuItem(value: n, child: Text(n));
                }).toList(),
                onChanged: (v) => setState(() => _niveau = v!),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _anneeScolaireController,
                decoration: const InputDecoration(
                  labelText: 'Annee scolaire',
                  hintText: 'ex: 2024-2025',
                ),
                validator: (v) => v!.isEmpty ? 'Champ obligatoire' : null,
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
              final newClasse = ClasseModel(
                id: DateTime.now().millisecondsSinceEpoch.toString(),
                libelle: _libelleController.text,
                niveau: _categorieNiveau,
                anneeScolaire: _anneeScolaireController.text,
              );
              widget.onSave(newClasse);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Classe ajoutee avec succes')),
              );
            }
          },
          child: const Text('Enregistrer'),
        ),
      ],
    );
  }
}