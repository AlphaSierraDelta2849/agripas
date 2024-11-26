import 'package:flutter/material.dart';

class MenuWidget extends StatelessWidget {
  const MenuWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(96, 169, 23, 100), // Couleur du menu
        borderRadius: BorderRadius.only(topLeft: Radius.circular(21),topRight: Radius.circular(21)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildMenuItem(
            context,
            iconPath: 'assets/images/page-daccueil.png',
            label: 'Accueil',
            onTap: () => Navigator.pushNamed(context, '/home'),
          ),
          _buildMenuItem(
            context,
            iconPath: 'assets/images/plantee.png',
            label: 'Conseils',
            onTap: () => Navigator.pushNamed(context, '/conseilAgricole'),
          ),
          _buildMenuItem(
            context,
            iconPath: 'assets/images/irrigation.png',
            label: 'Irrigation',
            onTap: () => Navigator.pushNamed(context, '/irrigation'),
          ),
          _buildMenuItem(
            context,
            iconPath: 'assets/images/street-market-blue.png',
            label: 'Marché',
            onTap: () => Navigator.pushNamed(context, '/marche'),
          ),
          _buildMenuItem(
            context,
            iconPath: 'assets/images/chatbot.png',
            label: 'Chatbot',
            onTap: () => Navigator.pushNamed(context, '/chat'),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required String iconPath,
    required String label,
    required VoidCallback onTap,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 251, 252, 252), 
              borderRadius: BorderRadius.circular(12),
            ),
            child: Image.asset(
              iconPath,
              width: 25,
              height: 25,
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}
