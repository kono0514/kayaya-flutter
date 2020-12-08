import 'package:flutter/material.dart';

class PlayerUIController extends ChangeNotifier {
  PlayerUIController();

  bool _hideControls;

  bool get hideControls => _hideControls;

  void hide() {
    _hideControls = true;
    notifyListeners();
  }

  void show() {
    _hideControls = false;
    notifyListeners();
  }
}
