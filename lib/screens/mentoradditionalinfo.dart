import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MentorAdditionalInfo extends StatefulWidget {
  const MentorAdditionalInfo({super.key});

  @override
  MentorAdditionalInfoState createState() => MentorAdditionalInfoState();
}

class MentorAdditionalInfoState extends State<MentorAdditionalInfo> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for input fields
  final TextEditingController categoryController = TextEditingController();
  final TextEditingController skillsController = TextEditingController();
  final TextEditingController bioController = TextEditingController();
  final TextEditingController linkedinController = TextEditingController();

  String selectedCategory = 'Please Select'; // Default category

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Additional Information',
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
              buildCategoryDropdown(),
              const SizedBox(height: 16.0),
              buildTextFormField('Skills (comma-separated)', skillsController),
              const SizedBox(height: 16.0),
              // Updated Bio section
              Container(
                constraints: const BoxConstraints(
                  minHeight: 50, // Minimum height when empty
                  maxHeight: 200, // Maximum height for expansion
                ),
                child: TextFormField(
                  controller: bioController,
                  maxLines: null, // Allow unlimited lines for expansion
                  decoration: const InputDecoration(
                    labelText: 'Bio',
                    helperText:
                        'Tell us (and your mentees) a little bit about yourself—your \n passion for teaching. This will be public and help mentees \n connect with you on a more personal level.',
                    alignLabelWithHint: true,
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 12.0),
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.teal, width: 2.0),
                    ),
                    helperMaxLines: 2,
                    floatingLabelStyle: TextStyle(
                      color: Colors.teal,
                      fontWeight: FontWeight.bold,
                    ),
                    helperStyle: TextStyle(
                      height: 1.5,
                      color: Colors.black54,
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your Bio';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 16.0),
              buildTextFormField('LinkedIn URL', linkedinController),
              const SizedBox(height: 16.0),
              buildNextButton(),
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
        floatingLabelStyle: TextStyle(
          color: Colors.teal,
          fontWeight: FontWeight.bold,
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
      {int maxLines = 1, String? helperText}) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        helperText: helperText,
        alignLabelWithHint: true,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 10.0, horizontal: 12.0),
        border: const OutlineInputBorder(),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.teal, width: 2.0),
        ),
        helperMaxLines: 2,
        floatingLabelStyle: const TextStyle(
          color: Colors.teal,
          fontWeight: FontWeight.bold,
        ),
        helperStyle: const TextStyle(
          height: 1.5,
          color: Colors.black54,
        ),
      ),
      textAlign: TextAlign.start,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter your $label';
        }
        return null;
      },
    );
  }

  Widget buildNextButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: Tooltip(
        message: 'Proceed to the next step',
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.teal,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              Get.snackbar('Success', 'Proceeding to the next step!');
            }
          },
          child: const Text(
            'Complete Registration',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
