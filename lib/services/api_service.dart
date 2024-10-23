// lib/network/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String _baseUrl = 'http://localhost:3000'; // Replace with your backend URL

  Future<Map<String, dynamic>> login(String username, String password) async {
    final url = Uri.parse('$_baseUrl/api/login');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'username': username, 'password': password}),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body); // Return the response data
    } else {
      throw Exception('Failed to login: ${response.reasonPhrase}');
    }
  }
}
