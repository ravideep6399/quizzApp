import 'package:flutter/material.dart';

class ResultScreen extends StatelessWidget {
  final int correctAnswers;
  final int totalQuestions;

  ResultScreen({required this.correctAnswers, required this.totalQuestions});

  @override
  Widget build(BuildContext context) {
    double percentage = (correctAnswers / totalQuestions) * 100;

    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz Result'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You scored:',
              style: TextStyle(fontSize: 24),
            ),
            Text(
              '$correctAnswers / $totalQuestions',
              style: TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              'Percentage: ${percentage.toStringAsFixed(2)}%',
              style: TextStyle(fontSize: 24, color: Colors.green),
            ),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Navigate back to the quiz screen
              },
              child: Text('Retry Quiz'),
            ),
          ],
        ),
      ),
    );
  }
}
