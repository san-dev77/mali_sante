import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DoctorHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Accueil Médecin'),
      ),
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset(
              'assets/img/bg1.jpg',
              fit: BoxFit.cover,
            ),
          ),
          // Overlay effect
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.5),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => DoctorHomePage()),
                    );
                  },
                  child: Text('Voir Rendez-vous'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    textStyle:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => DoctorMedicalRecordPage()),
                    );
                  },
                  child: Text('Gestion du Carnet Médical'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    textStyle:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    await prefs.clear();
                    Navigator.pushReplacementNamed(context, '/home');
                  },
                  child: Text('Déconnexion'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    textStyle:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DoctorMedicalRecordPage extends StatefulWidget {
  @override
  _DoctorMedicalRecordPageState createState() =>
      _DoctorMedicalRecordPageState();
}

class _DoctorMedicalRecordPageState extends State<DoctorMedicalRecordPage> {
  List<String> selectedSymptoms = [];
  List<String> treatments = [];

  final TextEditingController _treatmentController = TextEditingController();

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

  _saveTreatment() async {
    if (_treatmentController.text.isNotEmpty) {
      setState(() {
        treatments.add(_treatmentController.text);
      });
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setStringList('treatments', treatments);
      _treatmentController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Carnet Médical du Patient'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListView(
          children: [
            Text(
              'Symptômes sélectionnés par le patient :',
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
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: TextField(
                controller: _treatmentController,
                decoration: InputDecoration(
                  labelText: 'Ajouter un traitement',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: _saveTreatment,
              child: Text('Ajouter'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
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
