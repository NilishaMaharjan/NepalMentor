import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SessionHistoryPage extends StatefulWidget {
  const SessionHistoryPage({super.key});

  @override
  State<SessionHistoryPage> createState() => _SessionHistoryPageState();
}

class _SessionHistoryPageState extends State<SessionHistoryPage> {
  List<Map<String, dynamic>> sessionHistory = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchSessionHistory();
  }

  Future<void> _fetchSessionHistory() async {
   final String apiUrl = 'https://192.168.0.108:3000/api/session-history';

    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        if (mounted) {
          setState(() {
            sessionHistory = List<Map<String, dynamic>>.from(data);
            isLoading = false;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            isLoading = false;
            errorMessage = 'Failed to load session history. Status code: ${response.statusCode}';
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          isLoading = false;
          errorMessage = 'Error: $e';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Session History')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
              ? Center(child: Text(errorMessage))
              : sessionHistory.isEmpty
                  ? const Center(child: Text('No session history found.'))
                  : ListView.builder(
                      itemCount: sessionHistory.length,
                      itemBuilder: (context, index) {
                        final session = sessionHistory[index];
                        return ListTile(
                          leading: const Icon(Icons.history),
                          title: Text(session['sessionTitle'] ?? 'Unknown Session'),
                          subtitle: Text('Completed on: ${session['completedOn'] ?? 'Unknown Date'}'),
                          trailing: const Icon(Icons.arrow_forward),
                          onTap: () => _showSessionDetails(session),
                        );
                      },
                    ),
    );
  }

  void _showSessionDetails(Map<String, dynamic> session) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(session['sessionTitle'] ?? 'Session Details'),
        content: Text(session['details'] ?? 'No details available.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
