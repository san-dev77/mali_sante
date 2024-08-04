import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hopitalmap/pages/consultation/data_provider.dart';

class PatientPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Patients - Liste des Docteurs'),
      ),
      body: Consumer<DataProvider>(
        builder: (context, dataProvider, child) {
          return ListView.builder(
            itemCount: dataProvider.doctors.length,
            itemBuilder: (context, index) {
              final doctor = dataProvider.doctors[index];
              return Card(
                margin: EdgeInsets.all(10),
                child: ListTile(
                  title: Text(doctor['name']!),
                  subtitle: Text('Disponibilité: ${doctor['availability']}'),
                  trailing: IconButton(
                    icon: Icon(Icons.add),
                    onPressed: () {
                      _showAppointmentDialog(context, doctor['name']!);
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _showAppointmentDialog(BuildContext context, String doctorName) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Demander un rendez-vous'),
          content:
              Text('Voulez-vous demander un rendez-vous avec $doctorName?'),
          actions: [
            TextButton(
              child: Text('Annuler'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Confirmer'),
              onPressed: () {
                Navigator.of(context).pop();
                Provider.of<DataProvider>(context, listen: false)
                    .addAppointment('Demande de RDV avec $doctorName');
              },
            ),
          ],
        );
      },
    );
  }
}
