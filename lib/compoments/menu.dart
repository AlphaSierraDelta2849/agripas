import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class MenuWidget extends StatelessWidget {
  const MenuWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF60A917),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(21),
          topRight: Radius.circular(21),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildMenuItem(
            context,
            icon: Icons.home_outlined,
            label: 'Accueil',
            onTap: () => Navigator.pushNamed(context, '/home'),
          ),
          _buildMenuItem(
            context,
            icon: FontAwesomeIcons.seedling,
            label: 'Conseils',
            onTap: () => Navigator.pushNamed(context, '/conseilAgricole'),
          ),
          _buildMenuItem(
            context,
            icon: FontAwesomeIcons.water,
            label: 'Irrigation',
            onTap: () => Navigator.pushNamed(context, '/irrigations'),
          ),
          _buildMenuItem(
            context,
            icon: FontAwesomeIcons.store,
            label: 'Marché',
            onTap: () => Navigator.pushNamed(context, '/market'),
          ),
          _buildMenuItem(
            context,
            icon: FontAwesomeIcons.comments,
            label: 'Chatbot',
            onTap: () => Navigator.pushNamed(context, '/chat'),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white, // Fond blanc des icônes
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(
              icon,
              size: 24,
              color: const Color.fromRGBO(96, 169, 23, 1), // Couleur de l'icône
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.black,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
