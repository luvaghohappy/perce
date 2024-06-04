import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';

class Inscription extends StatefulWidget {
  const Inscription({super.key});

  @override
  State<Inscription> createState() => _InscriptionState();
}

class _InscriptionState extends State<Inscription> {
  final number = '+243828797626';

  Future<void> _selectDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1980),
      lastDate: DateTime(2101),
    );

    if (picked != null) {
      setState(() {
        txtDate_debut.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  Future<void> _selectDatefin() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1980),
      lastDate: DateTime(2101),
    );

    if (picked != null) {
      setState(() {
        txtDate_fin.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  TextEditingController txtnom = TextEditingController();
  TextEditingController txtpostnom = TextEditingController();
  TextEditingController txtprenom = TextEditingController();
  TextEditingController txtsexe = TextEditingController();
  TextEditingController txtorg_privee = TextEditingController();
  TextEditingController txtFormation = TextEditingController();
  TextEditingController txtpaiement = TextEditingController();
  TextEditingController txtDate_debut = TextEditingController();
  TextEditingController txtDate_fin = TextEditingController();
  TextEditingController txtLieu = TextEditingController();
  TextEditingController txtTelephone = TextEditingController();
  TextEditingController txtEmail = TextEditingController();
  TextEditingController txtNomOrganisation = TextEditingController();

  String? selectedOption = 'Organisation';

  //insert data
  Future<void> insertData() async {
    final response = await http.post(
      Uri.parse("http://192.168.43.148:81/MRG/insertuser.php"),
      body: {
        'nom': txtnom.text,
        'postnom': txtpostnom.text,
        'prenom': txtprenom.text,
        'sexe': txtsexe.text,
        'org_privee': selectedOption,
        'nom_organisation':
            selectedOption == 'Organisation' ? txtNomOrganisation.text : '',
        'Formation': txtFormation.text,
        'paiement': txtpaiement.text,
        'Date_debut': txtDate_debut.text,
        'Date_fin': txtDate_fin.text,
        'Lieu': txtLieu.text,
        'Telephone': txtTelephone.text,
        'Email': txtEmail.text,
      },
    );
    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      if (responseData == "success") {
        // Effacer les champs de saisie
        txtnom.clear();
        txtpostnom.clear();
        txtprenom.clear();
        txtsexe.clear();
        txtorg_privee.clear();
        txtFormation.clear();
        txtpaiement.clear();
        txtDate_debut.clear();
        txtDate_fin.clear();
        txtLieu.clear();
        txtTelephone.clear();
        txtEmail.clear();
        txtNomOrganisation.clear();

        // Afficher un message de confirmation
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Enregistrement réussi'),
          ),
        );
      } else {
        // Afficher un message d'erreur en cas d'échec
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Erreur lors de l\'enregistrement'),
          ),
        );
      }
    } else {
      // Afficher un message d'erreur en cas d'échec de la requête HTTP
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Erreur de connexion au serveur'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
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
                "FORMULAIRE D'INSCRIPTION",
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 20),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: ListTile(
                leading: const CircleAvatar(
                  radius: 20,
                  backgroundImage: AssetImage('assets/perce.png'),
                ),
                title: const Text('perce.formation@gmail.com'),
                subtitle: const Text('+243 828797626'),
                trailing: IconButton(
                  onPressed: () async {
                    await FlutterPhoneDirectCaller.callNumber(number);
                  },
                  icon: const Icon(Icons.call),
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 30),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                controller: txtnom,
                decoration: const InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white54),
                    ),
                    fillColor: Colors.white54,
                    filled: true,
                    hintText: 'Votre nom',
                    labelText: 'Nom'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                controller: txtpostnom,
                decoration: const InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white54),
                    ),
                    fillColor: Colors.white54,
                    filled: true,
                    hintText: 'Votre postnom',
                    labelText: 'PostNom'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                controller: txtprenom,
                decoration: const InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white54),
                    ),
                    fillColor: Colors.white54,
                    filled: true,
                    hintText: 'Votre prenom',
                    labelText: 'PreNom'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                controller: txtsexe,
                decoration: const InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white54),
                    ),
                    fillColor: Colors.white54,
                    filled: true,
                    hintText: 'Votre sexe',
                    labelText: 'Sexe'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: DropdownButtonFormField<String>(
                value: selectedOption,
                decoration: const InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white54),
                  ),
                  fillColor: Colors.white54,
                  filled: true,
                  labelText: 'Organisation ou privée',
                ),
                items: ['Organisation', 'Privée']
                    .map((label) => DropdownMenuItem(
                          child: Text(label),
                          value: label,
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedOption = value;
                  });
                },
              ),
            ),
            if (selectedOption == 'Organisation')
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextField(
                  controller: txtNomOrganisation,
                  decoration: const InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white54),
                      ),
                      fillColor: Colors.white54,
                      filled: true,
                      hintText: 'Nom de l\'organisation',
                      labelText: 'Nom de l\'organisation'),
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                controller: txtFormation,
                decoration: const InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white54),
                    ),
                    fillColor: Colors.white54,
                    filled: true,
                    hintText: 'Vous voulez quel formation',
                    labelText: 'Formation'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                controller: txtpaiement,
                decoration: const InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white54),
                    ),
                    fillColor: Colors.white54,
                    filled: true,
                    hintText: 'paiement en avance ou solde',
                    labelText: 'Avance ou Solde'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                controller: txtDate_debut,
                decoration: InputDecoration(
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black12),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white54),
                  ),
                  fillColor: Colors.white54,
                  filled: true,
                  labelText: 'Date debut',
                  hintText: 'Date debut formation',
                  prefixIcon: IconButton(
                    iconSize: 15,
                    onPressed: () {},
                    icon: const Icon(Icons.calendar_today),
                  ),
                ),
                readOnly: true,
                onTap: () {
                  _selectDate();
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                controller: txtDate_fin,
                decoration: InputDecoration(
                  enabledBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black12),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white54),
                  ),
                  fillColor: Colors.white54,
                  filled: true,
                  labelText: 'Date fin',
                  hintText: 'Date fin formation',
                  prefixIcon: IconButton(
                    iconSize: 15,
                    onPressed: () {},
                    icon: const Icon(Icons.calendar_today),
                  ),
                ),
                readOnly: true,
                onTap: () {
                  _selectDatefin();
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                controller: txtLieu,
                decoration: const InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white54),
                    ),
                    fillColor: Colors.white54,
                    filled: true,
                    hintText: 'Lieu',
                    labelText: 'Choisis un lieu'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                controller: txtTelephone,
                decoration: const InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white54),
                    ),
                    fillColor: Colors.white54,
                    filled: true,
                    hintText: 'Numero tel',
                    labelText: 'Numero'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                controller: txtEmail,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white54),
                    ),
                    fillColor: Colors.white54,
                    filled: true,
                    hintText: 'Votre email',
                    labelText: 'Adresse mail'),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 30),
            ),
            ElevatedButton(
              onPressed: insertData,
              style: ElevatedButton.styleFrom(
                primary: const Color(0xFF004BA8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Center(
                child: Text("Enregistrer", style: TextStyle(fontSize: 16)),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 10),
            ),
          ],
        ),
      ),
    );
  }
}
