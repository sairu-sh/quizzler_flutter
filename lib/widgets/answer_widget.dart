import 'package:flutter/material.dart';

class AnswerButton extends StatefulWidget {
  final String answerText;
  final VoidCallback onPressed;
  final String color;
  final bool isAnswered;
  final int selectedIndex;
  final int index;
  final int correctIndex;
  final int currentIndex;
  final bool isTimeUp;
  final bool isAnswerImages;
  final bool questionAppeared;

  const AnswerButton({
    super.key,
    required this.answerText,
    required this.onPressed,
    required this.color,
    required this.isAnswered,
    required this.isAnswerImages,
    required this.correctIndex,
    required this.selectedIndex,
    required this.index,
    required this.currentIndex,
    required this.isTimeUp,
    required this.questionAppeared,
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
    if (oldWidget.currentIndex != widget.currentIndex ||
        oldWidget.questionAppeared != widget.questionAppeared) {
      _controller.reset();
      _controller.forward();
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
                    border: Border.all(
                      width: (widget.selectedIndex == widget.index ||
                                  (widget.isAnswered &&
                                      (widget.index == widget.selectedIndex ||
                                          widget.index ==
                                              widget.correctIndex))) &&
                              widget.isAnswerImages
                          ? 5
                          : 0.0,
                      color: widget.isAnswered
                          ? widget.correctIndex == widget.index
                              ? Colors.green
                              : widget.selectedIndex == widget.index
                                  ? Colors.red
                                  : Colors.white
                          : Colors.transparent,
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
                      widget.isAnswerImages
                          ? const EdgeInsets.all(0.0)
                          : isLandscape
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
                  onPressed: widget.isAnswered ? null : widget.onPressed,
                  child: widget.isAnswerImages
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(15.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: Image.asset(
                                  'assets/images/${widget.answerText}',
                                  height: 100,
                                  fit: BoxFit
                                      .fill, // Ensures the image covers the button space
                                ),
                              ),
                            ],
                          ),
                        )
                      : Text(
                          widget.answerText,
                          style: const TextStyle(
                              fontSize: 14, color: Colors.white),
                        ),
                ),
              ),
            )
          : Container(),
    );
  }
}
