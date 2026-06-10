import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexora/core/theme.dart';
import 'package:nexora/models/matiere_model.dart';

class MatieresScreen extends ConsumerStatefulWidget {
  const MatieresScreen({super.key});

  @override
  ConsumerState<MatieresScreen> createState() => _MatieresScreenState();
}

class _MatieresScreenState extends ConsumerState<MatieresScreen> {
  final _searchController = TextEditingController();
  String _searchQuery = '';

  final List<MatiereModel> _matieres = [
    MatiereModel(id: '1', libelle: 'Mathematiques', coefficient: 4),
    MatiereModel(id: '2', libelle: 'Francais', coefficient: 4),
    MatiereModel(id: '3', libelle: 'Anglais', coefficient: 3),
    MatiereModel(id: '4', libelle: 'Sciences de la Vie et de la Terre', coefficient: 3),
    MatiereModel(id: '5', libelle: 'Histoire-Geographie', coefficient: 2),
    MatiereModel(id: '6', libelle: 'Physique-Chimie', coefficient: 3),
    MatiereModel(id: '7', libelle: 'Education Physique et Sportive', coefficient: 2),
    MatiereModel(id: '8', libelle: 'Informatique', coefficient: 2),
  ];

  List<MatiereModel> get _filteredMatieres {
    if (_searchQuery.isEmpty) return _matieres;
    return _matieres.where((m) =>
      m.libelle.toLowerCase().contains(_searchQuery.toLowerCase())
    ).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showAddMatiereDialog() {
    showDialog(
      context: context,
      builder: (context) => _AddMatiereDialog(
        onSave: (matiere) {
          setState(() => _matieres.add(matiere));
        },
      ),
    );
  }

  void _showDeleteConfirmation(MatiereModel matiere) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmer la suppression'),
        content: Text('Voulez-vous supprimer la matiere ${matiere.libelle} ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() => _matieres.removeWhere((m) => m.id == matiere.id));
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${matiere.libelle} supprimee avec succes')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );
  }

  Color _getCoefficientColor(int coefficient) {
    if (coefficient >= 4) return AppColors.primary;
    if (coefficient == 3) return const Color(0xFF388E3C);
    return AppColors.secondary;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestion des Matieres'),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddMatiereDialog,
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
                hintText: 'Rechercher une matiere...',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Text(
                  '${_filteredMatieres.length} matiere(s) trouvee(s)',
                  style: theme.textTheme.bodyMedium,
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: _filteredMatieres.isEmpty
                ? Center(
                    child: Text(
                      'Aucune matiere trouvee',
                      style: theme.textTheme.bodyLarge,
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _filteredMatieres.length,
                    itemBuilder: (context, index) {
                      final matiere = _filteredMatieres[index];
                      final color = _getCoefficientColor(matiere.coefficient);
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: color,
                            child: Text(
                              'C${matiere.coefficient}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          title: Text(matiere.libelle, style: theme.textTheme.titleLarge),
                          subtitle: Text('Coefficient : ${matiere.coefficient}'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit_outlined, color: AppColors.primary),
                                onPressed: () {},
                              ),
                              IconButton(
                                icon: Icon(Icons.delete_outlined, color: AppColors.error),
                                onPressed: () => _showDeleteConfirmation(matiere),
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

class _AddMatiereDialog extends StatefulWidget {
  final Function(MatiereModel) onSave;

  const _AddMatiereDialog({required this.onSave});

  @override
  State<_AddMatiereDialog> createState() => _AddMatiereDialogState();
}

class _AddMatiereDialogState extends State<_AddMatiereDialog> {
  final _formKey = GlobalKey<FormState>();
  final _libelleController = TextEditingController();
  int _coefficient = 1;

  @override
  void dispose() {
    _libelleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Ajouter une matiere'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _libelleController,
                decoration: const InputDecoration(
                  labelText: 'Nom de la matiere',
                  hintText: 'ex: Mathematiques',
                ),
                validator: (v) => v!.isEmpty ? 'Champ obligatoire' : null,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Text('Coefficient :'),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Slider(
                      value: _coefficient.toDouble(),
                      min: 1,
                      max: 6,
                      divisions: 5,
                      label: _coefficient.toString(),
                      activeColor: AppColors.primary,
                      onChanged: (v) => setState(() => _coefficient = v.toInt()),
                    ),
                  ),
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        '$_coefficient',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
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
              final newMatiere = MatiereModel(
                id: DateTime.now().millisecondsSinceEpoch.toString(),
                libelle: _libelleController.text,
                coefficient: _coefficient,
              );
              widget.onSave(newMatiere);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Matiere ajoutee avec succes')),
              );
            }
          },
          child: const Text('Enregistrer'),
        ),
      ],
    );
  }
}