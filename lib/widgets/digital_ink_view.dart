import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide Ink;
import 'package:flutter/services.dart';
import 'package:wordshk/widgets/digital_ink_view_foss.dart';
import 'package:wordshk/widgets/digital_ink_view_full.dart';

class DigitalInkView extends StatelessWidget {
  final void Function(String) typeCharacter;
  final void Function() backspace;
  final void Function() moveToEndOfSelection;

  const DigitalInkView({
    Key? key,
    required this.typeCharacter,
    required this.backspace,
    required this.moveToEndOfSelection,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (appFlavor == "foss") {
      return const DigitalInkViewFoss();
    } else {
      return DigitalInkViewFull(
          typeCharacter: typeCharacter,
          backspace: backspace,
          moveToEndOfSelection: moveToEndOfSelection);
    }
  }
}
