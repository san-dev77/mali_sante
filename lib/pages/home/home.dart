import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:hopitalmap/map_hopital.dart';
import 'package:hopitalmap/pages/carnet/carnet.dart';
import 'package:hopitalmap/pages/chat_bot/chat.dart';
import 'package:hopitalmap/pages/consultation/consultation.dart';
import 'package:hopitalmap/pages/consultation/models.dart';
import 'package:hopitalmap/pages/consultation/patient.dart';
import 'package:hopitalmap/pages/forms/login.dart';
import 'package:hopitalmap/pages/forms/sign_up.dart';
import 'package:hopitalmap/pages/geo/centreListePage.dart';
import 'package:hopitalmap/pages/health_tips/health_tips_page.dart';
import 'package:hopitalmap/pages/note/centreListePage.dart';
import 'package:hopitalmap/pages/note/note.dart';
import 'package:hopitalmap/pages/profil/profil.dart';
import 'package:hopitalmap/pages/rdv/rdv.dart';
import 'package:hopitalmap/rdv.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
      routes: {
        '/rechercher': (context) => CentresListPage_map(),
        '/rdv': (context) => HomePage(),
        '/profil': (context) => ProfilPage(),
        '/note': (context) => NoteAvisPage(),
        '/centres': (context) => CentresListPage_note(),
      },
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late String greeting;
  int adviceIndex = 0;
  double _rating = 3.0; // Default rating
  List<String> advices = [
    "Prenez soin de votre santé mentale.",
    "Buvez beaucoup d'eau chaque jour.",
    "Faites de l'exercice régulièrement.",
    "Mangez équilibré et varié.",
    "Dormez suffisamment chaque nuit.",
  ];

  @override
  void initState() {
    super.initState();
    greeting = _getGreeting();
    _showNotification(); // Afficher la notification lorsque la page est chargée
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Bonjour';
    } else if (hour < 18) {
      return 'Bon après-midi';
    } else {
      return 'Bonsoir';
    }
  }

  void _updateAdvice() {
    setState(() {
      adviceIndex = (adviceIndex + 1) % advices.length;
    });
  }

  void _showNotification() {
    // Afficher un SnackBar pour la notification
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Bienvenue sur Mali santé !'),
          backgroundColor: Color.fromARGB(255, 5, 175, 39),
          duration:
              Duration(seconds: 3), // Durée d'affichage de la notification
        ),
      );
    });
  }

  void _contactUs() async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: 'support@malisante.com',
      query: 'subject=Assistance&body=Bonjour,',
    );
    if (await canLaunch(emailUri.toString())) {
      await launch(emailUri.toString());
    } else {
      _showErrorDialog('Impossible d\'ouvrir l\'application de messagerie.');
    }
  }

  void _showRatingDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Noter nous"),
          content: RatingBar.builder(
            initialRating: _rating,
            minRating: 1,
            direction: Axis.horizontal,
            allowHalfRating: true,
            itemCount: 5,
            itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
            itemBuilder: (context, _) => Icon(
              Icons.star,
              color: Colors.amber,
            ),
            onRatingUpdate: (rating) {
              setState(() {
                _rating = rating;
              });
            },
          ),
          actions: <Widget>[
            TextButton(
              child: Text("Envoyer"),
              onPressed: () {
                Navigator.of(context).pop();
                // Envoyer la note
              },
            ),
          ],
        );
      },
    );
  }

  void _showRegionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Changer de région"),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                ListTile(
                  title: Text('Bamako'),
                  onTap: () {
                    // Changer de région
                    Navigator.of(context).pop();
                  },
                ),
                ListTile(
                  title: Text('Kayes'),
                  onTap: () {
                    // Changer de région
                    Navigator.of(context).pop();
                  },
                ),
                ListTile(
                  title: Text('Koulikoro'),
                  onTap: () {
                    // Changer de région
                    Navigator.of(context).pop();
                  },
                ),
                // Ajoutez d'autres régions ici
              ],
            ),
          ),
        );
      },
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Erreur"),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.of(context).pop(); // Fermer la popup
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                      'assets/img/bg1.jpg'), // Path to your header image
                  fit: BoxFit.cover,
                ),
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.contact_mail),
              title: Text('Nous contacter'),
              onTap: _contactUs,
            ),
            ListTile(
              leading: Icon(Icons.rate_review),
              title: Text('Notez nous'),
              onTap: _showRatingDialog,
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Paramètres'),
              onTap: _showRegionDialog,
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset(
              'assets/img/bg3.jpg', // Change this path to your image path
              fit: BoxFit.cover,
            ),
          ),
          // Overlay effect
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.2),
            ),
          ),
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header with greeting, logo, and menu button
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 20.0),
                  child: Row(
                    children: [
                      Image.asset(
                        'assets/Icones/logo_app.png', // Path to your logo image
                        height: 50,
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          '$greeting',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Builder(
                          builder: (context) => IconButton(
                            icon: Icon(Icons.menu, color: Colors.blue),
                            onPressed: () => Scaffold.of(context).openDrawer(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                children: [
                                  Image.asset(
                                    'assets/Icones/bot_tips.png', // Path to your bot image
                                    height: 80,
                                  ),
                                  SizedBox(width: 16),
                                  Expanded(
                                    child: Text(
                                      advices[adviceIndex],
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: GridView.count(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            crossAxisCount: 2,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                            children: [
                              _buildFeatureCard(
                                context,
                                imagePath:
                                    'assets/Icones/carnet.png', // Path to your feature image
                                text: 'Mon carnet',
                                destination:
                                    PatientMedicalRecordPage(), // Change to your target page
                              ),
                              _buildFeatureCard(
                                context,
                                imagePath:
                                    'assets/Icones/consultation.png', // Path to your feature image
                                text: 'Consultation',
                                destination:
                                    ConsultationsPage(), // Change to your target page
                              ),
                              _buildFeatureCard(
                                context,
                                imagePath:
                                    'assets/Icones/geo.png', // Path to your feature image
                                text: 'Rechercher',
                                destination: CentresListPage_map(),
                              ),
                              _buildFeatureCard(
                                context,
                                imagePath:
                                    'assets/Icones/centre.png', // Path to your feature image
                                text: 'Centres',
                                destination: CentresListPage_note(),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.blue, // Couleur de fond du BottomNavigationBar
        selectedItemColor: Colors.green, // Couleur des icônes sélectionnées
        unselectedItemColor: const Color.fromARGB(
            255, 16, 15, 15), // Couleur des icônes non sélectionnées
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Accueil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Rechercher',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.event),
            label: 'RDV',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
        onTap: (index) {
          switch (index) {
            case 0:
              // Accueil (do nothing or handle differently if needed)
              break;
            case 1:
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CentresListPage_map()));
              break;
            case 2:
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => DoctorAvailabilityPage()));
              break;
            case 3:
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ProfilPage()));
              break;
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => HealthTipsPage()));
        },
        child: Icon(Icons.lightbulb_outline),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildFeatureCard(BuildContext context,
      {required String imagePath,
      required String text,
      required Widget destination}) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => destination),
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              imagePath,
              height: 80,
            ),
            SizedBox(height: 8),
            Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
