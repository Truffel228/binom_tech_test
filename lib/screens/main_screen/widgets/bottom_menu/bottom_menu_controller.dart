import 'package:binom_tech_test/screens/main_screen/main_screen.dart';
import 'package:flutter/material.dart';

class BottomMenuController extends ChangeNotifier {
  bool isShowed = false;
  Person person = Person.empty();
  void show(Person value) {
    person = value;
    isShowed = true;
    notifyListeners();
  }

  void hide() {
    isShowed = false;
    notifyListeners();
  }
}