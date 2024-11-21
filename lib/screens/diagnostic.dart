import 'package:flutter/material.dart';

class DiagnosticPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Diagnostic"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.camera_alt, size: 80, color: Colors.green),
            SizedBox(height: 20),
            Text(
              "Analyser une photo pour le diagnostic",
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Logique d'analyse de l'image
              },
              child: Text("Télécharger une photo"),
            ),
          ],
        ),
      ),
    );
  }
}
