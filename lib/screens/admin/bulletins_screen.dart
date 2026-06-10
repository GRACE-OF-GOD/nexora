 import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexora/core/theme.dart';
import 'package:nexora/models/bulletin_model.dart';

class BulletinsScreen extends ConsumerStatefulWidget {
  const BulletinsScreen({super.key});

  @override
  ConsumerState<BulletinsScreen> createState() => _BulletinsScreenState();
}

class _BulletinsScreenState extends ConsumerState<BulletinsScreen> {
  String _searchQuery = '';
  final _searchController = TextEditingController();
  String _niveauFiltre = 'Primaire/Secondaire';
  int _selectedPeriode = 1;

  final List<BulletinModel> _bulletins = [
    BulletinModel(
      id: '1',
      trimestre: 1,
      moyenneGenerale: 15.5,
      rang: 1,
      mention: 'Bien',
      idEleve: '1',
      nomEleve: 'Koffi',
      prenomEleve: 'Kossi',
      libelleClasse: '6eme A',
      notes: [
        {'matiere': 'Mathematiques', 'coefficient': 4, 'note': 16.0, 'mention': 'Bien'},
        {'matiere': 'Francais', 'coefficient': 4, 'note': 15.0, 'mention': 'Bien'},
        {'matiere': 'Anglais', 'coefficient': 3, 'note': 14.0, 'mention': 'Bien'},
        {'matiere': 'Sciences', 'coefficient': 3, 'note': 17.0, 'mention': 'Tres Bien'},
        {'matiere': 'Histoire-Geo', 'coefficient': 2, 'note': 13.0, 'mention': 'Assez Bien'},
      ],
    ),
    BulletinModel(
      id: '2',
      trimestre: 1,
      moyenneGenerale: 12.3,
      rang: 2,
      mention: 'Assez Bien',
      idEleve: '2',
      nomEleve: 'Ama',
      prenomEleve: 'Akosua',
      libelleClasse: '6eme A',
      notes: [
        {'matiere': 'Mathematiques', 'coefficient': 4, 'note': 11.0, 'mention': 'Passable'},
        {'matiere': 'Francais', 'coefficient': 4, 'note': 13.0, 'mention': 'Assez Bien'},
        {'matiere': 'Anglais', 'coefficient': 3, 'note': 14.0, 'mention': 'Bien'},
        {'matiere': 'Sciences', 'coefficient': 3, 'note': 12.0, 'mention': 'Assez Bien'},
        {'matiere': 'Histoire-Geo', 'coefficient': 2, 'note': 11.0, 'mention': 'Passable'},
      ],
    ),
    BulletinModel(
      id: '3',
      trimestre: 1,
      moyenneGenerale: 14.8,
      rang: 1,
      mention: 'Bien',
      idEleve: '3',
      nomEleve: 'Mensah',
      prenomEleve: 'Afi',
      libelleClasse: 'Licence 1',
      notes: [
        {'matiere': 'Mathematiques', 'coefficient': 4, 'note': 15.0, 'mention': 'Bien'},
        {'matiere': 'Informatique', 'coefficient': 4, 'note': 16.0, 'mention': 'Bien'},
        {'matiere': 'Anglais', 'coefficient': 3, 'note': 13.0, 'mention': 'Assez Bien'},
        {'matiere': 'Physique', 'coefficient': 3, 'note': 14.0, 'mention': 'Bien'},
      ],
    ),
    BulletinModel(
      id: '4',
      trimestre: 2,
      moyenneGenerale: 13.5,
      rang: 2,
      mention: 'Assez Bien',
      idEleve: '4',
      nomEleve: 'Agbo',
      prenomEleve: 'Kofi',
      libelleClasse: 'Master 1',
      notes: [
        {'matiere': 'Recherche', 'coefficient': 4, 'note': 14.0, 'mention': 'Bien'},
        {'matiere': 'Gestion', 'coefficient': 4, 'note': 13.0, 'mention': 'Assez Bien'},
        {'matiere': 'Anglais', 'coefficient': 3, 'note': 12.0, 'mention': 'Assez Bien'},
      ],
    ),
  ];

  bool get _isUniversitaire => _niveauFiltre == 'Universitaire';

  List<int> get _periodes => _isUniversitaire ? [1, 2] : [1, 2, 3];

  String get _periodeLabel => _isUniversitaire ? 'Semestre' : 'Trimestre';

  bool _isClasseUniversitaire(String libelle) {
    return libelle.contains('Licence') ||
        libelle.contains('Master') ||
        libelle.contains('Doctorat');
  }

