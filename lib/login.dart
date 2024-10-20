import 'package:flutter/material.dart';
import 'package:get/get.dart'; // Import GetX for navigation

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  bool isMentee = true; // Track whether 'Mentee' or 'Mentor' is selected.
  bool _isPasswordVisible = false; // Track password visibility.

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
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.teal, width: 2.0),
                    ),
                    floatingLabelStyle: TextStyle(color: Colors.teal),
                  ),
                ),
                const SizedBox(height: 16.0),

                // Password TextField with Eye Icon
                TextField(
                  obscureText: !_isPasswordVisible,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: const OutlineInputBorder(),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.teal, width: 2.0),
                    ),
                    floatingLabelStyle: const TextStyle(color: Colors.teal),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Colors.teal,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 24.0),

                // Log in Button
                Container(
                  height: 56.0,
                  decoration: BoxDecoration(
                    color: Colors.teal,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      // Navigate to Dashboard using GetX
                      Get.toNamed('/dashboard');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      padding: EdgeInsets.zero,
                    ),
                    child: const Text(
                      'Log in',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),

                const SizedBox(height: 8.0),
                const Text('or', textAlign: TextAlign.center),
                const SizedBox(height: 8.0),

                // Google Login Button
                Container(
                  height: 56.0,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: TextButton.icon(
                    onPressed: () {
                      // Handle Google login logic
                    },
                    icon: const Icon(Icons.login, color: Colors.black),
                    label: const Text(
                      'Log in with Google',
                      style: TextStyle(color: Colors.black),
                    ),
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

                const Text(
                  "Don't have an account?",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14.0),
                ),
                const SizedBox(height: 8.0),

                // Mentor/Mentee Sign-up Options
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
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
                    const Text(' or ', style: TextStyle(fontSize: 14.0)),
                    GestureDetector(
                      onTap: () {
                        // Navigate to the Mentor Registration Screen
                        Get.toNamed('/mentorregistration'); // Example route
                      },
                      child: const Text(
                        'apply to be a mentor',
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

  // Helper function for role selection
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
