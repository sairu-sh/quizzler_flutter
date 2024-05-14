import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerScreen extends StatefulWidget {
  VoidCallback pauseVideo;
  VoidCallback setisAnswered;
  int pauseOn;
  bool questionAppeared;
  bool isAnswered;
  final VideoPlayerController vController;

  VideoPlayerScreen(
      {super.key,
      required this.pauseVideo,
      required this.setisAnswered,
      required this.pauseOn,
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

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _checkVideoPosition() {
    if (_controller.value.position >= Duration(seconds: widget.pauseOn) &&
        !widget.isAnswered &&
        widget.pauseOn != -1) {
      _controller.pause();
      widget.pauseVideo();
      widget.setisAnswered();
    }
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
