import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Welcome to the Quizzler")),
        body: Center(
            child: ElevatedButton(
          child: const Text("Start Quizz"),
          onPressed: () => Navigator.pushNamed(context, '/first'),
        )));
  }
}
