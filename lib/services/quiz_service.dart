import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/question.dart';

class QuizService {
  static const _apiKey = 'qa_sk_f1fdaedb9757710b9660b83c208ab6affa82d2f2';

 Future<List<Question>> fetchQuestions() async {
  final response = await http.get(
    Uri.parse('https://quizapi.io/api/v1/questions?api_key=qa_sk_f1fdaedb9757710b9660b83c208ab6affa82d2f2&limit=10&category=Programming&difficulty=Easy'),
  ).timeout(const Duration(seconds: 10));

  if (response.statusCode != 200) {
    throw Exception('API error: ${response.statusCode}');
  }

  final decoded = json.decode(response.body);

  // API wraps results in {"success": true, "data": [...]}
  final List<dynamic> data = decoded is List ? decoded : decoded['data'] as List;

  if (data.isEmpty) throw Exception('No questions returned');

  return data
      .map((item) => Question.fromJson(item as Map<String, dynamic>))
      .where((q) => q.answers.isNotEmpty && q.correctAnswer.isNotEmpty)
      .toList();
}
}