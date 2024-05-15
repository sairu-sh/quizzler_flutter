import 'package:flutter/material.dart';

class QuestionWidget extends StatelessWidget {
  final String questionText;
  final Color textColor;
  final String questionImage;

  const QuestionWidget(
      {super.key,
      required this.questionText,
      this.textColor = Colors.black,
      required this.questionImage});

  @override
  Widget build(BuildContext context) {
    bool isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    return Container(
      padding: isLandscape
          ? const EdgeInsets.all(5)
          : const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (questionImage.isNotEmpty)
            Image.asset(
              'assets/images/$questionImage',
              height: 200,
              width: MediaQuery.of(context).size.width - 50,
            ),
          if (questionImage.isNotEmpty && questionText.isNotEmpty)
            const SizedBox(height: 10),
          if (questionText.isNotEmpty)
            Text(
              questionText,
              style: TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold, color: textColor),
              textAlign: TextAlign.center,
            ),
        ],
      ),
    );
  }
}
