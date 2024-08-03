import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'pre-consultation.dart';

class ConsultationsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset(
              'assets/img/bg4.jpg', // Change this path to your image path
              fit: BoxFit.cover,
            ),
          ),
          // Overlay effect
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.5),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      Text(
                        'Consultations',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(
                          width: 48), // Placeholder for centering the title
                    ],
                  ),
                ),
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.all(10),
                    children: [
                      _buildConsultationCard(
                        context,
                        title: 'Nouvelle Consultation',
                        icon: Icons.medical_services,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => PreConsultationPage()),
                          );
                        },
                      ),
                      _buildConsultationCard(
                        context,
                        title: 'Consultations Passées',
                        icon: Icons.history,
                        onTap: () {
                          // Navigate to past consultations
                        },
                      ),
                      _buildConsultationCard(
                        context,
                        title: 'Mes Rendez-vous',
                        icon: Icons.calendar_today,
                        onTap: () {
                          // Navigate to appointments
                        },
                      ),
                      _buildConsultationCard(
                        context,
                        title: 'Paramètres de Santé',
                        icon: Icons.settings,
                        onTap: () {
                          // Navigate to health settings
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConsultationCard(BuildContext context,
      {required String title,
      required IconData icon,
      required VoidCallback onTap}) {
    return FadeInUp(
      child: Card(
        margin: EdgeInsets.symmetric(vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        elevation: 5,
        child: ListTile(
          contentPadding: EdgeInsets.all(15),
          leading: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 30,
            ),
          ),
          title: Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          trailing: Icon(Icons.arrow_forward_ios),
          onTap: onTap,
        ),
      ),
    );
  }
}
