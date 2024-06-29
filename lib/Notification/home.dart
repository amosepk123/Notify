import 'package:flutter/material.dart';

class hoome extends StatefulWidget {
  const hoome({super.key});

  @override
  State<hoome> createState() => _hoomeState();
}

class _hoomeState extends State<hoome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Text("Welocme home")
        ],
      ),
    );
  }
}
