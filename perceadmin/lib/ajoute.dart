import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class Ajouteformation extends StatefulWidget {
  const Ajouteformation({Key? key}) : super(key: key);

  @override
  State<Ajouteformation> createState() => _AjouteformationState();
}

class _AjouteformationState extends State<Ajouteformation> {
  Future<void> _showEditDialog(Map<String, dynamic> item) async {
    txtdesign.text = item['designation'] ?? '';
    txtdescription.text = item['descriptions'] ?? '';
    txtprixinscription.text = item['prix_inscription'] ?? '';
    txtprixparti.text = item['prix_participation'] ?? '';
    txtDate_debut.text = item['Date_debut'] ?? '';
    txtDate_fin.text = item['Date_Fin'] ?? '';

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
                    controller: txtprixinscription,
                    decoration:
                        const InputDecoration(labelText: 'Prix inscription'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextField(
                    controller: txtprixparti,
                    decoration: const InputDecoration(
                        labelText: 'prix de participation'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextField(
                    controller: txtDate_debut,
                    decoration: InputDecoration(
                      labelText: 'Date debut',
                      prefixIcon: IconButton(
                        iconSize: 15,
                        onPressed: () => _selectDate(txtDate_debut),
                        icon: const Icon(Icons.calendar_today),
                      ),
                    ),
                    readOnly: true,
                    onTap: () {
                      _selectDate(txtDate_debut);
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextField(
                    controller: txtDate_fin,
                    decoration: InputDecoration(
                      labelText: 'Date Fin',
                      prefixIcon: IconButton(
                        iconSize: 15,
                        onPressed: () => _selectDate(txtDate_fin),
                        icon: const Icon(Icons.calendar_today),
                      ),
                    ),
                    readOnly: true,
                    onTap: () {
                      _selectDate(txtDate_fin);
                    },
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
    final prix_inscription = txtprixinscription.text;
    final prix_participation = txtprixparti.text;
    final Date_debut = txtDate_debut.text;
    final Date_fin = txtDate_fin.text;

    final response = await http.post(
      Uri.parse("http://192.168.43.148:81/MRG/update.php"),
      body: {
        'id': id,
        'designation': designation,
        'descriptions': description,
        'prix_inscription': prix_inscription,
        'prix_participation': prix_participation,
        'Date_debut': Date_debut,
        'Date_Fin': Date_fin,
      },
    );

    if (response.statusCode == 200) {
      txtdesign.clear();
      txtdescription.clear();
      txtprixinscription.clear();
      txtprixparti.clear();
      txtDate_debut.clear();
      txtDate_fin.clear();

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

  Future<void> _selectDate(TextEditingController controller) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1980),
      lastDate: DateTime(2101),
    );

    if (picked != null) {
      setState(() {
        controller.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  TextEditingController txtdesign = TextEditingController();
  TextEditingController txtdescription = TextEditingController();
  TextEditingController txtprixinscription = TextEditingController();
  TextEditingController txtprixparti = TextEditingController();
  TextEditingController txtDate_debut = TextEditingController();
  TextEditingController txtDate_fin = TextEditingController();

  Future<void> insertData() async {
    final response = await http.post(
      Uri.parse("http://192.168.43.148:81/MRG/insertformation.php"),
      body: {
        'designation': txtdesign.text,
        'descriptions': txtdescription.text,
        'prix_inscription': txtprixinscription.text,
        'prix_participation': txtprixparti.text,
        'Date_debut': txtDate_debut.text,
        'Date_Fin': txtDate_fin.text,
      },
    );
    if (response.statusCode == 200) {
      txtdesign.clear();
      txtdescription.clear();
      txtprixinscription.clear();
      txtprixparti.clear();
      txtDate_debut.clear();
      txtDate_fin.clear();
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
        Uri.parse("http://192.168.43.148:81/MRG/charger.php"),
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
      var url = 'http://192.168.43.148:81/MRG/deleteformation.php?id=$id';
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
          title: const Text('Ajouter formation'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextField(
                    controller: txtdesign,
                    decoration: const InputDecoration(labelText: 'Formation'),
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
                    controller: txtprixinscription,
                    decoration:
                        const InputDecoration(labelText: 'Prix inscription'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextField(
                    controller: txtprixparti,
                    decoration: const InputDecoration(
                        labelText: 'prix de participation'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextField(
                    controller: txtDate_debut,
                    decoration: InputDecoration(
                      labelText: 'Date debut',
                      prefixIcon: IconButton(
                        iconSize: 15,
                        onPressed: () => _selectDate(txtDate_debut),
                        icon: const Icon(Icons.calendar_today),
                      ),
                    ),
                    readOnly: true,
                    onTap: () {
                      _selectDate(txtDate_debut);
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextField(
                    controller: txtDate_fin,
                    decoration: InputDecoration(
                      labelText: 'Date Fin',
                      prefixIcon: IconButton(
                        iconSize: 15,
                        onPressed: () => _selectDate(txtDate_fin),
                        icon: const Icon(Icons.calendar_today),
                      ),
                    ),
                    readOnly: true,
                    onTap: () {
                      _selectDate(txtDate_fin);
                    },
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
        centerTitle: true,
        title: const Text('NOS FORMATIONS'),
      ),
      body: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start, // Correction : alignement à gauche
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
                                    'Date Début: ${item['Date_debut'] ?? 'N/A'}',
                                    style: const TextStyle(
                                      color: Colors.grey,
                                    ),
                                  ),
                                  Text(
                                    'Date Fin: ${item['Date_Fin'] ?? 'N/A'}',
                                    style: const TextStyle(
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    'Prix Inscription: ${item['prix_inscription'] ?? 'N/A'}',
                                    style: const TextStyle(
                                      color: Colors.grey,
                                    ),
                                  ),
                                  Text(
                                    'Prix Participation: ${item['prix_participation'] ?? 'N/A'}',
                                    style: const TextStyle(
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const Divider(),
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
