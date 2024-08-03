import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:hopitalmap/rdv.dart';
import 'firebase_options.dart';
import 'package:hopitalmap/map_hopital.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hopitalmap/pages/home/splash_screen.dart';
import 'package:hopitalmap/pages/consultation/pre-consultation.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Mali Santé',
        theme: ThemeData(
          textTheme: GoogleFonts.robotoTextTheme(),
        ),
        home: SplashScreen()
        //PreConsultationPage(),
        //AppointmentsPage(),
        );
  }
}
