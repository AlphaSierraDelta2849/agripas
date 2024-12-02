import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:agripas/services/weather.dart';
import 'package:agripas/compoments/header.dart';
import 'package:agripas/compoments/menu.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class ConseilAgricolePage extends StatefulWidget {
  const ConseilAgricolePage({Key? key}) : super(key: key);

  @override
  State<ConseilAgricolePage> createState() => _ConseilAgricolePageState();
}

class _ConseilAgricolePageState extends State<ConseilAgricolePage> {
  final WeatherService weatherService = WeatherService();
  bool isLoading = true;
  String? errorMessage;
  Map<String, dynamic>? currentWeather;

  final List<Map<String, String>> cultures = [
    {
      "name": "Tomates",
      "image": "assets/images/tomate.jpg",
    },
    {
      "name": "Carottes",
      "image": "assets/images/carotte.jpg",
    },
    {
      "name": "Manioc",
      "image": "assets/images/manioc.jpg",
    },
  ];

  @override
  void initState() {
    super.initState();
    _fetchWeatherData();
  }

  Future<void> _fetchWeatherData() async {
    try {
      final data = await weatherService.fetchWeatherData(14.6928, -17.4467); // Dakar
      setState(() {
        currentWeather = data.first;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Erreur lors de la récupération des données météo : $e';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const HeaderWidget(),
          Expanded(
            child: SingleChildScrollView(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : errorMessage != null
                      ? Center(
                          child: Text(
                            errorMessage!,
                            style: const TextStyle(color: Colors.red),
                          ),
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildCultureSelection(),
                            const SizedBox(height: 16),
                            _buildSeasonalRecommendations(),
                            const SizedBox(height: 16),
                            _buildWeatherAlerts(),
                          ],
                        ),
            ),
          ),
          const MenuWidget(),
        ],
      ),
    );
  }

  Widget _buildCultureSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            "Sélectionnez une Culture",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
          ),
        ),
        const SizedBox(height: 8),
        CarouselSlider(
          options: CarouselOptions(
            height: 180,
            enlargeCenterPage: true,
            enableInfiniteScroll: true,
          ),
          items: cultures.map((culture) {
            return GestureDetector(
              onTap: () {
                print("Culture sélectionnée : ${culture['name']}");
              },
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      image: DecorationImage(
                        image: AssetImage(culture['image']!),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(12),
                        bottomRight: Radius.circular(12),
                      ),
                    ),
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      culture['name']!,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildSeasonalRecommendations() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Conseils Saisonniers",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
          ),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFE0E3E7),
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _buildRecommendationCard(
                  "Fertilisation",
                  "Appliquez des engrais riches en azote pour stimuler la croissance.",
                  FontAwesomeIcons.seedling,
                  const Color(0xFF60A917),
                ),
                const SizedBox(height: 12),
                _buildRecommendationCard(
                  "Irrigation",
                  "Irriguez tôt le matin pour éviter l'évaporation excessive.",
                  FontAwesomeIcons.tint,
                  Colors.blue,
                ),
                const SizedBox(height: 12),
                _buildRecommendationCard(
                  "Traitement des Sols",
                  "Aérez le sol pour améliorer l'infiltration d'eau.",
                  FontAwesomeIcons.tractor,
                  Colors.brown,
                ),
                const SizedBox(height: 16),
                _buildGrowthGraph(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGrowthGraph() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Graphique de Croissance",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildGrowthStage("Germination", 0.3, "30%"),
            _buildGrowthStage("Croissance Active", 0.6, "60%"),
            _buildGrowthStage("Maturation", 1.0, "100%"),
          ],
        ),
      ],
    );
  }

  Widget _buildGrowthStage(String label, double percent, String value) {
    return Column(
      children: [
        LinearPercentIndicator(
          width: 80,
          lineHeight: 10,
          percent: percent,
          progressColor: percent == 1.0 ? Colors.green : Colors.blue,
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
        Text(value, style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  Widget _buildRecommendationCard(String title, String description, IconData icon, Color color) {
    return Row(
      children: [
        CircleAvatar(
          radius: 30,
          backgroundColor: color.withOpacity(0.2),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(
                description,
                style: const TextStyle(fontSize: 14, color: Colors.black87),
              ),
            ],
          ),
        ),
        if (currentWeather != null)
          Icon(
            currentWeather!['rain'] > 0 ? FontAwesomeIcons.cloudRain : FontAwesomeIcons.sun,
            color: currentWeather!['rain'] > 0 ? Colors.blue : Colors.orange,
          ),
      ],
    );
  }

  Widget _buildWeatherAlerts() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: const Color(0xFF60A917),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: const [
              Icon(Icons.warning, color: Colors.yellow, size: 24),
              SizedBox(width: 8),
              Text(
                "Alerte sécheresse dans les 3 prochains jours",
                style: TextStyle(fontSize: 14, color: Colors.white),
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.info, color: Colors.white),
            onPressed: () {
              print("Détails des alertes météo");
            },
          ),
        ],
      ),
    );
  }
}
