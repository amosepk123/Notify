import 'package:call/locations.dart';
import 'package:call/profile/profile.dart';
import 'package:flutter/material.dart';

import 'Map/googleMap_implement.dart';
import 'Map/original.dart';
import 'contact.dart';
import 'histroy.dart';
import 'home.dart';
import 'location.dart';

class bot extends StatefulWidget {
  const bot({super.key});

  @override
  State<bot> createState() => _botState();
}

class _botState extends State<bot> {
  int _index=0;
  final screen=[
    HomePage(),
    ContactPage(),
    // Histroy(),
    GGGG(),
    Profile(),


  ];

  void tap(index){
    setState(() {
      _index=index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screen[_index],
      bottomNavigationBar: BottomNavigationBar(items: [
        BottomNavigationBarItem(icon: Icon(Icons.home),label: "Home"),
        BottomNavigationBarItem(icon: Icon(Icons.person),label: "Contact"),
        // BottomNavigationBarItem(icon: Icon(Icons.history),label: "Histroy"),
        BottomNavigationBarItem(icon: Icon(Icons.location_on_outlined),label: "Location"),
        BottomNavigationBarItem(icon: Icon(Icons.account_circle_outlined),label: "Profile"),

      ],
        currentIndex: _index,
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.cyan,
        onTap: tap,
      ),


    );
  }
}
