import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:agripas/utils/colors.dart';

class HeaderWidget extends StatelessWidget {
  const HeaderWidget({Key? key}) : super(key: key);

  Future<void> _logout(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut(); // Déconnexion Firebase
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/auth', // Redirige vers la page d'authentification
        (route) => false,
      );
    } catch (e) {
      // Afficher un message d'erreur si la déconnexion échoue
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Erreur lors de la déconnexion : $e")),
      );
    }
  }

  void _showUserMenu(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Mon Profil",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const Divider(),
              if (user != null)
                ListTile(
                  leading: const Icon(Icons.person, color: Colors.green),
                  title: Text(user.displayName ?? "Nom d'utilisateur"),
                  subtitle: Text(user.email ?? "Email non disponible"),
                ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.logout, color: Colors.red),
                title: const Text("Déconnexion"),
                onTap: () {
                  Navigator.pop(context); // Fermer le menu modal
                  _logout(context); // Déconnexion
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Column(
      children: [
        // En-tête principal
        Container(
          width: double.infinity,
          height: 80,
          decoration: BoxDecoration(
            color: Colors.green,
            boxShadow: const [
              BoxShadow(
                blurRadius: 4,
                color: Color(0x33000000),
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back, color: AppColors.white),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // Bouton Forum
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, '/forum');
                      },
                      icon: const Icon(Icons.forum_outlined, size: 24, color: AppColors.white),
                      label: const Text(
                        'Forum',
                        style: TextStyle(
                          fontFamily: 'Outfit',
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: AppColors.white,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Icône de profil
                    GestureDetector(
                      onTap: () => _showUserMenu(context),
                      child: CircleAvatar(
                        backgroundColor: AppColors.white,
                        radius: 22,
                        child: Text(
                          user?.displayName?[0].toUpperCase() ?? "?",
                          style: const TextStyle(color: AppColors.blue, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
            ],
          ),
        ),
        // Image avec champ de recherche
        Container(
          width: double.infinity,
          height: 100,
          decoration: BoxDecoration(
            color: AppColors.blue,
            image: const DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage(
                'assets/images/champs.jpg',
              ),
            ),
          ),
          child: Row(
            children: [
              const SizedBox(width: 16),
              IconButton(
                icon: const Icon(Icons.search, color: AppColors.white),
                onPressed: () {
                  print("Search button pressed");
                },
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "Rechercher",
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.7),
                    contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  style: const TextStyle(fontFamily: 'Inter', fontSize: 16),
                ),
              ),
              const SizedBox(width: 16),
            ],
          ),
        ),
      ],
    );
  }
}
