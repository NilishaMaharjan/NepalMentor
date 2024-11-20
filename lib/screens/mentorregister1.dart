import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';  // For json encoding

class MentorRegistrationAndAdditionalInfo extends StatefulWidget {
  const MentorRegistrationAndAdditionalInfo({super.key});

  @override
  MentorRegistrationAndAdditionalInfoState createState() =>
      MentorRegistrationAndAdditionalInfoState();
}

class MentorRegistrationAndAdditionalInfoState
    extends State<MentorRegistrationAndAdditionalInfo> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for input fields
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController qualificationsController = TextEditingController();
  final TextEditingController skillsController = TextEditingController();
  final TextEditingController jobTitleController = TextEditingController();
  final TextEditingController companyController = TextEditingController();
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController bioController = TextEditingController();
  final TextEditingController classLevelController = TextEditingController();
  final TextEditingController subjectsController = TextEditingController();

  String selectedCategory = 'Please Select'; // Default category
  bool _obscurePassword = true; // For toggling password visibility

  @override
  void initState() {
    super.initState();
  }

  Future<void> submitMentorData() async {
    final firstName = firstNameController.text;
    final lastName = lastNameController.text;
    final email = emailController.text;
    final password = passwordController.text;
    final location = locationController.text;
    final qualifications = qualificationsController.text;
    final skills = skillsController.text;
    final jobTitle = jobTitleController.text;
    final company = companyController.text;
    final category = selectedCategory;
    final bio = bioController.text;
    final classLevel = classLevelController.text;
    final subjects = subjectsController.text;

    // Prepare the data to send
    var data = {
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'password': password,
      'location': location,
      'qualifications': qualifications,
      'skills': skills,
      'jobTitle': jobTitle,
      'company': company,
      'category': category,
      'bio': bio,
      'classLevel': classLevel,
      'subjects': subjects,
    };

    try {
      // Send the data as JSON using a POST request
      final response = await http.post(
        Uri.parse('http://192.168.0.108:3000/api/mentorregister/mentor'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(data),
      );

      if (response.statusCode == 200) {
        Get.snackbar('Success', 'Your mentor registration has been submitted!');
      } else {
        Get.snackbar('Error', 'Failed to submit information. Try again later.');
        print('Server Response: ${response.body}'); // Log the response for debugging
      }
    } catch (e) {
      Get.snackbar('Error', 'An unexpected error occurred: $e');
      print('Error: $e'); // Log the error for further debugging
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Mentor Registration',
          style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const SizedBox(height: 24.0),
              buildTextFormField('First Name', firstNameController),
              const SizedBox(height: 16.0),
              buildTextFormField('Last Name', lastNameController),
              const SizedBox(height: 16.0),
              buildTextFormField('Email', emailController),
              const SizedBox(height: 16.0),
              buildPasswordFormField(),
              const SizedBox(height: 16.0),
              buildTextFormField('Location', locationController),
              const SizedBox(height: 16.0),
              buildTextFormField('Qualification', qualificationsController),
              const SizedBox(height: 16.0),
              buildTextFormField('Skills (comma-separated)', skillsController),
              const SizedBox(height: 16.0),
              buildTextFormField('Job Title', jobTitleController),
              const SizedBox(height: 16.0),
              buildTextFormField('Company', companyController),
              const SizedBox(height: 24.0),
              buildCategoryDropdown(),
              const SizedBox(height: 16.0),
              buildBioField(),
              const SizedBox(height: 16.0),
              buildTextFormField('Class Level', classLevelController),
              const SizedBox(height: 16.0),
              buildTextFormField('Subject', subjectsController),
              const SizedBox(height: 16.0),
              buildSubmitButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildCategoryDropdown() {
    return DropdownButtonFormField<String>(
      value: selectedCategory,
      decoration: const InputDecoration(
        labelText: 'Category',
        border: OutlineInputBorder(),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.teal, width: 2.0),
        ),
      ),
      items: <String>[
        'Please Select',
        'Primary level',
        'Secondary level',
        'Diploma',
        'Bachelors',
        'Masters'
      ].map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: (String? newValue) {
        setState(() {
          selectedCategory = newValue!;
        });
      },
      validator: (value) {
        if (value == null || value == 'Please Select') {
          return 'Please select a category';
        }
        return null;
      },
    );
  }

  Widget buildTextFormField(String label, TextEditingController controller,
      {int maxLines = 1}) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      textCapitalization: TextCapitalization.words,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.teal, width: 2.0),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your $label';
        }
        return null;
      },
    );
  }

  Widget buildPasswordFormField() {
    return TextFormField(
      controller: passwordController,
      obscureText: _obscurePassword,
      decoration: InputDecoration(
        labelText: 'Password',
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
          return 'Please enter your Password';
        }
        return null;
      },
    );
  }

  Widget buildBioField() {
    return TextFormField(
      controller: bioController,
      maxLines: null,
      decoration: const InputDecoration(
        labelText: 'Bio',
        border: OutlineInputBorder(),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your Bio';
        }
        return null;
      },
    );
  }

  Widget buildSubmitButton() {
    return ElevatedButton(
      onPressed: () {
        if (_formKey.currentState?.validate() ?? false) {
          submitMentorData();
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.teal,
        padding: const EdgeInsets.symmetric(vertical: 12.0),
      ),
      child: const Text(
        'Submit',
        style: TextStyle(fontSize: 18.0),
      ),
    );
  }
}