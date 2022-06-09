import 'package:flutter/material.dart';

import '../models/input_mode.dart';
import '../utils.dart';

class InputModeState with ChangeNotifier {
  InputMode mode = InputMode.keyboard;
  FocusNode? searchFieldFocusNode;

  void setSearchFieldFocusNode(FocusNode focusNode) {
    searchFieldFocusNode = focusNode;
  }

  void updateInputMode(InputMode newMode) {
    if ((mode == InputMode.keyboard && newMode == InputMode.ink) ||
        ((mode == InputMode.done || mode == InputMode.ink) &&
            newMode == InputMode.keyboard)) {
      switchKeyboardType(searchFieldFocusNode!);
    }
    mode = newMode;
    notifyListeners();
  }
}
