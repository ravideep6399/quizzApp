import 'dart:async';

import 'package:flutter/material.dart';
import 'package:quiz_app/data/api.dart';
import 'package:quiz_app/models/questions_model.dart';
import 'package:quiz_app/result_page.dart';

class QuizAttemptScreen extends StatefulWidget {
  const QuizAttemptScreen({super.key});

  @override
  State<QuizAttemptScreen> createState() => _QuizAttemptScreenState();
}

class _QuizAttemptScreenState extends State<QuizAttemptScreen> {
  late Future<List<Question>> _questionsFuture;
  ApiService apiService = ApiService();
  int _currentQuestionIndex = 0;
  int _totalQuestionsAttempted = 0;
  bool _isAnswered = false;
  bool _isCorrect = false;
  int _selectedOptionIndex = -1;
  int correctAnswers = 0;
  @override
  void initState() {
    super.initState();
    // Fetch the questions from the API when the page initializes
    _questionsFuture = ApiService.fetchQuestions();
  }

  void _submitAnswer(List<Question> questions) {
    if (_selectedOptionIndex != -1 && !_isAnswered) {
      setState(() {
        _isAnswered = true;
        _isCorrect = _selectedOptionIndex ==
            questions[_currentQuestionIndex].correctOptionIndex;
        if (_isCorrect) {
          correctAnswers++;
        }
        _totalQuestionsAttempted++;
      });
    }
  }

  void _nextQuestion(List<Question> questions, BuildContext context) {
    if (_currentQuestionIndex < questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
        _isAnswered = false;
        _selectedOptionIndex = -1;
      });
    } else {
      // Navigate to the result page once the final question is answered
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => ResultScreen(
                  correctAnswers: correctAnswers,
                  totalQuestions: questions.length,
                )),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Quiz App')),
      body: FutureBuilder<List<Question>>(
        future: _questionsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            List<Question>? questions = snapshot.data;
            return _buildQuizContent(questions!);
          } else {
            return const Center(child: Text('No questions found.'));
          }
        },
      ),
    );
  }

  Widget _buildQuizContent(List<Question> questions) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Progress bar
          LinearProgressIndicator(
            value: _totalQuestionsAttempted / questions.length,
          ),
          const SizedBox(height: 20),

          // Question text
          Text(
            'Question ${_currentQuestionIndex + 1}/${questions.length}:',
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Text(
            questions[_currentQuestionIndex].questionText,
            style: const TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 20),

          // Options as Radio buttons
          Column(
            children: List.generate(
                questions[_currentQuestionIndex].options.length, (index) {
              return RadioListTile(
                title: Text(questions[_currentQuestionIndex].options[index]),
                value: index,
                groupValue: _selectedOptionIndex,
                onChanged: _isAnswered
                    ? null
                    : (int? value) {
                        setState(() {
                          _selectedOptionIndex = value!;
                        });
                      },
              );
            }),
          ),
          const SizedBox(height: 20),

          // Submit button
          ElevatedButton(
            onPressed: () => _submitAnswer(questions),
            child: const Text('Submit'),
          ),

          // Feedback after submission
          if (_isAnswered)
            Text(
              _isCorrect
                  ? 'Correct!'
                  : 'Wrong! The correct answer is: ${questions[_currentQuestionIndex].options[questions[_currentQuestionIndex].correctOptionIndex]}',
              style: TextStyle(
                color: _isCorrect ? Colors.green : Colors.red,
                fontSize: 18,
              ),
            ),

          const SizedBox(height: 20),

          // Next question button
          if (_isAnswered)
            ElevatedButton(
              onPressed: () => _nextQuestion(questions, context),
              child: Text(_currentQuestionIndex < questions.length - 1
                  ? 'Next Question'
                  : 'Finish Quiz'),
            ),

          // Questions attempted
          Text(
            'Questions attempted: $_totalQuestionsAttempted/${questions.length}',
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}
