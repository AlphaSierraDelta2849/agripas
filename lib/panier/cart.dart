import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CartPage extends StatefulWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Obtenir les articles du panier de l'utilisateur connecté
  Stream<QuerySnapshot> _getCartItems() {
    final userId = _auth.currentUser?.uid;
    return _firestore.collection('cart').doc(userId).collection('items').snapshots();
  }

  /// Supprimer un article du panier
  Future<void> _removeItem(String itemId) async {
    final userId = _auth.currentUser?.uid;
    await _firestore.collection('cart').doc(userId).collection('items').doc(itemId).delete();
  }

  /// Calculer le total des articles
  Future<double> _calculateTotal() async {
    final userId = _auth.currentUser?.uid;
    final itemsSnapshot = await _firestore.collection('cart').doc(userId).collection('items').get();
    double total = 0.0;

    for (var doc in itemsSnapshot.docs) {
      final data = doc.data();
      total += (data['price'] ?? 0) * (data['quantity'] ?? 1);
    }
    return total;
  }

  /// Simuler un paiement
  Future<void> _checkout() async {
    final userId = _auth.currentUser?.uid;
    await _firestore.collection('cart').doc(userId).collection('items').get().then((snapshot) {
      for (DocumentSnapshot doc in snapshot.docs) {
        doc.reference.delete(); // Vider le panier après paiement
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Paiement réussi !")));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mon Panier"),
        backgroundColor: Colors.green,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _getCartItems(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("Votre panier est vide."));
          }

          final items = snapshot.data!.docs;

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final data = items[index].data() as Map<String, dynamic>;
                    final itemId = items[index].id;

                    return Card(
                      child: ListTile(
                        leading: Image.network(data['image'], width: 50, height: 50, fit: BoxFit.cover),
                        title: Text(data['name']),
                        subtitle: Text("${data['price']} FCFA x ${data['quantity']}"),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _removeItem(itemId),
                        ),
                      ),
                    );
                  },
                ),
              ),
              FutureBuilder<double>(
                future: _calculateTotal(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }

                  final total = snapshot.data ?? 0.0;

                  return Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          "Total : $total FCFA",
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: _checkout,
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                          child: const Text("Paiement"),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
