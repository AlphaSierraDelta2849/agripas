import 'package:agripas/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:agripas/services/weather.dart';
import 'package:agripas/compoments/menu.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final WeatherService _weatherService = WeatherService();
  bool isLoading = true;
  Map<String, dynamic>? weatherData;

  @override
  void initState() {
    super.initState();
    fetchWeather(); 
  }

  Future<void> fetchWeather() async {
    try {
      final data = await _weatherService.fetchWeatherData(14.6928, -17.4467); 
      setState(() {
        weatherData = data.isNotEmpty ? data[4] : null;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Erreur lors de la récupération des données météo : $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;

    return Scaffold(
      backgroundColor: AppColors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Header avec température et météo
              Stack(
                children: [
                  // Image de fond
                  Container(
                    height: isTablet ? 300 : 250,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: const AssetImage(
                          'assets/images/champs.jpg',
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  // Données météo
                  Positioned(
                    top: isTablet ? 100 : 70,
                    left: 20,
                    right: 20,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Ma position',
                              style: TextStyle(
                                fontSize: 24,
                                color: AppColors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 8),
                            if (!isLoading && weatherData != null)
                              Image.network(
                                "https://openweathermap.org/img/wn/${weatherData!["icon"]}@2x.png",
                                width: 60,
                                height: 60,
                              ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'DAKAR',
                          style: TextStyle(
                            fontSize: 20,
                            color: AppColors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          isLoading
                              ? 'Chargement...'
                              : '${weatherData?['temperature']}',
                          style: const TextStyle(
                            fontSize: 50,
                            color: AppColors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Cartes météo (Temps et Humidité)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    _buildStatCard(
                      title: 'TEMPS',
                      value: isLoading
                          ? 'Chargement...'
                          : '${weatherData?['condition']}',
                      imagePath: '',
                      isTablet: isTablet,
                      backgroundColor: AppColors.blue,
                    ),
                    const SizedBox(width: 10),
                    _buildStatCard(
                      title: 'HUMIDITÉ',
                      value: isLoading
                          ? 'Chargement...'
                          : '${weatherData?['humidity']}',
                      subtitle: isLoading
                          ? 'Chargement...'
                          : 'Tres sec',
                      isTablet: isTablet,
                      backgroundColor: AppColors.blue,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Section principale (Risque, Maladie, etc.)
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.blue,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: GridView.count(
                  crossAxisCount: isTablet ? 3 : 2,
                  shrinkWrap: true,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    _buildGridItem(
                      title: 'RISQUE DE\nRAVAGEURS',
                      imagePath: 'assets/images/coccinelle.png',
                      isTablet: isTablet,
                    ),
                    _buildGridItem(
                      title: 'MALADIE DES\nPLANTES',
                      imagePath: 'assets/images/plante.png',
                      isTablet: isTablet,
                    ),
                    _buildGridItem(
                      title: 'RECOMMANDATIONS',
                      imagePath: 'assets/images/arrosagee.png',
                      isTablet: isTablet,
                    ),
                    _buildGridItem(
                      title: 'MARCHÉ',
                      imagePath: 'assets/images/street-markett.png',
                      isTablet: isTablet,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const MenuWidget(), 
    );
  }

  // Widget pour les cartes météo 
  Widget _buildStatCard({
    required String title,
    required String value,
    String? subtitle,
    required bool isTablet,
    required Color backgroundColor,
    String? imagePath,
    
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                color: AppColors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 18,
                color: AppColors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (subtitle != null)
              const SizedBox(height: 8),
            if (subtitle != null)
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.white,
                ),
                textAlign: TextAlign.center,
              ),
          ],
        ),
      ),
    );
  }

  // Widget pour les éléments de la grille 
  Widget _buildGridItem({
    required String title,
    required String imagePath,
    required bool isTablet,
  }) {
    return Column(
      children: [
        Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 14,
            color: AppColors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Image.asset(
          imagePath,
          width: isTablet ? 80 : 60,
          height: isTablet ? 80 : 60,
        ),
      ],
    );
  }
}
