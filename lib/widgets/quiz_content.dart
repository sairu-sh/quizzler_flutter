import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../widgets/button_widget.dart';
import '../widgets/timer_widget.dart';
import '../widgets/answer_widget.dart';
import '../widgets/question_widget.dart';
import '../controllers/quiz_brain.dart';

class QuizContent extends StatefulWidget {
  final Orientation orientation;
  final QuizBrain controller;
  final VideoPlayerController vController;
  final bool isAnswered;
  final bool isTimeUp;
  final bool isOver;
  final bool showAnimation;
  final bool isPressed;
  final bool isCorrect;
  final bool questionAppeared;
  final Function(bool) setIsAnswered;
  final Function(bool) setIsTimeUp;
  final Function(bool) setIsOver;
  final Function(bool) setShowAnimation;
  final Function(bool) setIsPressed;
  final Function(bool) setIsCorrect;
  final Function(bool) setQuestionAppeared;
  final Function(int) setPauseOn;

  const QuizContent({
    super.key,
    required this.orientation,
    required this.controller,
    required this.vController,
    required this.isTimeUp,
    required this.isAnswered,
    required this.isOver,
    required this.showAnimation,
    required this.isPressed,
    required this.isCorrect,
    required this.setIsAnswered,
    required this.setIsTimeUp,
    required this.setIsOver,
    required this.setShowAnimation,
    required this.setIsPressed,
    required this.setIsCorrect,
    required this.questionAppeared,
    required this.setQuestionAppeared,
    required this.setPauseOn,
  });

  @override
  State<QuizContent> createState() => _QuizContentState();
}

class _QuizContentState extends State<QuizContent> {
  int selectedIndex = -1;
  int? pausedOn;
  bool autoPlay = true;

