import 'package:flutter/material.dart';

import '../../models/entry.dart';

List<TextSpan> showWord(EntryWord word) => word.texts.map(showText).toList();

TextSpan showText(EntryText text) => TextSpan(
    text: '${text.text}⁠', // Use Word Joiner to mark this segment as non-splittable during selection
    style: TextStyle(
        fontWeight: text.style == EntryTextStyle.normal
            ? FontWeight.normal
            : FontWeight.w600));
