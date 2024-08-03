import 'package:hopitalmap/map_hopital.dart';
import 'package:hopitalmap/pages/home/home.dart';
import 'package:flutter/material.dart';
import 'package:hopitalmap/pages/forms/login.dart';
import 'package:hopitalmap/pages/forms/sign_up.dart';
import 'package:hopitalmap/pages/truc/delayed_anime.dart';
import 'package:hopitalmap/pages/welcome/ShowFeatures.dart';
import 'package:hopitalmap/pages/map/map.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              color:
                  Colors.black.withOpacity(0.3), // Change the opacity as needed
            ),
          ),
          // Foreground content
          Center(
            child: SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 60, horizontal: 30),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        DelayedAnimation(
                          child: Text(
                            "Bienvenue sur\n Mali Santé",
                            style: TextStyle(
                              fontSize: 27,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          delay: 1200,
                        ),
                        SizedBox(
                            width: 10), // Espacement entre le texte et l'image
                        DelayedAnimation(
                          child: Image.asset("assets/Icones/logo_app.png",
                              height: 100),
                          delay: 1200,
                        ),
                      ],
                    ),
                    SizedBox(
                        height: 40), // Espacement entre la rangée et le bouton
                    DelayedAnimation(
                      child: Text(
                        "Votre allié sûr en matière de santé !",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      delay: 1200,
                    ),
                    SizedBox(
                        height: 150), // Espacement entre le texte et le bouton
                    DelayedAnimation(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => FeaturesPage()),
                          );
                        },
                        icon: Icon(Icons.explore),
                        label: Text("Découvrir"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue, // Button color
                          foregroundColor: Colors.white, // Text color
                          textStyle: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          elevation: 15,
                          padding: EdgeInsets.symmetric(
                              horizontal: 24, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ),
                      delay: 1200,
                    ),
                    SizedBox(
                        height:
                            100), // Espacement entre le bouton et les deux autres boutons
                    DelayedAnimation(
                      child: Row(
                        children: [
                          Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 1.0),
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            InscriptionPage()),
                                  );
                                },
                                icon: Icon(Icons.person_add),
                                label: Text("S'inscrire"),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green, // Button color
                                  foregroundColor: Colors.white, // Text color
                                  textStyle: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  elevation: 10,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 24, vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 10, width: 5),
                          Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 1.0),
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              HomePage()) //ConnexionPage()),
                                      );
                                },
                                icon: Icon(Icons.login),
                                label: Text("Connexion"),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Colors.orange, // Button color
                                  foregroundColor: Colors.white, // Text color
                                  textStyle: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold, // Gras
                                  ),
                                  shadowColor:
                                      Colors.black, // Couleur de l'ombre
                                  elevation: 12, // Hauteur de l'ombre
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 24, vertical: 12),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      delay: 1200,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: WelcomePage(),
  ));
}
