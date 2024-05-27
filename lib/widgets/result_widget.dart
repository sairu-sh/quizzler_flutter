import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class ResultWidget extends StatefulWidget {
  final bool? isCorrect;
  final double width;
  final double height;
  final bool isTimeUp;
  final String? animationPath;
  final Function(bool)? setIsOver;
  final Function(bool)? setIsPressed;
  final Function(bool)? setShowAnimation;
  final Function(int)? setPauseOn;

  const ResultWidget(
      {super.key,
      required this.isCorrect,
      this.setPauseOn,
      this.animationPath,
      this.setIsOver,
      this.setIsPressed,
      this.setShowAnimation,
      required this.isTimeUp,
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
          widget.setShowAnimation!(false);
          widget.setIsPressed!(false);
          if (widget.setIsOver != null) {
            widget.setIsOver!(false);
          }
          if (widget.setPauseOn != null) {
            widget.setPauseOn!(-1);
          }
        }
      }
    });
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    String getAnimationPath() {
      return widget.animationPath ??
          (widget.isTimeUp
              ? 'assets/animations/timeup.json'
              : widget.isCorrect!
                  ? 'assets/animations/confetti.json'
                  : 'assets/animations/oops.json');
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
