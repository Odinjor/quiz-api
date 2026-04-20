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
    final answerMap = Map<String, dynamic>.from(
      json['answers'] as Map? ?? {},
    );

    final correctMap = Map<String, dynamic>.from(
      json['correct_answers'] as Map? ?? {},
    );

    // Build answer list, skip null/empty values
    final answers = answerMap.entries
        .where((e) => e.value != null && e.value.toString().isNotEmpty)
        .map((e) => e.value.toString())
        .toList();

    // Find which answer key is correct (value == "true")
    final correctKey = correctMap.entries
        .firstWhere(
          (e) => e.value == 'true',
          orElse: () => MapEntry('', ''),
        )
        .key;

    // correctKey is like "answer_a_correct" — strip "_correct"
    final answerKey = correctKey.replaceAll('_correct', '');
    final correctAnswer = answerMap[answerKey]?.toString() ?? '';

    return Question(
      questionText: json['question']?.toString() ?? 'No question',
      answers: answers,
      correctAnswer: correctAnswer,
    );
  }
}