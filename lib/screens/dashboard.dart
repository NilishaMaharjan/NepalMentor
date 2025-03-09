import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'primary.dart';
import 'secondary.dart';
import 'diploma.dart';
import 'ctevt.dart';
import 'bachelor.dart';
import 'masters.dart';
import 'session_history.dart';
import 'my_mentors.dart';
import 'menteeprofile_edit.dart';
import 'mentee_chat_page.dart'; // Import the chat page.
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web_socket_channel/io.dart';
import '../conf_ip.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  File? _profileImage;
  final Color themeColor = const Color.fromARGB(255, 47, 161, 150);
  int _selectedIndex = 0;
  String? firstName;
  List<Map<String, dynamic>> notifications = [];
  IOWebSocketChannel? channel;
  Map<String, String> mentorNameCache = {};

  @override
  void initState() {
    super.initState();
    fetchFirstName();
    _loadNotificationsFromLocalStorage(); // Load stored notifications first.
    fetchNotifications();
    connectWebSocket();
  }

  void connectWebSocket() async {
    if (channel != null) return;
    try {
      channel = IOWebSocketChannel.connect(
          'ws://$serverIP:$serverPort/ws/notifications');
      String? userId = await getUserId();
      if (userId != null) {
        channel?.sink.add(jsonEncode({'userId': userId}));
        print("Sent userId to WebSocket server: $userId");
      } else {
        print("Error: userId is null");
      }
      channel?.stream.listen(
        (message) {
          print("New Notification Received: $message");
          try {
            final decodedMessage = json.decode(message);
            if (decodedMessage is Map<String, dynamic> &&
                decodedMessage.containsKey('message')) {
              if (!notifications.any(
                  (notif) => notif['message'] == decodedMessage['message'])) {
                setState(() {
                  notifications.insert(0, decodedMessage);
                });
                _saveNotificationsToLocalStorage();
              }
            }
          } catch (e) {
            print("Error decoding WebSocket message: $e");
          }
        },
        onError: (error) {
          print("WebSocket Error: $error");
        },
      );
    } catch (e) {
      print("WebSocket connection failed: $e");
    }
  }

  Future<String?> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userId');
    print("userId retrieved: $userId");
    return userId;
  }

  Future<void> fetchFirstName() async {
    String? userId = await getUserId();
    if (userId == null) {
      print("No userId found.");
      return;
    }
    final url = Uri.parse('$baseUrl/api/mentees/$userId');
    print("Fetching data from $url");
    try {
      final response = await http.get(url);
      print("Response status: ${response.statusCode}");
      if (response.statusCode == 200) {
        final Map<String, dynamic> profileData = json.decode(response.body);
        final fetchedName = profileData['firstName'];
        if (fetchedName != null) {
          setState(() {
            firstName = fetchedName;
          });
          print("First name set to: $firstName");
        } else {
          print("First name not found in the response.");
        }
      } else {
        print(
            'Failed to fetch first name. Status Code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching first name: $error');
    }
  }

  Future<void> _saveNotificationsToLocalStorage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('notifications', jsonEncode(notifications));
  }

  Future<void> _loadNotificationsFromLocalStorage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedNotifications = prefs.getString('notifications');
    if (savedNotifications != null) {
      setState(() {
        notifications =
            List<Map<String, dynamic>>.from(jsonDecode(savedNotifications));
      });
    }
  }

  Future<void> fetchNotifications() async {
    String? userId = await getUserId();
    if (userId == null) return;
    final url = Uri.parse('$baseUrl/api/requests/notifications/$userId');
    print("Fetching notifications from $url");
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> fetchedNotifications = json.decode(response.body);
        setState(() {
          notifications = fetchedNotifications.cast<Map<String, dynamic>>();
        });
        _saveNotificationsToLocalStorage();
      } else {
        print(
            "Failed to fetch notifications. Status Code: ${response.statusCode}");
      }
    } catch (error) {
      print("Error fetching notifications: $error");
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedImage = await ImagePicker().pickImage(source: source);
    if (pickedImage != null) {
      setState(() {
        _profileImage = File(pickedImage.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: themeColor,
        title: Text(
          _selectedIndex == 0
              ? 'Learning Dashboard'
              : _selectedIndex == 1
                  ? 'My Community'
                  : _selectedIndex == 2
                      ? 'Notifications'
                      : 'Profile',
          style: const TextStyle(color: Colors.black),
        ),
        leading: _selectedIndex != 0
            ? IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () {
                  setState(() {
                    _selectedIndex = 0;
                  });
                },
              )
            : null,
      ),
      body: _selectedIndex == 0
          ? _buildLearningDashboard()
          : _selectedIndex == 1
              ? const CommunitySlotsScreen()
              : _selectedIndex == 2
                  ? _buildNotificationScreen()
                  : _buildProfile(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const CommunitySlotsScreen()),
            );
          } else {
            setState(() {
              _selectedIndex = index;
            });
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.groups), label: 'My Community'),
          BottomNavigationBarItem(
              icon: Icon(Icons.notifications), label: 'Notifications'),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_circle), label: 'Profile'),
        ],
        selectedItemColor: themeColor,
        unselectedItemColor: Colors.grey,
      ),
    );
  }

  Widget _buildLearningDashboard() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Dashboard UI (profile image, welcome text, dashboard image, etc.)
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => _showImageSourceDialog(context),
                  child: Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(35),
                    ),
                    child: _profileImage != null
                        ? ClipOval(
                            child: Image.file(
                              _profileImage!,
                              fit: BoxFit.cover,
                              width: 70,
                              height: 70,
                            ),
                          )
                        : Icon(
                            Icons.camera_alt,
                            size: 35,
                            color: themeColor,
                          ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome, ${firstName ?? "User"}!',
                        style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                      const SizedBox(height: 5),
                      const Text(
                        '"Learning is a treasure that will follow its \nowner everywhere."',
                        style: TextStyle(
                            fontSize: 14,
                            fontStyle: FontStyle.italic,
                            color: Colors.black87),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Container(
              height: 300,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  'assets/dashboard.png',
                  fit: BoxFit.fill,
                  width: double.infinity,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'Choose your level',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: GridView.count(
              crossAxisCount: 3,
              childAspectRatio: 1,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const PrimaryLevelPage()),
                  ),
                  child: _buildLevelCard('Primary', Icons.school),
                ),
                GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const SecondaryLevelPage()),
                  ),
                  child: _buildLevelCard('Secondary', Icons.auto_stories),
                ),
                GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const DiplomaLevelPage()),
                  ),
                  child: _buildLevelCard('Diploma', Icons.menu_book),
                ),
                GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const CTEVTLevelPage()),
                  ),
                  child: _buildLevelCard('CTEVT', Icons.library_books),
                ),
                GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const BachelorLevelPage()),
                  ),
                  child: _buildLevelCard('Bachelor', Icons.school_outlined),
                ),
                GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const MastersLevelPage()),
                  ),
                  child: _buildLevelCard('Masters', Icons.workspace_premium),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationScreen() {
    return ListView.builder(
      itemCount: notifications.length,
      itemBuilder: (context, index) {
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          elevation: 1,
          color: Colors.white,
          child: ListTile(
            onTap: () {
              print("Notification tapped: ${notifications[index]['message']}");
            },
            leading: const Icon(Icons.notifications, color: Colors.teal),
            title: Text(
              notifications[index]['message'],
              style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87),
            ),
          ),
        );
      },
    );
  }

  Widget _buildProfile() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Setting',
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
          ),
          const SizedBox(height: 20),
          _buildProfileOption(Icons.person, 'My Profile', () async {
            String? userId = await getUserId();
            if (userId != null) {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ProfileEditPage(userId: userId)),
              );
            }
          }),
          _buildProfileOption(Icons.history, 'Session History', () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const SessionHistoryPage()),
            );
          }),
          _buildProfileOption(Icons.star_border, 'My Mentors', () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const MyMentorsPage()),
            );
          }),
          _buildProfileOption(Icons.payment, 'Payment History'),
          const SizedBox(height: 20),
          _buildLogoutButton(),
        ],
      ),
    );
  }

  Widget _buildLogoutButton() {
    return ListTile(
      leading: const Icon(Icons.logout, color: Colors.red),
      title: const Text('Logout', style: TextStyle(color: Colors.red)),
      onTap: () {
        Navigator.pushReplacementNamed(context, '/login');
      },
    );
  }

  Widget _buildProfileOption(IconData icon, String title,
      [void Function()? onTap]) {
    return ListTile(
      leading: Icon(icon, color: Colors.black87),
      title: Text(title, style: const TextStyle(color: Colors.black87)),
      onTap: onTap,
    );
  }

  Widget _buildLevelCard(String level, IconData icon) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 40, color: themeColor),
          const SizedBox(height: 10),
          Text(level,
              style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87)),
        ],
      ),
    );
  }

  void _showImageSourceDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Photo Library'),
                onTap: () => _pickImage(ImageSource.gallery),
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Camera'),
                onTap: () => _pickImage(ImageSource.camera),
              ),
            ],
          ),
        );
      },
    );
  }
}

