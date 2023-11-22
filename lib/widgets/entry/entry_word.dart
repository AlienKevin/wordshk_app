import 'dart:ui';

import 'package:flutter/material.dart';

import '../../models/entry.dart';

List<TextSpan> showWord(EntryWord word) => word.texts.map(showText).toList();

TextSpan showText(EntryText text) => TextSpan(
    text: text.text,
    style: TextStyle(fontVariations: [
      FontVariation('wght', text.style == EntryTextStyle.normal ? 400 : 600)
    ]));
