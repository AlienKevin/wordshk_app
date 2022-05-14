import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';

ExpandableTheme applyExpandableTheme(Widget child) => ExpandableTheme(
    data: const ExpandableThemeData(
        animationDuration: Duration(milliseconds: 200), useInkWell: false),
    child: child);

Widget expandButton(String text, IconData icon, TextStyle lineTextStyle) =>
    ExpandableButton(
        child: RichText(
            text: TextSpan(
      children: [
        TextSpan(text: text, style: lineTextStyle),
        WidgetSpan(child: Icon(icon, color: lineTextStyle.color!))
      ],
    )));
