import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

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

  Future<void> sendEmail(String email, String nom, String postnom,
      String prenom, String formation, DateTime dateDebut) async {
    String username = 'perce.formation@gmail.com';
    String password = 'PERCE2017';

    final smtpServer = gmail(username, password);
    final message = Message()
      ..from = Address(username, 'PERCE RD Congo')
      ..recipients.add(email)
      ..subject = 'Inscription réussie à une formation'
      ..text =
          'Bonjour $prenom $nom $postnom,\n\nVous avez été inscrit à la formation $formation.et'
              'Votre formation commence dans ${dateDebut.difference(DateTime.now()).inDays} jours.';

    try {
      final sendReport = await send(message, smtpServer);
      print('Message sent: ' + sendReport.toString());
    } on MailerException catch (e) {
      print('Message not sent. \n' + e.toString());
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
  String? selected;
  String? selectedsexe;
  String? selectedformation;

  //insert data
  Future<void> insertData() async {
    final response = await http.post(
      Uri.parse("http://192.168.43.149:81/MRG/insertuser.php"),
      body: {
        'nom': txtnom.text,
        'postnom': txtpostnom.text,
        'prenom': txtprenom.text,
        'sexe': selectedsexe,
        'org_privee': selectedOption,
        'nom_organisation':
            selectedOption == 'Organisation' ? txtNomOrganisation.text : '',
        'Formation': selectedformation,
        'paiement': selected,
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

        // Envoyer l'email de confirmation
        sendEmail(
          txtEmail.text,
          txtnom.text,
          txtpostnom.text,
          txtprenom.text,
          selectedformation!,
          DateTime.parse(txtDate_debut.text),
        );

        // Afficher un message de confirmation
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Enregistrement réussi et email envoyé'),
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

  List<String> designations = [];

  @override
  void initState() {
    super.initState();
    fetchDesignations();
  }

  Future<void> fetchDesignations() async {
    try {
      final response = await http.get(
        Uri.parse("http://192.168.43.149:81/MRG/formation.php"),
      );
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        setState(() {
          designations =
              data.map((item) => item['designation'] as String).toList();
        });
      } else {
        throw Exception('Failed to load designations');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to load designations: $e'),
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
              padding: const EdgeInsets.only(left: 5),
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
                      borderSide: BorderSide(color: Colors.black),
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
                      borderSide: BorderSide(color: Colors.black),
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
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    fillColor: Colors.white54,
                    filled: true,
                    hintText: 'Votre prenom',
                    labelText: 'PreNom'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: DropdownButtonFormField<String>(
                value: selectedsexe,
                decoration: const InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  fillColor: Colors.white54,
                  filled: true,
                  labelText: 'Sexe',
                ),
                items: ['Feminin', 'Masculin']
                    .map((label) => DropdownMenuItem(
                          child: Text(label),
                          value: label,
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedsexe = value;
                  });
                },
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
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  fillColor: Colors.white54,
                  filled: true,
                  labelText: 'Est vous une organisation ou privee',
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
                        borderSide: BorderSide(color: Colors.black),
                      ),
                      fillColor: Colors.white54,
                      filled: true,
                      hintText: 'Nom de l\'organisation',
                      labelText: 'Nom de l\'organisation'),
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: DropdownButtonFormField<String>(
                value: selectedformation,
                decoration: const InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  fillColor: Colors.white54,
                  filled: true,
                  labelText: 'Formation',
                ),
                items: designations.map((designation) {
                  return DropdownMenuItem<String>(
                    value: designation,
                    child: Text(designation),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedformation = value;
                  });
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: DropdownButtonFormField<String>(
                value: selected,
                decoration: const InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  fillColor: Colors.white54,
                  filled: true,
                  labelText: 'Paiement',
                ),
                items: ['Solde', 'Avance']
                    .map((label) => DropdownMenuItem(
                          child: Text(label),
                          value: label,
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    selected = value;
                  });
                },
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
                    borderSide: BorderSide(color: Colors.black),
                  ),
                  fillColor: Colors.white54,
                  filled: true,
                  labelText: 'Date disponibilité',
                  hintText: 'Date début',
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
                    borderSide: BorderSide(color: Colors.black),
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
                      borderSide: BorderSide(color: Colors.black),
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
                      borderSide: BorderSide(color: Colors.black),
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
                      borderSide: BorderSide(color: Colors.black),
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
                backgroundColor: const Color(0xFF004BA8),
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
