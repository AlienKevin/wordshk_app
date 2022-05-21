import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:wordshk/widgets/scalable_text_span.dart';

ExpandableTheme applyExpandableTheme(Widget child) => ExpandableTheme(
    data: const ExpandableThemeData(
        animationDuration: Duration(milliseconds: 200), useInkWell: false),
    child: child);

Widget expandButton(String text, IconData icon, TextStyle lineTextStyle) =>
    ExpandableButton(child: Builder(builder: (context) {
      return RichText(
          textScaleFactor: MediaQuery.of(context).textScaleFactor,
          text: ScalableTextSpan(
            context,
            children: [
              TextSpan(text: text, style: lineTextStyle),
              WidgetSpan(child: Icon(icon, color: lineTextStyle.color!))
            ],
          ));
    }));
