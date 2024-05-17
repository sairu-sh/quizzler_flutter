import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class ResultWidget extends StatefulWidget {
  final bool? isCorrect;
  final VoidCallback resetQuestion;
  double width;
  double height;
  bool isTimeUp;

  ResultWidget(
      {super.key,
      required this.isCorrect,
      required this.isTimeUp,
      required this.resetQuestion,
      required this.height,
      required this.width});

  @override
  State<ResultWidget> createState() => _ResultWidgetState();
}

class _ResultWidgetState extends State<ResultWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  int _playCount = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _playCount++;
        if (_playCount < 2) {
          _controller.forward(from: 0.0);
        } else {
          widget.resetQuestion();
        }
      }
    });
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    String getAnimationPath() {
      return widget.isTimeUp
          ? 'assets/animations/timeup.json'
          : widget.isCorrect!
              ? 'assets/animations/confetti.json'
              : 'assets/animations/wrong.json';
    }

    return Lottie.asset(
      getAnimationPath(),
      controller: _controller,
      repeat: true,
      animate: true,
      height: widget.height,
      width: widget.width,
    );
  }

  @override
  void dispose() {
    _controller.dispose(); // Dispose the animation controller
    super.dispose();
  }
}
