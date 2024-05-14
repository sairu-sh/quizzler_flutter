import 'package:flutter/material.dart';

class AnswerButton extends StatefulWidget {
  final String answerText;
  final VoidCallback onPressed;
  final VoidCallback raiseButton;
  String color;
  bool isAnswered;
  int selectedIndex;
  int index;
  int correctIndex;
  int currentIndex;
  bool isTimeUp;

  AnswerButton({
    super.key,
    required this.answerText,
    required this.onPressed,
    required this.color,
    required this.isAnswered,
    required this.correctIndex,
    required this.selectedIndex,
    required this.index,
    required this.currentIndex,
    required this.raiseButton,
    required this.isTimeUp,
  });

  @override
  State<AnswerButton> createState() => _AnswerButtonState();
}

class _AnswerButtonState extends State<AnswerButton>
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

    // Create a color tween from blue to green
    // _colorAnimation = ColorTween(
    //   begin: Colors.lightBlueAccent[700],
    //   end: Colors.greenAccent[400],
    // ).animate(_controller);

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

  @override
  void didUpdateWidget(AnswerButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentIndex != widget.currentIndex) {
      _controller.reset();
      _controller.forward();
      widget.raiseButton();
    }
  }

  Color _getBackgroundColor() {
    if (widget.isAnswered || widget.isTimeUp) {
      if (widget.correctIndex == widget.index) {
        return Colors.green[400]!;
      } else if (widget.selectedIndex == widget.index) {
        return Colors.red[400]!;
      } else {
        return Colors.transparent;
      }
    } else {
      return Colors.transparent;
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    return SlideTransition(
      position: _offsetAnimation,
      child: widget.answerText != ''
          ? Container(
              margin: const EdgeInsets.symmetric(vertical: 7.5, horizontal: 20),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                decoration: BoxDecoration(
                    color: widget.answerText == ''
                        ? Colors.transparent
                        : Colors.lightBlueAccent[700],
                    borderRadius: BorderRadius.circular(
                      isLandscape ? 8 : 15,
                    ),
                    boxShadow: widget.selectedIndex == widget.index &&
                            widget.answerText != ''
                        ? [
                            BoxShadow(
                                color: Colors.grey.shade500,
                                blurRadius: 15,
                                spreadRadius: 1,
                                offset: const Offset(6, 6)),
                            const BoxShadow(
                              color: Colors.white,
                              offset: Offset(-6, -6),
                              blurRadius: 15,
                            )
                          ]
                        : []),
                child: ElevatedButton(
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          isLandscape ? 8 : 15,
                        ),
                      ),
                    ),
                    padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                      isLandscape
                          ? const EdgeInsets.symmetric(
                              vertical: 15, horizontal: 10)
                          : const EdgeInsets.symmetric(
                              vertical: 20, horizontal: 10),
                    ),
                    backgroundColor: MaterialStateProperty.all<Color>(
                      _getBackgroundColor(),
                    ),
                    elevation: MaterialStateProperty.all<double>(
                      widget.color == 'active'
                          ? 6.0
                          : 0.0, // Apply shadow if active
                    ),
                  ),
                  onPressed: widget.isAnswered || widget.selectedIndex == -2
                      ? null
                      : widget.onPressed,
                  child: Text(
                    widget.answerText,
                    style: const TextStyle(fontSize: 14, color: Colors.white),
                  ),
                ),
              ),
            )
          : Container(),
    );
  }
}
