import 'dart:convert';
import 'package:http/http.dart' as http;

class ChatbotService {
  final String apiUrl='https://a334-41-82-207-174.ngrok-free.app/webhooks/rest/webhook';

  // Constructeur pour initialiser l'URL de l'API

  // Méthode pour envoyer un message et récupérer la réponse
  Future<String> sendMessage(String userMessage) async {
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'message': userMessage}),
      );
      if (response.statusCode == 200) {
        // Parse et renvoie la réponse du chatbot
        final responseData = jsonDecode(response.body);
        String text = '';
        for (var response in responseData){
          print('response: ' + response['text']);
          text += response['text'];
        }

        return text ?? "Aucune réponse reçue.";
      } else {
        return "Erreur serveur : ${response.statusCode}.";
      }
    } catch (e) {
      return "Erreur : impossible de contacter le serveur.";
    }
  }
}
