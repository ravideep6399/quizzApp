import 'package:flutter/material.dart';
import 'package:quiz_app/quiz_attempt_screen.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        centerTitle: true,
        title: const Text("Start Page",style:TextStyle(color: Colors.white),),
      ),
      body: Center(
        child: ElevatedButton(
            style: const ButtonStyle(
              backgroundColor: WidgetStatePropertyAll(Colors.deepPurple)
            ),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return const QuizAttemptScreen();
              }));
            },
            child: const Text("Start Quizz",style: TextStyle(color: Colors.white),)),
      ),
    );
  }
}
