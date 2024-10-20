import 'package:flutter/material.dart';

class PrimaryLevelPage extends StatelessWidget {
  const PrimaryLevelPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Primary Level'),
        backgroundColor: Colors.teal,
      ),
      body: ListView(
        children: [
          ListTile(
            title: const Text('Grade 7'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Navigate to the Grade 7 Subjects Page
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Grade7SubjectsPage()),
              );
            },
          ),
          const ListTile(
            title: Text('Grade 8'),
            trailing: Icon(Icons.arrow_forward_ios),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(icon: Icon(Icons.school), label: 'My Learning'),
          BottomNavigationBarItem(
              icon: Icon(Icons.notifications), label: 'Notifications'),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_circle), label: 'Account'),
        ],
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.grey,
      ),
    );
  }
}

class Grade7SubjectsPage extends StatelessWidget {
  const Grade7SubjectsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Grade 7 Subjects'),
        backgroundColor: Colors.teal,
      ),
      body: ListView(
        children: [
          const ListTile(
            title:  Text('Science'),
            trailing:  Icon(Icons.arrow_forward_ios),
          ),
          ListTile(
            title: const Text('Maths'),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              // Navigate to the Maths Page
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MathsPage()),
              );
            },
          ),
          const ListTile(
            title: Text('Computer Science'),
            trailing: Icon(Icons.arrow_forward_ios),
          ),
        ],
      ),
    );
  }
}

class MathsPage extends StatelessWidget {
  const MathsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Maths'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Available Mentors',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: [
                  _buildMentorCard(
                    context,
                    'Shubha Acharya',
                    'assets/john_doe.png', // Replace with actual image path
                    'Maths Specialist with 5 years experience',
                    true, // Availability: true (green dot)
                  ),
                  _buildMentorCard(
                    context,
                    'Nilisha Maharjan',
                    'assets/jane_smith.png', // Replace with actual image path
                    'Maths Teacher for Grades 7-10',
                    false, // Availability: false (red dot)
                  ),
                  _buildMentorCard(
                    context,
                    'Sanjeeta Acharya ',
                    'assets/jane_smith.png', // Replace with actual image path
                    'Maths Teacher for Grades 7-10',
                    false,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMentorCard(BuildContext context, String name, String imagePath, String info, bool isAvailable) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Mentor Photo
            CircleAvatar(
              radius: 30,
              backgroundImage: AssetImage(imagePath),
            ),
            const SizedBox(width: 16),
            // Mentor Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    info,
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            ),
            // Availability Indicator and View Profile Button
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // Availability Dot
                Icon(
                  Icons.circle,
                  size: 12,
                  color: isAvailable ? Colors.green : Colors.red,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    // Handle View Profile action
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('View Profile'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
