class Question {
  String questionText;
  List<String> answers;
  int correctAnswerIndex;
  int pausedOn;

  Question({
    required this.questionText,
    required this.answers,
    required this.correctAnswerIndex,
    required this.pausedOn,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
        questionText: json['questionText'] as String,
        answers: List<String>.from(json['answers']),
        correctAnswerIndex: json['correctAnswerIndex'] as int,
        pausedOn: json['pausedOn'] as int);
  }
}
