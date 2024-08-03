import 'package:hopitalmap/pages/welcome/welcome_page.dart';
import 'package:hopitalmap/pages/truc/delayed_anime.dart';
import 'package:flutter/material.dart';

class ConnexionPage extends StatelessWidget {
  const ConnexionPage({Key? key}) : super(key: key);

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
          Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16.0),
              child: Form(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        DelayedAnimation(
                          child: Image.asset("assets/Icones/logo_app.png",
                              height: 100),
                          delay: 1200,
                        ),
                        SizedBox(
                            width: 10), // Espacement entre l'image et le texte
                        DelayedAnimation(
                          child: Text(
                            "Mali Santé",
                            style: TextStyle(
                              fontSize: 35,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          delay: 1200,
                        ),
                      ],
                    ),
                    SizedBox(
                        height: 50), // Espacement entre la rangée et le bouton
                    DelayedAnimation(
                      child: Text(
                        "Connexion",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      delay: 1200,
                    ),
                    SizedBox(height: 20),
                    DelayedAnimation(
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Email',
                          labelStyle: TextStyle(color: Colors.white),
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.3),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez entrer votre email';
                          }
                          return null;
                        },
                      ),
                      delay: 1200,
                    ),
                    SizedBox(height: 16),
                    DelayedAnimation(
                      child: TextFormField(
                        decoration: InputDecoration(
                          labelText: 'Mot de passe',
                          labelStyle: TextStyle(color: Colors.white),
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.3),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Veuillez entrer votre mot de passe';
                          }
                          return null;
                        },
                      ),
                      delay: 1200,
                    ),
                    SizedBox(height: 32),
                    DelayedAnimation(
                      child: ElevatedButton(
                        onPressed: () {
                          // Soumettre le formulaire de connexion
                        },
                        child: Text('Connexion',
                            style: TextStyle(color: Colors.white)),
                        style: ElevatedButton.styleFrom(
                          textStyle: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),

                          elevation: 13,
                          backgroundColor: Colors.blue,

                          // Utiliser backgroundColor au lieu de primary
                          padding: EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ),
                      delay: 1200,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 40,
            left: 10,
            child: FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => WelcomePage()),
                );
              },
              child: Icon(Icons.arrow_back),
            ),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: ConnexionPage(),
  ));
}
