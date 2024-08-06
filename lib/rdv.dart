class Appointment {
  final String patientName;
  final String doctorName;
  final String date;
  final String time;
  String status;

  Appointment({
    required this.patientName,
    required this.doctorName,
    required this.date,
    required this.time,
    this.status = 'pending',
  });
}
