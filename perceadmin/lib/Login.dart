import 'package:flutter/material.dart';
import '../foramationUsers.dart';
import 'navigation.dart';

class Loginadmin extends StatefulWidget {
  const Loginadmin({super.key});

  @override
  State<Loginadmin> createState() => _LoginadminState();
}

class _LoginadminState extends State<Loginadmin> {
  TextEditingController txtemail = TextEditingController();
  TextEditingController txtpassword = TextEditingController();

  void login() {
    if (txtemail.text.isEmpty || txtpassword.text.isEmpty) {
      showErrorDialog("Veuillez remplir tous les champs.");
      return;
    }

    if (txtemail.text == "perce@gmail.com" && txtpassword.text == "1234") {
      // Navigate to Users page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => NaviagtionPage(),
        ),
      );
    } else {
      showErrorDialog("Email ou mot de passe incorrect.");
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 100),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Row(
                children: const [
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: AssetImage('assets/perce.png'),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 10),
                  ),
                  Text(
                    'FORMATION PERCE ADMIN',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 60),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: TextField(
                controller: txtemail,
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
                    prefixIcon: Icon(Icons.email),
                    hintText: 'Email admin',
                    labelText: 'Email'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: TextField(
                controller: txtpassword,
                decoration: const InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white54),
                    ),
                    fillColor: Colors.white54,
                    filled: true,
                    prefixIcon: Icon(Icons.password_outlined),
                    hintText: 'Votre password',
                    labelText: 'Mot de passe'),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 30),
            ),
            GestureDetector(
              onTap: login,
              child: Container(
                height: 50,
                width: 250,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Center(
                  child: Text(
                    'Connexion',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
