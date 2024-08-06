import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class MedicalRecord {
  final String date;
  final String doctorName;
  final String diagnosis;
  final String prescription;

  MedicalRecord({
    required this.date,
    required this.doctorName,
    required this.diagnosis,
    required this.prescription,
  });

  Map<String, dynamic> toJson() => {
        'date': date,
        'doctorName': doctorName,
        'diagnosis': diagnosis,
        'prescription': prescription,
      };

  static MedicalRecord fromJson(Map<String, dynamic> json) => MedicalRecord(
        date: json['date'],
        doctorName: json['doctorName'],
        diagnosis: json['diagnosis'],
        prescription: json['prescription'],
      );
}

class DoctorMedicalRecordPage extends StatefulWidget {
  @override
  _DoctorMedicalRecordPageState createState() =>
      _DoctorMedicalRecordPageState();
}

class _DoctorMedicalRecordPageState extends State<DoctorMedicalRecordPage> {
  List<MedicalRecord> records = [];

  @override
  void initState() {
    super.initState();
    _loadRecords();
  }

  Future<void> _loadRecords() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? recordsJson = prefs.getString('medical_records');
    if (recordsJson != null) {
      List<dynamic> recordsList = jsonDecode(recordsJson);
      setState(() {
        records = recordsList
            .map((recordJson) => MedicalRecord.fromJson(recordJson))
            .toList();
      });
    }
  }

  Future<void> _saveRecords() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String recordsJson = jsonEncode(records.map((e) => e.toJson()).toList());
    await prefs.setString('medical_records', recordsJson);
  }

  void _addRecord(MedicalRecord record) {
    setState(() {
      records.add(record);
    });
    _saveRecords();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Carnet Médical (Docteur)'),
      ),
      body: ListView.builder(
        itemCount: records.length,
        itemBuilder: (context, index) {
          final record = records[index];
          return Card(
            margin: EdgeInsets.all(10),
            child: ListTile(
              title: Text(record.date),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Médecin: ${record.doctorName}'),
                  Text('Diagnostic: ${record.diagnosis}'),
                  Text('Prescription: ${record.prescription}'),
                ],
              ),
              trailing: Icon(Icons.arrow_forward),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        MedicalRecordDetailPage(record: record),
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddMedicalRecordPage(onAdd: _addRecord),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class AddMedicalRecordPage extends StatefulWidget {
  final Function(MedicalRecord) onAdd;

  AddMedicalRecordPage({required this.onAdd});

  @override
  _AddMedicalRecordPageState createState() => _AddMedicalRecordPageState();
}

class _AddMedicalRecordPageState extends State<AddMedicalRecordPage> {
  final _formKey = GlobalKey<FormState>();
  final _dateController = TextEditingController();
  final _doctorNameController = TextEditingController();
  final _diagnosisController = TextEditingController();
  final _prescriptionController = TextEditingController();

  void _addRecord() {
    if (_formKey.currentState!.validate()) {
      final newRecord = MedicalRecord(
        date: _dateController.text,
        doctorName: _doctorNameController.text,
        diagnosis: _diagnosisController.text,
        prescription: _prescriptionController.text,
      );
      widget.onAdd(newRecord);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ajouter un Enregistrement Médical'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _dateController,
                decoration: InputDecoration(labelText: 'Date'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer la date';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _doctorNameController,
                decoration: InputDecoration(labelText: 'Nom du Médecin'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer le nom du médecin';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _diagnosisController,
                decoration: InputDecoration(labelText: 'Diagnostic'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer le diagnostic';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _prescriptionController,
                decoration: InputDecoration(labelText: 'Prescription'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer la prescription';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _addRecord,
                child: Text('Ajouter'),
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
            ],
          ),
        ),
      ),
    );
  }
}

class MedicalRecordDetailPage extends StatelessWidget {
  final MedicalRecord record;

  MedicalRecordDetailPage({required this.record});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Détail du Carnet Médical'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Date: ${record.date}',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text('Médecin: ${record.doctorName}',
                style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
            Text('Diagnostic: ${record.diagnosis}',
                style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
            Text('Prescription: ${record.prescription}',
                style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
