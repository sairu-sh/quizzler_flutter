import 'package:flutter/material.dart';

class SlideInButton extends StatefulWidget {
  final String text;
  final VoidCallback onPressed;
  late Color color;
  final int index;
  late Color textColor;

  SlideInButton({
    super.key,
    required this.text,
    required this.onPressed,
    required this.index,
    Color? color,
    Color? textColor,
  })  : color = color ?? Colors.blue,
        textColor = textColor ?? Colors.white;

  @override
  State<SlideInButton> createState() => _AnswerButtonState();
}

class _AnswerButtonState extends State<SlideInButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 400 + 100 * (widget.index + 1)),
    );

    _offsetAnimation = Tween<Offset>(
      begin: const Offset(-1, 0),
      end: const Offset(0, 0),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // @override
  // void didUpdateWidget(AnswerButton oldWidget) {
  //   super.didUpdateWidget(oldWidget);
  //   if (oldWidget.currentIndex != widget.currentIndex ||
  //       oldWidget.questionAppeared != widget.questionAppeared) {
  //     _controller.reset();
  //     _controller.forward();
  //     // widget.setIsPressed(false);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _offsetAnimation,
      child: SlideTransition(
          position: _offsetAnimation,
          child: GestureDetector(
            onTap: widget.onPressed,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Container(
                color: widget.color,
                height: 50,
                child: Center(
                  child: Text(widget.text,
                      style: TextStyle(
                          color: widget.textColor,
                          fontWeight: FontWeight.w800,
                          fontSize: 16),
                      textAlign: TextAlign.center),
                ),
              ),
            ),
          )),
    );
  }
}
