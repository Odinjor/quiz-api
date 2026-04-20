class Question {
  final String questionText;
  final List<String> answers;
  final String correctAnswer;

  Question({
    required this.questionText,
    required this.answers,
    required this.correctAnswer,
  });
factory Question.fromJson(Map<String, dynamic> json) {
  final answerList = (json['answers'] as List? ?? []);

  // Extract all answer text strings
  final answers = answerList
      .map((a) => a['text']?.toString() ?? '')
      .where((t) => t.isNotEmpty)
      .toList();

  // Find the correct answer text directly from isCorrect flag
  final correctAnswer = answerList
      .firstWhere(
        (a) => a['isCorrect'] == true,
        orElse: () => {'text': ''},
      )['text']
      ?.toString() ?? '';

  return Question(
    questionText: json['text']?.toString() ?? 'No question',
    answers: answers,
    correctAnswer: correctAnswer,
  );
}
}