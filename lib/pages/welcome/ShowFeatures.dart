import 'package:flutter/material.dart';

class FeaturesPage extends StatefulWidget {
  const FeaturesPage({Key? key}) : super(key: key);

  @override
  _FeaturesPageState createState() => _FeaturesPageState();
}

class _FeaturesPageState extends State<FeaturesPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  void _onPageChanged(int index) {
    setState(() {
      _currentPage = index;
    });
  }

  Widget _buildIndicator(bool isActive) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      margin: EdgeInsets.symmetric(horizontal: 5.0),
      height: isActive ? 12.0 : 8.0,
      width: isActive ? 12.0 : 8.0,
      decoration: BoxDecoration(
        color: isActive ? Colors.white : Colors.white.withOpacity(0.5),
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset(
              'assets/img/bg1.jpg', // Change this path to your image path
              fit: BoxFit.cover,
            ),
          ),
          // Overlay effect
          Positioned.fill(
            child: Container(
              color:
                  Colors.black.withOpacity(0.5), // Change the opacity as needed
            ),
          ),
          PageView(
            controller: _pageController,
            onPageChanged: _onPageChanged,
            children: [
              _buildPage(
                context,
                title: 'Le carnet médical',
                subtitle: "Votre carnet médical, toujours à portée de main",
                imagePath: 'assets/Icones/carnet.png',
                description:
                    'Gardez une trace de toutes vos informations médicales importantes, accessibles partout et à tout moment.',
              ),
              _buildPage(
                context,
                title: 'Géolocalisation',
                subtitle: "En cas d'urgence, nous sommes là",
                imagePath: 'assets/Icones/geo.png',
                description:
                    'Grâce à la géolocalisation, retrouvez les centres de santé les plus proches de vous en un instant.',
              ),
              _buildPage(
                context,
                title: 'Consultation en ligne',
                subtitle: "Consultez un médecin sans quitter votre maison",
                imagePath: 'assets/Icones/consultation.png',
                description:
                    'Réservez une consultation en ligne avec des professionnels de santé qualifiés et obtenez des conseils médicaux en toute sécurité.',
              ),
              _buildPage(
                context,
                title: "Avis et notes",
                subtitle: "Partagez votre expérience",
                imagePath: 'assets/Icones/note.png',
                description:
                    'Laissez une critique ou une suggestion aux établissements de santé qui vous ont marqué et aidez les autres à faire leur choix.',
              ),
              _buildPage(
                context,
                title: "Assistant de santé",
                subtitle: "Votre assistant santé personnel",
                imagePath: 'assets/Icones/bot_tips.png',
                description:
                    'Recevez des conseils de santé personnalisés et restez informé grâce à notre assistant santé intelligent.',
              ),
            ],
          ),
          Positioned(
            top: 40,
            left: 10,
            child: FloatingActionButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Icon(Icons.arrow_back),
            ),
          ),
          // Page indicators
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                  5, (index) => _buildIndicator(index == _currentPage)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPage(BuildContext context,
      {required String imagePath,
      required String title,
      required String subtitle,
      required String description}) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 10),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.bold,
              color: Colors.white70,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20),
          Image.asset(imagePath, height: 200),
          SizedBox(height: 20),
          Text(
            description,
            style: TextStyle(
              fontSize: 16,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: FeaturesPage(),
  ));
}
