import 'package:flutter/material.dart';

class ConseilsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Conseils"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.info, size: 80, color: Colors.blue),
              SizedBox(height: 20),
              Text(
                "Recommandations pour vos cultures",
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              Text(
                "Voici quelques conseils généraux pour une bonne santé des plantes.",
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              // Ajoutez plus de conseils ici
            ],
          ),
        ),
      ),
    );
  }
}
