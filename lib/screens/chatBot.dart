import 'dart:convert';
import 'package:agripas/services/chatbotService.dart';
import 'package:agripas/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ChatBotApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ChatScreen(),
    );
  }
}

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final Map<String, String> salutations = {'sender':'bot','text':'Salut, Je suis Macodou. Comment Je pourrais vous aider?'};
  final List<Map<String, String>> messages = []; // Stocke les messages
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    messages.add(salutations);
  }
  _sendMessage(String text) async {
    final chatbotService = ChatbotService();
    final response = await chatbotService.sendMessage(text);
    _controller.clear();
    setState(() {
      messages.add({'sender': 'user','text':text});
      messages.add({'sender': 'bot','text':response});
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.green,
        title: Text('Assistant Agricole'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Zone de messages
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(10),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                final isUser = message['sender'] == 'user';

                return Align(
                  alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: EdgeInsets.symmetric(vertical: 5),
                    padding: EdgeInsets.all(12),
                    constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
                    decoration: BoxDecoration(
                      color: isUser ? AppColors.blue : Color(0xFFE0E0E0),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      message['text']!,
                      style: TextStyle(
                        color: isUser ? Colors.white : Colors.black87,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Barre de saisie
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Posez une question...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                ),
                SizedBox(width: 8),
                IconButton(
                  onPressed: () => _sendMessage(_controller.text),
                  icon: Icon(Icons.send),
                  color: Color(0xFFB7D76A),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
