import 'package:flutter/material.dart';

class MentorProfilePage extends StatelessWidget {
  const MentorProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mentor Profile'),
        backgroundColor: Colors.teal, // Keep original teal color
      ),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ProfileHeader(),
            SizedBox(height: 20),
            ProfileDetails(), // Updated to include skill chips
            SizedBox(height: 20),
            TimeSchedule(),
          ],
        ),
      ),
    );
  }
}

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300), // Add border
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Row(
        children: [
          CircleAvatar(
            radius: 40,
            backgroundImage: NetworkImage(
              'https://example.com/profile-image.jpg', // Replace with actual image URL
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Shubha Acharya', // Replace with mentor's name
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                Text(
                  'Maths Specialist with 5 years experience', // Replace with mentor's role
                  style: TextStyle(fontSize: 16, color: Colors.black),
                  maxLines: 2, // Limit to 2 lines
                  overflow: TextOverflow.ellipsis, // Add ellipsis if overflow
                ),
                Row(
                  children: [
                    Icon(Icons.star, color: Colors.amber, size: 20),
                    SizedBox(width: 4),
                    Text('4.9 (20 reviews)'), // Replace with mentor's rating
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ProfileDetails extends StatelessWidget {
  const ProfileDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade200), // Add border
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Skills: ',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold), // Bold heading
              ),
              // No line break after heading
            ],
          ),
          SizedBox(height: 5),
          SkillChips(skills: ['Algebra', 'Calculus', 'Geometry']), // Updated to use SkillChips widget
          SizedBox(height: 10),
          Divider(thickness: 1), // Fine line separator
          SizedBox(height: 10),
          Text(
            'Experience: ',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold), // Bold heading
          ),
          Text(
            '5+ years in Advanced Mathematics', // Normal text
            style: TextStyle(fontSize: 16), // Normal text
          ),
          SizedBox(height: 10),
          Divider(thickness: 1), // Fine line separator
          SizedBox(height: 10),
          Text(
            'Availability: ',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold), // Bold heading
          ),
          Text(
            'Online / Home Tuition Available', // Normal text
            style: TextStyle(fontSize: 16), // Normal text
          ),
        ],
      ),
    );
  }
}

// New Widget for displaying skills as chips
class SkillChips extends StatelessWidget {
  final List<String> skills;

  const SkillChips({super.key, required this.skills});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8.0, // Spacing between chips
      children: skills.map((skill) {
        return Chip(
          label: Text(
            skill,
            style: const TextStyle(
              fontWeight: FontWeight.bold, // Bold text for skill names
              fontSize: 16, // Slightly larger font size
            ),
          ),
          backgroundColor: Colors.grey.shade50, // Keep the existing color for chips
          padding: const EdgeInsets.symmetric(horizontal: 12.0), // Horizontal padding for chip
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30), // Oval shape
          ),
        );
      }).toList(),
    );
  }
}

class TimeSchedule extends StatelessWidget {
  const TimeSchedule({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300), // Add border
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Time Schedule:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          // Using a Table to create a structured layout with visible lines
          Table(
            border: TableBorder.all(
              color: Colors.grey.shade300,
              style: BorderStyle.solid,
              width: 1,
            ),
            columnWidths: const {
              0: FractionColumnWidth(0.6), // First column takes 60% of width
              1: FractionColumnWidth(0.4), // Second column takes 40% of width
            },
            children: [
              TableRow(
                decoration: BoxDecoration(color: Colors.teal.shade100), // Header background color
                children: const [
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Time Slot',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Status',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              _buildTableRow('6:00 PM - 8:00 PM', 'Available'),
              _buildTableRow('8:00 PM - 10:00 PM', 'Available'),
              _buildTableRow('10:00 AM - 12:00 PM', 'Available'),
              _buildTableRow('1:00 PM - 3:00 PM', 'Available'),
            ],
          ),
        ],
      ),
    );
  }

  TableRow _buildTableRow(String time, String availability) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            time,
            style: const TextStyle(fontSize: 16),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            availability,
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ],
    );
  }
}
