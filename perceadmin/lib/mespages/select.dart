import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class InsertAdmin extends StatefulWidget {
  const InsertAdmin({super.key});

  @override
  State<InsertAdmin> createState() => _InsertAdminState();
}

class _InsertAdminState extends State<InsertAdmin> {
  TextEditingController txtemail = TextEditingController();
  TextEditingController txtpassword = TextEditingController();

  Future<void> _showEditDialog(Map<String, dynamic> item) async {
    txtemail.text = item['email'] ?? '';
    txtpassword.text = item['passwords'] ?? '';

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Modifier'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: txtemail,
                  decoration: const InputDecoration(labelText: 'email'),
                ),
                TextField(
                  controller: txtpassword,
                  decoration: const InputDecoration(labelText: 'passwords'),
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
              },
              child: const Text('Modifier'),
            ),
          ],
        );
      },
    );
  }

  Future<void> updateData(String id) async {
    final email = txtemail.text;
    final password = txtpassword.text;

    final response = await http.post(
      Uri.parse("http://192.168.43.149:81/MRG/updateadmin.php"),
      body: {
        'id': id,
        'email': email,
        'passwords': password,
      },
    );

    if (response.statusCode == 200) {
      txtemail.clear();
      txtpassword.clear();

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
      var url = 'http://192.168.43.149:81/MRG/deleteadmin.php?id=$id';
      var response = await http.post(Uri.parse(url));

      if (response.statusCode == 200) {
        print('Données supprimées avec succès');
      } else {
        print(
            'Échec de la suppression des données. Erreur: ${response.reasonPhrase}');
      }
    } else {
      print('Suppression annulée');
    }
  }

  List<Map<String, dynamic>> items = [];

  Future<void> fetchData() async {
    try {
      final response = await http.get(
        Uri.parse("http://192.168.43.149:81/MRG/select.php"),
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
  }

  Future<void> insertData() async {
    final response = await http.post(
      Uri.parse("http://192.168.43.149:81/MRG/insertadmin.php"),
      body: {
        'email': txtemail.text,
        'passwords': txtpassword.text,
      },
    );

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      txtemail.clear();
      txtpassword.clear();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Enregistrement réussi'),
        ),
      );
      fetchData();
      Navigator.of(context).pop(true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Erreur lors de l\'enregistrement'),
        ),
      );
    }
  }

  /////////
  Future<void> _showAddDialog() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Ajouter Service'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextField(
                    controller: txtemail,
                    decoration: const InputDecoration(labelText: 'email'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextField(
                    controller: txtpassword,
                    decoration: const InputDecoration(labelText: 'password'),
                  ),
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
                if (txtemail.text.isNotEmpty && txtpassword.text.isNotEmpty) {
                  insertData();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Veuillez remplir tous les champs'),
                    ),
                  );
                }
              },
              child: const Text('Ajouter'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Perce Admins'),
        actions: [
          IconButton(
            iconSize: 25,
            icon: const Icon(Icons.add),
            onPressed: () {
              _showAddDialog();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 40),
            ),
            Column(
              children: [
                Card(
                  color: Colors.grey.shade100,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columns: const [
                        DataColumn(label: Text('Email')),
                        DataColumn(label: Text('Password')),
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
                              Text(item['email'] ?? ''),
                            ),
                            DataCell(
                              Text(item['passwords'] ?? ''),
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
                                ],
                              ),
                            ),
                          ],
                        );
                      }).toList(),
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
