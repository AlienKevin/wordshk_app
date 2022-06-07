import 'package:flutter/material.dart';
import 'package:wordshk/utils.dart';

import '../models/input_mode.dart';

class InputModeState with ChangeNotifier {
  InputMode mode = InputMode.keyboard;
  late final FocusNode searchFieldFocusNode;

  void setSearchFieldFocusNode(FocusNode focusNode) {
    searchFieldFocusNode = focusNode;
  }

  void updateInputMode(InputMode newMode) {
    if (mode == InputMode.keyboard) {
      if (newMode == InputMode.ink) {
        switchKeyboardType(searchFieldFocusNode);
      }
    }
    mode = newMode;
    notifyListeners();
  }
}
