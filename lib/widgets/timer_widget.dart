import 'package:flutter/material.dart';
import 'dart:math' as math;

class CountDownTimer extends StatefulWidget {
  final Function(bool) setIsTimeUp;
  final Function(bool) setShowAnimation;
  final Function(bool) setIsAnswered;
  final Function(int) setSelectedIndex;
  final int currentQuestionIndex;
  final bool questionAppeared;
  final int time;
  final bool isAnswered;
  final bool isTimeUp;
  final int correctIndex;

  const CountDownTimer(
      {super.key,
      required this.setIsTimeUp,
      required this.isTimeUp,
      required this.setShowAnimation,
      required this.setIsAnswered,
      required this.correctIndex,
      required this.setSelectedIndex,
      required this.isAnswered,
      required this.currentQuestionIndex,
      required this.questionAppeared,
      required this.time});
  @override
  State<CountDownTimer> createState() => _CountDownTimerState();
}

class _CountDownTimerState extends State<CountDownTimer>
    with TickerProviderStateMixin {
  late AnimationController controller;

  String get timerString {
    Duration duration = controller.duration! * (1.0 - controller.value) +
        const Duration(seconds: 1);
    if (controller.value == 1) {
      return '00:00';
    }
    return '${(duration.inMinutes).toString().padLeft(2, '0')}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
  }

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: widget.time),
    );
    controller.forward();
    controller.addStatusListener((status) {
      if (status == AnimationStatus.completed && widget.questionAppeared) {
        widget.setIsAnswered(true);
        widget.setIsTimeUp(!widget.isTimeUp);
        widget.setShowAnimation(true);
        widget.setSelectedIndex(widget.correctIndex);
      }
    });
  }

  @override
  void didUpdateWidget(CountDownTimer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isAnswered && !oldWidget.isAnswered) {
      controller.stop();
    }
    if (widget.currentQuestionIndex != oldWidget.currentQuestionIndex ||
        widget.questionAppeared != oldWidget.questionAppeared) {
      controller.reset();
      controller.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white10,
      body: AnimatedBuilder(
          animation: controller,
          builder: (context, child) {
            return Stack(
              children: <Widget>[
                Container(
                  width: 100,
                  height: 100,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.blue,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Expanded(
                          child: Align(
                            alignment: FractionalOffset.center,
                            child: AspectRatio(
                              aspectRatio: 1.0,
                              child: Stack(
                                children: <Widget>[
                                  Positioned.fill(
                                    child: CustomPaint(
                                        painter: CustomTimerPainter(
                                      animation: controller,
                                      backgroundColor: Colors.white,
                                      color: Colors.red,
                                    )),
                                  ),
                                  Align(
                                    alignment: FractionalOffset.center,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Text(
                                          timerString,
                                          style: const TextStyle(
                                              fontSize: 20.0,
                                              color: Colors.white),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }),
    );
  }

  @override
  void dispose() {
    controller.dispose(); // Dispose the animation controller
    super.dispose();
  }
}

class CustomTimerPainter extends CustomPainter {
  CustomTimerPainter({
    required this.animation,
    required this.backgroundColor,
    required this.color,
    // required this.isTimeUp,
  }) : super(repaint: animation);

  final Animation<double> animation;
  final Color backgroundColor, color;
  // final bool isTimeUp;

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = backgroundColor
      ..strokeWidth = 10.0
      ..strokeCap = StrokeCap.butt
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(size.center(Offset.zero), size.width / 2.0, paint);
    paint.color = color;
    double progress = (1.0 - animation.value) * 2 * math.pi;
    canvas.drawArc(Offset.zero & size, math.pi * 1.5, -progress, false, paint);
  }

  @override
  bool shouldRepaint(CustomTimerPainter oldDelegate) {
    return animation.value != oldDelegate.animation.value;
  }
}
