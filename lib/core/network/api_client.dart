// lib/core/network/api_client.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/api_constants.dart';

class ApiClient {
  final http.Client _client;
  final String baseUrl;

  // Initialize with a client and an optional baseUrl
  ApiClient({http.Client? client, this.baseUrl = ApiConstants.baseUrl})
      : _client = client ?? http.Client();

  // POST method to send data to the API
  Future<http.Response> post(
      String endpoint,
      Map<String, dynamic> body,
      ) async {
    final url = Uri.parse(baseUrl + endpoint);
    return _client.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );
  }

  // GET method with dynamic headers
  Future<http.Response> get(
      String endpoint, {
        required Map<String, String> headers, // Ensure headers are required
      }) async {
    final url = Uri.parse(baseUrl + endpoint);
    return _client.get(
      url,
      headers: headers, // Use the passed headers
    );
  }
}
