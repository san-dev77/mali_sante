import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ConsultationPage extends StatelessWidget {
  final String doctorName;

  ConsultationPage({required this.doctorName});

  void _startConsultation(BuildContext context) async {
    const url = 'https://zoom.us/join'; // URL pour démarrer la consultation
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Impossible de lancer l\'URL de la consultation.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Consultation avec $doctorName'),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () => _startConsultation(context),
          child: Text('Démarrer la Consultation'),
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            textStyle: TextStyle(fontSize: 18),
            backgroundColor: Colors.blue,
          ),
        ),
      ),
    );
  }
}
