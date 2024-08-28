import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../navigation.dart';

class Loginadmin extends StatefulWidget {
  const Loginadmin({super.key});

  @override
  State<Loginadmin> createState() => _LoginadminState();
}

class _LoginadminState extends State<Loginadmin> {
  TextEditingController txtemail = TextEditingController();
  TextEditingController txtpassword = TextEditingController();

  Future<void> login() async {
    if (txtemail.text.isEmpty || txtpassword.text.isEmpty) {
      showErrorDialog("Veuillez remplir tous les champs.");
      return;
    }

    final response = await http.post(
      Uri.parse('http://192.168.43.149:81/MRG/selectadmin.php'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': txtemail.text,
        'password': txtpassword.text,
      }),
    );

    final responseData = jsonDecode(response.body);

    if (responseData['status'] == 'success') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => NaviagtionPage(),
        ),
      );
    } else {
      showErrorDialog(responseData['message']);
    }
  }

  void showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Erreur'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: const Text('OK'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Container en arrière-plan avec une image
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/photo.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
            child: Card(
              elevation: 8.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: Container(
                width: 650,
                height: 350,
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    // Image à gauche
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16.0),
                        child: Image.asset(
                          'assets/login.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),

                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextField(
                              controller: txtemail,
                              keyboardType: TextInputType.emailAddress,
                              decoration: const InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.black),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.black),
                                  ),
                                  fillColor: Colors.white30,
                                  filled: true,
                                  prefixIcon: Icon(
                                    Icons.email,
                                    size: 15,
                                  ),
                                  hintText: 'Email admin',
                                  labelText: 'Email'),
                            ),
                            const SizedBox(height: 16.0),
                            TextField(
                              controller: txtpassword,
                              obscureText: true,
                              decoration: const InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.black),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.black),
                                  ),
                                  fillColor: Colors.white30,
                                  filled: true,
                                  prefixIcon: Icon(
                                    Icons.password_outlined,
                                    size: 15,
                                  ),
                                  hintText: 'Votre password',
                                  labelText: 'Mot de passe'),
                            ),
                            const SizedBox(height: 24.0),
                            GestureDetector(
                              onTap: login,
                              child: Container(
                                height: 50,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Colors.blueAccent,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Center(
                                  child: Text(
                                    'Connexion',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
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
            ),
          ),
        ],
      ),
    );
  }
}
