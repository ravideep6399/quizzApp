import 'dart:convert';

import 'package:quiz_app/models/questions_model.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static String apiUrl =
      'https://opentdb.com/api.php?amount=20&category=18&difficulty=medium&type=multiple';

  // Function to fetch questions from the API
  static Future<List<Question>> fetchQuestions() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        // Decode the JSON response
        final jsonResponse = json.decode(response.body);

        // Extract the "results" array from the JSON
        final List<dynamic> results = jsonResponse['results'];

        // Map the "results" array to a list of Question objects
        return results.map((json) => Question.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load questions from API');
      }
    } catch (e) {
      throw Exception('Error fetching questions: $e');
    }
  }
}
