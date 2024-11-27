import 'package:flutter/material.dart';
import 'package:agripas/utils/colors.dart';


class HeaderWidget extends StatelessWidget {
  const HeaderWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          height: 80,
          decoration: BoxDecoration(
            color: AppColors.blue,
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
                        print("Forum button pressed");
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
                    CircleAvatar(
                      backgroundColor: AppColors.white,
                      radius: 22,
                      child: const Icon(Icons.person, color: AppColors.blue),
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
