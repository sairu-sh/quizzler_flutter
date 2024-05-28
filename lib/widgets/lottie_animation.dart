import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class ResultWidget extends StatefulWidget {
  final double width;
  final double height;
  final String animationPath;
  final int? playCount;
  final Function(bool)? setIsOver;
  final Function(bool)? setIsPressed;
  final Function(bool)? setShowAnimation;
  final Function(int)? setPauseOn;

  const ResultWidget(
      {super.key,
      this.setPauseOn,
      this.playCount,
      this.setIsOver,
      this.setIsPressed,
      this.setShowAnimation,
      required this.height,
      required this.animationPath,
      required this.width});

  @override
  State<ResultWidget> createState() => _ResultWidgetState();
}

class _ResultWidgetState extends State<ResultWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  double _playCount = 0;
  late double limit;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    limit = widget.playCount != null
        ? widget.playCount!.toDouble()
        : double.infinity;

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _playCount++;
        if (_playCount < limit) {
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
    return Lottie.asset(
      widget.animationPath,
      controller: _controller,
      repeat: true,
      animate: true,
      height: widget.height,
      width: widget.width,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
