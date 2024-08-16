import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import 'FirebaseNotification.dart';

class summa extends StatefulWidget {
  const summa({super.key});

  @override
  State<summa> createState() => _summaState();
}

class _summaState extends State<summa> {
  final FirebaseController dataController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Obx(()=>Text(dataController.token as String)),

        ],
      ),
    );
  }
}
