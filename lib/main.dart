import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import 'package:provider/provider.dart';
import 'package:lottie/lottie.dart';

import 'widgets/answer_widget.dart';
import 'widgets/question_widget.dart';
import 'widgets/result_widget.dart';
import 'widgets/button_widget.dart';
import 'widgets/timer_widget.dart';
import 'widgets/video_player.dart';
import 'quiz_brain.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => QuizBrain(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isAnswered = false;
  int selectedIndex = -1;
  bool isCorrect = false;
  bool showAnimation = false;
  bool isPressed = false;
  bool isTimeUp = false;
  bool questionAppeared = false;
  int? pausedOn;
  bool autoPlay = true;
  final VideoPlayerController vController =
      VideoPlayerController.asset('assets/videos/jjk.mp4');
  // final VideoPlayerController vController = VideoPlayerController.networkUrl(
  //   Uri.parse(
  //     'https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4',
  //   ),
  // );

  void resetQuestion() {
    setState(() {
      showAnimation = false;
      isPressed = false;
    });
  }

  void raiseButton() {
    isPressed = false;
  }

  void timeUp() {
    setState(() {
      isTimeUp = !isTimeUp;
      selectedIndex = -2;
      showAnimation = true;
      isAnswered = true;
    });
  }

  void pauseVideo() {
    setState(() {
      questionAppeared = true;
    });
  }

  void setisAnswered() {
    setState(() {
      isAnswered = false;
      isTimeUp = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.blueGrey[100],
        appBar: MediaQuery.of(context).orientation == Orientation.portrait
            ? AppBar(
                title: const Text('Quizzler',
                    style: TextStyle(color: Colors.white)),
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
                return SingleChildScrollView(
                  child: Stack(children: [
                    SizedBox(
                      height: orientation == Orientation.landscape
                          ? MediaQuery.of(context).size.height
                          : MediaQuery.of(context).size.height * 0.25,
                      child: VideoPlayerScreen(
                        pauseVideo: pauseVideo,
                        questionAppeared: questionAppeared,
                        pauseOn: controller.pauseOn,
                        isAnswered: isAnswered,
                        setisAnswered: setisAnswered,
                        vController: vController,
                      ),
                    ),
                    Visibility(
                      visible: !questionAppeared &&
                          orientation == Orientation.portrait,
                      child: Column(
                        children: [
                          if (orientation == Orientation.portrait)
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.25,
                            ),
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
                      visible:
                          questionAppeared && controller.currentIndex != -1,

                      // duration: const Duration(milliseconds: 500),
                      // top: orientation == Orientation.portrait
                      //     ? MediaQuery.of(context).size.height * 0.25
                      //     : 0,
                      // left: questionAppeared
                      //     ? 0
                      //     : -MediaQuery.of(context).size.width,
                      // child: Positioned(
                      //   top: orientation == Orientation.portrait
                      //       ? MediaQuery.of(context).size.height * 0.25
                      //       : 0,
                      //   width: MediaQuery.of(context).size.width,
                      child: Column(
                        children: [
                          if (orientation == Orientation.portrait)
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.25,
                            ),
                          Container(
                            color: Colors.grey[300],
                            constraints: BoxConstraints(
                              minHeight: MediaQuery.of(context).size.height,
                            ),
                            child: Column(
                              children: [
                                controller.isLoading
                                    ? const CircularProgressIndicator()
                                    : Padding(
                                        padding: EdgeInsets.only(
                                            top: orientation ==
                                                    Orientation.landscape
                                                ? 20.0
                                                : 5.0),
                                        child: QuestionWidget(
                                          questionText:
                                              controller.currentQuestion,
                                          textColor: Colors.black,
                                        ),
                                      ),
                                const SizedBox(height: 10.0),
                                if (orientation == Orientation.landscape)
                                  SizedBox(
                                    child: ListView.builder(
                                      shrinkWrap: true,
                                      physics: const ClampingScrollPhysics(),
                                      itemCount:
                                          (controller.currentAnswers.length / 2)
                                              .ceil(),
                                      itemBuilder: (context, index) {
                                        final startIndex = index * 2;
                                        final endIndex = startIndex + 2;
                                        final sublist =
                                            controller.currentAnswers.sublist(
                                                startIndex,
                                                endIndex >
                                                        controller
                                                            .currentAnswers
                                                            .length
                                                    ? controller
                                                        .currentAnswers.length
                                                    : endIndex);

                                        return Padding(
                                          padding:
                                              const EdgeInsets.only(top: 10.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              for (var answer in sublist)
                                                Expanded(
                                                  child: AnswerButton(
                                                    currentIndex:
                                                        controller.currentIndex,
                                                    answerText:
                                                        answer.toString(),
                                                    isTimeUp: isTimeUp,
                                                    onPressed: () {
                                                      setState(() {
                                                        selectedIndex =
                                                            controller
                                                                .currentAnswers
                                                                .indexOf(
                                                                    answer);
                                                      });
                                                    },
                                                    color: selectedIndex ==
                                                            controller
                                                                .currentAnswers
                                                                .indexOf(answer)
                                                        ? 'active'
                                                        : 'inactive',
                                                    isAnswered: isAnswered,
                                                    index: controller
                                                        .currentAnswers
                                                        .indexOf(answer),
                                                    selectedIndex:
                                                        selectedIndex,
                                                    correctIndex: controller
                                                        .correctAnswerIndex,
                                                    raiseButton: raiseButton,
                                                  ),
                                                ),
                                              if (sublist.length == 1 &&
                                                  endIndex <=
                                                      controller.currentAnswers
                                                          .length)
                                                Expanded(
                                                    child: SizedBox(
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.25)), // Add an empty widget to maintain layout
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  )
                                else
                                  ListView(
                                    shrinkWrap: true,
                                    physics: const ClampingScrollPhysics(),
                                    children:
                                        controller.currentAnswers.map((answer) {
                                      return AnswerButton(
                                        currentIndex: controller.currentIndex,
                                        answerText: answer.toString(),
                                        isTimeUp: isTimeUp,
                                        onPressed: () {
                                          setState(() {
                                            selectedIndex = controller
                                                .currentAnswers
                                                .indexOf(answer);
                                          });
                                        },
                                        color: selectedIndex ==
                                                controller.currentAnswers
                                                    .indexOf(answer)
                                            ? 'active'
                                            : 'inactive',
                                        isAnswered: isAnswered,
                                        index: controller.currentAnswers
                                            .indexOf(answer),
                                        selectedIndex: selectedIndex,
                                        correctIndex:
                                            controller.correctAnswerIndex,
                                        raiseButton: raiseButton,
                                      );
                                    }).toList(),
                                  ),
                                SizedBox(
                                    height: orientation == Orientation.landscape
                                        ? 40.0
                                        : 20.0),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Container(
                                      width: 100,
                                      height: 100,
                                      margin: const EdgeInsets.only(left: 10),
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        // color: Colors.blue,
                                      ),
                                      child: CountDownTimer(
                                          // questionAppeared: questionAppeared,
                                          timeUp: timeUp,
                                          currentQuestionIndex:
                                              controller.currentIndex,
                                          time: 10,
                                          isAnswered: isAnswered),
                                    ),
                                    Button(
                                      onPressed: selectedIndex == -1
                                          ? null
                                          : () {
                                              if (isAnswered) {
                                                controller.nextQuestion();
                                                setState(() {
                                                  isAnswered = false;
                                                  selectedIndex = -1;
                                                  showAnimation = false;

                                                  pausedOn = controller.pauseOn;

                                                  questionAppeared = false;
                                                });
                                                vController.play();
                                              } else if (isTimeUp) {
                                                controller.nextQuestion();
                                                setState(() {
                                                  isAnswered = false;
                                                  isTimeUp = false;
                                                  selectedIndex = -1;
                                                  questionAppeared = false;
                                                  pausedOn = controller.pauseOn;
                                                });
                                                vController.play();
                                              } else {
                                                isCorrect = controller
                                                    .checkAnswer(selectedIndex);
                                                setState(() {
                                                  isAnswered = true;
                                                  showAnimation = true;
                                                });
                                              }
                                              setState(() {
                                                isPressed = true;
                                              });
                                            },
                                      text: isTimeUp
                                          ? 'Continue'
                                          : !isAnswered
                                              ? 'Check'
                                              : 'Continue',
                                      isPressed: isPressed,
                                      buttonColor: selectedIndex == -1
                                          ? Colors.grey[300]!
                                          : isTimeUp
                                              ? Colors.red
                                              : isAnswered
                                                  ? isCorrect
                                                      ? Colors.green
                                                      : Colors.red
                                                  : Colors.lightBlueAccent,
                                      textColor: selectedIndex == -1
                                          ? Colors.black
                                          : Colors.white,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20)
                              ],
                            ),
                          ),
                        ],
                      ),
                      // ),
                    ),
                    if (showAnimation)
                      Positioned(
                        top: 175,
                        left:
                            (orientation == Orientation.landscape) ? 110 : -50,
                        child: ResultWidget(
                            isCorrect: isCorrect,
                            isTimeUp: isTimeUp,
                            resetQuestion: resetQuestion,
                            height: (orientation == Orientation.landscape)
                                ? 350
                                : 500,
                            width: 500),
                      ),
                  ]),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