  void setSelectedIndex(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  void restartQuiz() {
    setState(() {
      widget.vController.seekTo(const Duration(seconds: 0));
      widget.vController.play();
    });
  }

  // @override
  // void dispose() {
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          if (widget.orientation == Orientation.portrait)
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.25,
            ),
          Container(
            color: Colors.grey[300],
            constraints: widget.orientation == Orientation.landscape
                ? BoxConstraints(
                    minHeight: MediaQuery.of(context).size.height,
                  )
                : const BoxConstraints(),
            child: Column(
              children: [
                widget.controller.isLoading
                    ? const CircularProgressIndicator()
                    : Padding(
                        padding: EdgeInsets.only(
                            top: widget.orientation == Orientation.landscape
                                ? 20.0
                                : 5.0),
                        child: QuestionWidget(
                          questionText: widget.controller.currentQuestion,
                          questionImage: widget.controller.currentQuestionImage,
                          textColor: Colors.black,
                        ),
                      ),
                const SizedBox(height: 10.0),
                if (widget.orientation == Orientation.landscape)
                  SizedBox(
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: const ClampingScrollPhysics(),
                      itemCount: (widget.controller
                                  .currentAnswersOrImages['list'].length /
                              2)
                          .ceil(),
                      itemBuilder: (context, index) {
                        final startIndex = index * 2;
                        final endIndex = startIndex + 2;

                        final sublist = widget
                            .controller.currentAnswersOrImages['list']
                            .sublist(
                          startIndex,
                          endIndex >
                                  widget.controller
                                      .currentAnswersOrImages['list'].length
                              ? widget.controller.currentAnswersOrImages.length
                              : endIndex,
                        );

                        if (sublist.length == 1) {
                          sublist.add('');
                        }

                        return Padding(
                          padding: const EdgeInsets.only(top: 10.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              for (var answer in sublist)
                                Expanded(
                                  child: AnswerButton(
                                    isAnswerImages: widget
                                            .controller.currentAnswersOrImages[
                                        'isAnswerImages'],
                                    currentIndex:
                                        widget.controller.currentIndex,
                                    answerText: answer.toString(),
                                    isTimeUp: widget.isTimeUp,
                                    onPressed: () {
                                      setState(() {
                                        selectedIndex = widget.controller
                                            .currentAnswersOrImages['list']
                                            .indexOf(answer);
                                      });
                                    },
                                    color: selectedIndex ==
                                            widget.controller
                                                .currentAnswersOrImages['list']
                                                .indexOf(answer)
                                        ? 'active'
                                        : 'inactive',
                                    isAnswered: widget.isAnswered,
                                    index: widget.controller
                                        .currentAnswersOrImages['list']
                                        .indexOf(answer),
                                    selectedIndex: selectedIndex,
                                    correctIndex:
                                        widget.controller.correctAnswerIndex,
                                    // setIsPressed: widget.setIsPressed,
                                    questionAppeared: widget.questionAppeared,
                                  ),
                                ),
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
                    children: (widget.controller.currentAnswersOrImages['list']
                            as List<String>)
                        .map((answer) {
                      return AnswerButton(
                        isAnswerImages: widget.controller
                            .currentAnswersOrImages['isAnswerImages'] as bool,
                        currentIndex: widget.controller.currentIndex,
                        answerText: answer.toString(),
                        isTimeUp: widget.isTimeUp,
                        onPressed: () {
                          setState(() {
                            selectedIndex = (widget.controller
                                        .currentAnswersOrImages['list']
                                    as List<String>)
                                .indexOf(answer);
                          });
                        },
                        color: selectedIndex ==
                                widget.controller.currentAnswersOrImages['list']
                                    .indexOf(answer)
                            ? 'active'
                            : 'inactive',
                        isAnswered: widget.isAnswered,
                        index: (widget.controller.currentAnswersOrImages['list']
                                as List<String>)
                            .indexOf(answer),
                        selectedIndex: selectedIndex,
                        correctIndex: widget.controller.correctAnswerIndex,
                        // setIsPressed: widget.setIsPressed,
                        questionAppeared: widget.questionAppeared,
                      );
                    }).toList(),
                  ),
                SizedBox(
                    height: widget.orientation == Orientation.landscape
                        ? 40.0
                        : 20.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                          questionAppeared: widget.questionAppeared,
                          setSelectedIndex: setSelectedIndex,
                          correctIndex: widget.controller.correctAnswerIndex,
                          setIsTimeUp: widget.setIsTimeUp,
                          setShowAnimation: widget.setShowAnimation,
                          setIsAnswered: widget.setIsAnswered,
                          currentQuestionIndex: widget.controller.currentIndex,
                          time: 10,
                          isTimeUp: widget.isTimeUp,
                          isAnswered: widget.isAnswered),
                    ),
                    Button(
                      onPressed: selectedIndex == -1
                          ? null
                          : () {
                              if (widget.isAnswered) {
                                widget.controller.nextQuestion();
                                widget.setIsAnswered(false);
                                widget.setShowAnimation(false);
                                widget.setQuestionAppeared(false);
                                setState(() {
                                  pausedOn = widget.controller.pauseOn;
                                  selectedIndex = -1;
                                });
                                if (widget.controller.currentIndex != -1) {
                                  widget.setPauseOn(pausedOn!);
                                  widget.vController.play();
                                } else {
                                  widget.setIsOver(true);
                                }
                              } else if (widget.isTimeUp) {
                                widget.controller.nextQuestion();
                                setState(() {
                                  selectedIndex = -1;
                                  pausedOn = widget.controller.pauseOn;
                                });
                                widget.vController.play();
                              } else {
                                widget.setIsCorrect(widget.controller
                                    .checkAnswer(selectedIndex));

                                widget.setIsAnswered(true);
                                widget.setShowAnimation(true);
                              }

                              widget.setIsPressed(true);
                            },
                      text: widget.isTimeUp || widget.isAnswered
                          ? 'Continue'
                          : 'Check',
                      isPressed: widget.isPressed,
                      buttonColor: selectedIndex == -1
                          ? Colors.grey[300]!
                          : widget.isTimeUp
                              ? Colors.red
                              : widget.isAnswered
                                  ? widget.isCorrect
                                      ? Colors.green
                                      : Colors.red
                                  : Colors.lightBlueAccent,
                      textColor:
                          selectedIndex == -1 ? Colors.black : Colors.white,
                    ),
                  ],
                ),
                const SizedBox(height: 20)
              ],
            ),
          ),
        ],
      ),
    );
  }
}
