import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hopitalmap/pages/consultation/data_provider.dart';
import 'pages/home/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SharedPreferences.getInstance();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_) => DataProvider()..loadAppointments()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Mali Santé',
        theme: ThemeData(
          textTheme: GoogleFonts.robotoTextTheme(),
        ),
        home: SplashScreen(),
      ),
    );
  }
}
