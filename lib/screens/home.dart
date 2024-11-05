import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Conseiller Agricole"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Option Diagnostic
            ElevatedButton.icon(
              icon: Icon(Icons.camera_alt),
              label: Text("Diagnostic"),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                textStyle: TextStyle(fontSize: 18),
              ),
              onPressed: () {
                // Naviguer vers l'écran de diagnostic
                Navigator.pushNamed(context, '/diagnostic');
              },
            ),
            SizedBox(height: 16),

            // Option Conseils
            ElevatedButton.icon(
              icon: Icon(Icons.info),
              label: Text("Conseils"),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                textStyle: TextStyle(fontSize: 18),
              ),
              onPressed: () {
                // Naviguer vers l'écran de conseils
                Navigator.pushNamed(context, '/conseils');
              },
            ),
            SizedBox(height: 16),

            // Option Météo
            ElevatedButton.icon(
              icon: Icon(Icons.wb_sunny),
              label: Text("Météo"),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                textStyle: TextStyle(fontSize: 18),
              ),
              onPressed: () {
                // Naviguer vers l'écran de météo
                Navigator.pushNamed(context, '/meteo');
              },
            ),
          ],
        ),
      ),
    );
  }
}
