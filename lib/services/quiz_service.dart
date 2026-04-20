import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/question.dart';

class QuizService {
  static const _apiKey = String.fromEnvironment('qa_sk_f1fdaedb9757710b9660b83c208ab6affa82d2f2');

  static const _baseUrl = 'https://quizapi.io/api/v1/questions?limit=10&offset=0&category=Programming&difficulty=EASY&type=MULTIPLE_CHOICE&random=true';

  Future<List<Question>> fetchQuestions() async {
    final uri = Uri.parse(_baseUrl).replace(queryParameters: {
      'limit': '10',
      'category': 'Programming',
      'difficulty': 'Easy',
      'type': 'Multiple Choice',
      'random_quick': 'true',
    });

    final response = await http
        .get(uri, headers: {'X-Api-Key': _apiKey})
        .timeout(const Duration(seconds: 10));

    if (response.statusCode != 200) {
      throw Exception('API error: ${response.statusCode}');
    }

    final List<dynamic> data = json.decode(response.body);

    if (data.isEmpty) {
      throw Exception('No questions returned');
    }

    return data
        .map((item) => Question.fromJson(item as Map<String, dynamic>))
        .where((q) => q.answers.isNotEmpty && q.correctAnswer.isNotEmpty)
        .toList();
  }
}
