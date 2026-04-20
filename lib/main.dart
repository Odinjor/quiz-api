import 'package:flutter/material.dart';
import 'screens/quiz_screen.dart';
import 'screens/results_screen.dart'; 

void main() {
  runApp(const QuizApp());
}

class QuizApp extends StatelessWidget {
  const QuizApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quiz App',
      theme: ThemeData(useMaterial3: true),
      initialRoute: '/',
      routes: {
        '/': (context) => const QuizScreen(),
        '/results': (context) => const ResultsScreen(),
      },
    );
  }
}