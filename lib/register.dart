import 'package:flutter/material.dart';

class MyRegister extends StatefulWidget {
  const MyRegister({super.key});

  @override
  MyRegisterState createState() => MyRegisterState();
}

class MyRegisterState extends State<MyRegister>{
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.transparent
      ),
      backgroundColor: Colors.transparent,
      body: Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/registration.png'),
              fit: BoxFit.cover
          )
      ),
      child: Stack(
        children: [
          Container(
              padding: const EdgeInsets.only(left: 35, top: 130),
              child: const Text(
                'Create\nAccount',
                style: TextStyle(color: Colors.black87, fontSize: 33),
              ),
            ),
            SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height,
                    right: 35,
                    left: 35
                ),
                child: Column(
                    children: [
                      TextField(
                        decoration: InputDecoration(
                          fillColor: Colors.grey.shade100,
                          filled: true,
                          hintText: 'Name',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)
                          )
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              TextField(
                obscureText: true,
                decoration: InputDecoration(
                    fillColor: Colors.grey.shade100,
                    filled: true,
                    hintText: 'Email',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)
                    )
                ),
              ),
                      const SizedBox(
                        height: 30,
                      ),
                      TextField(
                        obscureText: true,
                        decoration: InputDecoration(
                            fillColor: Colors.grey.shade100,
                            filled: true,
                            hintText: 'Password',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10)
                            )
                        ),
                      ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Sign In',
                    style: TextStyle(
                        fontSize: 27,
                        fontWeight: FontWeight.w700
                    ),
                  ),
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: const Color(0xff4c505b),
                    child: IconButton(
                      color: Colors.white,
                      onPressed: (){},
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
                      onPressed: (){
                        Navigator.pushNamed(context, 'register');
                      },
                      child: const Text(
                        'Sign Up',
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                          fontSize: 18,
                          color: Color(0xff4c505b),
                        ),
                      )
                  ),
                  TextButton(
                      onPressed: (){},
                      child: const Text(
                        'Forgot password',
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                          fontSize: 18,
                          color: Color(0xff4c505b),
                        ),
                      )
                  )
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


