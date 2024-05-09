import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'question.dart';

class QuizBrain with ChangeNotifier {
  List<Question> questions = [];
  bool _isLoading = true;
  int _currentQuestionIndex = 0;

  QuizBrain() {
    loadQuestions();
  }

  Future<void> loadQuestions() async {
    _isLoading = true;
    notifyListeners();
    try {
      final String response =
          await rootBundle.loadString('assets/questions.json');
      final List data = await json.decode(response) as List;
      questions = data.map((item) => Question.fromJson(item)).toList();
      _isLoading = false;
    } catch (e) {
      print('error $e occured');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
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

  bool get isLoading => _isLoading;
  int get currentIndex => _currentQuestionIndex;
  int get correctAnswerIndex =>
      questions[_currentQuestionIndex].correctAnswerIndex;
  String get currentQuestion =>
      questions.isNotEmpty && _currentQuestionIndex != -1
          ? questions[_currentQuestionIndex].questionText
          : 'No question loaded';
  List<String> get currentAnswers =>
      questions.isNotEmpty && _currentQuestionIndex != -1
          ? questions[_currentQuestionIndex].answers
          : [];
  int get pauseOn => _currentQuestionIndex != -1
      ? questions[_currentQuestionIndex].pausedOn
      : -1;
}
