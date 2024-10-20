import 'package:flutter/material.dart';
import 'package:get/get.dart'; // Import GetX for Snackbar

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  SignupPageState createState() => SignupPageState();
}

class SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final FocusNode _passwordFocus = FocusNode();
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Signup'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildTextFormField(
                controller: firstNameController,
                label: 'First Name',
                validatorMessage: 'Please enter your first name',
              ),
              const SizedBox(height: 16.0),
              buildTextFormField(
                controller: lastNameController,
                label: 'Last Name',
                validatorMessage: 'Please enter your last name',
              ),
              const SizedBox(height: 16.0),
              buildTextFormField(
                controller: emailController,
                label: 'Email',
                keyboardType: TextInputType.emailAddress,
                validatorMessage: 'Please enter a valid email address',
                customValidator: (value) {
                  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                      .hasMatch(value!)) {
                    return 'Please enter a valid email address';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              buildPasswordField(),
              const SizedBox(height: 16.0),
              buildPasswordRules(), // Display password rules here
              const SizedBox(height: 24.0),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      Get.snackbar('Success', 'Signup successful');
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                  ),
                  child: const Text(
                    'Sign Up',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextFormField({
    required TextEditingController controller,
    required String label,
    required String validatorMessage,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? customValidator,
  }) {
    return TextFormField(
      controller: controller,
      cursorColor: Colors.teal,
      style: const TextStyle(color: Colors.teal),
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.teal, width: 2.0),
        ),
      ),
      validator: customValidator ??
          (value) {
            if (value == null || value.isEmpty) {
              return validatorMessage;
            }
            return null;
          },
    );
  }

  Widget buildPasswordField() {
    return TextFormField(
      controller: passwordController,
      focusNode: _passwordFocus,
      obscureText: _obscurePassword,
      cursorColor: Colors.teal,
      style: TextStyle(
        color: _passwordFocus.hasFocus ? Colors.teal : Colors.black,
      ),
      decoration: InputDecoration(
        labelText: 'Password',
        labelStyle: TextStyle(
          color: _passwordFocus.hasFocus ? Colors.teal : Colors.grey,
        ),
        border: const OutlineInputBorder(),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.teal, width: 2.0),
        ),
        suffixIcon: IconButton(
          icon: Icon(
            _obscurePassword ? Icons.visibility_off : Icons.visibility,
            color: Colors.teal,
          ),
          onPressed: () {
            setState(() {
              _obscurePassword = !_obscurePassword;
            });
          },
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a password';
        }
        if (value.length < 8 || value.length > 16) {
          return 'Password must be 8-16 characters long';
        }
        if (!RegExp(r'^(?=.*[a-zA-Z])(?=.*\d)[A-Za-z\d]+$')
            .hasMatch(value)) {
          return 'Password must be alphanumeric';
        }
        return null;
      },
      onTap: () {
        setState(() {}); // Refresh UI to update text color
      },
    );
  }

  Widget buildPasswordRules() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Password Requirements:',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.teal,
          ),
        ),
        SizedBox(height: 8.0),
        BulletPoint(text: 'Must be 8-16 characters long.'),
        BulletPoint(text: 'Must be alphanumeric.'),
      ],
    );
  }
}

class BulletPoint extends StatelessWidget {
  final String text;

  const BulletPoint({super.key, required this.text}); // Named parameter for text

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('• ', style: TextStyle(color: Colors.teal)),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(color: Colors.black),
          ),
        ),
      ],
    );
  }
}
//Signup lai bottom ma rakhne , I am not a robot add garne 
//password requirements add garne 