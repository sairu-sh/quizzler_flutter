import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:video_player/video_player.dart';

class RestartResume extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey.shade300,
      height: isPortrait
          ? MediaQuery.of(context).size.height * 0.65
          : MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          if (!isPortrait)
            SizedBox(height: MediaQuery.of(context).size.height * 0.05),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Yay you completed the quiz! There are no more questions! What would you like to do?',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4a4a4a)),
            ),
          ),
          SizedBox(
              height: isPortrait
                  ? MediaQuery.of(context).size.height * 0.05
                  : MediaQuery.of(context).size.height * 0.1),
          Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
            Flexible(
              flex: isPortrait ? 1 : 2,
              child: Padding(
                padding: EdgeInsets.only(
                    left: isPortrait
                        ? 10.0
                        : MediaQuery.of(context).size.width * 0.1),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                          onPressed: () {
                            vController.seekTo(const Duration(seconds: 0));
                            resetQuestionIndex();
                            setQuestionAppeared(false);
                            vController.play();
                          },
                          child: const Text('Restart Quiz')),
                      ElevatedButton(
                          onPressed: () {
                            vController.play();
                          },
                          child: const Text('Continue watching')),
                      ElevatedButton(
                          onPressed: () {},
                          child: const Text('Choose another')),
                    ]),
              ),
            ),
            if (!isPortrait)
              SizedBox(width: MediaQuery.of(context).size.width * 0.05),
            Flexible(
              flex: 1,
              child: SizedBox(
                height: 200,
                width: 200,
                child: Lottie.asset(
                  'assets/animations/shiba.json',
                  repeat: true,
                  animate: true,
                ),
              ),
            )
          ]),
        ],
      ),
    );
  }
}
