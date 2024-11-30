import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MarketPage extends StatefulWidget {
  const MarketPage({Key? key}) : super(key: key);

  @override
  State<MarketPage> createState() => _MarketPageState();
}

class _MarketPageState extends State<MarketPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  int cartItemCount = 0;

  @override
  void initState() {
    super.initState();
    _fetchCartItemCount();
  }

  /// Récupère le nombre total d'articles dans le panier
  Future<void> _fetchCartItemCount() async {
    final userId = _auth.currentUser?.uid;

    if (userId == null) return;

    final cartItems = await _firestore.collection('cart').doc(userId).collection('items').get();
    int totalItems = 0;
    for (var doc in cartItems.docs) {
      totalItems += (doc['quantity'] ?? 0) as int;
    }

    setState(() {
      cartItemCount = totalItems;
    });
  }

  /// Ajoute un produit à la base de données
  Future<void> _addProduct() async {
    final user = _auth.currentUser;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Veuillez vous connecter pour ajouter un produit.")),
      );
      return;
    }

    // Récupérer le username à partir de Firestore
    final userSnapshot = await _firestore.collection('users').doc(user.uid).get();
    final username = userSnapshot.data()?['username'] ?? 'Utilisateur inconnu';

    TextEditingController nameController = TextEditingController();
    TextEditingController priceController = TextEditingController();
    TextEditingController imageController = TextEditingController();
    TextEditingController descriptionController = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Ajouter un produit"),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: "Nom du produit"),
              ),
              TextField(
                controller: priceController,
                decoration: const InputDecoration(labelText: "Prix"),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: imageController,
                decoration: const InputDecoration(labelText: "URL de l'image"),
              ),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: "Description"),
                maxLines: 3,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Annuler"),
          ),
          ElevatedButton(
            onPressed: () async {
              final name = nameController.text.trim();
              final price = double.tryParse(priceController.text.trim());
              final image = imageController.text.trim();
              final description = descriptionController.text.trim();

              if (name.isNotEmpty && price != null) {
                await _firestore.collection('products').add({
                  'name': name,
                  'price': price,
                  'image': image,
                  'description': description,
                  'addedBy': username,
                  'createdAt': FieldValue.serverTimestamp(),
                });

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Produit ajouté avec succès.")),
                );

                Navigator.pop(context);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Veuillez remplir tous les champs correctement.")),
                );
              }
            },
            child: const Text("Ajouter"),
          ),
        ],
      ),
    );
  }

  /// Ajoute un produit au panier
  Future<void> _addToCart(Map<String, dynamic> product, int quantity) async {
    final userId = _auth.currentUser?.uid;

    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Veuillez vous connecter pour ajouter au panier.")),
      );
      return;
    }

    final cartItemRef = _firestore.collection('cart').doc(userId).collection('items').doc(product['id']);

    await cartItemRef.get().then((doc) {
      if (doc.exists) {
        final currentQuantity = (doc['quantity'] ?? 0) as int;
        cartItemRef.update({'quantity': currentQuantity + quantity});
      } else {
        cartItemRef.set({
          'productId': product['id'],
          'name': product['name'],
          'price': product['price'],
          'quantity': quantity,
          'image': product['image'],
        });
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("${product['name']} ajouté au panier.")),
    );

    _fetchCartItemCount();
  }

  /// Grille des produits
  Widget _buildProductGrid() {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('products').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text("Aucun produit disponible."));
        }

        final products = snapshot.data!.docs;

        return GridView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 2 / 3,
          ),
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index].data() as Map<String, dynamic>;
            return _buildProductCard(product);
          },
        );
      },
    );
  }

  /// Carte produit
  Widget _buildProductCard(Map<String, dynamic> product) {
    final quantityController = TextEditingController(text: '1');

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 1.5,
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              child: Image.network(
                product['image'] ?? '',
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              product['name'] ?? '',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              product['description'] ?? 'Aucune description',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              "${product['price']} FCFA",
              style: const TextStyle(color: Colors.green, fontSize: 16),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              "Ajouté par : ${product['addedBy'] ?? 'Utilisateur inconnu'}",
              style: const TextStyle(fontSize: 12, color: Colors.blueGrey),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: quantityController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: "Kg",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    final quantity = int.tryParse(quantityController.text) ?? 1;
                    if (quantity > 0) {
                      _addToCart(product, quantity);
                    }
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green.shade700), 
                  child: const Text("Ajouter"),  
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green.shade700,
        elevation: 2,
        title: const Text(
          "AgriShop 🌱",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color.fromARGB(245, 253, 251, 251)),
        ),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: () => Navigator.pushNamed(context, '/cart'),
                color: Color.fromARGB(255, 247, 245, 245),
              ),
              if (cartItemCount > 0)
                Positioned(
                  right: 0,
                  top: 4,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '$cartItemCount',
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _addProduct,
            color: Color.fromARGB(255, 247, 245, 245),

          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: _buildProductGrid(),
            ),
          ],
        ),
      ),
    );
  }
}
