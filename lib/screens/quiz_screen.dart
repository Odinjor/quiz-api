import 'package:flutter/material.dart';
import '../models/question.dart';
import '../services/quiz_service.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});
  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  final _service = QuizService();

  List<Question> _questions = [];
  int _currentIndex = 0;
  bool _isLoading = true;
  String? _errorMessage;
  String? _selectedAnswer;
  bool _answered = false;
  int _score = 0;
  List<String> _shuffledAnswers = [];

  @override
  void initState() {
    super.initState();
    _loadQuestions();
  }

  Widget _buildLoading() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            'assets/images/thinking.png',
            height: 100,
            errorBuilder: (_, __, ___) => const SizedBox.shrink(),
          ),
          const SizedBox(height: 20),
          const CircularProgressIndicator(),
          const SizedBox(height: 16),
          const Text('Loading questions...'),
        ],
      ),
    );
  }

  Widget _buildError() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.wifi_off, size: 48, color: Colors.grey),
            const SizedBox(height: 16),
            Text(_errorMessage!, textAlign: TextAlign.center),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _loadQuestions,
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmpty() {
    return const Center(child: Text('No questions available.'));
  }

    Widget _buildQuestion() {
    final question = _questions[_currentIndex];
    final total = _questions.length;

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Progress indicator
          Text(
            'Question ${_currentIndex + 1} of $total',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          LinearProgressIndicator(
            value: (_currentIndex + 1) / total,
          ),
          const SizedBox(height: 32),

          // Question text
          Text(
            question.questionText,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 24),

          // Answer buttons
          ..._shuffledAnswers.map((answer) => _buildAnswerButton(answer, question)),

          const Spacer(),

          // Next button — only visible after answering
          if (_answered)
            ElevatedButton(
              onPressed: _nextQuestion,
              child: Text(
                _currentIndex + 1 < total ? 'Next question' : 'See results',
              ),
            ),
        ],
      ),
    );
  }

    Widget _buildAnswerButton(String answer, Question question) {
    Color? buttonColor;

    if (_answered) {
      if (answer == question.correctAnswer) {
        buttonColor = Colors.green.shade100;
      } else if (answer == _selectedAnswer) {
        buttonColor = Colors.red.shade100;
      }
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: buttonColor,
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
        onPressed: _answered ? null : () => _selectAnswer(answer, question),
        child: Text(answer),
      ),
    );
  }

    void _selectAnswer(String answer, Question question) {
    setState(() {
      _selectedAnswer = answer;
      _answered = true;
      if (answer == question.correctAnswer) {
        _score++;
      }
    });
  }

  void _nextQuestion() {
    final isLast = _currentIndex + 1 >= _questions.length;

    if (isLast) {
      Navigator.pushReplacementNamed(
        context,
        '/results',
        arguments: {'score': _score, 'total': _questions.length},
      );
      return;
    }

    setState(() {
      _currentIndex++;
      _selectedAnswer = null;
      _answered = false;
      _shuffledAnswers = _buildShuffled(_currentIndex);
    });
  }

    Future<void> _loadQuestions() async {
      setState(() { _isLoading = true; _errorMessage = null; });
      try {
        final questions = await _service.fetchQuestions();
        setState(() {
          _questions = questions;
          _isLoading = false;
          _shuffledAnswers = _buildShuffled(0);
        });
      } catch (e) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Could not load questions. Check your connection.';
        });
      }
    }

   List<String> _buildShuffled(int index) {
    final answers = List<String>.from(_questions[index].answers);
    answers.shuffle();
    return answers;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Quiz')),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) return _buildLoading();
    if (_errorMessage != null) return _buildError();
    if (_questions.isEmpty) return _buildEmpty();
    return _buildQuestion();
  }
}

