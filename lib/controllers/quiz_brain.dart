import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import 'dart:convert';
import '../models/question.dart';

class QuizBrain with ChangeNotifier {
  List<Question> questions = [];
  bool _isLoading = true;
  int _currentQuestionIndex = 0;
  int _index = 0;
  String videoName = '';
  late VideoPlayerController videoPlayerController;

  QuizBrain() {
    loadQuestions();
  }

  void setIndexAndLoadQuestions(int index) {
    _index = index;
    loadQuestions();
  }

  Future<void> loadQuestions() async {
    _isLoading = true;
    notifyListeners();
    try {
      final String response =
          await rootBundle.loadString('assets/questions.json');
      final List data = await json.decode(response) as List;
      final List questionsJson = data[_index]['questions'] as List;
      videoName = data[_index]['video'] as String;
      questions = questionsJson.map((item) => Question.fromJson(item)).toList();

      videoPlayerController = VideoPlayerController.asset(videoName)
        ..initialize().then((_) {
          notifyListeners();
        });
      _isLoading = false;
    } catch (e) {
      print('error $e occured');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    videoPlayerController.dispose();
    super.dispose();
  }

  void nextQuestion() {
    if (_currentQuestionIndex < questions.length - 1) {
      _currentQuestionIndex++;
    } else {
      _currentQuestionIndex = -1;
    }
    notifyListeners();
  }

  bool checkAnswer(int index) {
    return questions[_currentQuestionIndex].correctAnswerIndex == index;
  }

  void restartQuiz() {
    _currentQuestionIndex = 0;
    notifyListeners();
  }

  bool get isLoading => _isLoading;
  int get currentIndex => _currentQuestionIndex;
  int get correctAnswerIndex {
    if (_currentQuestionIndex != -1) {
      return questions[_currentQuestionIndex].correctAnswerIndex;
    } else {
      return -1;
    }
  }

  String get currentQuestion =>
      questions.isNotEmpty && _currentQuestionIndex != -1
          ? (questions[_currentQuestionIndex].questionText)
          : 'No question loaded';
  Map<String, dynamic> get currentAnswersOrImages {
    if (questions.isNotEmpty && _currentQuestionIndex != -1) {
      var currentQuestion = questions[_currentQuestionIndex];
      if (currentQuestion.answers != null &&
          currentQuestion.answers!.isNotEmpty) {
        return {'list': currentQuestion.answers!, 'isAnswerImages': false};
      } else if (currentQuestion.answerImages != null &&
          currentQuestion.answerImages!.isNotEmpty) {
        return {'list': currentQuestion.answerImages!, 'isAnswerImages': true};
      }
    }
    return {'list': <String>[], 'isAnswerImages': false};
  }

  String get currentQuestionImage =>
      questions.isNotEmpty && _currentQuestionIndex != -1
          ? (questions[_currentQuestionIndex].questionImage ?? '')
          : 'No question loaded';

  int get pauseOn => _currentQuestionIndex != -1
      ? questions[_currentQuestionIndex].pausedOn
      : -1;
}
