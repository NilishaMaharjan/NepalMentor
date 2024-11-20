import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nepalmentors/screens/profile.dart';
import 'package:nepalmentors/screens/splashview.dart';
import 'package:nepalmentors/screens/login.dart';
import 'package:nepalmentors/screens/mentorregister1.dart';
import 'package:nepalmentors/screens/mentoradditionalinfo.dart';
import 'package:nepalmentors/screens/dashboard.dart';
import 'package:nepalmentors/screens/mentordashboard.dart';
import 'package:nepalmentors/screens/signup.dart';
import 'package:nepalmentors/screens/forgetpw.dart';
import 'package:nepalmentors/screens/primary.dart';
import 'package:nepalmentors/screens/mathsavail.dart';
import 'package:nepalmentors/screens/resetpw.dart';
import 'package:nepalmentors/screens/edit_availability.dart'; // Import file for view availability functionality

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
        GetPage(
            name: '/forgetpassword', page: () => const ForgotPasswordPage()),
        GetPage(
            name: '/mentorregistration',
            page: () => const MentorRegistration()),
        GetPage(
            name: '/mentorregistrationinfo',
            page: () => const MentorAdditionalInfo()),
        GetPage(name: '/dashboard', page: () => const Dashboard()),
        GetPage(
          name: '/mentordashboard',
          page: () => const MentorDashboard(), // No need to pass userId
        ),
        GetPage(name: '/primarylevel', page: () => const PrimaryLevelPage()),
        GetPage(name: '/grade7maths', page: () => const MathsPage()),
        GetPage(
          name: '/viewAvailability',
          page: () =>
              const ViewAvailabilityScreen(), // No need to pass userId here
        ),
        GetPage(
          name: '/mentorprofile',
          page: () {
            final userId = Get.parameters['mentorId'] ??
                ''; // Default to empty string if not found
            return MentorProfilePage(userId: userId); // Pass userId here
          },
        ),
        GetPage(
          name: '/reset-password/:token',
          page: () {
            final token = Get.parameters['token']!;
            return ResetPasswordPage(token: token);
          },
        ),
      ],
    );
  }
}
