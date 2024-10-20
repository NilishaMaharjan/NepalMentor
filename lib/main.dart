import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nepalmentors/splashview.dart';
import 'package:nepalmentors/login.dart';
import 'package:nepalmentors/mentorregister1.dart';
import 'package:nepalmentors/mentoradditionalinfo.dart';
import 'package:nepalmentors/dashboard.dart';
import 'package:nepalmentors/signup.dart';
import 'package:nepalmentors/forgetpw.dart';
import 'package:nepalmentors/primary.dart';

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
        GetPage(name: '/signupmentee', page: () => const SignupPage()),
        GetPage(name: '/forgetpassword', page: () => const ForgotPasswordPage()),        GetPage(name: '/mentorregistration', page: () => const MentorRegistration()),
        GetPage(name: '/mentorregistrationinfo', page: () => const MentorAdditionalInfo()), 
        GetPage(name: '/dashboard',page: () => const Dashboard()),
        GetPage(name: '/primarylevel', page: () => const PrimaryLevelPage()),
      ],
    );
  }
}

