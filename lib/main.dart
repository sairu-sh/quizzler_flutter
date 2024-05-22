import 'package:flutter/material.dart';
import 'package:my_animation/controllers/video_list.dart';
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
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<QuizBrain>(create: (_) => QuizBrain()),
        ChangeNotifierProvider<VideoList>(create: (_) => VideoList()),
      ],
      child: MaterialApp(
        title: 'Quizzler',
        initialRoute: '/',
        routes: {
          '/': (context) => const App(),
          '/first': (context) {
            final args = ModalRoute.of(context)!.settings.arguments
                as Map<String, dynamic>;
            return Quizzler(index: args['index']);
          },
        },
        theme: ThemeData(
          primarySwatch: Colors.red,
        ),
      ),
    );
  }
}
