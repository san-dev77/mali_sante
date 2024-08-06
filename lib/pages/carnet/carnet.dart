import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PatientMedicalRecordPage extends StatefulWidget {
  @override
  _PatientMedicalRecordPageState createState() =>
      _PatientMedicalRecordPageState();
}

class _PatientMedicalRecordPageState extends State<PatientMedicalRecordPage> {
  List<String> selectedSymptoms = [];
  List<String> treatments = [];

  @override
  void initState() {
    super.initState();
    _loadMedicalData();
  }

  _loadMedicalData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      selectedSymptoms = prefs.getStringList('selectedSymptoms') ?? [];
      treatments = prefs.getStringList('treatments') ?? [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mon Carnet Médical'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListView(
          children: [
            Text(
              'Symptômes sélectionnés :',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            ...selectedSymptoms.map((symptom) => ListTile(
                  title: Text(symptom),
                  leading: Icon(Icons.check, color: Colors.blue),
                )),
            SizedBox(height: 20),
            Text(
              'Traitements prescrits :',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            ...treatments.map((treatment) => ListTile(
                  title: Text(treatment),
                  leading: Icon(Icons.medical_services, color: Colors.green),
                )),
          ],
        ),
      ),
    );
  }
}
