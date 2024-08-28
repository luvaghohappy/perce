import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;

class Archives extends StatefulWidget {
  const Archives({super.key});

  @override
  State<Archives> createState() => _ArchivesState();
}

class _ArchivesState extends State<Archives> {
  List<Map<String, dynamic>> items = [];
  List<Map<String, dynamic>> filteredItems = [];
  late String currentDate;
  DateTime? startDate;
  DateTime? endDate;

  final ScrollController _horizontalScrollController = ScrollController();
  final ScrollController _verticalScrollController = ScrollController();

  Future<void> fetchData() async {
    try {
      final response = await http.get(
        Uri.parse("http://192.168.43.149:81/MRG/archive.php"),
      );
      if (response.statusCode == 200) {
        setState(() {
          items = List<Map<String, dynamic>>.from(json.decode(response.body));
          filteredItems =
              items; // Initialement, tous les éléments sont affichés
        });
      } else {
        print('Failed to load data');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to load items'),
          ),
        );
      }
    } catch (e) {
      print('Error fetching data: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to load items'),
        ),
      );
    }
  }

  void filterData() {
    setState(() {
      filteredItems = items.where((item) {
        try {
          final itemDateString = item['Date'] ?? '';
          final itemDate = DateTime.parse(
              itemDateString.isEmpty ? '1970-01-01' : itemDateString);

          return (startDate == null || itemDate.isAfter(startDate!)) &&
              (endDate == null || itemDate.isBefore(endDate!));
        } catch (e) {
          print('Error parsing date: $e');
          return false;
        }
      }).toList();
    });

    _showFilteredDialog();
  }

  void _showFilteredDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Données Filtrées'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView(
              children: filteredItems.isNotEmpty
                  ? filteredItems.map((item) {
                      return ListTile(
                        title: Text(item['nom'] ?? 'Nom non disponible'),
                        subtitle:
                            Text(item['postnom'] ?? 'Postnom non disponible'),
                      );
                    }).toList()
                  : [const Text('Aucun résultat')],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Annuler'),
            ),
            TextButton(
              onPressed: () {
                _printFilteredData(); // Fonction pour imprimer en PDF
              },
              child: const Text('Imprimer'),
            ),
          ],
        );
      },
    );
  }

  void _printFilteredData() {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.ListView.builder(
            itemCount: filteredItems.length,
            itemBuilder: (pw.Context context, int index) {
              final item = filteredItems[index];
              return pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text('Nom: ${item['nom'] ?? 'Non disponible'}'),
                  pw.Text('Postnom: ${item['postnom'] ?? 'Non disponible'}'),
                  pw.Text('Prénom: ${item['prenom'] ?? 'Non disponible'}'),
                  pw.Text('Sexe: ${item['sexe'] ?? 'Non disponible'}'),
                  pw.Text('Orga: ${item['org_privee'] ?? 'Non disponible'}'),
                  pw.Text(
                      'Formation: ${item['Formation'] ?? 'Non disponible'}'),
                  pw.Text('Paiement: ${item['paiement'] ?? 'Non disponible'}'),
                  pw.Text(
                      'Date début: ${item['Date_debut'] ?? 'Non disponible'}'),
                  pw.Text('Date fin: ${item['Date_fin'] ?? 'Non disponible'}'),
                  pw.Text('Lieu: ${item['Lieu'] ?? 'Non disponible'}'),
                  pw.Text(
                      'Téléphone: ${item['Telephone'] ?? 'Non disponible'}'),
                  pw.Text('Email: ${item['Email'] ?? 'Non disponible'}'),
                  pw.SizedBox(height: 10),
                ],
              );
            },
          );
        },
      ),
    );

    Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdf.save());
  }

  @override
  void initState() {
    super.initState();
    fetchData();
    currentDate = DateFormat('y-MM-dd').format(DateTime.now());
  }

  @override
  void dispose() {
    _horizontalScrollController.dispose();
    _verticalScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Column(
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 20),
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: Text(
                    'Archives des participants',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 30),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () async {
                        final pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2101),
                        );
                        if (pickedDate != null) {
                          setState(() {
                            startDate = pickedDate;
                          });
                        }
                      },
                      child: Text(
                        startDate != null
                            ? DateFormat('y-MM-dd').format(startDate!)
                            : 'Sélectionnez la date de début',
                      ),
                    ),
                    const SizedBox(width: 10),
                    TextButton(
                      onPressed: () async {
                        final pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2101),
                        );
                        if (pickedDate != null) {
                          setState(() {
                            endDate = pickedDate;
                          });
                        }
                      },
                      child: Text(
                        endDate != null
                            ? DateFormat('y-MM-dd').format(endDate!)
                            : 'Sélectionnez la date de fin',
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 30),
                    ),
                    CircleAvatar(
                      radius: 15,
                      child: Center(
                        child: IconButton(
                          iconSize: 12,
                          color: Colors.white,
                          onPressed: filterData,
                          icon: const Icon(Icons.search),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Positioned.fill(
                  top: 80,
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
                              DataColumn(label: Text('Date')),
                              DataColumn(label: Text('Nom')),
                              DataColumn(label: Text('Postnom')),
                              DataColumn(label: Text('Prenom')),
                              DataColumn(label: Text('Sexe')),
                              DataColumn(label: Text('Orga')),
                              DataColumn(label: Text('Formation')),
                              DataColumn(label: Text('Paiement')),
                              DataColumn(label: Text('Date_debut')),
                              DataColumn(label: Text('Date_fin')),
                              DataColumn(label: Text('Lieu')),
                              DataColumn(label: Text('Téléphone')),
                              DataColumn(label: Text('Email')),
                            ],
                            rows: items.map((item) {
                              return DataRow(cells: [
                                DataCell(
                                  Text(currentDate),
                                ),
                                DataCell(Text(item['nom'] ?? '')),
                                DataCell(Text(item['postnom'] ?? '')),
                                DataCell(Text(item['prenom'] ?? '')),
                                DataCell(Text(item['sexe'] ?? '')),
                                DataCell(Text(item['org_privee'] ?? '')),
                                DataCell(Text(item['Formation'] ?? '')),
                                DataCell(Text(item['paiement'] ?? '')),
                                DataCell(Text(item['Date_debut'] ?? '')),
                                DataCell(Text(item['Date_fin'] ?? '')),
                                DataCell(Text(item['Lieu'] ?? '')),
                                DataCell(Text(item['Telephone'] ?? '')),
                                DataCell(Text(item['Email'] ?? '')),
                              ]);
                            }).toList(),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
