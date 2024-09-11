class Question {
  final String questionText;
  final List<String> options;
  final int correctOptionIndex;

  Question({
    required this.questionText,
    required this.options,
    required this.correctOptionIndex,
  });

  // Factory method to create a Question object from JSON
  factory Question.fromJson(Map<String, dynamic> json) {
    // Combine the correct answer with the incorrect answers
    List<String> allOptions = List<String>.from(json['incorrect_answers']);
    allOptions.add(json['correct_answer']);

    // Shuffle the options so the correct answer is not always in the same position
    allOptions.shuffle();

    // Find the index of the correct answer after shuffling
    int correctIndex = allOptions.indexOf(json['correct_answer']);

    return Question(
      questionText: json['question'],
      options: allOptions,
      correctOptionIndex: correctIndex,
    );
  }
}