  List<BulletinModel> get _filteredBulletins {
    return _bulletins.where((b) {
      final matchPeriode = b.trimestre == _selectedPeriode;
      final matchNiveau = _isUniversitaire
          ? _isClasseUniversitaire(b.libelleClasse)
          : !_isClasseUniversitaire(b.libelleClasse);
      final matchSearch = _searchQuery.isEmpty ||
          b.fullName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          b.libelleClasse.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchPeriode && matchNiveau && matchSearch;
    }).toList();
  }

  Color _getMentionColor(String mention) {
    switch (mention) {
      case 'Tres Bien':
        return const Color(0xFF7B1FA2);
      case 'Bien':
        return const Color(0xFF388E3C);
      case 'Assez Bien':
        return AppColors.primary;
      case 'Passable':
        return const Color(0xFFF57C00);
      default:
        return AppColors.error;
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showBulletinDetail(BulletinModel bulletin) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Bulletin de ${bulletin.fullName}'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Classe : ${bulletin.libelleClasse}'),
                  Text(
                    '$_periodeLabel ${bulletin.trimestre}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const Divider(),
              const SizedBox(height: 8),
              Table(
                border: TableBorder.all(
                  color: AppColors.lightGrey,
                  borderRadius: BorderRadius.circular(8),
                ),
                columnWidths: const {
                  0: FlexColumnWidth(3),
                  1: FlexColumnWidth(1),
                  2: FlexColumnWidth(1),
                },
                children: [
                  const TableRow(
                    decoration: BoxDecoration(color: AppColors.primary),
                    children: [
                      Padding(
                        padding: EdgeInsets.all(8),
                        child: Text(
                          'Matiere',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8),
                        child: Text(
                          'Coef',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8),
                        child: Text(
                          'Note',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  ...bulletin.notes.map((note) {
                    final noteVal = note['note'] as double;
                    final color = _getMentionColor(note['mention'] as String);
                    return TableRow(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: Text(note['matiere'] as String),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: Text('${note['coefficient']}'),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: Text(
                            noteVal.toStringAsFixed(1),
                            style: TextStyle(color: color, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    );
                  }),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Moyenne generale',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '${bulletin.moyenneGenerale.toStringAsFixed(2)} / 20',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Rang : ${bulletin.rang}'),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getMentionColor(bulletin.mention),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      bulletin.mention,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
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
                  content: Text('Bulletin de ${bulletin.fullName} telecharge'),
                  backgroundColor: const Color(0xFF388E3C),
                ),
              );
            },
            icon: const Icon(Icons.download_outlined),
            label: const Text('Telecharger PDF'),
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
        title: const Text('Bulletins'),
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
                Expanded(
                  child: SegmentedButton<String>(
                    segments: const [
                      ButtonSegment(
                        value: 'Primaire/Secondaire',
                        label: Text('Prim/Sec'),
                        icon: Icon(Icons.school_outlined),
                      ),
                      ButtonSegment(
                        value: 'Universitaire',
                        label: Text('Universite'),
                        icon: Icon(Icons.account_balance_outlined),
                      ),
                    ],
                    selected: {_niveauFiltre},
                    onSelectionChanged: (value) {
                      setState(() {
                        _niveauFiltre = value.first;
                        _selectedPeriode = 1;
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 48,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: _periodes.map((periode) {
                final isSelected = _selectedPeriode == periode;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text('$_periodeLabel $periode'),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() => _selectedPeriode = periode);
                    },
                    selectedColor: AppColors.primary,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : null,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Text(
                  '${_filteredBulletins.length} bulletin(s) trouve(s)',
                  style: theme.textTheme.bodyMedium,
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: _filteredBulletins.isEmpty
                ? Center(
                    child: Text(
                      'Aucun bulletin trouve',
                      style: theme.textTheme.bodyLarge,
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _filteredBulletins.length,
                    itemBuilder: (context, index) {
                      final bulletin = _filteredBulletins[index];
                      final mentionColor = _getMentionColor(bulletin.mention);

                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: mentionColor,
                            child: Text(
                              '${bulletin.rang}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          title: Text(
                            bulletin.fullName,
                            style: theme.textTheme.titleLarge,
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Classe : ${bulletin.libelleClasse}'),
                              Text(
                                'Moyenne : ${bulletin.moyenneGenerale.toStringAsFixed(2)} / 20',
                              ),
                            ],
                          ),
                          trailing: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: mentionColor,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              bulletin.mention,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          onTap: () => _showBulletinDetail(bulletin),
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