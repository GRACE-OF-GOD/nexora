import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexora/core/theme.dart';
import 'package:nexora/models/paiement_model.dart';
import 'package:nexora/models/eleve_model.dart';

class PaiementsScreen extends ConsumerStatefulWidget {
  const PaiementsScreen({super.key});

  @override
  ConsumerState<PaiementsScreen> createState() => _PaiementsScreenState();
}

class _PaiementsScreenState extends ConsumerState<PaiementsScreen> {
  final _searchController = TextEditingController();
  String _searchQuery = '';
  String _filtreType = 'Tous';

  final List<PaiementModel> _paiements = [
    PaiementModel(id: '1', montant: 50000, datePaiement: '2024-10-01', typeFrais: 'Inscription', idEleve: '1', nomEleve: 'Koffi', prenomEleve: 'Kossi', libelleClasse: '6eme A'),
    PaiementModel(id: '2', montant: 25000, datePaiement: '2024-10-05', typeFrais: 'Scolarite', idEleve: '2', nomEleve: 'Ama', prenomEleve: 'Akosua', libelleClasse: '6eme A'),
    PaiementModel(id: '3', montant: 50000, datePaiement: '2024-10-08', typeFrais: 'Inscription', idEleve: '3', nomEleve: 'Agbo', prenomEleve: 'Kofi', libelleClasse: '5eme B'),
    PaiementModel(id: '4', montant: 25000, datePaiement: '2024-10-10', typeFrais: 'Scolarite', idEleve: '4', nomEleve: 'Mensah', prenomEleve: 'Afi', libelleClasse: '3eme A'),
    PaiementModel(id: '5', montant: 10000, datePaiement: '2024-10-12', typeFrais: 'Transport', idEleve: '1', nomEleve: 'Koffi', prenomEleve: 'Kossi', libelleClasse: '6eme A'),
  ];

  final List<EleveModel> _eleves = [
    EleveModel(id: '1', matricule: 'NEX001', nom: 'Koffi', prenom: 'Kossi', sexe: 'M', dateNaissance: '2005-03-15', telephone: '90000001', adresse: 'Lome', idClasse: '1', libelleClasse: '6eme A'),
    EleveModel(id: '2', matricule: 'NEX002', nom: 'Ama', prenom: 'Akosua', sexe: 'F', dateNaissance: '2006-07-20', telephone: '90000002', adresse: 'Lome', idClasse: '1', libelleClasse: '6eme A'),
    EleveModel(id: '3', matricule: 'NEX003', nom: 'Agbo', prenom: 'Kofi', sexe: 'M', dateNaissance: '2005-11-10', telephone: '90000003', adresse: 'Lome', idClasse: '2', libelleClasse: '5eme B'),
    EleveModel(id: '4', matricule: 'NEX004', nom: 'Mensah', prenom: 'Afi', sexe: 'F', dateNaissance: '2006-01-05', telephone: '90000004', adresse: 'Lome', idClasse: '3', libelleClasse: '3eme A'),
  ];

  final List<String> _typesFrais = ['Tous', 'Inscription', 'Scolarite', 'Transport', 'Cantine', 'Autre'];

  List<PaiementModel> get _filteredPaiements {
    return _paiements.where((p) {
      final matchSearch = _searchQuery.isEmpty ||
          p.fullName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          p.libelleClasse.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchType = _filtreType == 'Tous' || p.typeFrais == _filtreType;
      return matchSearch && matchType;
    }).toList();
  }

  double get _totalPaiements =>
      _filteredPaiements.fold(0, (sum, p) => sum + p.montant);

