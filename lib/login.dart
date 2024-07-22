import 'package:flutter/material.dart';

class MyLogin extends StatefulWidget{
  const MyLogin({super.key});

  @override
  MyLoginState createState() => MyLoginState();
}

class MyLoginState extends State<MyLogin> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/login.png'), fit: BoxFit.cover)),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            Container(
              padding: const EdgeInsets.only(left: 35, top: 280),
              child: const Text(
                'Welcome',
                style: TextStyle(color: Colors.black87, fontSize: 50),
              ),
            ),
            SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(
                    top: MediaQuery
                        .of(context)
                        .size
                        .height * 0.5,
                    right: 35,
                    left: 35),
                child: Column(
                  children: [
                    TextField(
                      decoration: InputDecoration(
                          fillColor: Colors.grey.shade200,
                          filled: true,
                          hintText: 'Email',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15))),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    TextField(
                      obscureText: true,
                      decoration: InputDecoration(
                          fillColor: Colors.grey.shade200,
                          filled: true,
                          hintText: 'Password',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15))),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Sign In',
                          style: TextStyle(
                              fontSize: 27, fontWeight: FontWeight.w700),
                        ),
                        CircleAvatar(
                          radius: 20,
                          backgroundColor: const Color(0xff4c505b),
                          child: IconButton(
                            color: Colors.white,
                            onPressed: () {},
                            icon: const Icon(Icons.arrow_forward),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, 'register');
                            },
                            child: const Text(
                              'Sign Up',
                              style: TextStyle(
                                decoration: TextDecoration.underline,
                                fontSize: 18,
                                color: Color(0xff4c505b),
                              ),
                            )),
                        TextButton(
                            onPressed: () {},
                            child: const Text(
                              'Forgot password',
                              style: TextStyle(
                                decoration: TextDecoration.underline,
                                fontSize: 18,
                                color: Color(0xff4c505b),
                              ),
                            ))
                      ],
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}