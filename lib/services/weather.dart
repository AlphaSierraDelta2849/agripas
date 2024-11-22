import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class WeatherService {
  final String apiKey = '28bf1f2dac242dc42bc80f3bebc3a2b2'; // Replace with your OpenWeather API Key

  Future<List<Map<String, dynamic>>> fetchWeatherData(
      double latitude, double longitude) async {
    final String url =
        'https://api.agromonitoring.com/agro/1.0/weather/forecast?lat=$latitude&lon=$longitude&appid=$apiKey&units=metric';
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<Map<String, dynamic>> hourlyWeather = [];
        // print(data['list']);
        for (var item in data) {
          hourlyWeather.add({
            "time": DateTime.fromMillisecondsSinceEpoch(item['dt'] * 1000),
            "condition": item['weather'][0]['description'],
            "temperature": "${item['main']['temp']}°C",
            "humidity": "${item['main']['humidity']}%",
            "pressure": "${item['main']['pressure']} hPa",
            "wind_speed": "${item['wind']['speed']} m/s",
            "rain": item['rain']?['3h']?.toString() ?? "0.0 mm",
          });
        }

        return hourlyWeather;
      } else {
        throw Exception('Failed to fetch weather data');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
