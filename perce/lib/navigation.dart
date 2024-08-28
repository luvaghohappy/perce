import 'package:flutter/material.dart';
import 'package:perce/firstpage.dart';
import 'package:perce/lespages/formation.dart';
import 'lespages/service.dart';

class NaviagtionPage extends StatefulWidget {
  NaviagtionPage({super.key});

  @override
  State<NaviagtionPage> createState() => _NaviagtionPageState();
}

class _NaviagtionPageState extends State<NaviagtionPage> {
  @override
  int currentindex = 0;
  List<Widget> screen = [
    const Myfirstpage(),
    const Formations(),
    const Services(),
  ];
  void _listbotton(int index) {
    currentindex = index;
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2D2E33),
      body: Container(),
      bottomSheet: screen[currentindex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        selectedItemColor: Colors.black54,
        unselectedItemColor: Colors.black,
        currentIndex: currentindex,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            currentindex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              (Icons.home),
              size: 20,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              (Icons.window_sharp),
              size: 20,
            ),
            label: 'Formation',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              (Icons.help),
              size: 20,
            ),
            label: 'Services',
          ),
        ],
      ),
    );
  }
}
