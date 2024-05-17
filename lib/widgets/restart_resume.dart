import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:video_player/video_player.dart';

class RestartResume extends StatelessWidget {
  final VideoPlayerController vController;
  final VoidCallback resetQuestionIndex;
  final VoidCallback resetQuestionAppeared;
  const RestartResume({
    super.key,
    required this.vController,
    required this.resetQuestionAppeared,
    required this.resetQuestionIndex,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.5,
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
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
          Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                          onPressed: () {
                            vController.seekTo(const Duration(seconds: 0));
                            resetQuestionIndex();
                            resetQuestionAppeared();
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
            Expanded(
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
