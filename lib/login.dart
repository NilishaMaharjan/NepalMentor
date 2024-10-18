import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  bool isMentee = true; // Track whether 'Mentee' or 'Mentor' is selected.

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Log in',
                  style: TextStyle(
                    fontSize: 32.0,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 32.0),

                // Tabs for 'Mentee' and 'Mentor'
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    buildRoleTab('I\'m a mentee', isMentee),
                    buildRoleTab('I\'m a mentor', !isMentee),
                  ],
                ),
                const SizedBox(height: 24.0),

                // Email/Username TextField
                const TextField(
                  decoration: InputDecoration(
                    labelText: 'Email or username',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16.0),

                // Password TextField
                const TextField(
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                ),
                const SizedBox(height: 24.0),

                // Log in Button
                ElevatedButton(
                  onPressed: () {
                    // Handle login logic here
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal, // Button color
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                  ),
                  child: const Text('Log in'),
                ),
                const SizedBox(height: 8.0),

                // 'Or' between Log in and Google Login
                const Text(
                  'or',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16.0, color: Colors.grey),
                ),
                const SizedBox(height: 8.0),

                // Google Login Button
                TextButton.icon(
                  onPressed: () {
                    // Handle Google login logic
                  },
                  icon: const Icon(Icons.login, color: Colors.black),
                  label: const Text(
                    'Log in with Google',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
                const SizedBox(height: 16.0),

                // Forgot Password
                TextButton(
                  onPressed: () {
                    // Handle forgot password logic
                  },
                  child: const Text('Forgot password?'),
                ),
                const SizedBox(height: 16.0),

                // Sign-up Options for Mentee or Mentor
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have an account?"),
                    const SizedBox(height: 4.0),
                    GestureDetector(
                      onTap: () {
                        // Handle mentee sign-up logic
                      },
                      child: const Text(
                        'Sign up as a mentee',
                        style: TextStyle(
                          color: Colors.teal,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4.0),
                    const Text('or'),
                    const SizedBox(height: 4.0),
                    GestureDetector(
                      onTap: () {
                        // Handle mentor application logic
                      },
                      child: const Text(
                        'Apply to be a mentor',
                        style: TextStyle(
                          color: Colors.teal,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper function to build role selection tab
  Widget buildRoleTab(String title, bool isSelected) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isMentee = title.contains('mentee');
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: Column(
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.teal : Colors.grey,
              ),
            ),
            const SizedBox(height: 4.0),
            if (isSelected)
              Container(
                height: 2.0,
                width: 80.0,
                color: Colors.teal,
              ),
          ],
        ),
      ),
    );
  }
}
