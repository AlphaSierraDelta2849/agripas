import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:agripas/services/weather.dart';

class ForumPage extends StatefulWidget {
  const ForumPage({Key? key}) : super(key: key);

  @override
  State<ForumPage> createState() => _ForumPageState();
}

class _ForumPageState extends State<ForumPage> {
  final WeatherService weatherService = WeatherService();
  final ImagePicker _picker = ImagePicker();
  Uint8List? _selectedImage;
  String? weatherInfo;
  List<String> notes = []; // Liste des observations (notes)

  @override
  void initState() {
    super.initState();
    _fetchWeather();
  }

  Future<void> _fetchWeather() async {
    try {
      final data = await weatherService.fetchWeatherData(14.6928, -17.4467); // Dakar
      setState(() {
        weatherInfo =
            "Température : ${data.first['temperature']}°C\nPrécipitations : ${data.first['rain']} mm";
      });
    } catch (e) {
      setState(() {
        weatherInfo = "Erreur lors de la récupération des données météo.";
      });
    }
  }

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
      print("Erreur lors de la sélection de l'image : $e");
    }
  }

  Future<void> _addNote() async {
    String? newNote = await showDialog(
      context: context,
      builder: (context) {
        TextEditingController noteController = TextEditingController();
        return AlertDialog(
          title: const Text("Ajouter une Observation"),
          content: TextField(
            controller: noteController,
            decoration: const InputDecoration(hintText: "Écrivez votre note ici..."),
            maxLines: 3,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Annuler"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context, noteController.text);
              },
              child: const Text("Ajouter"),
            ),
          ],
        );
      },
    );

    if (newNote != null && newNote.isNotEmpty) {
      setState(() {
        notes.add(newNote);
      });
    }
  }

  Future<void> _showWeatherDialog() async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Rapport Météo"),
          content: Text(weatherInfo ?? "Données météo indisponibles."),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Fermer"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildDiscussionList(),
                    const SizedBox(height: 16),
                    _buildCommunityRecommendations(),
                    const SizedBox(height: 16),
                    _buildSharingOptions(),
                    const SizedBox(height: 16),
                    if (_selectedImage != null) _buildImagePreview(),
                    const SizedBox(height: 16),
                    _buildPublicationHistory(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNote,
        backgroundColor: Colors.green,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.green,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "Forum Agricole",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {
              print("Rechercher dans le forum");
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDiscussionList() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Discussions", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          _buildDiscussionCard(
              "Comment optimiser l'irrigation ?", "15 réponses • Dernière réponse : 2 heures", Colors.green),
          const SizedBox(height: 8),
          _buildDiscussionCard("Maladies fréquentes en saison humide", "10 réponses • Dernière réponse : 1 jour",
              Colors.orange),
          const SizedBox(height: 8),
          _buildDiscussionCard("Quel engrais est adapté pour le maïs ?", "8 réponses • Dernière réponse : 5 heures",
              Colors.blue),
        ],
      ),
    );
  }

  Widget _buildDiscussionCard(String title, String subtitle, Color color) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.2),
          child: Icon(Icons.forum, color: color),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          print("Naviguer vers la discussion : $title");
        },
      ),
    );
  }

  Widget _buildCommunityRecommendations() {
  return Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white, // Fond blanc pour un meilleur contraste
      borderRadius: BorderRadius.circular(12),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Recommandations Communautaires",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black, // Texte en noir pour une meilleure lisibilité
          ),
        ),
        const SizedBox(height: 8),
        _buildRecommendationCard(
          "Arroser tôt le matin",
          "Évitez d'arroser en pleine journée pour réduire l'évaporation.",
          "Approuvé par 20+ agriculteurs",
        ),
        const SizedBox(height: 8),
        _buildRecommendationCard(
          "Prévenir les maladies fongiques",
          "Utilisez un fongicide naturel après les pluies.",
          "Conseil populaire",
        ),
      ],
    ),
  );
}

Widget _buildRecommendationCard(String title, String description, String badge) {
  return Card(
    color: const Color(0xFFF5F5F5), // Fond gris très clair pour un contraste doux
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.black, // Couleur du texte noir
            ),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black87, // Texte gris foncé pour un contraste agréable
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.thumb_up, color: Colors.green, size: 20),
              const SizedBox(width: 8),
              Text(
                badge,
                style: const TextStyle(
                  color: Colors.black54, // Texte en gris moyen
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

Widget _buildSharingOptions() {
  return Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: const Color(0xFFF7FBF8), // Fond vert clair très doux
      borderRadius: BorderRadius.circular(12),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Options de Partage",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black, // Couleur du texte noir
          ),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton.icon(
              onPressed: _selectImage,
              icon: const Icon(Icons.camera_alt, color: Colors.white),
              label: const Text("Photo"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue, // Bouton bleu
                foregroundColor: Colors.white, // Texte blanc
              ),
            ),
            ElevatedButton.icon(
              onPressed: weatherInfo == null ? null : _showWeatherDialog,
              icon: const Icon(Icons.cloud, color: Colors.white),
              label: const Text("Météo"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green, // Bouton vert
                foregroundColor: Colors.white, // Texte blanc
              ),
            ),
            ElevatedButton.icon(
              onPressed: _addNote,
              icon: const Icon(Icons.note, color: Colors.white),
              label: const Text("Note"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange, // Bouton orange
                foregroundColor: Colors.white, // Texte blanc
              ),
            ),
          ],
        ),
      ],
    ),
  );
}


  Widget _buildImagePreview() {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text("Image Sélectionnée", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.memory(_selectedImage!, height: 200, fit: BoxFit.cover),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPublicationHistory() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.grey.shade100,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Historique des Publications", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color.fromRGBO(6, 6, 6, 0.612))),
          const SizedBox(height: 8),
          for (String note in notes)
            Card(
              child: ListTile(
                leading: const Icon(Icons.note, color: Colors.orange),
                title: Text(note, style: const TextStyle(fontSize: 14)),
                subtitle: Text(DateTime.now().toLocal().toString().split(' ')[0]),
              ),
            ),
        ],
      ),
    );
  }
}
