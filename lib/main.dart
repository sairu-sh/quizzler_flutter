import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app.dart';
import 'controllers/quiz_brain.dart';
import 'screens/quiz_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<QuizBrain>(
      create: (_) => QuizBrain(),
      child: MaterialApp(
        title: 'Quizzler',
        initialRoute: '/',
        routes: {
          '/': (context) => const App(),
          '/first': (context) => const Quizzler()
        },
        theme: ThemeData(
          primarySwatch: Colors.blueGrey,
        ),
      ),
    );
  }
}
