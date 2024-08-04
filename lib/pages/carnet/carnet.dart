import 'package:flutter/material.dart';

class MedicalRecordPage extends StatefulWidget {
  @override
  _MedicalRecordPageState createState() => _MedicalRecordPageState();
}

class _MedicalRecordPageState extends State<MedicalRecordPage> {
  final List<Map<String, String>> medicalRecords = [];

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _sexController = TextEditingController();
  final TextEditingController _bloodGroupController = TextEditingController();
  final TextEditingController _allergiesController = TextEditingController();
  final TextEditingController _medicationsController = TextEditingController();
  final TextEditingController _vaccinationsController = TextEditingController();
  final TextEditingController _reportsController = TextEditingController();

  void _addMedicalRecord() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        medicalRecords.add({
          'name': _nameController.text,
          'age': _ageController.text,
          'sex': _sexController.text,
          'bloodGroup': _bloodGroupController.text,
          'allergies': _allergiesController.text,
          'medications': _medicationsController.text,
          'vaccinations': _vaccinationsController.text,
          'reports': _reportsController.text,
        });
      });
      _nameController.clear();
      _ageController.clear();
      _sexController.clear();
      _bloodGroupController.clear();
      _allergiesController.clear();
      _medicationsController.clear();
      _vaccinationsController.clear();
      _reportsController.clear();
      Navigator.pop(context);
    }
  }

  void _showAddRecordDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Ajouter une fiche médicale'),
          content: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(labelText: 'Nom'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez entrer un nom';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _ageController,
                    decoration: InputDecoration(labelText: 'Âge'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez entrer un âge';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _sexController,
                    decoration: InputDecoration(labelText: 'Sexe'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez entrer le sexe';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _bloodGroupController,
                    decoration: InputDecoration(labelText: 'Groupe sanguin'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez entrer le groupe sanguin';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _allergiesController,
                    decoration: InputDecoration(labelText: 'Allergies'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez entrer les allergies';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _medicationsController,
                    decoration: InputDecoration(labelText: 'Médicaments'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez entrer les médicaments';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _vaccinationsController,
                    decoration: InputDecoration(labelText: 'Vaccinations'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez entrer les vaccinations';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _reportsController,
                    decoration: InputDecoration(labelText: 'Rapports médicaux'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez entrer les rapports médicaux';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              child: Text('Annuler'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: Text('Ajouter'),
              onPressed: _addMedicalRecord,
            ),
          ],
        );
      },
    );
  }

  Widget _buildMedicalRecordCard(Map<String, String> record) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Nom: ${record['name']}',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text('Âge: ${record['age']}'),
            Text('Sexe: ${record['sex']}'),
            Text('Groupe sanguin: ${record['bloodGroup']}'),
            Text('Allergies: ${record['allergies']}'),
            Text('Médicaments: ${record['medications']}'),
            Text('Vaccinations: ${record['vaccinations']}'),
            Text('Rapports médicaux: ${record['reports']}'),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    // Implement edit functionality
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    setState(() {
                      medicalRecords.remove(record);
                    });
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Carnet Médical'),
      ),
      body: ListView.builder(
        itemCount: medicalRecords.length,
        itemBuilder: (context, index) {
          final record = medicalRecords[index];
          return _buildMedicalRecordCard(record);
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: _showAddRecordDialog,
      ),
    );
  }
}
