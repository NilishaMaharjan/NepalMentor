import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'dashboard.dart';

class RequestPage extends StatefulWidget {
  final String mentorId; // Mentor's profile ID
  final String slot; // The selected time slot

  const RequestPage({Key? key, required this.mentorId, required this.slot})
      : super(key: key);

  @override
  _RequestPageState createState() => _RequestPageState();
}

class _RequestPageState extends State<RequestPage> {
  bool isLoading = false; // For showing a loading spinner
  String? errorMessage; // For displaying errors
  String? mentorUserId; // Mentor's user ID
  String? tuitionType = 'Home Tuition'; // Default tuition type

  @override
  void initState() {
    super.initState();
    _fetchMentorUserId(); // Fetch the user ID for the mentor
  }

  Future<void> _fetchMentorUserId() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      // API endpoint to fetch the user ID using the mentor's profile ID
      final String apiUrl =
          'http://192.168.193.174:3000/api/mentors/${widget.mentorId}';

      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        // Extract the mentor user ID from the response
        setState(() {
          mentorUserId = data['user']?['_id']; // Fetch the user._id
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'Failed to fetch mentor user ID.';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'An error occurred while fetching mentor user ID.';
        isLoading = false;
      });
    }
  }

  Future<void> sendRequest() async {
    if (mentorUserId == null) {
      setState(() {
        errorMessage = 'Mentor user ID not available.';
      });
      return;
    }

    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userId = prefs.getString('userId');

      if (userId == null) {
        setState(() {
          errorMessage = 'User ID not found. Please log in again.';
        });
        return;
      }

      const String apiUrl = 'http://192.168.193.174:3000/api/requests';

      Map<String, String> requestBody = {
        'mentor': mentorUserId!, // Use the fetched mentor user ID
        'userId': userId, // Mentee's user ID
        'tuitionType': tuitionType!, // Add tuition type to request
      };

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(requestBody),
      );

      if (response.statusCode == 201) {
        setState(() {
          isLoading = false;
        });
         showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.check_circle,
                                size: 60,
                                color: Colors.green,
                              ),
                              const SizedBox(height: 20),
                              const Text(
                                'Your Session Request has been sent.',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 10),
                              const Text(
                                'Your request has been successfully submitted, and you will be notified via email once the mentor confirms or declines your request. Thank you for your patience!',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 16),
                              ),
                              const SizedBox(height: 20),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).pop(); // Close the dialog
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const Dashboard()),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.teal,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                ),
                                child: const Text(
                                  'Thanks, will do',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  }else if (response.statusCode == 400) {
        final responseData = json.decode(response.body);
        setState(() {
          errorMessage = responseData['error'] ?? 'Failed to send request.';
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'Failed to send request. Please try again.';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'An error occurred. Please try again later.';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal, // Teal background for AppBar
        title: const Text(
          'Request Detail',
          style: TextStyle(color: Colors.black), // Black text in AppBar
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Selected Slot:',
              style: TextStyle(
                fontSize: 18,
                color: Colors.teal, // Teal color for "Selected Slot"
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              widget.slot,
              style: const TextStyle(
                fontSize: 16, // Slightly smaller font for the time
                color: Colors.black, // Black color for the time
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 20),

            // Choose Tuition Type using Row to display in the same line
            Text(
              'Choose Type:',
              style: TextStyle(
                fontSize: 18,
                color: Colors.teal, // Teal color for "Choose Type"
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // Home Tuition Radio Button
                Radio<String>(
                  value: 'Home Tuition',
                  groupValue: tuitionType,
                  onChanged: (value) {
                    setState(() {
                      tuitionType = value;
                    });
                  },
                ),
                Text(
                  'Home Tuition',
                  style: TextStyle(
                    fontSize: 16, // Increased font size
                    color: Colors.black, // Black color for the label
                    fontWeight: FontWeight.w400,
                  ),
                ),

                // Add space between the radio buttons
                const SizedBox(width: 80),  // Adjust space as per your need

                // Online Radio Button
                Radio<String>(
                  value: 'Online',
                  groupValue: tuitionType,
                  onChanged: (value) {
                    setState(() {
                      tuitionType = value;
                    });
                  },
                ),
                Text(
                  'Online',
                  style: TextStyle(
                    fontSize: 16, // Increased font size
                    color: Colors.black, // Black color for the label
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            if (errorMessage != null)
              Text(
                errorMessage!,
                style: const TextStyle(color: Colors.red, fontSize: 14),
              ),
            const Spacer(), // Push the button toward the bottom center
            Align(
              alignment: Alignment.center, // Center horizontally
              child: SizedBox(
                width: 200, // Smaller width for the button
                height: 50, // Larger height for the button
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal, // Teal background for button
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  onPressed: isLoading || mentorUserId == null ? null : sendRequest,
                  child: isLoading
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : const Text(
                          'Send Request',
                          style: TextStyle(
                            fontSize: 18, // Smaller font size for button text
                            fontWeight: FontWeight.bold,
                            color: Colors.white, // White text for the button
                          ),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
