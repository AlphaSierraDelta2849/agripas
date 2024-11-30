import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:agripas/compoments/menu.dart';
import 'package:agripas/compoments/header.dart';

class DiagnosticPage extends StatefulWidget {
  const DiagnosticPage({Key? key}) : super(key: key);

  @override
  State<DiagnosticPage> createState() => _DiagnosticPageState();
}

class _DiagnosticPageState extends State<DiagnosticPage> {
  Uint8List? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  // Fonction pour sélectionner une image
  Future<void> _selectImage() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        final Uint8List imageBytes = await pickedFile.readAsBytes();
        setState(() {
          _selectedImage = imageBytes;
        });
      }
    } catch (e) {
      print("Erreur lors de la sélection d'image : $e");
    }
  }

  // Fonction pour prendre une photo
  Future<void> _captureImage() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(source: ImageSource.camera);
      if (pickedFile != null) {
        final Uint8List imageBytes = await pickedFile.readAsBytes();
        setState(() {
          _selectedImage = imageBytes;
        });
      }
    } catch (e) {
      print("Erreur lors de la capture d'image : $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: SafeArea(
        child: Column(
          children: [
            const HeaderWidget(),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildLocalAlertsSection(),
                    const SizedBox(height: 16),
                    _buildAssistedDetectionSection(),
                    const SizedBox(height: 16),
                    _buildTreatmentRecommendations(),
                    const SizedBox(height: 16),
                    _buildAlertHistory(),
                  ],
                ),
              ),
            ),
            const MenuWidget(), // Ajout du menu
          ],
        ),
      ),
    );
  }

  // Alertes Locales ⚠️
  Widget _buildLocalAlertsSection() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Alertes Locales",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
          ),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: Colors.orange.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                const Icon(Icons.warning, color: Colors.orange, size: 30),
                const SizedBox(width: 12),
                Expanded(
                  child: const Text(
                    "Alerte critique : Pucerons détectés dans votre région. Risque élevé !",
                    style: TextStyle(color: Colors.black, fontSize: 14),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.info, color: Colors.orange),
                  onPressed: () {
                    print("Afficher détails des alertes.");
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildAlertCard("Pucerons", "Risque : Élevé", Colors.red),
              _buildAlertCard("Mildiou", "Risque : Moyen", Colors.orange),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAlertCard(String name, String riskLevel, Color color) {
    return Flexible(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: color.withOpacity(0.3),
              child: Icon(FontAwesomeIcons.bug, color: color, size: 24),
            ),
            const SizedBox(height: 8),
            Text(
              name,
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: color),
            ),
            Text(
              riskLevel,
              style: const TextStyle(fontSize: 12, color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }

  // Détection Assistée 📷
  Widget _buildAssistedDetectionSection() {
    return Container(
      color: Colors.green.shade50,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Détection Assistée",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton.icon(
                onPressed: _selectImage,
                icon: const Icon(Icons.image),
                label: const Text("Galerie"),
                style: ElevatedButton.styleFrom(iconColor:  Colors.green),
              ),
              ElevatedButton.icon(
                onPressed: _captureImage,
                icon: const Icon(Icons.camera_alt),
                label: const Text("Caméra"),
                style: ElevatedButton.styleFrom(iconColor: Colors.green),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (_selectedImage != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.memory(_selectedImage!, height: 200, fit: BoxFit.cover),
            ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.info, color: Colors.green, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: const Text(
                  "Téléchargez une photo ou prenez une photo pour identifier les ravageurs ou maladies présents sur vos cultures.",
                  style: TextStyle(fontSize: 14, color: Colors.black),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Conseils de Traitement 🧴
  Widget _buildTreatmentRecommendations() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Conseils de Traitement",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
          ),
          const SizedBox(height: 8),
          _buildTreatmentCard(
            "Pucerons",
            "Utilisez un mélange de savon noir dilué et d'eau pour traiter naturellement vos plantes.",
            Colors.orange,
          ),
          const SizedBox(height: 12),
          _buildTreatmentCard(
            "Mildiou",
            "Appliquez un fongicide naturel à base de cuivre pour limiter la propagation.",
            Colors.blue,
          ),
        ],
      ),
    );
  }

  Widget _buildTreatmentCard(String title, String description, Color color) {
    return Container(
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: color.withOpacity(0.3),
            child: Icon(FontAwesomeIcons.sprayCan, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(fontSize: 14, color: Colors.black87),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Historique des Alertes 📅
  Widget _buildAlertHistory() {
    return Container(
      color: Colors.grey.shade100,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Historique des Alertes",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _buildAlertHistoryItem("Pucerons", "20/11/2024", Colors.orange)),
              Expanded(child: _buildAlertHistoryItem("Mildiou", "18/11/2024", Colors.blue)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAlertHistoryItem(String name, String date, Color color) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Text(name, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: color)),
          const SizedBox(height: 4),
          Text(date, style: const TextStyle(fontSize: 12, color: Colors.black)),
        ],
      ),
    );
  }
}
