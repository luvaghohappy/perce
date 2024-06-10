import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class Archives extends StatefulWidget {
  const Archives({super.key});

  @override
  State<Archives> createState() => _ArchivesState();
}

class _ArchivesState extends State<Archives> {
  List<Map<String, dynamic>> items = [];
  late String currentDate;

  Future<void> fetchData() async {
    try {
      final response = await http.get(
        Uri.parse("http://192.168.43.148:81/MRG/archive.php"),
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

  @override
  void initState() {
    super.initState();
    fetchData();
     currentDate = DateFormat('y-MM-dd').format(DateTime.now());
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
                'Archives des participants',
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
                child: Card(
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
                        DataColumn(label: Text('Formation')),
                        DataColumn(label: Text('paiement')),
                        DataColumn(label: Text('Date_debut')),
                        DataColumn(label: Text('Date_fin')),
                        DataColumn(label: Text('Lieu')),
                        DataColumn(label: Text('Telephone')),
                        DataColumn(label: Text('Email')),
                       
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
       ] ),
       ),
    );
  }
}







