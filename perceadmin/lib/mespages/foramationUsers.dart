import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'fiche.dart';
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class Users extends StatefulWidget {
  const Users({super.key});

  @override
  State<Users> createState() => _UsersState();
}

class _UsersState extends State<Users> {
  void _generatePdf(
      BuildContext context, List<Map<String, dynamic>> items) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4.landscape,
        build: (pw.Context context) {
          return pw.Column(
            children: [
              pw.Text(
                'Rapport Complet des Participants',
                style:
                    pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
              ),
              pw.SizedBox(height: 20),
              pw.Table.fromTextArray(
                headers: [
                  'Date',
                  'Nom',
                  'Postnom',
                  'Prenom',
                  'Sexe',
                  'Organisation',
                  'Nom Organisation',
                  'Formation',
                  'Paiement',
                  'Date Debut',
                  'Date Fin',
                  'Lieu',
                  'Telephone',
                  'Email',
                ],
                data: items.map((item) {
                  return [
                    DateFormat('y-MM-dd')
                        .format(DateTime.now()), // Date actuelle
                    item['nom'] ?? '',
                    item['postnom'] ?? '',
                    item['prenom'] ?? '',
                    item['sexe'] ?? '',
                    item['org_privee'] ?? '',
                    item['nom_organisation'] ?? '',
                    item['Formation'] ?? '',
                    item['paiement'] ?? '',
                    item['Date_debut'] ?? '',
                    item['Date_fin'] ?? '',
                    item['Lieu'] ?? '',
                    item['Telephone'] ?? '',
                    item['Email'] ?? '',
                  ];
                }).toList(),
                cellAlignment: pw.Alignment.centerLeft,
                cellStyle: const pw.TextStyle(fontSize: 12),
                headerStyle: pw.TextStyle(
                    fontSize: 14,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.white),
                headerDecoration: const pw.BoxDecoration(color: PdfColors.blue),
                rowDecoration: const pw.BoxDecoration(
                    border: pw.Border(
                        bottom: pw.BorderSide(color: PdfColors.grey))),
                columnWidths: {
                  0: const pw.FixedColumnWidth(60),
                  1: const pw.FixedColumnWidth(50),
                  2: const pw.FixedColumnWidth(60),
                  3: const pw.FixedColumnWidth(60),
                  4: const pw.FixedColumnWidth(40),
                  5: const pw.FixedColumnWidth(80),
                  6: const pw.FixedColumnWidth(80),
                  7: const pw.FixedColumnWidth(60),
                  8: const pw.FixedColumnWidth(60),
                  9: const pw.FixedColumnWidth(60),
                  10: const pw.FixedColumnWidth(60),
                  11: const pw.FixedColumnWidth(50),
                  12: const pw.FixedColumnWidth(80),
                  13: const pw.FixedColumnWidth(80),
                },
              ),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }

  List<Map<String, dynamic>> items = [];
  List<Map<String, dynamic>> filteredItems = [];
  String searchQuery = '';
  late String currentDate;
  Timer? _timer;
  DateTime? startDate;
  DateTime? endDate;

  TextEditingController searchController = TextEditingController();
  final ScrollController _horizontalScrollController = ScrollController();
  final ScrollController _verticalScrollController = ScrollController();
  TextEditingController txtnom = TextEditingController();
  TextEditingController txtpostnom = TextEditingController();
  TextEditingController txtprenom = TextEditingController();
  TextEditingController txtsexe = TextEditingController();
  TextEditingController txtorg_privee = TextEditingController();
  TextEditingController txtnom_organisation = TextEditingController();
  TextEditingController txtFormation = TextEditingController();
  TextEditingController txtpaiement = TextEditingController();
  TextEditingController txtDate_debut = TextEditingController();
  TextEditingController txtDate_fin = TextEditingController();
  TextEditingController txtLieu = TextEditingController();
  TextEditingController txtTelephone = TextEditingController();
  TextEditingController txtEmail = TextEditingController();

  Future<void> _showEditDialog(Map<String, dynamic> item) async {
    // Initialiser les contrôleurs de texte avec les valeurs de l'élément à modifier
    txtnom.text = item['nom'] ?? '';
    txtpostnom.text = item['postnom'] ?? '';
    txtprenom.text = item['prenom'] ?? '';
    txtsexe.text = item['sexe'] ?? '';
    txtorg_privee.text = item['org_privee'] ?? '';
    txtnom_organisation.text = item['nom_organisation'] ?? '';
    txtFormation.text = item['Formation'] ?? '';
    txtpaiement.text = item['paiement'] ?? '';
    txtDate_debut.text = item['Date_debut'] ?? '';
    txtDate_fin.text = item['Date_fin'] ?? '';
    txtLieu.text = item['Lieu'] ?? '';
    txtTelephone.text = item['Telephone'] ?? '';
    txtEmail.text = item['Email'] ?? '';

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Modifier Participant'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: txtnom,
                  decoration: const InputDecoration(labelText: 'Nom'),
                ),
                TextField(
                  controller: txtpostnom,
                  decoration: const InputDecoration(labelText: 'Postnom'),
                ),
                TextField(
                  controller: txtprenom,
                  decoration: const InputDecoration(labelText: 'Prenom'),
                ),
                TextField(
                  controller: txtsexe,
                  decoration: const InputDecoration(labelText: 'Sexe'),
                ),
                TextField(
                  controller: txtorg_privee,
                  decoration: const InputDecoration(
                      labelText: 'Organisation ou privee'),
                ),
                TextField(
                  controller: txtorg_privee,
                  decoration:
                      const InputDecoration(labelText: 'Nom organisation'),
                ),
                TextField(
                  controller: txtFormation,
                  decoration: const InputDecoration(labelText: 'Formation'),
                ),
                TextField(
                  controller: txtpaiement,
                  decoration: const InputDecoration(labelText: 'Paiement'),
                ),
                TextField(
                  controller: txtDate_debut,
                  decoration: const InputDecoration(labelText: 'Date debut'),
                ),
                TextField(
                  controller: txtDate_fin,
                  decoration: const InputDecoration(labelText: 'Date Fin'),
                ),
                TextField(
                  controller: txtLieu,
                  decoration: const InputDecoration(labelText: 'Lieu'),
                ),
                TextField(
                  controller: txtTelephone,
                  decoration: const InputDecoration(labelText: 'Numero'),
                ),
                TextField(
                  controller: txtEmail,
                  decoration: const InputDecoration(labelText: 'Email'),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Annuler'),
            ),
            TextButton(
              onPressed: () {
                updateData(item['id'].toString());
                Navigator.of(context).pop();
              },
              child: const Text('Modifier'),
            ),
          ],
        );
      },
    );
  }

  Future<void> updateData(String id) async {
    final nom = txtnom.text;
    final postnom = txtpostnom.text;
    final prenom = txtprenom.text;
    final sexe = txtsexe.text;
    final org_privee = txtorg_privee.text;
    final nom_organisation = txtorg_privee.text;
    final Formation = txtFormation.text;
    final paiement = txtpaiement.text;
    final Date_debut = txtDate_debut.text;
    final Date_fin = txtDate_fin.text;
    final Lieu = txtLieu.text;
    final Telephone = txtTelephone.text;
    final Email = txtEmail.text;

    final response = await http.post(
      Uri.parse("http://192.168.43.149:81/MRG/updateuser.php"),
      body: {
        'id': id,
        'nom': nom,
        'postnom': postnom,
        'prenom': prenom,
        'sexe': sexe,
        'org_privee': org_privee,
        'nom_organisation': nom_organisation,
        'Formation': Formation,
        'paiement': paiement,
        'Date_debut': Date_debut,
        'Date_fin': Date_fin,
        'Lieu': Lieu,
        'Telephone': Telephone,
        'Email': Email,
      },
    );

    if (response.statusCode == 200) {
      txtnom.clear();
      txtpostnom.clear();
      txtprenom.clear();
      txtsexe.clear();
      txtorg_privee.clear();
      txtnom_organisation.clear();
      txtFormation.clear();
      txtpaiement.clear();
      txtDate_debut.clear();
      txtDate_fin.clear();
      txtLieu.clear();
      txtTelephone.clear();
      txtEmail.clear();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Mise à jour réussie'),
        ),
      );

      fetchData();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Erreur lors de la mise à jour'),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    currentDate = DateFormat('y-MM-dd').format(DateTime.now());
    fetchData();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      fetchData();
    });
  }

  @override
  void dispose() {
    _horizontalScrollController.dispose();
    _verticalScrollController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  static Future<Map<String, dynamic>> loadfiche(String id) async {
    final Uri url = Uri.parse('http://192.168.43.149:81/MRG/fiche.php?id=$id');

    try {
      final http.Response response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> receiptData = jsonDecode(response.body);
        return receiptData;
      } else {
        throw Exception('Failed to load receipt data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load receipt data: $e');
    }
  }

//festch data
  void _filterItems(String query) {
    setState(() {
      searchQuery = query;
      if (query.isEmpty) {
        filteredItems = items;
      } else {
        filteredItems = items.where((item) {
          final nom = item['nom']?.toLowerCase() ?? '';
          final postnom = item['postnom']?.toLowerCase() ?? '';
          final prenom = item['prenom']?.toLowerCase() ?? '';
          final searchLower = query.toLowerCase();
          return nom.contains(searchLower) ||
              postnom.contains(searchLower) ||
              prenom.contains(searchLower);
        }).toList();
      }
    });
  }

  void _filterDate() {
    setState(() {
      filteredItems = items.where((item) {
        final userDate = DateTime.tryParse(item['created_at'] ?? '');
        bool matchesDate = true;

        if (startDate != null && endDate != null && userDate != null) {
          // On utilise `isAfter` pour inclure `startDate` et `isBefore` pour inclure `endDate`.
          matchesDate = (userDate.isAfter(
                      startDate!.subtract(const Duration(seconds: 1))) ||
                  userDate.isAtSameMomentAs(startDate!)) &&
              (userDate.isBefore(endDate!.add(const Duration(days: 1))) ||
                  userDate.isAtSameMomentAs(endDate!));
        }

        return matchesDate;
      }).toList();
    });
  }

  Future<void> _selectDateRange(BuildContext context) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        startDate = picked.start;
        endDate = picked.end;
      });
      _filterDate();
      _showFilteredResultsDialog(context);
    }
  }

  void _showFilteredResultsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Résultats Filtrés'),
          content: filteredItems.isEmpty
              ? const Center(
                  child: Text(
                    'Aucun Element trouvé pour ces dates',
                    style: TextStyle(fontSize: 18),
                  ),
                )
              : SizedBox(
                  width: double.maxFinite,
                  child: Scrollbar(
                    controller: _horizontalScrollController,
                    thumbVisibility: true,
                    thickness: 12.0,
                    radius: const Radius.circular(10),
                    trackVisibility: true,
                    child: SingleChildScrollView(
                      controller: _horizontalScrollController,
                      scrollDirection: Axis.horizontal,
                      child: Scrollbar(
                        controller: _verticalScrollController,
                        thumbVisibility: true,
                        thickness: 12.0,
                        radius: const Radius.circular(10),
                        trackVisibility: true,
                        child: SingleChildScrollView(
                          controller: _verticalScrollController,
                          scrollDirection: Axis.vertical,
                          child: DataTable(
                            columns: const [
                              DataColumn(label: Text('#')),
                              DataColumn(label: Text('Date')),
                              DataColumn(label: Text('Nom')),
                              DataColumn(label: Text('Postnom')),
                              DataColumn(label: Text('Prenom')),
                              DataColumn(label: Text('Sexe')),
                              DataColumn(label: Text('Orga')),
                              DataColumn(label: Text('nom organisation')),
                              DataColumn(label: Text('Formation')),
                              DataColumn(label: Text('Paiement')),
                              DataColumn(label: Text('Date_debut')),
                              DataColumn(label: Text('Date_fin')),
                              DataColumn(label: Text('Lieu')),
                              DataColumn(label: Text('Telephone')),
                              DataColumn(label: Text('Email')),
                            ],
                            rows: List<DataRow>.generate(filteredItems.length,
                                (int index) {
                              final item = filteredItems[index];
                              return DataRow(
                                cells: [
                                  DataCell(Text((index + 1).toString())),
                                  DataCell(
                                    Text(item['created_at'] ?? ''),
                                  ),
                                  DataCell(
                                    Text(item['nom'] ?? ''),
                                  ),
                                  DataCell(
                                    Text(item['postnom'] ?? ''),
                                  ),
                                  DataCell(
                                    Text(item['prenom'] ?? ''),
                                  ),
                                  DataCell(
                                    Text(item['sexe'] ?? ''),
                                  ),
                                  DataCell(
                                    Text(item['org_privee'] ?? ''),
                                  ),
                                  DataCell(
                                    Text(item['nom_organisation'] ?? ''),
                                  ),
                                  DataCell(
                                    Text(item['Formation'] ?? ''),
                                  ),
                                  DataCell(
                                    Text(item['paiement'] ?? ''),
                                  ),
                                  DataCell(
                                    Text(item['Date_debut'] ?? ''),
                                  ),
                                  DataCell(
                                    Text(item['Date_fin'] ?? ''),
                                  ),
                                  DataCell(
                                    Text(item['Lieu'] ?? ''),
                                  ),
                                  DataCell(
                                    Text(item['Telephone'] ?? ''),
                                  ),
                                  DataCell(
                                    Text(item['Email'] ?? ''),
                                  ),
                                ],
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Quitter'),
            ),
            ElevatedButton(
              onPressed: () {
                _generateAndPrintPdf(context, filteredItems);
              },
              child: const Text('Imprimer'),
            ),
          ],
        );
      },
    );
  }

  void _generateAndPrintPdf(
      BuildContext context, List<Map<String, dynamic>> items) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4.landscape, // Mode paysage
        build: (pw.Context context) {
          return pw.Column(
            children: [
              pw.Text(
                'Rapport des Participants Par Dates',
                style:
                    pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold),
              ),
              pw.SizedBox(height: 20),
              pw.Table.fromTextArray(
                headers: [
                  'Date',
                  'Nom',
                  'Postnom',
                  'Prenom',
                  'Sexe',
                  'Organisation',
                  'Nom Organisation',
                  'Formation',
                  'Paiement',
                  'Date Debut',
                  'Date Fin',
                  'Lieu',
                  'Telephone',
                  'Email',
                ],
                data: items.map((item) {
                  return [
                    item['created_at'] ?? '',
                    item['nom'] ?? '',
                    item['postnom'] ?? '',
                    item['prenom'] ?? '',
                    item['sexe'] ?? '',
                    item['org_privee'] ?? '',
                    item['nom_organisation'] ?? '',
                    item['Formation'] ?? '',
                    item['paiement'] ?? '',
                    item['Date_debut'] ?? '',
                    item['Date_fin'] ?? '',
                    item['Lieu'] ?? '',
                    item['Telephone'] ?? '',
                    item['Email'] ?? '',
                  ];
                }).toList(),
                cellAlignment: pw.Alignment.centerLeft,
                cellStyle: const pw.TextStyle(fontSize: 12),
                headerStyle: pw.TextStyle(
                    fontSize: 14,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.white),
                headerDecoration: const pw.BoxDecoration(color: PdfColors.blue),
                rowDecoration: const pw.BoxDecoration(
                    border: pw.Border(
                        bottom: pw.BorderSide(color: PdfColors.grey))),
                columnWidths: {
                  0: const pw.FixedColumnWidth(
                      60), // Adjust the width for each column
                  1: const pw.FixedColumnWidth(50),
                  2: const pw.FixedColumnWidth(60),
                  3: const pw.FixedColumnWidth(60),
                  4: const pw.FixedColumnWidth(40),
                  5: const pw.FixedColumnWidth(80),
                  6: const pw.FixedColumnWidth(80),
                  7: const pw.FixedColumnWidth(60),
                  8: const pw.FixedColumnWidth(60),
                  9: const pw.FixedColumnWidth(60),
                  10: const pw.FixedColumnWidth(60),
                  11: const pw.FixedColumnWidth(50),
                  12: const pw.FixedColumnWidth(80),
                  13: const pw.FixedColumnWidth(80),
                },
              ),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }

  Future<void> fetchData() async {
    try {
      final response = await http.get(
        Uri.parse("http://192.168.43.149:81/MRG/chargeruser.php"),
      );
      setState(() {
        items = List<Map<String, dynamic>>.from(json.decode(response.body));
        filteredItems = items;
      });
      _filterItems(searchQuery);
    } catch (e) {
      print('Error fetching data: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to load items'),
        ),
      );
    }
  }

  Future<void> deleteData(BuildContext context, String id) async {
    bool confirmDelete = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmation'),
          content: const Text('Voulez-vous vraiment supprimer ?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text('Non'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text('Oui'),
            ),
          ],
        );
      },
    );

    if (confirmDelete == true) {
      var url = 'http://192.168.43.149:81/MRG/deleteuser.php?id=$id';

      var response = await http.post(Uri.parse(url));

      if (response.statusCode == 200) {
        print('Données supprimées avec succès');
        fetchData();
      } else {
        print(
            'Échec de la suppression des données. Erreur: ${response.reasonPhrase}');
      }
    } else {
      print('Suppression annulée');
    }
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Les Participants à Formation'),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 30),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(left: 250),
                      ),
                      ElevatedButton(
                        onPressed: () => _selectDateRange(context),
                        child: const Text('Rapports par Dates'),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(left: 100),
                      ),
                      Positioned(
                        top: 10,
                        right: 10,
                        child: SizedBox(
                          width: 300,
                          child: TextField(
                            controller: searchController,
                            onChanged: _filterItems,
                            decoration: InputDecoration(
                              hintText: 'Rechercher un Participant...',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide:
                                    const BorderSide(color: Colors.white),
                              ),
                              filled: true,
                              fillColor: Colors.white,
                              prefixIcon: const Icon(Icons.search),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                filteredItems.isEmpty
                    ? const Center(
                        child: Padding(
                          padding: EdgeInsets.only(top: 200),
                          child: Text(
                            'Aucun élément trouvé',
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                      )
                    : Scrollbar(
                        controller: _horizontalScrollController,
                        thumbVisibility: true,
                        thickness: 12.0,
                        radius: const Radius.circular(10),
                        trackVisibility: true,
                        child: SingleChildScrollView(
                          controller: _horizontalScrollController,
                          scrollDirection: Axis.horizontal,
                          child: Scrollbar(
                            controller: _verticalScrollController,
                            thumbVisibility: true,
                            thickness: 12.0,
                            radius: const Radius.circular(10),
                            trackVisibility: true,
                            child: SingleChildScrollView(
                              controller: _verticalScrollController,
                              scrollDirection: Axis.vertical,
                              child: DataTable(
                                columns: const [
                                  DataColumn(label: Text('#')),
                                  DataColumn(label: Text('Date')),
                                  DataColumn(label: Text('Nom')),
                                  DataColumn(label: Text('Postnom')),
                                  DataColumn(label: Text('Prenom')),
                                  DataColumn(label: Text('Sexe')),
                                  DataColumn(label: Text('Orga')),
                                  DataColumn(label: Text('Nom organisation')),
                                  DataColumn(label: Text('Formation')),
                                  DataColumn(label: Text('Paiement')),
                                  DataColumn(label: Text('Date_debut')),
                                  DataColumn(label: Text('Date_fin')),
                                  DataColumn(label: Text('Lieu')),
                                  DataColumn(label: Text('Telephone')),
                                  DataColumn(label: Text('Email')),
                                  DataColumn(label: Text('Actions')),
                                ],
                                rows: List<DataRow>.generate(
                                    filteredItems.length, (int index) {
                                  final item = filteredItems[index];
                                  return DataRow(
                                    cells: [
                                      DataCell(Text((index + 1).toString())),
                                      DataCell(
                                        Text(item['created_at'] ?? ''),
                                      ),
                                      DataCell(
                                        Text(item['nom'] ?? ''),
                                      ),
                                      DataCell(
                                        Text(item['postnom'] ?? ''),
                                      ),
                                      DataCell(
                                        Text(item['prenom'] ?? ''),
                                      ),
                                      DataCell(
                                        Text(item['sexe'] ?? ''),
                                      ),
                                      DataCell(
                                        Text(item['org_privee'] ?? ''),
                                      ),
                                      DataCell(
                                        Text(item['nom_organisation'] ?? ''),
                                      ),
                                      DataCell(
                                        Text(item['Formation'] ?? ''),
                                      ),
                                      DataCell(
                                        Text(item['paiement'] ?? ''),
                                      ),
                                      DataCell(
                                        Text(item['Date_debut'] ?? ''),
                                      ),
                                      DataCell(
                                        Text(item['Date_fin'] ?? ''),
                                      ),
                                      DataCell(
                                        Text(item['Lieu'] ?? ''),
                                      ),
                                      DataCell(
                                        Text(item['Telephone'] ?? ''),
                                      ),
                                      DataCell(
                                        Text(item['Email'] ?? ''),
                                      ),
                                      DataCell(
                                        Row(
                                          children: [
                                            IconButton(
                                              iconSize: 15,
                                              color: Colors.red,
                                              icon: const Icon(Icons.delete),
                                              onPressed: () {
                                                deleteData(context, item['id']);
                                              },
                                            ),
                                            IconButton(
                                              iconSize: 15,
                                              color: Colors.blue,
                                              icon: const Icon(Icons.edit),
                                              onPressed: () {
                                                _showEditDialog(item);
                                              },
                                            ),
                                            IconButton(
                                              iconSize: 15,
                                              color: Colors.black,
                                              icon: const Icon(Icons.download),
                                              onPressed: () async {
                                                try {
                                                  Map<String, dynamic>
                                                      receiptData =
                                                      await loadfiche(item['id']
                                                          .toString());
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          Fiche(
                                                        receiptData['id']
                                                            .toString(),
                                                      ),
                                                    ),
                                                  );
                                                } catch (e) {
                                                  print(
                                                      'Error fetching receipt data: $e');
                                                }
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        ),
                      ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _generatePdf(context, items);
        },
        child: const Icon(Icons.print),
      ),
    );
  }
}
