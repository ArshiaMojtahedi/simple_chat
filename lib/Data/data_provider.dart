import 'dart:convert';
import 'package:http/http.dart' as http;

class DataProvider {
  static const String baseUrl =
      'https://jefe-stg-media-bucket.s3.amazonaws.com/programming-test/api/';

  Future<List<Map<String, dynamic>>> fetchChatList() async {
    final response = await http.get(Uri.parse('${baseUrl}/inbox.json'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return List<Map<String, dynamic>>.from(data);
    } else {
      throw Exception('Failed to fetch chat list');
    }
  }

  Future<Map<String, dynamic>> fetchChatDetails(String chatId) async {
    final response = await http.get(Uri.parse('${baseUrl}${chatId}.json'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return Map<String, dynamic>.from(data);
    } else {
      throw Exception('Failed to fetch chat details');
    }
  }
}
