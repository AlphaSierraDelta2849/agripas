import 'package:agripas/utils/colors.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SenegalMapPage extends StatefulWidget {
  @override
  _SenegalMapPageState createState() => _SenegalMapPageState();
}

class _SenegalMapPageState extends State<SenegalMapPage> {
  LatLng _selectedLocation = LatLng(14.4974, -14.4524); // Default to Senegal

  List<dynamic>? _weatherData;
  bool _loading = false;
  int cnt=0;
  changeJour(){
    setState(() {
      cnt<10?cnt++:cnt=0;
      // _weatherData = data;
    });
    
  }
  String formatTimestampToFrenchDate(int timestamp) {
    initializeDateFormatting('fr_FR', null);
  // Convert timestamp to DateTime
  DateTime date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);

  // Format date in French
  Intl.defaultLocale = 'fr_FR'; // Set locale to French
  DateFormat dateFormatter = DateFormat('EEEE d MMMM yyyy, HH:mm', 'fr_FR'); // Example: "mardi 8 juin 2021, 16:00"
  return dateFormatter.format(date);
}
  // Fonction pour récupérer les données de l'API en fonction des coordonnées sélectionnées
  Future<void> _fetchLocationData(LatLng location) async {
    setState(() {
      _loading = true;
    });
    const apiKey = "28bf1f2dac242dc42bc80f3bebc3a2b2";
    // "317f998d51adb0d6c94b654ef1df5351";
    // Exemple : appel à une API (remplacez par l'API réelle)
    final apiUrl =
        "https://api.agromonitoring.com/agro/1.0/weather/forecast?lat=${location.latitude}&lon=${location.longitude}&appid=$apiKey&units=metric";
        // "https://api.openweathermap.org/data/2.5/forecast?lat=${location.latitude}&lon=${location.longitude}&appid=$apiKey&units=metric";
        // "https://api.open-meteo.com/v1/forecast?latitude=${location.latitude}&longitude=${location.longitude}&current_weather=true";
    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      // print(data[cnt]["main"]);
      setState(() {
        _weatherData = data;
        print("données ${_weatherData?[cnt]!["dt"]}");
      });
    } else {
      setState(() {
        _weatherData = ["error","Impossible de récupérer les données"];
      });
    }

    setState(() {
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      // width: 400,
      // height: 500,
    child:Column(
        children: [
          // Weather Info Section
          if (_weatherData != null) ...[
            Container(
              margin: EdgeInsets.all(10),
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Weather Icon and Description
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children:[
                            Text(
                            "Météo prévisionnelle",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          VerticalDivider(),
                         
                          Align(
                            alignment: Alignment.bottomRight,
                            child: 
                            ElevatedButton(onPressed: changeJour, child: Text('suivant')))
                          ,
                        ]),
                        
                         Row(children: [Text(
                            formatTimestampToFrenchDate(_weatherData?[cnt]!["dt"]),
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          )]),
                          Row(children:[
                          Text(
                            _weatherData![cnt]["weather"][0]["description"],
                            style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                          ),
                        
                      Image.network(
                        "https://openweathermap.org/img/wn/${_weatherData![cnt]["weather"][0]["icon"]}@2x.png",
                        height: 50,
                        width: 50,
                      )],
                      ),]),
                    ],
                  ),
                  SizedBox(height: 5),
                  // Temperature and Details
                  Text(
                    "${_weatherData![cnt]["main"]["temp"]}°C",
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                  Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          Icon(Icons.thermostat, color: Colors.blue),
                          SizedBox(height: 5),
                          Text("Pressure"),
                          Text("${_weatherData![cnt]["main"]["pressure"]} hPa"),
                        ],
                      ),
                      Column(
                        children: [
                          Icon(Icons.water, color: Colors.blue),
                          SizedBox(height: 5),
                          Text("Humidity"),
                          Text("${_weatherData![cnt]["main"]["humidity"]}%"),
                        ],
                      ),
                      Column(
                        children: [
                          Icon(Icons.wind_power, color: Colors.blue),
                          SizedBox(height: 5),
                          Text("Wind"),
                          Text("${_weatherData![cnt]["wind"]["speed"]} m/s"),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
          // Map Section
          Expanded(
            child: 
            Card(
              margin: EdgeInsets.all(10),
              shape: CircleBorder(eccentricity: 0.5),
              elevation: 4,
            child:FlutterMap(
              options: MapOptions(
                center: _selectedLocation,
                zoom: 7.0,
                onTap: (tapPosition, point) {
                  setState(() {
                    _selectedLocation = point;
                  });
                  _fetchLocationData(point); // Récupérer les données pour le point sélectionné
                },
              ),
              children: [
                TileLayer(
                  urlTemplate: "https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}{r}.png",
                  subdomains: ['a', 'b', 'c'],
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      point: _selectedLocation,
                      builder: (ctx) => Icon(
                        Icons.location_pin,
                        color: Colors.red,
                        size: 40,
                      ),
                    ),
                  ],
                ),
              ],
          ),
          )
          ),
        
        ],
    )
  );
  }
}
