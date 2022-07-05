import 'package:flutter/material.dart';

import '../models/input_mode.dart';
import '../utils.dart';

class InputModeState with ChangeNotifier {
  InputMode mode = InputMode.keyboard;
  FocusNode? searchFieldFocusNode;
  late void Function() onDone;

  void setSearchFieldFocusNode(FocusNode focusNode) {
    searchFieldFocusNode = focusNode;
  }

  void setOnDone(void Function() newOnDone) {
    onDone = newOnDone;
  }

  void updateInputMode(InputMode newMode) {
    if (newMode == InputMode.done) {
      onDone();
    }
    if ((mode == InputMode.keyboard && newMode == InputMode.ink) ||
        ((mode == InputMode.done || mode == InputMode.ink) &&
            newMode == InputMode.keyboard)) {
      switchKeyboardType(searchFieldFocusNode!);
    }
    mode = newMode;
    notifyListeners();
  }
}
