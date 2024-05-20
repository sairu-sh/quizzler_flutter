import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import 'package:provider/provider.dart';
import 'package:lottie/lottie.dart';

import '../widgets/restart_resume.dart';
import '../widgets/result_widget.dart';
import '../widgets/video_player.dart';
import '../widgets/quiz_content.dart';
import '../controllers/quiz_brain.dart';

class Quizzler extends StatefulWidget {
  const Quizzler({super.key});

  @override
  State<Quizzler> createState() => _QuizzlerState();
}

class _QuizzlerState extends State<Quizzler> {
  bool questionAppeared = false;
  bool isAnswered = false;
  bool isTimeUp = false;
  bool isOver = false;
  bool showAnimation = false;
  bool isPressed = false;
  bool isCorrect = false;

  final VideoPlayerController vController =
      VideoPlayerController.asset('assets/videos/jjk.mp4');
  // final VideoPlayerController vController = VideoPlayerController.networkUrl(
  //   Uri.parse(
  //     'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
  //   ),
  // );

  void setIsOver(bool value) {
    setState(() {
      isOver = value;
    });
  }

  void setIsPressed(bool value) {
    setState(() {
      isPressed = value;
    });
  }

  void setShowAnimation(bool value) {
    setState(() {
      showAnimation = value;
    });
  }

  void setIsCorrect(bool value) {
    setState(() {
      isCorrect = value;
    });
  }

  void setQuestionAppeared(bool value) {
    setState(() {
      questionAppeared = value;
    });
  }

  void setIsAnswered(bool value) {
    setState(() {
      isAnswered = value;
    });
  }

  void setIsTimeUp(bool value) {
    setState(() {
      isTimeUp = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[100],
      appBar: MediaQuery.of(context).orientation == Orientation.portrait
          ? AppBar(
              title:
                  const Text('Quizzler', style: TextStyle(color: Colors.white)),
              backgroundColor: Colors.blueGrey[900],
            )
          : PreferredSize(
              preferredSize: const Size.fromHeight(0.0),
              child: Container(),
            ),
      body: Consumer<QuizBrain>(
        builder: (context, controller, child) {
          if (controller.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          return OrientationBuilder(
            builder: (context, orientation) {
              if (orientation == Orientation.landscape) {
                SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
                    overlays: [SystemUiOverlay.bottom]);
              } else {
                SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
                    overlays: SystemUiOverlay.values);
              }
              return Stack(children: [
                SizedBox(
                  height: orientation == Orientation.landscape
                      ? MediaQuery.of(context).size.height
                      : MediaQuery.of(context).size.height * 0.25,
                  child: VideoPlayerScreen(
                    setQuestionAppeared: setQuestionAppeared,
                    questionAppeared: questionAppeared,
                    pauseOn: controller.pauseOn,
                    isAnswered: isAnswered,
                    setisAnswered: setIsAnswered,
                    setIsTimeUp: setIsTimeUp,
                    vController: vController,
                  ),
                ),
                Visibility(
                  visible: !questionAppeared,
                  child: Column(
                    children: [
                      SizedBox(
                        height: orientation == Orientation.portrait
                            ? MediaQuery.of(context).size.height * 0.25
                            : 0,
                      ),
                      if (isOver)
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 400),
                          color: Colors.blueGrey[300],
                          height: orientation == Orientation.portrait
                              ? 500
                              : MediaQuery.of(context).size.height,
                          width: MediaQuery.of(context).size.width,
                          child: Column(
                            children: [
                              const SizedBox(height: 10),
                              const Text(
                                'Quiz Complete!!',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),
                              ResultWidget(
                                height: orientation == Orientation.portrait
                                    ? MediaQuery.of(context).size.height * 0.4
                                    : MediaQuery.of(context).size.height * 0.7,
                                width: 400.0,
                                isTimeUp: true,
                                isCorrect: false,
                                animationPath:
                                    'assets/animations/happy-fox.json',
                                setIsOver: setIsOver,
                                setShowAnimation: setShowAnimation,
                                setIsPressed: setIsPressed,
                              ),
                            ],
                          ),
                        )
                      else if (controller.currentIndex == -1)
                        RestartResume(
                            isPortrait: orientation == Orientation.portrait,
                            vController: vController,
                            setQuestionAppeared: setQuestionAppeared,
                            resetQuestionIndex: controller.restartQuiz)
                      else if (orientation == Orientation.portrait)
                        SizedBox(
                          height: 500,
                          width: 500,
                          child: Lottie.asset(
                            'assets/animations/watchingCat.json',
                            repeat: true,
                            animate: true,
                            height: 500,
                            width: 500,
                          ),
                        ),
                    ],
                  ),
                ),
                Visibility(
                    visible: questionAppeared && controller.currentIndex != -1,
                    child: QuizContent(
                      orientation: orientation,
                      controller: controller,
                      isTimeUp: isTimeUp,
                      isAnswered: isAnswered,
                      isOver: isOver,
                      showAnimation: showAnimation,
                      isCorrect: isCorrect,
                      isPressed: isPressed,
                      questionAppeared: questionAppeared,
                      setIsCorrect: setIsCorrect,
                      setIsPressed: setIsPressed,
                      setIsAnswered: setIsAnswered,
                      setIsOver: setIsOver,
                      setIsTimeUp: setIsTimeUp,
                      setShowAnimation: setShowAnimation,
                      setQuestionAppeared: setQuestionAppeared,
                      vController: vController,
                    )
                    // ),
                    ),
                if (showAnimation)
                  Positioned(
                    top: MediaQuery.of(context).size.height * 0.5 - 250,
                    left: MediaQuery.of(context).size.width * 0.5 - 250,
                    child: ResultWidget(
                        isCorrect: isCorrect,
                        isTimeUp: isTimeUp,
                        setShowAnimation: setShowAnimation,
                        setIsPressed: setIsPressed,
                        height:
                            (orientation == Orientation.landscape) ? 500 : 500,
                        width:
                            (orientation == Orientation.landscape) ? 500 : 500),
                  ),
              ]);
            },
          );
        },
      ),
    );
  }
}
