import 'package:flutter/material.dart';
import 'api.dart';

class AppointmentsPage_rdv extends StatefulWidget {
  @override
  _AppointmentsPageState createState() => _AppointmentsPageState();
}

class _AppointmentsPageState extends State<AppointmentsPage_rdv> {
  final ApiService apiService = ApiService();
  List<dynamic> _appointments = [];

  @override
  void initState() {
    super.initState();
    _loadAppointments();
  }

  void _loadAppointments() async {
    try {
      final appointments = await apiService.getAppointments();
      setState(() {
        _appointments = appointments;
      });
    } catch (e) {
      print('Error loading appointments: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Appointments')),
      body: _appointments.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _appointments.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(_appointments[index]['motif']),
                  subtitle: Text('Date: ${_appointments[index]['date_rdv']}'),
                  trailing: Text('Statut: ${_appointments[index]['statut']}'),
                );
              },
            ),
    );
  }
}
