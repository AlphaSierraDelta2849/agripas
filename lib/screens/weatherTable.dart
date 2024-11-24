import 'package:agripas/services/localisation.dart';
import 'package:agripas/services/weather.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
class WeatherTablePage extends StatefulWidget {
  @override
  _WeatherTablePageState createState() => _WeatherTablePageState();
}

class _WeatherTablePageState extends State<WeatherTablePage> {
  List<Map<String, dynamic>> weatherData = [];
  bool isLoading = true;
  final LocationPermissionService _locationService = LocationPermissionService();
  String errorMessage = "";



  @override
  void initState() {
    super.initState();
    fetchWeatherData();
    }
 Future<void> fetchWeatherData() async {
    try {
      // Step 1: Get location
      Position? position = await _locationService.fetchLocation();
      if (position == null) {
        setState(() {
          errorMessage = "Unable to fetch location.";
          isLoading = false;
        });
        return;
      }

      double latitude = position.latitude;
      double longitude = position.longitude;

      // Step 2: Fetch weather data using the location
      // Replace this with your weather API fetching logic
      final service = WeatherService();
      var weatherApiData = await service.fetchWeatherData(position.latitude, position.longitude);

      setState(() {
        weatherData = weatherApiData;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = "Error: $e";
        isLoading = false;
      });
    }
  }

  
  @override
  Widget build(BuildContext context) {
    return 
    Container(
  height: MediaQuery.of(context).size.height * 0.8, // Constrain table height
  child: isLoading
      ? Center(child: CircularProgressIndicator())
      : Column(
          children: [
            // Fixed header
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                headingRowColor: WidgetStateProperty.resolveWith<Color>(
                    (states) => Colors.blueAccent.shade100), // Header background color
                headingTextStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.white,
                ),
                columns: [
                  DataColumn(label: Text('Time')),
                  DataColumn(label: Text('Condition')),
                  DataColumn(label: Text('Temp')),
                  DataColumn(label: Text('Humidity')),
                  DataColumn(label: Text('Pressure')),
                  DataColumn(label: Text('Wind')),
                  DataColumn(label: Text('Rain')),
                ],
                rows: const [], // Keep rows empty to only show the header
              ),
            ),
            // Scrollable rows
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: DataTable(
                    columns: [
                      DataColumn(label: Text('Time')), // Reuse column definitions
                      DataColumn(label: Text('Condition')),
                      DataColumn(label: Text('Temp')),
                      DataColumn(label: Text('Humidity')),
                      DataColumn(label: Text('Pressure')),
                      DataColumn(label: Text('Wind')),
                      DataColumn(label: Text('Rain')),
                    ],
                    rows: weatherData
                        .map(
                          (data) => DataRow(
                            cells: [
                              DataCell(Text(data['time'].toString())),
                              DataCell(Text(data['condition'])),
                              DataCell(Text(data['temperature'])),
                              DataCell(Text(data['humidity'])),
                              DataCell(Text(data['pressure'])),
                              DataCell(Text(data['wind_speed'])),
                              DataCell(Text(data['rain'])),
                            ],
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
            ),
          ],
        ),
);
}
}
