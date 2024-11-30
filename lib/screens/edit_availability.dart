import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ViewAvailabilityScreen extends StatefulWidget {
  const ViewAvailabilityScreen({super.key});

  @override
  State<ViewAvailabilityScreen> createState() => _ViewAvailabilityScreenState();
}

class _ViewAvailabilityScreenState extends State<ViewAvailabilityScreen> {
  List<String> slots = [];
  bool isLoading = true;
  String? userId;
  TextEditingController slotController = TextEditingController();

  // Fetch the user ID from SharedPreferences
  Future<void> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getString('userId');
    });
    print("Fetched userId: $userId");
  }

  // Fetch current availability
  Future<void> getAvailability() async {
    if (userId == null) {
      await getUserId();
    }

    if (userId == null) {
      print("Error: userId is null, cannot fetch availability.");
      return;
    }

    try {
      print("Fetching availability for userId: $userId");
      final response = await http.get(
        Uri.parse('http://192.168.193.174:3000/api/availability/$userId'),
        headers: {'Content-Type': 'application/json'},
      );

      print("Response Status Code (GET): ${response.statusCode}");

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (mounted) {
          setState(() {
            slots = List<String>.from(data['slots'] ?? []);
            isLoading = false;
          });
        }
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  // Add new availability slot (range)
  Future<void> addSlot() async {
    if (userId == null) {
      await getUserId();
    }

    if (userId == null || slotController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Slot is empty')),
      );
      return;
    }

    final newSlot = slotController.text;

    try {
      print("Attempting to add slot: $newSlot for userId: $userId");

      // Send the new slot to the backend
      final response = await http.post(
        Uri.parse('http://192.168.193.174:3000/api/availability/$userId'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'slots': [newSlot], // Send the new slot as an array
        }),
      );

      print("Response Status Code (POST): ${response.statusCode}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('New slot added successfully')),
        );
        setState(() {
          slots.add(newSlot); // Update the UI with the new slot
          slotController.clear(); // Clear the input field
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text(
                  'Failed to add slots, try correct format(e.g 3:00 P.M - 5:00 P.M) or different slots that arent allocated')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error adding slot')),
      );
    }
  }

  // Update existing slot
  Future<void> updateSlot(String oldSlot, String newSlot) async {
    if (userId == null || newSlot.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Slot is empty')),
      );
      return;
    }

    try {
      print(
          "Attempting to update slot: $oldSlot to $newSlot for userId: $userId");

      // Send the updated slot to the backend
      final response = await http.put(
        Uri.parse(
            'http://192.168.193.174:3000/api/availability/$userId/edit-slot'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'oldSlot': oldSlot,
          'newSlot': newSlot,
        }),
      );

      print("Response Status Code (PUT): ${response.statusCode}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Slot updated successfully')),
        );
        setState(() {
          int index = slots.indexOf(oldSlot);
          if (index != -1) {
            slots[index] = newSlot; // Update the UI with the new slot
          }
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to update slot')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error updating slot')),
      );
    }
  }

  // Delete an existing slot with confirmation
  Future<void> _showDeleteConfirmationDialog(String slot) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content: const Text('Are you sure you want to delete this slot?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                deleteSlot(slot); // Proceed with deletion if confirmed
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  // Delete slot
  Future<void> deleteSlot(String slot) async {
    if (userId == null || slot.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid slot')),
      );
      return;
    }

    try {
      print("Attempting to delete slot: $slot for userId: $userId");

      // Send the delete request to the backend
      final response = await http.delete(
        Uri.parse(
            'http://192.168.193.174:3000/api/availability/$userId/delete-slot'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'slot': slot}), // Send the slot to be deleted
      );

      print("Response Status Code (DELETE): ${response.statusCode}");

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Slot deleted successfully')),
        );
        setState(() {
          slots.remove(slot); // Remove the slot from the UI
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to delete slot')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error deleting slot')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    getUserId().then((_) {
      getAvailability(); // Fetch availability after userId is retrieved
    });
  }

  // Show dialog to edit a slot
  void _showEditDialog(String oldSlot) {
    slotController.text = oldSlot;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Slot', style: TextStyle(color: Colors.teal)),
          content: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField(
              controller: slotController,
              decoration: const InputDecoration(
                labelText: 'New Slot',
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.teal), // Teal border
                ),
              ),
              cursorColor: Colors.teal, // Teal cursor
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (slotController.text.isNotEmpty) {
                  updateSlot(oldSlot, slotController.text);
                  Navigator.of(context).pop();
                }
              },
              style: TextButton.styleFrom(
                foregroundColor: Colors.teal, // Teal text color
              ),
              child: const Text('Save'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              style: TextButton.styleFrom(
                foregroundColor: Colors.teal, // Teal text color
              ),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'View Availability',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.teal,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Add Slot Title
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Text(
              "Add New Slot",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.teal,
              ),
            ),
          ),
          // Add Slot TextField
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: slotController,
              decoration: InputDecoration(
                labelText: 'Add Time Slot (e.g. 3:00 P.M - 5:00 P.M)',
                labelStyle: const TextStyle(color: Colors.black),
                filled: true,
                fillColor: Colors.white,
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.add, color: Colors.teal),
                  onPressed: addSlot,
                ),
              ),
            ),
          ),
          // Current Slots Title
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Text(
              "Current Slots",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.teal,
              ),
            ),
          ),
          // If data is loading, show a progress indicator
          if (isLoading)
            const Expanded(
              child: Center(child: CircularProgressIndicator()),
            ),
          // Display slots in the list view
          if (!isLoading)
            Expanded(
              child: ListView.builder(
                itemCount: slots.length,
                itemBuilder: (context, index) {
                  return Card(
                    color: Colors.white,
                    margin:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      title: Text(
                        slots[index],
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.teal),
                            onPressed: () => _showEditDialog(slots[index]),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () =>
                                _showDeleteConfirmationDialog(slots[index]),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
