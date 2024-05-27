import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerScreen extends StatefulWidget {
  final Function(bool) setQuestionAppeared;
  final Function(bool) setisAnswered;
  final Function(bool) setIsTimeUp;
  final int Function() getPauseOn;
  final int currentIndex;
  final bool questionAppeared;
  final bool isAnswered;
  final VideoPlayerController vController;

  const VideoPlayerScreen(
      {super.key,
      required this.setQuestionAppeared,
      required this.setisAnswered,
      required this.setIsTimeUp,
      required this.getPauseOn,
      required this.currentIndex,
      required this.questionAppeared,
      required this.vController,
      required this.isAnswered});

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    super.initState();
    _controller = widget.vController;

    _initializeVideoPlayerFuture = _controller.initialize();

    _controller.play();

    _controller.addListener(_checkVideoPosition);
  }

  void _checkVideoPosition() {
    final pauseOn = widget.getPauseOn();
    if (_controller.value.position >= Duration(seconds: pauseOn) &&
        !widget.isAnswered &&
        pauseOn != -1) {
      _controller.pause();
      widget.setQuestionAppeared(true);
      widget.setisAnswered(false);
      widget.setIsTimeUp(false);
    }
  }

  Future<Duration?> get position async {
    // if (_isDisposed) {
    //   return null;
    // }
    return widget.vController.value.position;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (!widget.questionAppeared) {
          setState(() {
            if (_controller.value.isPlaying) {
              _controller.pause();
            } else {
              _controller.play();
            }
          });
        }
      },
      child: FutureBuilder(
        future: _initializeVideoPlayerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return VideoPlayer(_controller);
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
