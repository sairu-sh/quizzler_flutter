import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:video_player/video_player.dart';

import 'button_widget.dart';

class RestartResume extends StatefulWidget {
  final VideoPlayerController vController;
  final VoidCallback resetQuestionIndex;
  final Function(bool) setQuestionAppeared;
  final bool isPortrait;

  const RestartResume({
    super.key,
    required this.vController,
    required this.isPortrait,
    required this.setQuestionAppeared,
    required this.resetQuestionIndex,
  });

  @override
  State<RestartResume> createState() => _RestartResumeState();
}

class _RestartResumeState extends State<RestartResume>
    with TickerProviderStateMixin {
  late AnimationController _textController;
  late AnimationController _buttonsController;
  late AnimationController _lottieController;

  late Animation<Offset> _textOffset;
  late Animation<Offset> _buttonsOffset;
  late Animation<Offset> _lottieOffset;

  bool isPressed = false;

  void setIsPressed(bool value) {
    setState(() {
      isPressed = value;
    });
  }

  @override
  void initState() {
    super.initState();

    _textController = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
    _buttonsController = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
    _lottieController = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);

    _textOffset = Tween<Offset>(begin: const Offset(0, -1), end: Offset.zero)
        .animate(
            CurvedAnimation(parent: _textController, curve: Curves.easeInOut));

    _buttonsOffset = Tween<Offset>(begin: const Offset(-1, 0), end: Offset.zero)
        .animate(CurvedAnimation(
            parent: _buttonsController, curve: Curves.easeInOut));

    _lottieOffset = Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero)
        .animate(CurvedAnimation(
            parent: _lottieController, curve: Curves.easeInOut));

    _textController.forward();
    _buttonsController.forward();
    _lottieController.forward();
  }

  @override
  void dispose() {
    _textController.dispose();
    _buttonsController.dispose();
    _lottieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey.shade300,
      height: widget.isPortrait
          ? MediaQuery.of(context).size.height * 0.65
          : MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          if (!widget.isPortrait)
            SizedBox(height: MediaQuery.of(context).size.height * 0.05),
          SlideTransition(
            position: _textOffset,
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                'Yay you completed the quiz! There are no more questions! What would you like to do?',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF4a4a4a)),
              ),
            ),
          ),
          SizedBox(
              height: widget.isPortrait
                  ? MediaQuery.of(context).size.height * 0.05
                  : MediaQuery.of(context).size.height * 0.1),
          Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
            Flexible(
              flex: widget.isPortrait ? 1 : 2,
              child: SlideTransition(
                position: _buttonsOffset,
                child: Padding(
                  padding: EdgeInsets.only(
                      left: widget.isPortrait
                          ? 10.0
                          : MediaQuery.of(context).size.width * 0.1),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Button(
                          isPressed: isPressed,
                          onPressed: () {
                            setIsPressed(true);
                            widget.vController.play();
                          },
                          text: 'Continue watching',
                          buttonColor: Colors.cyan[400],
                        ),
                        const SizedBox(height: 15),
                        Button(
                            isPressed: isPressed,
                            onPressed: () {
                              setIsPressed(true);
                              widget.vController
                                  .seekTo(const Duration(seconds: 0));
                              widget.resetQuestionIndex();
                              widget.setQuestionAppeared(false);
                              widget.vController.play();
                            },
                            buttonColor: Colors.teal[300],
                            text: 'Restart Quiz'),
                        const SizedBox(height: 15),
                        Button(
                            onPressed: () {
                              setIsPressed(true);
                              widget.vController
                                  .seekTo(const Duration(seconds: 0));
                              widget.resetQuestionIndex();
                              widget.setQuestionAppeared(false);
                              Navigator.pushNamed(context, '/');
                            },
                            text: 'Choose another',
                            isPressed: isPressed,
                            buttonColor: Colors.purple[300]),
                      ]),
                ),
              ),
            ),
            if (!widget.isPortrait)
              SizedBox(width: MediaQuery.of(context).size.width * 0.05),
            Flexible(
              flex: 1,
              child: SlideTransition(
                position: _lottieOffset,
                child: SizedBox(
                  height: 200,
                  width: 200,
                  child: Lottie.asset(
                    'assets/animations/shiba.json',
                    repeat: true,
                    animate: true,
                  ),
                ),
              ),
            )
          ]),
        ],
      ),
    );
  }
}
