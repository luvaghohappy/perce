import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:printing/printing.dart';
import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pdfLib;

class Fiche extends StatefulWidget {
  final String id;

  Fiche(this.id);

  @override
  State<Fiche> createState() => _FicheState();
}

class _FicheState extends State<Fiche> {
  final String schoolName = "FORMATION MRG";
  final String formateur = "Mr Bienfait";
  String nom = "Nom";
  String postnom = "Postnom";
  String prenom = "Prenom";
  String sexe = "sexe";
  String org_privee = "organisation";
  String nom_organisation = "nom_organisation";
  String formation = "Formation";
  String paiement = "paiement";
  String Date_debut = "Date_debut";
  String Date_fin = "Date_fin";
  String Lieu = "Lieu";
  String Telephone = "Telephone";
  String Email = "Email";
  int receiptNumber = 0;

  @override
  void initState() {
    super.initState();
    _fetchReceiptData();
  }

  //imprimer recu
  //
  Future<Uint8List> generatePdf() async {
    final pdf = pdfLib.Document();

    // Add content to PDF
    pdf.addPage(
      pdfLib.Page(
        build: (context) {
          return pdfLib.Column(
            crossAxisAlignment: pdfLib.CrossAxisAlignment.start,
            children: [
              pdfLib.SizedBox(height: 10),
              pdfLib.Text(
                "FICHE D'INSCRIPTION A LA FORMATION",
                style: pdfLib.TextStyle(
                    fontWeight: pdfLib.FontWeight.bold, fontSize: 15),
              ),
              pdfLib.SizedBox(height: 20),
              pdfLib.Text('Fiche de: $nom $postnom $prenom'),
              pdfLib.Text('Sexe:$sexe'),
              pdfLib.Text('Numero de telephone:$Telephone'),
              pdfLib.Text('Email:$Email'),
              pdfLib.Text('Formation en :$formation '),
              pdfLib.Text(',Inscrit(e) le $Date_debut , Termine le: $Date_fin'),
              pdfLib.Text(
                  'organisation: $org_privee ,nom organisation $nom_organisation'),
              pdfLib.Text('paiement en : $paiement'),
              pdfLib.Text('Lieu: $Lieu'),
              pdfLib.SizedBox(height: 10),
              pdfLib.SizedBox(width: 30),
              pdfLib.Text('Signé par le Formateur: $formateur'),
            ],
          );
        },
      ),
    );

    // Return PDF as bytes
    return pdf.save();
  }

//print
//
//
  Future<void> printPdf() async {
    final pdfBytes = await generatePdf();
    await Printing.layoutPdf(
      onLayout: (format) async => pdfBytes,
    );
  }

//charger les donnees
  Future<void> _fetchReceiptData() async {
    try {
      final response = await http.get(
          Uri.parse('http://192.168.43.149:81/MRG/fiche.php?id=${widget.id}'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> receiptData = jsonDecode(response.body);
        setState(() {
          nom = receiptData['nom'];
          postnom = receiptData['postnom'];
          prenom = receiptData['prenom'];
          sexe = receiptData['sexe'];
          org_privee = receiptData['org_privee'];
          nom_organisation = receiptData['nom_organisation'];
          formation = receiptData['Formation'];
          paiement = receiptData['paiement'];
          Date_debut = receiptData['Date_debut'];
          Date_fin = receiptData['Date_fin'];
          Lieu = receiptData['Lieu'];
          Telephone = receiptData['Telephone'];
          Email = receiptData['Email'];

          // Calculate total based on class
        });
      } else {
        // Handle non-200 status code
        throw Exception('Failed to load receipt data: ${response.statusCode}');
      }
    } catch (e) {
      // Handle any errors during the request
      print('Error fetching receipt data: $e');
      // Show error message to user
      // You can implement this part
    }
  }

  //file picker

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.blue,
        title: const Text('Fiche Inscription'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const SizedBox(width: 10),
          Text(
            schoolName,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20.0),
          Text(
            'Fiche N° $receiptNumber',
            style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          ),
          const Padding(padding: EdgeInsets.only(top: 20)),
          Text(
            'Fiche de: $nom $postnom $prenom',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const Padding(padding: EdgeInsets.only(top: 10)),
          Text('sexe:$sexe'),
          const Padding(padding: EdgeInsets.only(top: 10)),
          Text(
            'Numero de telephone:$Telephone ,Email:$Email',
          ),
          const Padding(padding: EdgeInsets.only(top: 10)),
          Text(
            'Formation en :$formation ,Inscrit(e) le $Date_debut , Termine le: $Date_fin',
          ),
          const Padding(padding: EdgeInsets.only(top: 10)),
          Text(
              'organisation: $org_privee , nom organisation: $nom_organisation'),
          const Padding(padding: EdgeInsets.only(top: 10)),
          Text('paiement en : $paiement'),
          const Padding(padding: EdgeInsets.only(top: 10)),
          Text('Lieu: $Lieu'),
          const Padding(padding: EdgeInsets.only(top: 20)),
          Text(
            "Signé par le Formateur: $formateur",
          ),
          const Padding(padding: EdgeInsets.only(top: 100)),
          ElevatedButton(
            onPressed: () async {
              setState(() {
                receiptNumber++; // Increment receipt number
              });
              await printPdf(); // Generate and print PDF
            },
            child: const Text('Imprimer'),
          ),
        ]),
      ),
    );
  }
}
