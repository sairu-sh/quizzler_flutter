import 'package:flutter/material.dart';
import 'package:my_animation/controllers/video_list.dart';
import 'package:my_animation/widgets/slidein_options.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final videoList = Provider.of<VideoList>(context);
    return Scaffold(
        appBar: AppBar(title: const Text("Welcome to the Quizzler")),
        body: ListView.builder(
            itemCount: videoList.titles.length,
            itemBuilder: (context, index) {
              return Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                child: SlideInButton(
                  text: videoList.titles[index],
                  index: index,
                  color: Colors.teal[400],
                  onPressed: () => Navigator.pushNamed(
                    context,
                    '/first',
                    arguments: {'index': index},
                  ),
                ),
              );
            }));
  }
}
