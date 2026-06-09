import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexora/core/theme.dart';
import 'package:nexora/models/enseignant_model.dart';

class EnseignantsScreen extends ConsumerStatefulWidget {
  const EnseignantsScreen({super.key});

  @override
  ConsumerState<EnseignantsScreen> createState() => _EnseignantsScreenState();
}

class _EnseignantsScreenState extends ConsumerState<EnseignantsScreen> {
  final _searchController = TextEditingController();
  String _searchQuery = '';

  final List<EnseignantModel> _enseignants = [
    EnseignantModel(id: '1', nom: 'Koffi', prenom: 'Mawuli', telephone: '90000010', email: 'mawuli@nexora.com', specialite: 'Mathematiques'),
    EnseignantModel(id: '2', nom: 'Mensah', prenom: 'Afi', telephone: '90000011', email: 'afi@nexora.com', specialite: 'Francais'),
    EnseignantModel(id: '3', nom: 'Agbeko', prenom: 'Kodjo', telephone: '90000012', email: 'kodjo@nexora.com', specialite: 'Sciences'),
  ];

  List<EnseignantModel> get _filteredEnseignants {
    if (_searchQuery.isEmpty) return _enseignants;
    return _enseignants.where((e) =>
      e.fullName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
      e.specialite.toLowerCase().contains(_searchQuery.toLowerCase()) ||
      e.email.toLowerCase().contains(_searchQuery.toLowerCase())
    ).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showAddEnseignantDialog() {
    showDialog(
      context: context,
      builder: (context) => _AddEnseignantDialog(
        onSave: (enseignant) {
          setState(() => _enseignants.add(enseignant));
        },
      ),
    );
  }

  void _showDeleteConfirmation(EnseignantModel enseignant) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmer la suppression'),
        content: Text('Voulez-vous supprimer ${enseignant.fullName} ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() => _enseignants.removeWhere((e) => e.id == enseignant.id));
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${enseignant.fullName} supprime avec succes')),
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
        title: const Text('Gestion des Enseignants'),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddEnseignantDialog,
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
                hintText: 'Rechercher un enseignant...',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Text(
                  '${_filteredEnseignants.length} enseignant(s) trouve(s)',
                  style: theme.textTheme.bodyMedium,
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: _filteredEnseignants.isEmpty
                ? Center(
                    child: Text(
                      'Aucun enseignant trouve',
                      style: theme.textTheme.bodyLarge,
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _filteredEnseignants.length,
                    itemBuilder: (context, index) {
                      final enseignant = _filteredEnseignants[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: AppColors.secondary,
                            child: Text(
                              enseignant.prenom[0].toUpperCase(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          title: Text(enseignant.fullName, style: theme.textTheme.titleLarge),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Specialite: ${enseignant.specialite}'),
                              Text('Email: ${enseignant.email}'),
                              Text('Telephone: ${enseignant.telephone}'),
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
                                onPressed: () => _showDeleteConfirmation(enseignant),
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

class _AddEnseignantDialog extends StatefulWidget {
  final Function(EnseignantModel) onSave;

  const _AddEnseignantDialog({required this.onSave});

  @override
  State<_AddEnseignantDialog> createState() => _AddEnseignantDialogState();
}

class _AddEnseignantDialogState extends State<_AddEnseignantDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nomController = TextEditingController();
  final _prenomController = TextEditingController();
  final _telephoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _specialiteController = TextEditingController();

  @override
  void dispose() {
    _nomController.dispose();
    _prenomController.dispose();
    _telephoneController.dispose();
    _emailController.dispose();
    _specialiteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Ajouter un enseignant'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
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
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
                validator: (v) {
                  if (v!.isEmpty) return 'Champ obligatoire';
                  if (!v.contains('@')) return 'Email invalide';
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _telephoneController,
                decoration: const InputDecoration(labelText: 'Telephone'),
                keyboardType: TextInputType.phone,
                validator: (v) => v!.isEmpty ? 'Champ obligatoire' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _specialiteController,
                decoration: const InputDecoration(labelText: 'Specialite'),
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
              final newEnseignant = EnseignantModel(
                id: DateTime.now().millisecondsSinceEpoch.toString(),
                nom: _nomController.text,
                prenom: _prenomController.text,
                telephone: _telephoneController.text,
                email: _emailController.text,
                specialite: _specialiteController.text,
              );
              widget.onSave(newEnseignant);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Enseignant ajoute avec succes')),
              );
            }
          },
          child: const Text('Enregistrer'),
        ),
      ],
    );
  }
}