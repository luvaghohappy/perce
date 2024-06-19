import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
      body: SingleChildScrollView(
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
                  bottomLeft: Radius.circular(25),
                  bottomRight: Radius.circular(25),
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
                          radius: 40,
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
              height: 30,
              width: w,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 11, 101, 175),
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
              style: TextStyle(fontSize: 17),
            ),
            const Text(
              'Créé depuis 2017, est une entreprise de Renforcement de capacité et accompagnement professionnel, spécialisée dans le développement des compétences informatique et de gestion.',
              style: TextStyle(fontSize: 15),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 20),
            ),
            Container(
              height: 30,
              width: w,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 11, 101, 175),
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
              style: TextStyle(fontSize: 15, color: Colors.black),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 20),
            ),
            Container(
              height: 30,
              width: w,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 11, 101, 175),
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
              style: TextStyle(fontSize: 15, color: Colors.black),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 20),
            ),
            const Text(
              'NOS VALEURS',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 10),
            ),
            const Text(
              'PROXIMITÉ',
              style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            const Text(
              'Parce-que nous privilégions le travail en face à face',
              style: TextStyle(fontSize: 15, color: Colors.black),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 10),
            ),
            const Text(
              'CONFIANCE',
              style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            const Text(
              'Parce qu’un contrat relationnel est établi avec chaque participant pour aller au cœur de ses préoccupations.',
              style: TextStyle(fontSize: 15, color: Colors.black),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 10),
            ),
            const Text(
              'CONFIDENTIALITE',
              style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            const Text(
              "Parce que vos informations ne doivent pas être exposée à la portée du public et contribuent à l'émergence de votre carrière d'une part mais aussi du bien-être de votre entreprise.",
              style: TextStyle(fontSize: 15, color: Colors.black),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 10),
            ),
            const Text(
              'ÉCOUTE',
              style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            const Text(
              'Parce-que notre travail consiste d’abord à écouter les difficultés pour prendre la chance de répondre « juste »',
              style: TextStyle(fontSize: 15, color: Colors.black),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 10),
            ),
            const Text(
              'CONSIDÉRATION',
              style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            const Text(
              'Parce qu’il n’y a pas de formateurs et de stagiaires dans notre approche. Unique',
              style: TextStyle(fontSize: 15, color: Colors.black),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 20),
            ),
            Container(
              height: 30,
              width: w,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 11, 101, 175),
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
              'Analyser vos besoins Concevoir votre réponse sur-mesure : construction de programmes, sélection des prestataires et financement Mettre en œuvre : formation intra ou inter entreprise, en collectif ou en individuel, en présentiel ou à distance Évaluer les résultats : bilan, transformation des compétences, retour sur investissements.',
              style: TextStyle(fontSize: 15, color: Colors.black),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 20),
            ),
            Container(
              height: 30,
              width: w,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 11, 101, 175),
                borderRadius: BorderRadius.circular(5),
              ),
              child: const Center(
                child: Text(
                  "NOS SECTEURS D'ACTIVITE",
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
              'FORMATION',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            const Padding(
              padding: EdgeInsets.zero,
              child: ListTile(
                leading: FaIcon(
                  FontAwesomeIcons.solidCircle,
                  size: 10,
                  color: Colors.blue,
                ),
                title: Text('Formation en Excel Avancé'),
              ),
            ),
            const Padding(
              padding: EdgeInsets.zero,
              child: ListTile(
                leading: FaIcon(
                  FontAwesomeIcons.solidCircle,
                  size: 10,
                  color: Colors.blue,
                ),
                title: Text('Formation sur la bureautique'),
              ),
            ),
            const Padding(
              padding: EdgeInsets.zero,
              child: ListTile(
                leading: FaIcon(
                  FontAwesomeIcons.solidCircle,
                  size: 10,
                  color: Colors.blue,
                ),
                title: Text('Formation en Logistique'),
              ),
            ),
            const Padding(
              padding: EdgeInsets.zero,
              child: ListTile(
                leading: FaIcon(
                  FontAwesomeIcons.solidCircle,
                  size: 10,
                  color: Colors.blue,
                ),
                title: Text('Humanitaire'),
              ),
            ),
            const Padding(
              padding: EdgeInsets.zero,
              child: ListTile(
                leading: FaIcon(
                  FontAwesomeIcons.solidCircle,
                  size: 10,
                  color: Colors.blue,
                ),
                title: Text('Formation en suivi et évaluation'),
              ),
            ),
            const Padding(
              padding: EdgeInsets.zero,
              child: ListTile(
                leading: FaIcon(
                  FontAwesomeIcons.solidCircle,
                  size: 10,
                  color: Colors.blue,
                ),
                title: Text('Formation sur le Leadership'),
              ),
            ),
            const Padding(
              padding: EdgeInsets.zero,
              child: ListTile(
                leading: FaIcon(
                  FontAwesomeIcons.solidCircle,
                  size: 10,
                  color: Colors.blue,
                ),
                title: Text('Formation HEAT Training'),
              ),
            ),
            const Padding(
              padding: EdgeInsets.zero,
              child: ListTile(
                leading: FaIcon(
                  FontAwesomeIcons.solidCircle,
                  size: 10,
                  color: Colors.blue,
                ),
                title: Text('Formation formateur occasionnel, tuteur'),
              ),
            ),
            const Padding(
              padding: EdgeInsets.zero,
              child: ListTile(
                leading: FaIcon(
                  FontAwesomeIcons.solidCircle,
                  size: 10,
                  color: Colors.blue,
                ),
                title: Text('Gagner mes négociations'),
              ),
            ),
            const Padding(
              padding: EdgeInsets.zero,
              child: ListTile(
                leading: FaIcon(
                  FontAwesomeIcons.solidCircle,
                  size: 10,
                  color: Colors.blue,
                ),
                title: Text(
                    'Formation en Entrepreneuriat et leadership transformationnel'),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 20),
            ),
            const Text(
              'AUDIT ET COACHING',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            const Padding(
              padding: EdgeInsets.zero,
              child: ListTile(
                leading: FaIcon(
                  FontAwesomeIcons.solidCircle,
                  size: 10,
                  color: Colors.blue,
                ),
                title: Text('Audit logistique'),
              ),
            ),
            const Padding(
              padding: EdgeInsets.zero,
              child: ListTile(
                leading: FaIcon(
                  FontAwesomeIcons.solidCircle,
                  size: 10,
                  color: Colors.blue,
                ),
                title: Text('Audit informatique'),
              ),
            ),
            const Padding(
              padding: EdgeInsets.zero,
              child: ListTile(
                leading: FaIcon(
                  FontAwesomeIcons.solidCircle,
                  size: 10,
                  color: Colors.blue,
                ),
                title: Text('Audit de finance'),
              ),
            ),
            const Padding(
              padding: EdgeInsets.zero,
              child: ListTile(
                leading: FaIcon(
                  FontAwesomeIcons.solidCircle,
                  size: 10,
                  color: Colors.blue,
                ),
                title: Text('Audit de Sécu'),
              ),
            ),
            const Padding(
              padding: EdgeInsets.zero,
              child: ListTile(
                leading: FaIcon(
                  FontAwesomeIcons.solidCircle,
                  size: 10,
                  color: Colors.blue,
                ),
                title: Text(
                    'Coaching individuel (Logistique, Ressources Humaines et Enquêtes sur terrain)'),
              ),
            ),
            const Padding(
              padding: EdgeInsets.zero,
              child: ListTile(
                leading: FaIcon(
                  FontAwesomeIcons.solidCircle,
                  size: 10,
                  color: Colors.blue,
                ),
                title: Text(
                    'Coaching commun (Logistique, Ressources Humaines et Enquêtes sur terrain)'),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 20),
            ),
            const Text(
              'ETUDE ET CONSEIL',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            const Padding(
              padding: EdgeInsets.zero,
              child: ListTile(
                leading: FaIcon(
                  FontAwesomeIcons.solidCircle,
                  size: 10,
                  color: Colors.blue,
                ),
                title: Text('Étude des projets rentable'),
              ),
            ),
            const Padding(
              padding: EdgeInsets.zero,
              child: ListTile(
                leading: FaIcon(
                  FontAwesomeIcons.solidCircle,
                  size: 10,
                  color: Colors.blue,
                ),
                title: Text(
                    "Conception des plans d'affaires adaptées aux contextes locaux"),
              ),
            ),
            const Padding(
              padding: EdgeInsets.zero,
              child: ListTile(
                leading: FaIcon(
                  FontAwesomeIcons.solidCircle,
                  size: 10,
                  color: Colors.blue,
                ),
                title: Text('Conception des plans de gestion'),
              ),
            ),
            const Padding(
              padding: EdgeInsets.zero,
              child: ListTile(
                leading: FaIcon(
                  FontAwesomeIcons.solidCircle,
                  size: 10,
                  color: Colors.blue,
                ),
                title: Text(
                    "Conception projets d'urgence humanitaire et développement"),
              ),
            ),
            const Padding(
              padding: EdgeInsets.zero,
              child: ListTile(
                leading: FaIcon(
                  FontAwesomeIcons.solidCircle,
                  size: 10,
                  color: Colors.blue,
                ),
                title: Text('Conception des plans Sécu'),
              ),
            ),
            const Padding(
              padding: EdgeInsets.zero,
              child: ListTile(
                leading: FaIcon(
                  FontAwesomeIcons.solidCircle,
                  size: 10,
                  color: Colors.blue,
                ),
                title: Text('Gestion rationnelle des ressources naturelles'),
              ),
            ),
            const Padding(
              padding: EdgeInsets.zero,
              child: ListTile(
                leading: FaIcon(
                  FontAwesomeIcons.solidCircle,
                  size: 10,
                  color: Colors.blue,
                ),
                title: Text('Conception des plans de gestion'),
              ),
            ),
            const Padding(
              padding: EdgeInsets.zero,
              child: ListTile(
                leading: FaIcon(
                  FontAwesomeIcons.solidCircle,
                  size: 10,
                  color: Colors.blue,
                ),
                title: Text(
                    "Conception projets d'urgence humanitaire et développement"),
              ),
            ),
            const Padding(
              padding: EdgeInsets.zero,
              child: ListTile(
                leading: FaIcon(
                  FontAwesomeIcons.solidCircle,
                  size: 10,
                  color: Colors.blue,
                ),
                title: Text('Gestion des priorités'),
              ),
            ),
            const Padding(
              padding: EdgeInsets.zero,
              child: ListTile(
                leading: FaIcon(
                  FontAwesomeIcons.solidCircle,
                  size: 10,
                  color: Colors.blue,
                ),
                title: Text('Gestion de tress'),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 20),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 150),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: const [
                        FaIcon(
                          FontAwesomeIcons.locationPin,
                          size: 10,
                          color: Colors.blue,
                        ),
                        SizedBox(width: 5),
                        Text(
                          '36 Rue du Fleuve, Q. Katoyi,',
                          style: TextStyle(fontSize: 10),
                        ),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: const [
                        SizedBox(width: 5),
                        Text(
                          'Commune de Karisimbi, Goma RDC',
                          style: TextStyle(fontSize: 10),
                        ),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: const [
                        FaIcon(
                          FontAwesomeIcons.phone,
                          size: 10,
                          color: Colors.blue,
                        ),
                        SizedBox(width: 5),
                        Text(
                          '+243 828 797 626 | +243 899 117 141 |',
                          style: TextStyle(fontSize: 10),
                        ),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: const [
                        FaIcon(
                          FontAwesomeIcons.phone,
                          size: 10,
                          color: Colors.blue,
                        ),
                        SizedBox(width: 5),
                        Text(
                          ' +243 977 698 016',
                          style: TextStyle(fontSize: 10),
                        ),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: const [
                        Icon(
                          Icons.mail,
                          size: 10,
                          color: Colors.blue,
                        ),
                        SizedBox(width: 5),
                        Text(
                          'perce.formation@gmail.com',
                          style: TextStyle(fontSize: 10),
                        ),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: const [
                        FaIcon(
                          FontAwesomeIcons.facebook,
                          size: 10,
                          color: Colors.blue,
                        ),
                        SizedBox(width: 5),
                        FaIcon(
                          FontAwesomeIcons.linkedinIn,
                          size: 10,
                          color: Colors.blue,
                        ),
                        SizedBox(width: 5),
                        FaIcon(
                          FontAwesomeIcons.twitter,
                          size: 10,
                          color: Colors.blue,
                        ),
                        SizedBox(width: 5),
                        Text(
                          'Perce RDC',
                          style: TextStyle(fontSize: 10),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
