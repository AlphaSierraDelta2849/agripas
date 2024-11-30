import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLogin = true;
  bool _isLoading = false;
  bool _isPasswordVisible = false;

  // Inscription
  Future<void> _register() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final usernameSnapshot = await _firestore
          .collection('users')
          .where('username', isEqualTo: _usernameController.text.trim())
          .get();

      if (usernameSnapshot.docs.isNotEmpty) {
        throw FirebaseAuthException(
          code: 'username-already-in-use',
          message: 'Nom d\'utilisateur déjà pris.',
        );
      }

      final emailSnapshot = await _firestore
          .collection('users')
          .where('email', isEqualTo: _emailController.text.trim())
          .get();

      if (emailSnapshot.docs.isNotEmpty) {
        throw FirebaseAuthException(
          code: 'email-already-in-use',
          message: 'Email déjà pris.',
        );
      }

      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      await userCredential.user?.updateDisplayName(_usernameController.text.trim());

      await _firestore.collection('users').doc(userCredential.user?.uid).set({
        'username': _usernameController.text.trim(),
        'email': _emailController.text.trim(),
        'createdAt': FieldValue.serverTimestamp(),
      });

      await _auth.signOut();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Inscription réussie ! Connectez-vous pour accéder.")),
      );

      setState(() {
        _isLogin = true;
      });
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur : ${e.message}")),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Connexion
  Future<void> _login() async {
    setState(() {
      _isLoading = true;
    });

    try {
      String email = _emailController.text.trim();

      final usernameSnapshot = await _firestore
          .collection('users')
          .where('username', isEqualTo: email)
          .get();

      if (usernameSnapshot.docs.isNotEmpty) {
        email = usernameSnapshot.docs.first.data()['email'];
      }

      await _auth.signInWithEmailAndPassword(
        email: email,
        password: _passwordController.text.trim(),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Connexion réussie !")),
      );

      Navigator.pushReplacementNamed(context, '/home');
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur : ${e.message}")),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Champ de texte stylisé
  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    bool isPassword = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: isPassword && !_isPasswordVisible,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.grey),
        filled: true,
        fillColor: Colors.grey.shade200,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                  color: Colors.grey,
                ),
                onPressed: () {
                  setState(() {
                    _isPasswordVisible = !_isPasswordVisible;
                  });
                },
              )
            : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            child: Column(
              children: [
                // Logo
                Image.asset(
                  'assets/images/logo.png', // Remplacez par le chemin de votre logo
                  height: 120,
                ),
                const SizedBox(height: 24),

                // Titre principal
                Text(
                  _isLogin ? "Bienvenue !" : "Rejoignez-nous",
                  style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black87),
                ),
                const SizedBox(height: 8),
                Text(
                  _isLogin
                      ? "Connectez-vous avec votre compte"
                      : "Créez un compte pour démarrer",
                  style: const TextStyle(fontSize: 16, color: Colors.black54),
                ),
                const SizedBox(height: 24),

                // Formulaire
                if (!_isLogin)
                  _buildTextField(
                    label: "Nom d'utilisateur",
                    controller: _usernameController,
                  ),
                const SizedBox(height: 16),
                _buildTextField(
                  label: _isLogin ? "Email ou Nom d'utilisateur" : "Email",
                  controller: _emailController,
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  label: "Mot de passe",
                  controller: _passwordController,
                  isPassword: true,
                ),
                const SizedBox(height: 24),

                // Bouton principal
                if (_isLoading)
                  const CircularProgressIndicator()
                else
                  ElevatedButton(
                    onPressed: _isLogin ? _login : _register,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF60A917),
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: Text(
                      _isLogin ? "Connexion" : "Inscription",
                      style: const TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                const SizedBox(height: 24),

                // Basculer entre Connexion/Inscription
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _isLogin
                          ? "Vous n'avez pas de compte ? "
                          : "Vous avez déjà un compte ? ",
                      style: const TextStyle(color: Colors.black54),
                    ),
                    TextButton(
                      onPressed: () => setState(() => _isLogin = !_isLogin),
                      child: Text(
                        _isLogin ? "Inscrivez-vous" : "Connectez-vous",
                        style: const TextStyle(color: Color(0xFF60A917)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
