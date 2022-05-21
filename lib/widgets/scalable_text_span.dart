import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class ScalableTextSpan extends TextSpan {
  const ScalableTextSpan._internal({
    String? text,
    List<InlineSpan>? children,
    TextStyle? style,
    GestureRecognizer? recognizer,
    String? semanticsLabel,
  }) : super(
          style: style,
          text: text,
          children: children,
          recognizer: recognizer,
          semanticsLabel: semanticsLabel,
        );

  factory ScalableTextSpan(
    BuildContext context, {
    String? text,
    List<InlineSpan>? children,
    TextStyle? style,
    GestureRecognizer? recognizer,
    String? semanticsLabel,
  }) {
    double fontSize;
    style = DefaultTextStyle.of(context).style.merge(style);
    //The default fontSize is 14.0
    fontSize = style.fontSize!;
    return ScalableTextSpan._internal(
      style: style.copyWith(
          fontSize: fontSize * MediaQuery.of(context).textScaleFactor),
      text: text,
      children: children,
      recognizer: recognizer,
      semanticsLabel: semanticsLabel,
    );
  }
}
