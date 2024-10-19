import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nepalmentors/splashview.dart';
import 'package:nepalmentors/login.dart';
import 'package:nepalmentors/mentorregister1.dart'; // Import the Mentor Application Page

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/splash',
      getPages: [
        GetPage(name: '/splash', page: () => const MySplash()),
        GetPage(name: '/login', page: () => const LoginScreen()),
        GetPage(name: '/mentorregistration', page: () => const  MentorRegistration()), // Add route
      ],
    );
  }
}
