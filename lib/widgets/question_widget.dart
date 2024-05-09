import 'package:flutter/material.dart';

class QuestionWidget extends StatelessWidget {
  final String questionText;
  final Color textColor;

  const QuestionWidget(
      {super.key, required this.questionText, this.textColor = Colors.black});

  @override
  Widget build(BuildContext context) {
    bool isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    return Container(
      padding: isLandscape
          ? const EdgeInsets.all(5)
          : const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Text(
        questionText,
        style: TextStyle(
            fontSize: 18, fontWeight: FontWeight.bold, color: textColor),
        textAlign: TextAlign.center,
      ),
    );
  }
}
