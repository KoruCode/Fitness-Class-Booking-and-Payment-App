import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/fitness_booking_screen.dart';

void main() {
  runApp(FitnessBookingApp());
}

class FitnessBookingApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fitness Class Booking',
      theme: ThemeData(primarySwatch: Colors.teal),
      debugShowCheckedModeBanner: false, // Remove debug banner
      home: LoginScreen(),
      routes: {
        '/booking': (context) => FitnessBookingScreen(),
      },
    );
  }
}
