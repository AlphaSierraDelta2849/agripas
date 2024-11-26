import 'package:flutter/material.dart';
import 'package:agripas/compoments/menu.dart';
import 'package:agripas/compoments/header.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:agripas/utils/colors.dart';

class ConseilAgricolePage extends StatefulWidget {
  const ConseilAgricolePage({Key? key}) : super(key: key);

  @override
  State<ConseilAgricolePage> createState() => _ConseilAgricolePageState();
}

class _ConseilAgricolePageState extends State<ConseilAgricolePage> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: AppColors.blue,
        body: SafeArea(
          child: Column(
            children: [
              // HeaderWidget fixé en haut
              const HeaderWidget(),
              // Contenu défilable
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _buildCarouselSection(),
                      _buildRecommendationsCard(),
                      _buildInfoCard(
                        title: 'FERTILISATION',
                        image: 'assets/images/fertilation.png',
                        description:
                            'Appliquez un engrais riche\n en phosphore pour favoriser la floraison',
                      ),
                      _buildInfoCard(
                        title: 'IRRIGATION',
                        image: 'assets/images/irrigation2.png',
                        description:
                            'Arrosez tôt le matin pour minimiser l’évaporation et prévenir les maladies',
                      ),
                      _buildInfoCard(
                        title: 'MÉTÉO',
                        image: 'assets/images/meteo.png',
                        description:
                            'Prévoyez un arrosage supplémentaire \nen cas de sécheresse prolongée',
                      ),
                    ],
                  ),
                ),
              ),
              // MenuWidget fixé en bas
              const MenuWidget(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCarouselSection() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'TYPE DE CULTURE',
              style: const TextStyle(
                fontFamily: 'Inter',
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.white,
              ),
            ),
          ),
        ),
        CarouselSlider(
          items: [
            _buildCarouselImage('assets/images/tasty-organic-tomatoes-hidden-green-leaves.jpg'),
            _buildCarouselImage('assets/images/close-up-texture-carrots.jpg'),
            _buildCarouselImage('assets/images/arrangement-nutritious-cassava-roots.jpg'),
          ],
          options: CarouselOptions(
            height: 130,
            viewportFraction: 0.5,
            enlargeCenterPage: true,
            enableInfiniteScroll: true,
            onPageChanged: (index, _) {
              setState(() {
                currentIndex = index;
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCarouselImage(String imagePath) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.asset(
        imagePath,
        width: 200,
        height: 200,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _buildRecommendationsCard() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.blue,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'CARTE DE RECOMMANDATIONS',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.white,
                ),
              ),
              const SizedBox(height: 16),
              _buildProgressCard('Germination', 0.3, '30%'),
              _buildProgressCard('Croissance active', 0.5, '50%'),
              _buildProgressCard('Maturation', 0.7, '75%'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgressCard(String title, double percent, String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.white,
            ),
          ),
          LinearPercentIndicator(
            percent: percent,
            lineHeight: 25,
            animation: true,
            progressColor: AppColors.green,
            backgroundColor: AppColors.black.withOpacity(0.2),
            center: Text(
              label,
              style: const TextStyle(
                fontFamily: 'Inter Tight',
                fontSize: 18,
                color: AppColors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard({
    required String title,
    required String image,
    required String description,
  }) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.blue,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.white,
                ),
              ),
              const SizedBox(height: 16),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  image,
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                description,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 15,
                  color: AppColors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
