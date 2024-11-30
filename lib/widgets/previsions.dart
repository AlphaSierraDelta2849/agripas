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
  // Convert timestamp to DateTime
  // DateTime date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);

  // Format date in French
  Intl.defaultLocale = 'fr_FR'; // Set locale to French
  DateFormat dateFormatter = DateFormat('EEEE d MMMM yyyy, HH:mm', 'fr_FR'); // Example: "mardi 8 juin 2021, 16:00"
  return dateFormatter.format(date);
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
    return Container(
      height: 160,
      margin: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
          color: AppColors.orange,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
      child: 
           ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: weatherData.length,
            itemBuilder: (context, index) {
              final forecast = weatherData[index];
              final formattedTime = formatTimestampToFrenchDate(forecast["time"]);
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children:[
                Image.network('https://openweathermap.org/img/wn/${forecast["icon"]}@2x.png',width: 40,height: 40),
                Text('  $formattedTime  -  '),
                Text('${forecast["temperature"]}°C'),
                Text('Précipitations : ${forecast["rain"]} mm'),
                Text('Humidité : ${forecast["humidity"]} %'),]
              );
  }));
  }
  }