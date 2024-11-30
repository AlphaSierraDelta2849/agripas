import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';

class ForumPage extends StatefulWidget {
  const ForumPage({Key? key}) : super(key: key);

  @override
  State<ForumPage> createState() => _ForumPageState();
}

class _ForumPageState extends State<ForumPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final ImagePicker _picker = ImagePicker();

  Future<void> _addDiscussion() async {
    String? title = await _showInputDialog("Nouvelle Discussion", "Titre de la discussion");
    if (title != null && title.isNotEmpty) {
      try {
        await _firestore.collection('discussions').add({
          'content': title,
          'likes': 0,
          'createdAt': FieldValue.serverTimestamp(),
        });
      } catch (e) {
        print("Erreur lors de l'ajout de la discussion : $e");
      }
    }
  }

  Future<void> _likeDiscussion(String discussionId, int currentLikes) async {
    try {
      await _firestore.collection('discussions').doc(discussionId).update({
        'likes': currentLikes + 1,
      });
    } catch (e) {
      print("Erreur lors de l'ajout d'un like : $e");
    }
  }

  Future<String?> _showInputDialog(String title, String hint) async {
    TextEditingController controller = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(hintText: hint),
            cursorColor: Colors.black,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Annuler"),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, controller.text),
              child: const Text("Envoyer"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF60A917),
        title: const Text("Forum Agricole", style: TextStyle(color: Colors.white)),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('discussions').orderBy('createdAt', descending: true).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("Aucune discussion pour le moment."));
          }

          final discussions = snapshot.data!.docs;

          return ListView.builder(
            itemCount: discussions.length,
            itemBuilder: (context, index) {
              final discussion = discussions[index];
              final data = discussion.data() as Map<String, dynamic>;

              return Card(
                child: ListTile(
                  title: Text(
                    data['content'] ?? 'Discussion',
                    style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                  subtitle: Text(
                    "Likes : ${data['likes'] ?? 0}",
                    style: const TextStyle(color: Colors.grey),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.thumb_up, color: Colors.blue),
                    onPressed: () => _likeDiscussion(discussion.id, data['likes'] ?? 0),
                  ),
                  onTap: () => _navigateToDiscussion(context, discussion.id, data['content']),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addDiscussion,
        backgroundColor: const Color(0xFF60A917),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  void _navigateToDiscussion(BuildContext context, String discussionId, String title) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DiscussionPage(discussionId: discussionId, discussionTitle: title),
      ),
    );
  }
}

class DiscussionPage extends StatefulWidget {
  final String discussionId;
  final String discussionTitle;

  const DiscussionPage({Key? key, required this.discussionId, required this.discussionTitle}) : super(key: key);

  @override
  State<DiscussionPage> createState() => _DiscussionPageState();
}

class _DiscussionPageState extends State<DiscussionPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final ImagePicker _picker = ImagePicker();

  Future<void> _sharePhoto(String discussionId) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        final Uint8List imageBytes = await pickedFile.readAsBytes();
        await _firestore.collection('discussions/$discussionId/photos').add({
          'image': imageBytes,
          'uploadedAt': FieldValue.serverTimestamp(),
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Photo partagée avec succès.")),
        );
      }
    } catch (e) {
      print("Erreur lors du partage de photo : $e");
    }
  }

  Future<void> _addComment(String discussionId) async {
    String? comment = await _showInputDialog("Ajouter un Commentaire", "Écrivez votre commentaire");
    if (comment != null && comment.isNotEmpty) {
      await _firestore.collection('discussions/$discussionId/comments').add({
        'text': comment,
        'createdAt': FieldValue.serverTimestamp(),
      });
    }
  }

  Future<String?> _showInputDialog(String title, String hint) async {
    TextEditingController controller = TextEditingController();
    return showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(hintText: hint),
            cursorColor: Colors.black,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Annuler"),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, controller.text),
              child: const Text("Envoyer"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF60A917),
        title: Text(widget.discussionTitle, style: const TextStyle(color: Colors.white)),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore.collection('discussions/${widget.discussionId}/comments').orderBy('createdAt').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text("Aucun commentaire."));
                }

                final comments = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: comments.length,
                  itemBuilder: (context, index) {
                    final comment = comments[index];
                    final data = comment.data() as Map<String, dynamic>;

                    return ListTile(
                      title: Text(data['text'] ?? 'Commentaire', style: const TextStyle(color: Colors.black)),
                      subtitle: Text(data['createdAt']?.toDate()?.toString() ?? ''),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.camera_alt, color: Colors.blue),
                  onPressed: () => _sharePhoto(widget.discussionId),
                ),
                Expanded(
                  child: TextField(
                    onSubmitted: (value) {
                      if (value.isNotEmpty) {
                        _firestore.collection('discussions/${widget.discussionId}/comments').add({
                          'text': value,
                          'createdAt': FieldValue.serverTimestamp(),
                        });
                      }
                    },
                    decoration: const InputDecoration(
                      hintText: "Écrire un commentaire...",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
