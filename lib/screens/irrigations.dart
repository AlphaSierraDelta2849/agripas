import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:agripas/compoments/menu.dart';
import 'package:agripas/compoments/header.dart';
import 'package:agripas/utils/colors.dart'; 

class IrrigationPage extends StatelessWidget {
  const IrrigationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.blue, 
      body: SafeArea(
        child: Column(
          children: [
            const HeaderWidget(),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    _buildSuggestedWaterVolume(context),
                    _buildOptimalIrrigationTimings(context),
                    _buildActionInterface(context),
                    _buildIrrigationSummary(context),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const MenuWidget(), // Composant Menu
    );
  }

  Widget _buildSuggestedWaterVolume(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      color: AppColors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Volume d’Eau Suggéré",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.blue,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Text(
                    "15 mm/ha",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.green,
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(
                      FontAwesomeIcons.infoCircle,
                      color: AppColors.black,
                      size: 20,
                    ),
                    onPressed: () {
                      _showInfoDialog(context);
                    },
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOptimalIrrigationTimings(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Horaires d'Irrigation Optimaux",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.white,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    _IrrigationTimeSlot(
                      time: "6h - 8h",
                      temperature: "18°C",
                      icon: Icons.wb_sunny,
                    ),
                    _IrrigationTimeSlot(
                      time: "18h - 20h",
                      temperature: "22°C",
                      icon: Icons.cloud,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                LinearPercentIndicator(
                  lineHeight: 20,
                  percent: 0.5,
                  animation: true,
                  progressColor: AppColors.green,
                  backgroundColor: AppColors.black.withOpacity(0.2),
                  center: const Text(
                    "Évolution de la température",
                    style: TextStyle(fontSize: 12, color: AppColors.black),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionInterface(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ElevatedButton.icon(
            onPressed: () {
              print("Confirmation");
            },
            icon: const Icon(Icons.check),
            label: const Text("Confirmer"),
            style: ElevatedButton.styleFrom(
              iconColor: AppColors.orange,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          ElevatedButton.icon(
            onPressed: () {
              print("Ajouter une note");
            },
            icon: const Icon(Icons.note_add),
            label: const Text("Ajouter une Note"),
            style: ElevatedButton.styleFrom(
              iconColor: AppColors.orange,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          ElevatedButton.icon(
            onPressed: () {
              print("Modifier");
            },
            icon: const Icon(Icons.edit),
            label: const Text("Modifier"),
            style: ElevatedButton.styleFrom(
              iconColor: AppColors.orange,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIrrigationSummary(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Résumé des Données d'Irrigation Passées",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.white,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              _IrrigationStat(
                label: "Dernière irrigation",
                value: "12 mm/ha",
                date: "24/11/2024",
              ),
              _IrrigationStat(
                label: "Semaine Dernière",
                value: "85 mm/ha",
                date: "",
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Détails du Calcul"),
          content: const Text(
              "Le volume d'eau suggéré est calculé en fonction des caractéristiques du sol, des cultures et des conditions météorologiques."),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Fermer"),
            ),
          ],
        );
      },
    );
  }
}

class _IrrigationTimeSlot extends StatelessWidget {
  final String time;
  final String temperature;
  final IconData icon;

  const _IrrigationTimeSlot({
    required this.time,
    required this.temperature,
    required this.icon,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: AppColors.green, size: 40),
        const SizedBox(height: 8),
        Text(
          time,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold,color: AppColors.blue),
        ),
        const SizedBox(height: 4),
        Text(
          temperature,
          style: const TextStyle(fontSize: 14, color: Colors.red),
        ),
      ],
    );
  }
}

class _IrrigationStat extends StatelessWidget {
  final String label;
  final String value;
  final String date;

  const _IrrigationStat({
    required this.label,
    required this.value,
    this.date = "",
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.black,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            color: AppColors.white,
          ),
        ),
        if (date.isNotEmpty)
          Text(
            date,
            style: const TextStyle(fontSize: 14, color: AppColors.white),
          ),
      ],
    );
  }
}
