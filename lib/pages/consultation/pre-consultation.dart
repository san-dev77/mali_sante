import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../notification.dart'; // Assurez-vous que ce chemin est correct pour votre projet
import 'consultation.dart'; // Assurez-vous que ce chemin est correct pour votre projet

class PreConsultationPage extends StatefulWidget {
  @override
  _PreConsultationPageState createState() => _PreConsultationPageState();
}

class _PreConsultationPageState extends State<PreConsultationPage> {
  final Map<String, bool> symptomsSection1 = {
    'Fièvre': false,
    'Toux': false,
    'Mal de gorge': false,
    'Douleurs musculaires': false,
    'Fatigue': false,
    'Perte d\'odorat': false,
    'Perte de goût': false,
  };

  final Map<String, bool> symptomsSection2 = {
    'Maux de tête': false,
    'Nausées': false,
    'Vertiges': false,
    'Perte d\'appétit': false,
    'Douleurs abdominales': false,
    'Vomissements': false,
    'Constipation': false,
  };

  final Map<String, bool> symptomsSection3 = {
    'Essoufflement': false,
    'Douleur thoracique': false,
    'Palpitations': false,
    'Éruptions cutanées': false,
    'Diarrhée': false,
    'Douleurs articulaires': false,
    'Anxiété': false,
  };

  final NotificationService _notificationService = NotificationService();

  @override
  void initState() {
    super.initState();
    _notificationService.init();
    _showExplanationDialog();
  }

  void _showExplanationDialog() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Pré-consultation'),
            content: Text(
                'Veuillez sélectionner vos symptômes pour aider à déterminer les prochaines étapes de votre consultation.'),
            actions: <Widget>[
              ElevatedButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    });
  }

  void _finishPreConsultation() async {
    List<String> selectedSymptoms = [];

    symptomsSection1.forEach((symptom, selected) {
      if (selected) selectedSymptoms.add(symptom);
    });

    symptomsSection2.forEach((symptom, selected) {
      if (selected) selectedSymptoms.add(symptom);
    });

    symptomsSection3.forEach((symptom, selected) {
      if (selected) selectedSymptoms.add(symptom);
    });

    // Enregistrer les symptômes sélectionnés dans SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('selectedSymptoms', selectedSymptoms);

    _notificationService.showNotification(
      'Pré-consultation',
      'Pré-consultation terminée avec succès',
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            PreConsultationResultPage(selectedSymptoms: selectedSymptoms),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pré-consultation'),
        backgroundColor: Colors.blue,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => ConsultationsPage()));
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListView(
          children: [
            FadeInLeft(
                child: _buildSymptomSection(
                    'Symptômes généraux', symptomsSection1)),
            FadeInRight(
                child: _buildSymptomSection(
                    'Symptômes gastro-intestinaux', symptomsSection2)),
            FadeInLeft(
                child:
                    _buildSymptomSection('Autres symptômes', symptomsSection3)),
            SizedBox(height: 20),
            FadeInUp(
              child: ElevatedButton(
                onPressed: _finishPreConsultation,
                child: Text('Terminer'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: EdgeInsets.symmetric(vertical: 15),
                  textStyle: TextStyle(fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSymptomSection(String title, Map<String, bool> symptoms) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.blue,
              ),
            ),
            ...symptoms.keys.map((symptom) {
              return CheckboxListTile(
                activeColor: Colors.blue,
                checkColor: Colors.white,
                title: Text(symptom),
                value: symptoms[symptom],
                onChanged: (bool? value) {
                  setState(() {
                    symptoms[symptom] = value!;
                  });
                },
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}

class PreConsultationResultPage extends StatelessWidget {
  final List<String> selectedSymptoms;

  PreConsultationResultPage({required this.selectedSymptoms});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Résultats de la pré-consultation'),
        backgroundColor: Colors.blue,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListView(
          children: [
            Text(
              'Vous avez sélectionné les symptômes suivants :',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            ...selectedSymptoms.map((symptom) => ListTile(
                  title: Text(symptom),
                  leading: Icon(Icons.check, color: Colors.blue),
                )),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Retour à la page précédente
              },
              child: Text('Retour'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: EdgeInsets.symmetric(vertical: 15),
                textStyle: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
