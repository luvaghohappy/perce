import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class Ajouteformation extends StatefulWidget {
  const Ajouteformation({Key? key}) : super(key: key);

  @override
  State<Ajouteformation> createState() => _AjouteformationState();
}

class _AjouteformationState extends State<Ajouteformation> {
  File? _imageFile;
  final picker = ImagePicker();

  Future<void> getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
      Navigator.of(context).pop();
      showInsertDialog(context);
    } else {
      print('No image selected.');
    }
  }

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
                GestureDetector(
                  onTap: getImage,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage:
                        _imageFile != null ? FileImage(_imageFile!) : null,
                    child: _imageFile == null
                        ? const Icon(
                            Icons.add_a_photo,
                            size: 20,
                            color: Colors.white,
                          )
                        : null,
                  ),
                ),
                TextField(
                  controller: txtdesign,
                  decoration: const InputDecoration(labelText: 'Designation'),
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
                        labelText: 'Prix de participation'),
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

    var request = http.MultipartRequest(
      'POST',
      Uri.parse("http://192.168.43.149:81/MRG/update.php"),
    );

    request.fields['id'] = id;
    request.fields['designation'] = designation;
    request.fields['descriptions'] = description;
    request.fields['prix_inscription'] = prix_inscription;
    request.fields['prix_participation'] = prix_participation;
    request.fields['Date_debut'] = Date_debut;
    request.fields['Date_Fin'] = Date_fin;

    if (_imageFile != null) {
      request.files.add(
        await http.MultipartFile.fromPath(
          'image',
          _imageFile!.path,
        ),
      );
    }

    final response = await request.send();

    if (response.statusCode == 200) {
      _imageFile = null;
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
      fetch();
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
    fetch();
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
    var request = http.MultipartRequest(
      'POST',
      Uri.parse("http://192.168.43.149:81/MRG/insertformation.php"),
    );

    request.fields['designation'] = txtdesign.text;
    request.fields['descriptions'] = txtdescription.text;
    request.fields['prix_inscription'] = txtprixinscription.text;
    request.fields['prix_participation'] = txtprixparti.text;
    request.fields['Date_debut'] = txtDate_debut.text;
    request.fields['Date_Fin'] = txtDate_fin.text;

    if (_imageFile != null) {
      request.files.add(
        await http.MultipartFile.fromPath(
          'image',
          _imageFile!.path,
        ),
      );
    }

    final response = await request.send();

    if (response.statusCode == 200) {
      final responseBody = await response.stream.bytesToString();
      final responseJson = jsonDecode(responseBody);

      if (responseJson['status'] == 'success') {
        _imageFile = null;
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
        fetch();
        Navigator.of(context).pop(true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Erreur lors de l\'enregistrement: ${responseJson['error']}'),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Erreur lors de l\'enregistrement'),
        ),
      );
    }
  }

  Future<void> fetch() async {
    try {
      final response = await http.get(
        Uri.parse("http://192.168.43.149:81/MRG/charger.php"),
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

  Future<void> deleteFormation(String id) async {
    final response = await http.post(
      Uri.parse("http://192.168.43.149:81/MRG/deleteformation.php"),
      body: {'id': id},
    );

    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      if (result['status'] == 'success') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Suppression réussie'),
          ),
        );
        fetch();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur lors de la suppression : ${result['error']}'),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Erreur lors de la suppression'),
        ),
      );
    }
  }

  void _confirmDelete(String id) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirmation de suppression'),
          content: const Text('Voulez-vous vraiment supprimer cet élément ?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Annuler'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                deleteFormation(id);
              },
              child: const Text('Supprimer'),
            ),
          ],
        );
      },
    );
  }

  Future<void> showInsertDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Ajouter Formation'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                GestureDetector(
                  onTap: getImage,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage:
                        _imageFile != null ? FileImage(_imageFile!) : null,
                    child: _imageFile == null
                        ? const Icon(
                            Icons.add_a_photo,
                            size: 20,
                            color: Colors.white,
                          )
                        : null,
                  ),
                ),
                TextField(
                  controller: txtdesign,
                  decoration: const InputDecoration(labelText: 'Designation'),
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
                        labelText: 'Prix de participation'),
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
              onPressed: insertData,
              child: const Text('Enregistrer'),
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
                          Row(
                            children: [
                              CircleAvatar(
                                radius: 15,
                                backgroundColor: Colors.blue,
                                backgroundImage: item['image_path'] != null
                                    ? NetworkImage(
                                        "http://192.168.43.149:81/MRG/${item['image_path']}")
                                    : null,
                                child: item['image_path'] == null
                                    ? const Icon(Icons.image,
                                        size: 10, color: Colors.grey)
                                    : null,
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              Text(
                                item['designation'] ?? 'N/A',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 5),
                          Text(
                            item['descriptions'] ?? 'N/A',
                            style: const TextStyle(
                              color: Colors.grey,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      const Text(
                                        'Prix Inscription: ',
                                        style: TextStyle(
                                          color: Colors.black,
                                        ),
                                      ),
                                      Text(
                                        '${item['prix_inscription']}',
                                        style: const TextStyle(
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      const Text(
                                        'Prix Participation: ',
                                        style: TextStyle(
                                          color: Colors.black,
                                        ),
                                      ),
                                      Text(
                                        '${item['prix_participation']}',
                                        style: const TextStyle(
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      const Text(
                                        'Dates: ',
                                        style: TextStyle(
                                          color: Colors.black,
                                        ),
                                      ),
                                      Text(
                                        '${item['Date_debut']} jusqu\'à ${item['Date_Fin']}',
                                        style: const TextStyle(
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
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
                                  deleteFormation(item['id']);
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
        onPressed: () => showInsertDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}
