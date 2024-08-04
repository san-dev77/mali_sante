import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'models.dart';

class SharedData {
  static const String _appointmentsKey = 'appointments';
  static const String _doctorsKey = 'doctors';

  static Future<void> writeAppointment(Appointment appointment) async {
    final prefs = await SharedPreferences.getInstance();
    final appointments = await readAppointments();
    appointments.add(appointment);
    final String encodedData = jsonEncode(appointments.map((e) => e.toJson()).toList());
    await prefs.setString(_appointmentsKey, encodedData);
  }

  static Future<List<Appointment>> readAppointments() async {
    final prefs = await SharedPreferences.getInstance();
    final String? appointmentsData = prefs.getString(_appointmentsKey);
    if (appointmentsData != null) {
      final List<dynamic> jsonData = jsonDecode(appointmentsData);
      return jsonData.map((e) => Appointment.fromJson(e)).toList();
    }
    return [];
  }

  static Future<void> updateAppointmentStatus(Appointment appointment) async {
    final prefs = await SharedPreferences.getInstance();
    final appointments = await readAppointments();
    final index = appointments.indexWhere((a) => a.id == appointment.id);
    if (index != -1) {
      appointments[index] = appointment;
    }
    final String encodedData = jsonEncode(appointments.map((e) => e.toJson()).toList());
    await prefs.setString(_appointmentsKey, encodedData);
  }

  static Future<List<Doctor>> readDoctors() async {
    final prefs = await SharedPreferences.getInstance();
    final String? doctorsData = prefs.getString(_doctorsKey);
    if (doctorsData != null) {
      final List<dynamic> jsonData = jsonDecode(doctorsData);
      return jsonData.map((e) => Doctor.fromJson(e)).toList();
    }
    return [];
  }

  static Future<void> writeDoctors(List<Doctor> doctors) async {
    final prefs = await SharedPreferences.getInstance();
    final String encodedData = jsonEncode(doctors.map((e) => e.toJson()).toList());
    await prefs.setString(_doctorsKey, encodedData);
  }
}
