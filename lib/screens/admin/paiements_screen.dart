import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexora/core/theme.dart';

class PaiementsScreen extends ConsumerStatefulWidget {
  const PaiementsScreen({super.key});

  @override
  ConsumerState<PaiementsScreen> createState() => _PaiementsScreenState();
}

class _PaiementsScreenState extends ConsumerState<PaiementsScreen> {
  String _searchQuery = '';
  String _filtreStatut = 'Tous';

  final List<Map<String, dynamic>> _paiements = [
    {
      'nom': 'Mensah Koffi',
      'matricule': 'NEX-2024-001',
      'montant': '75000',
      'type': 'Scolarite',
      'statut': 'Paye',
      'date': '05/09/2024',
    },
    {
      'nom': 'Agbeko Ama',
      'matricule': 'NEX-2024-002',
      'montant': '75000',
      'type': 'Scolarite',
      'statut': 'En_attente',
      'date': '05/09/2024',
    },
    {
      'nom': 'Kofi Kossi',
      'matricule': 'NEX-2024-003',
      'montant': '75000',
      'type': 'Inscription',
      'statut': 'Partiel',
      'date': '01/09/2024',
    },
  ];

  List<Map<String, dynamic>> get _paiementsFiltres {
    return _paiements.where((p) {
      final matchSearch = p['nom']
              .toLowerCase()
              .contains(_searchQuery.toLowerCase()) ||
          p['matricule'].toLowerCase().contains(_searchQuery.toLowerCase());
      final matchStatut =
          _filtreStatut == 'Tous' || p['statut'] == _filtreStatut;
      return matchSearch && matchStatut;
    }).toList();
  }

  Color _couleurStatut(String statut) {
    switch (statut) {
      case 'Paye':
        return AppColors.success;
      case 'En_attente':
        return AppColors.error;
      case 'Partiel':
        return const Color(0xFFF57C00);
      default:
        return AppColors.primary;
    }
  }

  String _libelleStatut(String statut) {
    switch (statut) {
      case 'Paye':
        return 'Paye';
      case 'En_attente':
        return 'En attente';
      case 'Partiel':
        return 'Partiel';
      default:
        return statut;
    }
  }

  void _afficherFormulaire({Map<String, dynamic>? paiement}) {
    final nomController =
        TextEditingController(text: paiement?['nom'] ?? '');
    final montantController =
        TextEditingController(text: paiement?['montant'] ?? '');
    String typeFrais = paiement?['type'] ?? 'Scolarite';
    String statut = paiement?['statut'] ?? 'En_attente';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Padding(
          padding: EdgeInsets.only(
            left: 24,
            right: 24,
            top: 24,
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                paiement == null ? 'Nouveau paiement' : 'Modifier paiement',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 24),
              TextField(
                controller: nomController,
                decoration: const InputDecoration(
                  labelText: 'Nom de l\'eleve',
                  prefixIcon: Icon(Icons.person_outlined),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: montantController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Montant (FCFA)',
                  prefixIcon: Icon(Icons.payments_outlined),
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: typeFrais,
                decoration: const InputDecoration(
                  labelText: 'Type de frais',
                  prefixIcon: Icon(Icons.category_outlined),
                ),
                items: ['Scolarite', 'Inscription', 'Cantine', 'Uniforme', 'Transport']
                    .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                    .toList(),
                onChanged: (val) => setModalState(() => typeFrais = val!),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: statut,
                decoration: const InputDecoration(
                  labelText: 'Statut',
                  prefixIcon: Icon(Icons.info_outlined),
                ),
                items: ['Paye', 'En_attente', 'Partiel']
                    .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                    .toList(),
                onChanged: (val) => setModalState(() => statut = val!),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(paiement == null
                          ? 'Paiement enregistre'
                          : 'Paiement modifie'),
                      backgroundColor: AppColors.success,
                    ),
                  );
                },
                child: Text(paiement == null ? 'Enregistrer' : 'Modifier'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Paiements'),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _afficherFormulaire(),
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add, color: AppColors.white),
        label: const Text(
          'Nouveau paiement',
          style: TextStyle(color: AppColors.white),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  onChanged: (val) => setState(() => _searchQuery = val),
                  decoration: const InputDecoration(
                    hintText: 'Rechercher un eleve...',
                    prefixIcon: Icon(Icons.search),
                  ),
                ),
                const SizedBox(height: 12),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: ['Tous', 'Paye', 'En_attente', 'Partiel']
                        .map((statut) => Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: FilterChip(
                                label: Text(_libelleStatut(statut)),
                                selected: _filtreStatut == statut,
                                selectedColor:
                                    AppColors.primary.withValues(alpha: 0.2),
                                onSelected: (_) => setState(
                                    () => _filtreStatut = statut),
                              ),
                            ))
                        .toList(),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: _paiementsFiltres.isEmpty
                ? Center(
                    child: Text(
                      'Aucun paiement trouve',
                      style: theme.textTheme.bodyLarge,
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: _paiementsFiltres.length,
                    itemBuilder: (context, index) {
                      final p = _paiementsFiltres[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(16),
                          leading: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(Icons.payments_outlined,
                                color: AppColors.primary),
                          ),
                          title: Text(
                            p['nom'],
                            style: theme.textTheme.titleLarge!
                                .copyWith(fontSize: 16),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 4),
                              Text(
                                '${p['matricule']} - ${p['type']}',
                                style: theme.textTheme.bodyMedium,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${p['montant']} FCFA - ${p['date']}',
                                style: theme.textTheme.bodyMedium!.copyWith(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: _couleurStatut(p['statut'])
                                      .withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  _libelleStatut(p['statut']),
                                  style: TextStyle(
                                    color: _couleurStatut(p['statut']),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.edit_outlined,
                                    color: AppColors.primary, size: 20),
                                onPressed: () =>
                                    _afficherFormulaire(paiement: p),
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