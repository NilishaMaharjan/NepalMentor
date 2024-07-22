import 'package:flutter/material.dart';

class MySplash extends StatefulWidget{
  const MySplash({super.key});

  @override
  MySplashState createState() => MySplashState();
  }

class MySplashState extends State<MySplash> {
  @override
  void initState(){
    super.initState();
    Future.delayed(const Duration(seconds: 2),(){
      Navigator.pushReplacementNamed(context, 'welcome');
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

