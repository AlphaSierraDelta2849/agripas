import 'package:agripas/services/weather.dart';
import 'package:agripas/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

class WeatherForecast extends StatefulWidget {
  const WeatherForecast({super.key});

  @override
  State<WeatherForecast> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherForecast> {
  List<Map<String, dynamic>> weatherData = [];
  final WeatherService weatherService = WeatherService();
  String? errorMessage;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchWeatherData();
  }

  String formatTimestampToFrenchDate(DateTime date) {
    initializeDateFormatting('fr_FR', null);
    Intl.defaultLocale = 'fr_FR';
    DateFormat dateFormatter = DateFormat('EEEE d MMMM', 'fr_FR'); // Exemple : "mardi 8 juin"
    return dateFormatter.format(date);
  }

  Future<void> _fetchWeatherData() async {
    try {
      final data = await weatherService.fetchWeatherData(14.6928, -17.4467); // Dakar
      if (!mounted) return;
      setState(() {
        weatherData = data;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        errorMessage = 'Erreur lors de la récupération des données météo : $e';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      margin: const EdgeInsets.all(16),
      child: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage != null
              ? Center(
                  child: Text(
                    errorMessage!,
                    style: const TextStyle(color: Colors.red),
                  ),
                )
              : ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: weatherData.length,
                  itemBuilder: (context, index) {
                    final forecast = weatherData[index];
                    final formattedTime = formatTimestampToFrenchDate(forecast["time"]);

                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      width: 160,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [AppColors.lightBlue, AppColors.blueAccent],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Icône météo
                            Image.network(
                              'https://openweathermap.org/img/wn/${forecast["icon"]}@2x.png',
                              width: 60,
                              height: 60,
                            ),
                            // Date
                            Text(
                              formattedTime,
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            // Température
                            Text(
                              "${forecast["temperature"]}°C",
                              style: const TextStyle(
                                fontSize: 22,
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            // Précipitations et humidité
                            Text(
                              "Pluie : ${forecast["rain"]} mm",
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              "Humidité : ${forecast["humidity"]}%",
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
