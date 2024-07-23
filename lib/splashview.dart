import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:async';

import 'package:nepalmentors/welcome.dart';

class MySplash extends StatefulWidget{
  const MySplash({super.key});

  @override
  MySplashState createState() => MySplashState();
  }

class MySplashState extends State<MySplash> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 2), (){
      Get.to(const WelcomeScreen());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/logo.png'),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}

