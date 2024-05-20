class Question {
  String questionText;
  String? questionImage;
  List<String>? answers;
  List<String>? answerImages;
  int correctAnswerIndex;
  int pausedOn;

  Question({
    required this.questionText,
    this.answers,
    this.questionImage,
    this.answerImages,
    required this.correctAnswerIndex,
    required this.pausedOn,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      questionText: json['questionText'] as String,
      questionImage: json['questionImage'] as String?,
      answers:
          json.containsKey('answers') ? List<String>.from(json['answers']) : [],
      answerImages: json.containsKey('answerImages')
          ? List<String>.from(json['answerImages'])
          : [],
      correctAnswerIndex: json['correctAnswerIndex'] as int,
      pausedOn: json['pausedOn'] as int,
    );
  }
}
