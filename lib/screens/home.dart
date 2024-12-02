import 'package:agripas/screens/forum.dart';
import 'package:agripas/widgets/previsions.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:agripas/services/weather.dart';
import 'package:agripas/compoments/menu.dart';
import 'package:agripas/screens/diagnostic.dart';


class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final WeatherService weatherService = WeatherService();
  bool isLoading = true;
  String? errorMessage;
  List<Map<String, dynamic>>? weatherData;

  @override
  void initState() {
    super.initState();
    _fetchWeatherData();
  }

  @override
void dispose() {
  super.dispose();
}


Future<void> _fetchWeatherData() async {
  try {
    final data = await weatherService.fetchWeatherData(14.6928, -17.4467); // Dakar
    if (!mounted) return; // Vérifiez si le widget est toujours monté
    setState(() {
      weatherData = data;
      isLoading = false;
    });
  } catch (e) {
    if (!mounted) return; // Vérifiez si le widget est toujours monté
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
      body: SafeArea(
        child: Column(
          children: [
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
                              _buildHeaderWithIcons(context),
                              _buildWeatherForecastSection(),
                              const SizedBox(height: 16),
                              Center(child:Text(style:TextStyle(
                                fontSize: 18,
                                fontWeight:FontWeight.bold
                              ),
                              'Prévisions')),
                              const WeatherForecast(),
                              const SizedBox(height: 8),

                              _buildAlertsAndNotificationsSection(),
                            ],
                          ),
              ),
            ),
            const MenuWidget(), // Intégration du menu en bas
          ],
        ),
      ),
    );
  }

  // Section d'en-tête avec les icônes
  Widget _buildHeaderWithIcons(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      color: const Color(0xFF60A917), 
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "Tableau de Bord",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Row(
            children: [
              IconButton(
                icon: const Icon(
                  FontAwesomeIcons.camera,
                  color: Colors.white,
                  size: 20,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const DiagnosticPage()),
                  );
                },
              ),
              const SizedBox(width: 16),
              IconButton(
                icon: const Icon(
                  FontAwesomeIcons.user,
                  color: Colors.white,
                  size: 20,
                ),
                onPressed: () {
                  print("Profil utilisateur");
                },
              ),
              const SizedBox(width: 16),
              IconButton(
                icon: const Icon(
                  FontAwesomeIcons.comments,
                  color: Colors.white,
                  size: 20,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ForumPage()),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWeatherForecastSection() {
    final currentWeather = weatherData?.first;

    return Container(
      height: 250,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/champs.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            left: 16,
            bottom: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Température Actuelle",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                if (currentWeather != null)
                  Text(
                    "${currentWeather['temperature']}°C",
                    style: const TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                if (currentWeather == null)
                  const Text(
                    "Données indisponibles",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                const SizedBox(height: 8),
                if (currentWeather != null)
                  Text(
                    "Précipitations : ${currentWeather['rain']} mm",
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                const SizedBox(height: 8),
                if (currentWeather != null)
                  Text(
                    _getIrrigationAdvice(currentWeather),
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getIrrigationAdvice(Map<String, dynamic> currentWeather) {
    double rain = currentWeather['rain'];
    if (rain > 5) {
      return "Pas d'irrigation nécessaire aujourd'hui.";
    } else {
      return "Arrosage recommandé cet après-midi.";
    }
  }

  Widget _buildAlertsAndNotificationsSection() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Alertes et Notifications",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 3 / 2,
            children: [
              _buildAlertCard(
                icon: FontAwesomeIcons.bug,
                title: "Risque de Ravageurs",
                color: Colors.orange,
                onTap: () => Navigator.pushNamed(context, '/diagnostic'),
              ),
              _buildAlertCard(
                icon: FontAwesomeIcons.leaf,
                title: "Maladies des Plantes",
                color: Colors.red,
                onTap: () => Navigator.pushNamed(context, ''),
              ),
              _buildAlertCard(
                icon: FontAwesomeIcons.tint,
                title: "Besoins d'Irrigation",
                color: Colors.blue,
                onTap: () => Navigator.pushNamed(context, ''),
              ),
              _buildAlertCard(
                icon: FontAwesomeIcons.store,
                title: "Marché",
                color: Colors.green,
                onTap: () => Navigator.pushNamed(context, ''),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAlertCard({
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: color.withOpacity(0.2),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14, color: Colors.black87),
            ),
          ],
        ),
      ),
    );
  }
}
