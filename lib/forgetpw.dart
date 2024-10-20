import 'package:flutter/material.dart';
import 'package:get/get.dart'; // Import GetX for navigation

class ForgotPasswordPage extends StatelessWidget {
  const ForgotPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Forgot Password'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Reset Your Password',
                  style: TextStyle(
                    fontSize: 32.0,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8.0),
                const Text(
                  'Provide your account\'s email for which you want to reset your password.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 32.0),

                const TextField(
                  decoration: InputDecoration(
                    prefixIcon:  Icon(Icons.email, color: Colors.teal), // Email icon
                    labelText: 'Email',
                    border:  OutlineInputBorder(),
                    focusedBorder:  OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.teal, width: 2.0),
                    ),
                    floatingLabelStyle:  TextStyle(color: Colors.teal),
                  ),
                ),
                const SizedBox(height: 24.0),

                Container(
                  height: 56.0,
                  decoration: BoxDecoration(
                    color: Colors.teal,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      // Implement your password reset logic here
                      Get.snackbar(
                        'Reset Link Sent',
                        'Please check your email for the password reset link.',
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: Colors.white,
                        colorText: Colors.teal,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      padding: EdgeInsets.zero,
                    ),
                    child: const Text(
                      'Send Reset Link',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),

                const SizedBox(height: 16.0),
                TextButton(
                  onPressed: () {
                    // Navigate back to the login page
                    Get.back();
                  },
                  child: const Text('Back to Login',
                  style:TextStyle(color: Colors.black),),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