  Color _getTypeColor(String type) {
    switch (type) {
      case 'Inscription':
        return AppColors.primary;
      case 'Scolarite':
        return const Color(0xFF388E3C);
      case 'Transport':
        return const Color(0xFF7B1FA2);
      case 'Cantine':
        return const Color(0xFFF57C00);
      default:
        return AppColors.secondary;
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showAddPaiementDialog() {
    showDialog(
      context: context,
      builder: (context) => _AddPaiementDialog(
        eleves: _eleves,
        typesFrais: _typesFrais.where((t) => t != 'Tous').toList(),
        onSave: (paiement) {
          setState(() => _paiements.add(paiement));
        },
      ),
    );
  }

  void _showRecuDialog(PaiementModel paiement) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Recu de paiement'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                'NEXORA',
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Divider(),
            const SizedBox(height: 8),
            _buildRecuLigne('Eleve', paiement.fullName),
            _buildRecuLigne('Classe', paiement.libelleClasse),
            _buildRecuLigne('Type', paiement.typeFrais),
            _buildRecuLigne('Date', paiement.datePaiement),
            const Divider(),
            _buildRecuLigne(
              'Montant',
              '${paiement.montant.toStringAsFixed(0)} FCFA',
              isBold: true,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fermer'),
          ),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Recu de ${paiement.fullName} imprime'),
                  backgroundColor: const Color(0xFF388E3C),
                ),
              );
            },
            icon: const Icon(Icons.print_outlined),
            label: const Text('Imprimer'),
          ),
        ],
      ),
    );
  }

  Widget _buildRecuLigne(String label, String valeur, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text(
            valeur,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              fontSize: isBold ? 18 : 14,
              color: isBold ? AppColors.primary : null,
            ),
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
        title: const Text('Gestion des Paiements'),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddPaiementDialog,
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text('Nouveau paiement', style: TextStyle(color: Colors.white)),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Card(
              color: AppColors.primary,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Total encaisse',
                          style: TextStyle(color: Colors.white70),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Paiements filtres',
                          style: TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                      ],
                    ),
                    Text(
                      '${_totalPaiements.toStringAsFixed(0)} FCFA',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              controller: _searchController,
              onChanged: (value) => setState(() => _searchQuery = value),
              decoration: const InputDecoration(
                hintText: 'Rechercher un eleve...',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 40,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _typesFrais.length,
              itemBuilder: (context, index) {
                final type = _typesFrais[index];
                final isSelected = _filtreType == type;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(type),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() => _filtreType = type);
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
            child: Text(
              '${_filteredPaiements.length} paiement(s) trouve(s)',
              style: theme.textTheme.bodyMedium,
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: _filteredPaiements.isEmpty
                ? Center(
                    child: Text(
                      'Aucun paiement trouve',
                      style: theme.textTheme.bodyLarge,
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _filteredPaiements.length,
                    itemBuilder: (context, index) {
                      final paiement = _filteredPaiements[index];
                      final color = _getTypeColor(paiement.typeFrais);

                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: color,
                            child: const Icon(Icons.payments_outlined, color: Colors.white, size: 20),
                          ),
                          title: Text(paiement.fullName, style: theme.textTheme.titleLarge),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Classe : ${paiement.libelleClasse}'),
                              Text('Date : ${paiement.datePaiement}'),
                              Container(
                                margin: const EdgeInsets.only(top: 4),
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: color.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: color),
                                ),
                                child: Text(
                                  paiement.typeFrais,
                                  style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                '${paiement.montant.toStringAsFixed(0)}',
                                style: TextStyle(
                                  color: color,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const Text('FCFA', style: TextStyle(fontSize: 11)),
                              IconButton(
                                icon: const Icon(Icons.receipt_outlined),
                                onPressed: () => _showRecuDialog(paiement),
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
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

class _AddPaiementDialog extends StatefulWidget {
  final List<EleveModel> eleves;
  final List<String> typesFrais;
  final Function(PaiementModel) onSave;

  const _AddPaiementDialog({
    required this.eleves,
    required this.typesFrais,
    required this.onSave,
  });

  @override
  State<_AddPaiementDialog> createState() => _AddPaiementDialogState();
}

class _AddPaiementDialogState extends State<_AddPaiementDialog> {
  final _formKey = GlobalKey<FormState>();
  final _montantController = TextEditingController();
  EleveModel? _selectedEleve;
  String _typeFrais = 'Inscription';
  String _datePaiement = DateTime.now().toString().substring(0, 10);

  @override
  void dispose() {
    _montantController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Nouveau paiement'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<EleveModel>(
                value: _selectedEleve,
                decoration: const InputDecoration(labelText: 'Eleve'),
                items: widget.eleves.map((e) {
                  return DropdownMenuItem(
                    value: e,
                    child: Text('${e.fullName} - ${e.libelleClasse}'),
                  );
                }).toList(),
                onChanged: (v) => setState(() => _selectedEleve = v),
                validator: (v) => v == null ? 'Veuillez choisir un eleve' : null,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _typeFrais,
                decoration: const InputDecoration(labelText: 'Type de frais'),
                items: widget.typesFrais.map((t) {
                  return DropdownMenuItem(value: t, child: Text(t));
                }).toList(),
                onChanged: (v) => setState(() => _typeFrais = v!),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _montantController,
                decoration: const InputDecoration(
                  labelText: 'Montant (FCFA)',
                  prefixIcon: Icon(Icons.payments_outlined),
                ),
                keyboardType: TextInputType.number,
                validator: (v) {
                  if (v!.isEmpty) return 'Champ obligatoire';
                  if (double.tryParse(v) == null) return 'Montant invalide';
                  return null;
                },
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
                      _datePaiement = date.toString().substring(0, 10);
                    });
                  }
                },
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Date de paiement',
                    prefixIcon: Icon(Icons.calendar_today_outlined),
                  ),
                  child: Text(_datePaiement),
                ),
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
              final newPaiement = PaiementModel(
                id: DateTime.now().millisecondsSinceEpoch.toString(),
                montant: double.parse(_montantController.text),
                datePaiement: _datePaiement,
                typeFrais: _typeFrais,
                idEleve: _selectedEleve!.id,
                nomEleve: _selectedEleve!.nom,
                prenomEleve: _selectedEleve!.prenom,
                libelleClasse: _selectedEleve!.libelleClasse,
              );
              widget.onSave(newPaiement);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Paiement enregistre avec succes'),
                  backgroundColor: Color(0xFF388E3C),
                ),
              );
            }
          },
          child: const Text('Enregistrer'),
        ),
      ],
    );
  }
}