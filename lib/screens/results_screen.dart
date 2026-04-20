import 'package:flutter/material.dart';

class ResultsScreen extends StatelessWidget {
  const ResultsScreen({super.key});

  String _gradeMessage(int score, int total) {
    final pct = score / total;
    if (pct == 1.0) return 'Perfect score!';
    if (pct >= 0.8) return 'Great work!';
    if (pct >= 0.5) return 'Good effort!';
    return 'Keep practising!';
  }

  Color _gradeColor(int score, int total) {
    final pct = score / total;
    if (pct >= 0.8) return Colors.green;
    if (pct >= 0.5) return Colors.orange;
    return Colors.red;
  }
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments
        as Map<String, dynamic>;
    final score = args['score'] as int;
    final total = args['total'] as int;

    return Scaffold(
      appBar: AppBar(title: const Text('Results')),
      body: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Trophy asset (Phase 5 adds this image)
            Image.asset(
              'assets/images/trophy.png',
              height: 120,
              errorBuilder: (_, _, _) =>
                  const Icon(Icons.emoji_events, size: 80, color: Colors.amber),
            ),
            const SizedBox(height: 32),

            // Grade message
            Text(
              _gradeMessage(score, total),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),

            // Score display
            Text(
              '$score / $total',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.displayMedium?.copyWith(
                color: _gradeColor(score, total),
                fontWeight: FontWeight.bold,
              ),
            ),
              const SizedBox(height: 48),

            // Play again
            ElevatedButton(
              onPressed: () => Navigator.pushReplacementNamed(context, '/'),
              child: const Text('Play again'),
            ),
          ],
        ),
      ),
    );
  }
}