import 'package:flutter/material.dart';
import 'package:nepalmentors/splashview.dart';
import 'package:nepalmentors/welcome.dart';
import 'package:nepalmentors/login.dart';
import 'package:nepalmentors/register.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
      initialRoute: 'MySplash',
      routes: {
        'MySplash': (context ) => const MySplash(),
        'Welcome': (context) =>  const WelcomeScreen(),
        'login': (context) => const MyLogin(),
        'register': (context) => const MyRegister()
      },
  ));
}


