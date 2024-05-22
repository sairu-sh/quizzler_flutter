import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class VideoList with ChangeNotifier {
  List<String> titles = [];
  bool isLoading = false;

  VideoList() {
    loadTitles();
  }

  Future<void> loadTitles() async {
    isLoading = true;
    notifyListeners();
    try {
      final String response =
          await rootBundle.loadString('assets/questions.json');
      final List data = await json.decode(response) as List;
      titles = data.map((item) => item['title'].toString()).toList();

      isLoading = false;
    } catch (e) {
      print('error $e occured');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  List<String> get getTitles => titles;
}
