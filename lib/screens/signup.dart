import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
  final TextEditingController ageController = TextEditingController();
  final TextEditingController institutionController = TextEditingController();
  final TextEditingController locationController = TextEditingController();

  final FocusNode _firstNameFocus = FocusNode();
  final FocusNode _lastNameFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _ageFocus = FocusNode();
  final FocusNode _institutionFocus = FocusNode();
  final FocusNode _locationFocus = FocusNode();

  bool _obscurePassword = true;
  bool _isRobotChecked = false;

  @override
  void initState() {
    super.initState();
    _addFocusListeners();
  }

  void _addFocusListeners() {
    _firstNameFocus.addListener(() => setState(() {}));
    _lastNameFocus.addListener(() => setState(() {}));
    _emailFocus.addListener(() => setState(() {}));
    _passwordFocus.addListener(() => setState(() {}));
    _ageFocus.addListener(() => setState(() {}));
    _institutionFocus.addListener(() => setState(() {}));
    _locationFocus.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _disposeControllersAndFocusNodes();
    super.dispose();
  }

  void _disposeControllersAndFocusNodes() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    ageController.dispose();
    institutionController.dispose();
    locationController.dispose();

    _firstNameFocus.dispose();
    _lastNameFocus.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    _ageFocus.dispose();
    _institutionFocus.dispose();
    _locationFocus.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Signup'),
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextField(
                controller: firstNameController,
                focusNode: _firstNameFocus,
                label: 'First Name',
                validatorMessage: 'Please enter your first name',
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: lastNameController,
                focusNode: _lastNameFocus,
                label: 'Last Name',
                validatorMessage: 'Please enter your last name',
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: emailController,
                focusNode: _emailFocus,
                label: 'Email',
                validatorMessage: 'Please enter a valid email address',
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: ageController,
                focusNode: _ageFocus,
                label: 'Age',
                validatorMessage: 'Please enter your age',
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: institutionController,
                focusNode: _institutionFocus,
                label: 'Institution',
                validatorMessage: 'Please enter your institution',
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: locationController,
                focusNode: _locationFocus,
                label: 'Location',
                validatorMessage: 'Please enter your location',
              ),
              const SizedBox(height: 16),
              _buildPasswordField(),
              const SizedBox(height: 16),
              CheckboxListTile(
                title: const Text("I'm not a robot"),
                value: _isRobotChecked,
                onChanged: (bool? value) {
                  setState(() {
                    _isRobotChecked = value ?? false;
                  });
                },
                controlAffinity: ListTileControlAffinity.leading,
              ),
              const SizedBox(height: 24),
              _buildSignupButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required FocusNode focusNode,
    required String label,
    required String validatorMessage,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      keyboardType: keyboardType,
      cursorColor: Colors.teal,
      style: TextStyle(
        color: focusNode.hasFocus ? Colors.teal : Colors.black,
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          color: focusNode.hasFocus ? Colors.teal : Colors.grey,
        ),
        border: const OutlineInputBorder(),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.teal, width: 2.0),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return validatorMessage;
        }
        return null;
      },
    );
  }

  Widget _buildPasswordField() {
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
        if (!RegExp(r'^(?=.*[a-zA-Z])(?=.*\d)[A-Za-z\d]+$').hasMatch(value)) {
          return 'Password must be alphanumeric';
        }
        return null;
      },
    );
  }

  Widget _buildSignupButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          if (_formKey.currentState!.validate() && _isRobotChecked) {
            _registerMentee();
          } else if (!_isRobotChecked) {
            Get.snackbar('Error', "Please confirm you're not a robot.");
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.teal,
        ),
        child: const Text('Sign Up', style: TextStyle(color: Colors.white)),
      ),
    );
  }

  Future<void> _registerMentee() async {
    try {
      final response = await http.post(
        Uri.parse('http://192.168.1.13:3000/api/register/mentee'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'firstName': firstNameController.text,
          'lastName': lastNameController.text,
          'email': emailController.text,
          'password': passwordController.text,
          'age': ageController.text,
          'institution': institutionController.text,
          'location': locationController.text,
        }),
      );

      // Ensure the widget is still mounted
      if (!mounted) return;

      if (response.statusCode == 201) {
        // Successful registration
        Get.snackbar('Success', 'Registered successfully! Check your email.');
        Get.offNamed('/login');
      } else {
        // Handle error response
        final errorMessage = jsonDecode(response.body)['msg'] ??
            'Registration failed. Please try again.';
        Get.snackbar('Error', errorMessage);
      }
    } catch (e) {
      // Handle exceptions
      if (mounted) {
        Get.snackbar(
            'Error', 'An unexpected error occurred. Please try again later.');
      }
    }
  }
}
