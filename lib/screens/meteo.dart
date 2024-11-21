import 'package:agripas/screens/map.dart';
import 'package:agripas/screens/webMap.dart';
import 'package:flutter/material.dart';

class MeteoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Météo"),
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // Icon(Icons.wb_sunny, size: 80, color: Colors.orange),
              // SizedBox(height: 5),
              Text(
                "Prévisions Météo",
                style: TextStyle(fontSize: 12),
                textAlign: TextAlign.center,
              ),
              // SizedBox(height: 5),
              // Text(
              //   "Détails météorologiques à venir...",
              //   style: TextStyle(fontSize: 12),
              //   textAlign: TextAlign.center,
              // ),
              SenegalMapPage()
              // Ajoutez des informations météo dynamiques ici
            ],
          ),
        ),
      ),
    );
  }
}
