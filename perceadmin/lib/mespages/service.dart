import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class Services extends StatefulWidget {
  const Services({super.key});

  @override
  State<Services> createState() => _ServicesState();
}

class _ServicesState extends State<Services> {
  Future<void> _showEditDialog(Map<String, dynamic> item) async {
    txtdesign.text = item['designation'] ?? '';
    txtdescription.text = item['descriptions'] ?? '';
    txtdetaille.text = item['detaille'] ?? '';

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Modifier Formations'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: txtdesign,
                  decoration: const InputDecoration(labelText: 'designation'),
                ),
                TextField(
                  controller: txtdescription,
                  decoration: const InputDecoration(labelText: 'descriptions'),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextField(
                    controller: txtdetaille,
                    decoration: const InputDecoration(labelText: 'detaille'),
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
    final designation = txtdesign.text;
    final description = txtdescription.text;
    final detaille = txtdetaille.text;

    final response = await http.post(
      Uri.parse("http://192.168.43.149:81/MRG/updateservice.php"),
      body: {
        'id': id,
        'designation': designation,
        'descriptions': description,
        'detaille': detaille,
      },
    );

    if (response.statusCode == 200) {
      txtdesign.clear();
      txtdescription.clear();
      txtdetaille.clear();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Mise à jour réussie'),
        ),
      );
      fetchDesignationsAndDescriptions();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Erreur lors de la mise à jour'),
        ),
      );
    }
  }

  List<Map<String, dynamic>> items = [];

  @override
  void initState() {
    super.initState();
    fetchDesignationsAndDescriptions();
  }

  TextEditingController txtdesign = TextEditingController();
  TextEditingController txtdescription = TextEditingController();
  TextEditingController txtdetaille = TextEditingController();

  Future<void> insertData() async {
    final response = await http.post(
      Uri.parse("http://192.168.43.149:81/MRG/insertservice.php"),
      body: {
        'designation': txtdesign.text,
        'descriptions': txtdescription.text,
        'detaille': txtdetaille.text,
      },
    );

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      txtdesign.clear();
      txtdescription.clear();
      txtdetaille.clear();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Enregistrement réussi'),
        ),
      );
      fetchDesignationsAndDescriptions();
      Navigator.of(context).pop(true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Erreur lors de l\'enregistrement'),
        ),
      );
    }
  }

  Future<void> fetchDesignationsAndDescriptions() async {
    try {
      final response = await http.get(
        Uri.parse("http://192.168.43.149:81/MRG/chargerservice.php"),
      );
      setState(() {
        items = List<Map<String, dynamic>>.from(json.decode(response.body));
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to load items'),
        ),
      );
    }
  }

  Future<void> deleteDataformation(BuildContext context, String id) async {
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
      var url = 'http://192.168.43.149:81/MRG/deleteservice.php?id=$id';
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
                    controller: txtdesign,
                    decoration: const InputDecoration(labelText: 'designation'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextField(
                    controller: txtdescription,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    decoration: const InputDecoration(
                      hintText: 'Enter your description here',
                      labelText: 'Description',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextField(
                    controller: txtdetaille,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    decoration: const InputDecoration(
                      hintText: 'Etat',
                      labelText: 'Etat',
                      border: OutlineInputBorder(),
                    ),
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
                if (txtdesign.text.isNotEmpty &&
                    txtdescription.text.isNotEmpty) {
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        centerTitle: true,
        title: const Text('NOS SERVICES'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item['designation'] ?? 'N/A',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            item['descriptions'] ?? 'N/A',
                            style: const TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item['detaille'] ?? 'N/A',
                                    style: const TextStyle(
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                iconSize: 15,
                                icon: const Icon(Icons.edit),
                                onPressed: () {
                                  _showEditDialog(item);
                                },
                              ),
                              IconButton(
                                iconSize: 15,
                                icon: const Icon(Icons.delete),
                                onPressed: () {
                                  deleteDataformation(context, item['id']);
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}
