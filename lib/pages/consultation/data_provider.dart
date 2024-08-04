import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DataProvider with ChangeNotifier {
  List<String> _appointments = [];
  List<Map<String, String>> _doctors = [
    {'name': 'Dr. John Doe', 'availability': 'Lundi, Mercredi, Vendredi'},
    {'name': 'Dr. Jane Smith', 'availability': 'Mardi, Jeudi'},
    {'name': 'Dr. Emily Johnson', 'availability': 'Lundi, Jeudi, Samedi'}
  ];

  List<String> get appointments => _appointments;
  List<Map<String, String>> get doctors => _doctors;

  void addAppointment(String appointment) async {
    _appointments.add(appointment);
    notifyListeners();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList('appointments', _appointments);
  }

  void loadAppointments() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _appointments = prefs.getStringList('appointments') ?? [];
    notifyListeners();
  }
}
