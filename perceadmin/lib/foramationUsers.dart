import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'archive.dart';
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
  void _generateAndPrintPdf(
      BuildContext context, List<Map<String, dynamic>> items) async {
    final pdf = pw.Document();

    // Ajouter une page au PDF
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Table.fromTextArray(
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
                DateFormat('y-MM-dd').format(DateTime.now()), // Date actuelle
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
            // Spécifier les largeurs des colonnes
            columnWidths: {
              0: const pw.FlexColumnWidth(
                  1.5), // Ajustez la largeur selon vos besoins
              1: const pw.FlexColumnWidth(1),
              2: const pw.FlexColumnWidth(1),
              3: const pw.FlexColumnWidth(1),
              4: const pw.FlexColumnWidth(1),
              5: const pw.FlexColumnWidth(1),
              6: const pw.FlexColumnWidth(1),
              7: const pw.FlexColumnWidth(1),
              8: const pw.FlexColumnWidth(1),
              9: const pw.FlexColumnWidth(1),
              10: const pw.FlexColumnWidth(1),
              11: const pw.FlexColumnWidth(1),
              12: const pw.FlexColumnWidth(1),
              13: const pw.FlexColumnWidth(1),
            },
            // Ajouter des marges pour augmenter la hauteur des lignes
            cellPadding:
                pw.EdgeInsets.all(0), // Ajustez la marge selon vos besoins
          );
        },
      ),
    );

    // Imprimer le PDF
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }

  List<Map<String, dynamic>> items = [];
  late String currentDate;

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
      Uri.parse("http://192.168.43.148:81/MRG/updateuser.php"),
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
  }

  static Future<Map<String, dynamic>> loadfiche(String id) async {
    final Uri url = Uri.parse('http://192.168.43.148:81/MRG/fiche.php?id=$id');

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
  Future<void> fetchData() async {
    try {
      final response = await http.get(
        Uri.parse("http://192.168.43.148:81/MRG/chargeruser.php"),
      );
      setState(() {
        items = List<Map<String, dynamic>>.from(json.decode(response.body));
      });
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
      var url = 'http://192.168.43.148:81/MRG/deleteuser.php?id=$id';

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
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 20),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 20),
              child: Text(
                'Les participants de la formation',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 30),
            ),
            SingleChildScrollView(
              child: Container(
                height: h,
                width: w,
                child: Column(
                  children: [
                    Card(
                      color: Colors.grey.shade100,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          columns: const [
                            DataColumn(label: Text('Date')),
                            DataColumn(label: Text('nom')),
                            DataColumn(label: Text('postnom')),
                            DataColumn(label: Text('prenom')),
                            DataColumn(label: Text('sexe')),
                            DataColumn(label: Text('Orga')),
                            DataColumn(label: Text('nom organisation')),
                            DataColumn(label: Text('Formation')),
                            DataColumn(label: Text('paiement')),
                            DataColumn(label: Text('Date_debut')),
                            DataColumn(label: Text('Date_fin')),
                            DataColumn(label: Text('Lieu')),
                            DataColumn(label: Text('Telephone')),
                            DataColumn(label: Text('Email')),
                            DataColumn(label: Text('Actions')),
                          ],
                          rows: items.map<DataRow>((item) {
                            return DataRow(
                              color: MaterialStateColor.resolveWith(
                                (states) {
                                  return Colors.grey.shade200;
                                },
                              ),
                              cells: [
                                DataCell(
                                  Text(currentDate),
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
                                        icon: const Icon(Icons.delete),
                                        onPressed: () {
                                          deleteData(context, item['id']);
                                        },
                                      ),
                                      IconButton(
                                        iconSize: 15,
                                        icon: const Icon(Icons.edit),
                                        onPressed: () {
                                          _showEditDialog(item);
                                        },
                                      ),
                                      IconButton(
                                        iconSize: 15,
                                        icon: const Icon(Icons.download),
                                        onPressed: () async {
                                          try {
                                            Map<String, dynamic> receiptData =
                                                await loadfiche(
                                                    item['id'].toString());
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => Fiche(
                                                  receiptData['id'].toString(),
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
                    const Padding(
                      padding: EdgeInsets.only(top: 60),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 200),
                      child: GestureDetector(
                        onTap: () {
                          _generateAndPrintPdf(context, items);
                        },
                        child: Container(
                          height: 40,
                          width: 200,
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Center(
                            child: Text('Imprimer Listes'),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
