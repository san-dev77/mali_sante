import 'package:flutter/material.dart';
import 'package:hopitalmap/rdv.dart';

class AppointmentsPage extends StatefulWidget {
  @override
  _AppointmentsPageState createState() => _AppointmentsPageState();
}

class _AppointmentsPageState extends State<AppointmentsPage> {
  List<Appointment> appointments = [
    Appointment(
      patientName: 'Patient 1',
      doctorName: 'Dr. Smith',
      date: '2024-07-25',
      time: '10:00',
      status: 'pending',
    ),
    Appointment(
      patientName: 'Patient 2',
      doctorName: 'Dr. Smith',
      date: '2024-07-26',
      time: '11:00',
      status: 'confirmed',
    ),
  ];

  void _updateAppointmentStatus(int index, String status) {
    setState(() {
      appointments[index].status = status;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gérer les Rendez-vous'),
      ),
      body: ListView.builder(
        itemCount: appointments.length,
        itemBuilder: (context, index) {
          final appointment = appointments[index];
          return Card(
            margin: EdgeInsets.all(10),
            child: ListTile(
              title: Text('Patient: ${appointment.patientName}'),
              subtitle:
                  Text('Date: ${appointment.date}, Heure: ${appointment.time}'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.check, color: Colors.green),
                    onPressed: () {
                      _updateAppointmentStatus(index, 'confirmed');
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.close, color: Colors.red),
                    onPressed: () {
                      _updateAppointmentStatus(index, 'rejected');
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