class CommunitySlotsScreen extends StatefulWidget {
  const CommunitySlotsScreen({Key? key}) : super(key: key);

  @override
  _CommunitySlotsScreenState createState() => _CommunitySlotsScreenState();
}

class _CommunitySlotsScreenState extends State<CommunitySlotsScreen> {
  List<dynamic> acceptedSlots = [];
  String? userId;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _getUserIdAndFetchSlots();
  }

  Future<void> _getUserIdAndFetchSlots() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('userId');
    await _fetchAcceptedSlots();
  }

  Future<void> _fetchAcceptedSlots() async {
    if (userId == null) return;
    setState(() {
      isLoading = true;
    });
    final requestUrl = '$baseUrl/api/requests/mentee/accepted?userId=$userId';
    try {
      final response = await http.get(Uri.parse(requestUrl));
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        if (data is List && data.isNotEmpty) {
          setState(() {
            acceptedSlots = data;
          });
        } else {
          print("No accepted slots found for user: $userId");
        }
      } else {
        print("Failed to fetch accepted slots: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching accepted slots: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  /// getSlotInfo fetches availability data using the slot id,
  /// then retrieves mentor details (name and subject) and time slot.
  /// It returns a Map with keys: "mentor", "slotTime", and "subject".
  Future<Map<String, String>> getSlotInfo(dynamic slotData) async {
    try {
      // Extract slot ID.
      String? slotId = slotData['slotId'];
      if (slotId == null) {
        if (slotData.containsKey('_id')) {
          slotId = slotData['_id'];
        } else if (slotData.containsKey('slot')) {
          final dynamic slotObj = slotData['slot'];
          if (slotObj is Map<String, dynamic>) {
            slotId = slotObj['_id'];
          }
        }
      }
      if (slotId == null) {
        print("Slot id not found in slotData: $slotData");
        return {
          "mentor": "Unknown Mentor",
          "slotTime": "N/A",
          "subject": "N/A"
        };
      }
      print("Fetching availability for slotId: $slotId");

      final availResponse =
          await http.get(Uri.parse('$baseUrl/api/availability/slot/$slotId'));
      print("Availability response: ${availResponse.body}");

      if (availResponse.statusCode == 200) {
        final Map<String, dynamic> result = json.decode(availResponse.body);
        // Extract time slot.
        final String slotTime =
            (result.containsKey('slot') && result['slot'] is Map)
                ? (result['slot']['time'] ?? "N/A")
                : "N/A";
        final String? mentorUserId = result['mentorUserId'];
        print("Mentor user id: $mentorUserId");

        if (mentorUserId != null && mentorUserId.isNotEmpty) {
          // Retrieve mentor details.
          final mentorResponse =
              await http.get(Uri.parse('$baseUrl/api/mentors/$mentorUserId'));
          print("Mentor response: ${mentorResponse.body}");
          if (mentorResponse.statusCode == 200) {
            final Map<String, dynamic> mentor =
                json.decode(mentorResponse.body);
            String mentorName = "Unknown Mentor";
            if (mentor['firstName'] != null && mentor['lastName'] != null) {
              mentorName = "${mentor['firstName']} ${mentor['lastName']}";
            }
            String subjectStr = "N/A";
            if (mentor.containsKey('subjects')) {
              if (mentor['subjects'] is List && mentor['subjects'].isNotEmpty) {
                subjectStr = mentor['subjects'][0]; // Use first subject.
              } else if (mentor['subjects'] is String) {
                subjectStr = mentor['subjects'];
              }
            }
            return {
              "mentor": mentorName,
              "slotTime": slotTime,
              "subject": subjectStr
            };
          } else {
            print(
                "Failed to fetch mentor details. Status code: ${mentorResponse.statusCode}");
          }
        }
      } else {
        print(
            "Failed to fetch availability. Status code: ${availResponse.statusCode}");
      }
    } catch (e) {
      print("Error in getSlotInfo: $e");
    }
    return {"mentor": "Unknown Mentor", "slotTime": "N/A", "subject": "N/A"};
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Select a Community Slot"),
        backgroundColor: Colors.teal,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : acceptedSlots.isEmpty
              ? const Center(child: Text("No accepted slots available"))
              : ListView.builder(
                  itemCount: acceptedSlots.length,
                  itemBuilder: (context, index) {
                    final slotData = acceptedSlots[index];
                    return FutureBuilder<Map<String, String>>(
                      future: getSlotInfo(slotData),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Center(child: CircularProgressIndicator()),
                          );
                        } else if (snapshot.hasError) {
                          return const ListTile(
                            title: Text("Error loading slot info"),
                          );
                        } else {
                          final slotInfo = snapshot.data!;
                          return Card(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15)),
                            elevation: 4,
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MenteeChatScreen(
                                      slot: slotData,
                                      receiverId: "", // Adjust if needed.
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [Colors.white, Colors.grey.shade50],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Emphasized Subject Header
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: Colors.teal.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Row(
                                        children: [
                                          const Icon(Icons.subject,
                                              color: Colors.teal, size: 20),
                                          const SizedBox(width: 8),
                                          const Text("SUBJECT: ",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.teal,
                                                  fontSize: 16)),
                                          Expanded(
                                            child: Text(
                                              slotInfo["subject"] ?? "N/A",
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18,
                                                  color: Colors.teal),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    Row(
                                      children: [
                                        const Icon(Icons.access_time,
                                            color: Colors.teal, size: 18),
                                        const SizedBox(width: 8),
                                        const Text("TIME-SLOT: ",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.teal,
                                                fontSize: 14)),
                                        Expanded(
                                          child: Text(
                                            slotInfo["slotTime"] ?? "N/A",
                                            style: const TextStyle(
                                                fontSize: 16,
                                                color: Colors.black87),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        const Icon(Icons.person,
                                            color: Colors.teal, size: 18),
                                        const SizedBox(width: 8),
                                        const Text("MENTOR: ",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.teal,
                                                fontSize: 14)),
                                        Expanded(
                                          child: Text(
                                            slotInfo["mentor"] ??
                                                "Unknown Mentor",
                                            style: const TextStyle(
                                                fontSize: 16,
                                                color: Colors.black87),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }
                      },
                    );
                  },
                ),
    );
  }
}
