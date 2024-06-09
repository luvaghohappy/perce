import 'package:flutter/material.dart';

class Myfirstpage extends StatefulWidget {
  const Myfirstpage({super.key});

  @override
  State<Myfirstpage> createState() => _MyfirstpageState();
}

class _MyfirstpageState extends State<Myfirstpage> {
  @override
  Widget build(BuildContext context) {
    final h = MediaQuery.of(context).size.height;
    final w = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    height: h * 0.4,
                    width: w,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(
                            'https://beaubourg-avocats.fr/wp-content/uploads/2021/03/contrat-formation-informatique-scaled.jpg'),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      ),
                    ),
                    child: Stack(
                      children: [
                        Positioned(
                          top: 10,
                          left: 30,
                          child: Column(
                            children: const [
                              CircleAvatar(
                                radius: 50,
                                backgroundImage: AssetImage('assets/perce.png'),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 10),
                  ),
                  Container(
                    height: 40,
                    width: 350,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: const Center(
                      child: Text(
                        'QUI SOMMES NOUS ?',
                        style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 10),
                  ),
                  const Text(
                    'Programme Élargi pour le Renforce de Capacités « PERCE » en sigle.',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                  ),
                  const Text(
                    'Créé depuis 2017, est une entreprise de Renforcement de capacité et accompagnement professionnel, spécialisée dans le développement des compétences informatique et de gestion.',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 20),
                  ),
                  Container(
                    height: 40,
                    width: 350,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: const Center(
                      child: Text(
                        'NOTRE VISION',
                        style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 20),
                  ),
                  const Text(
                    "Faire grandir les personnes pour faire grandir I' entreprise.Une offre de formation adaptée à chaque public (salariés permanents, intérimaires, demandeurs d'emploi...)La création de formations sur-mesure (tous types de niveaux, professionnalisation, formateur)Des formateurs spécialisés dans leurs domaines d'activité Un réseau de partenaires Une souplesse et une réactivité d 'organisatio",
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 20),
                  ),
                  Container(
                    height: 40,
                    width: 350,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: const Center(
                      child: Text(
                        'NOTRE MISSION',
                        style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 20),
                  ),
                  const Text(
                    "Développer les compétences professionnelles à travers une gamme d'activité diversifiée et conçue sur mesure.",
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 20),
                  ),
                  Container(
                    height: 40,
                    width: 350,
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: const Center(
                      child: Text(
                        "NOS SECTEURS D'ACTIVITES",
                        style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 20),
                  ),
                  Row(
                    children: [
                      Column(
                        children: const [
                          Text(
                            'Formation',
                            style: TextStyle(
                                fontSize: 17, fontWeight: FontWeight.bold),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 10),
                          ),
                          Text(
                            'Formation professionnel',
                            style: TextStyle(
                                fontSize: 17, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const Padding(
                        padding: EdgeInsets.only(left: 20),
                      ),
                      Column(
                        children: const [
                          Text(
                            'Audit et coaching',
                            style: TextStyle(
                                fontSize: 17, fontWeight: FontWeight.bold),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 10),
                          ),
                          Text(
                            'Etude et conseil',
                            style: TextStyle(
                                fontSize: 17, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 20),
          ),
          Container(
            height: 40,
            width: 350,
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(5),
            ),
            child: const Center(
              child: Text(
                "Formation et Accompagnement Professionnel",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 20),
          ),
          const Text(
            'Nos valeurs',
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const Text(
            'PROXIMITÉ',
            style: TextStyle(
                fontSize: 17, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const Text(
            'Parce-que nous privilégions le travail en face à face',
            style: TextStyle(
                fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const Text(
            'CONFIANCE',
            style: TextStyle(
                fontSize: 17, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const Text(
            'Parce qu’un contrat relationnel est établi avec chaque participant pour aller au cœur de ses préoccupations.',
            style: TextStyle(
                fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const Text(
            'CONFIDENTIALITE',
            style: TextStyle(
                fontSize: 17, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const Text(
            "Parce que vos informations ne doivent pas être exposée à la portée du public et contribuent à l'émergence de votre carrière d'une part mais aussi du bien-être de votre entreprise.",
            style: TextStyle(
                fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const Text(
            'ÉCOUTE',
            style: TextStyle(
                fontSize: 17, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const Text(
            'Parce-que notre travail consiste d’abord à écouter les difficultés pour prendre la chance de répondre « juste »',
            style: TextStyle(
                fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const Text(
            'CONSIDÉRATION',
            style: TextStyle(
                fontSize: 17, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const Text(
            'Parce qu’il n’y a pas de formateurs et de stagiaires dans notre approche. Unique',
            style: TextStyle(
                fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 20),
          ),
          Container(
            height: 40,
            width: 350,
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(5),
            ),
            child: const Center(
              child: Text(
                "NOTRE SAVOIR-FAIRE",
                style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 20),
          ),
          const Text(
            'Analyser vos besoinsConcevoir votre réponse sur-mesure : construction de programmes, sélection des prestataires et financement Mettre en œuvre : formation intra ou inter entreprise, en collectif ou en individuel, en présentiel ou à distance Évaluer les résultats : bilan, transformation des compétences, retour sur investissements.',
            style: TextStyle(
                fontSize: 17, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
