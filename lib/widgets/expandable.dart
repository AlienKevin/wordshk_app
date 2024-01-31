import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

Widget expandButton(
        String text, IconData icon, TextStyle lineTextStyle, onPressed) =>
    SelectionContainer.disabled(
      child: TextButton(
          onPressed: onPressed,
          style: TextButton.styleFrom(
            padding: const EdgeInsets.all(0),
            minimumSize: const Size(0, 0),
          ),
          child: Text.rich(TextSpan(
            children: [
              TextSpan(text: text, style: lineTextStyle),
              WidgetSpan(child: Icon(icon, color: lineTextStyle.color!))
            ],
          ))),
    );

class MyExpandable extends StatefulWidget {
  final Widget child;
  final String collapseText;
  final String expandText;
  final TextStyle lineTextStyle;

  const MyExpandable(
      {super.key,
      required this.child,
      required this.collapseText,
      required this.expandText,
      required this.lineTextStyle});

  @override
  State<MyExpandable> createState() => _MyExpandableState();
}

class _MyExpandableState extends State<MyExpandable> {
  bool expanded = false;

  @override
  Widget build(BuildContext context) {
    return expanded
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              widget.child,
              expandButton(
                  widget.collapseText,
                  isMaterial(context)
                      ? Icons.expand_less
                      : CupertinoIcons.chevron_up,
                  widget.lineTextStyle, () {
                setState(() {
                  expanded = false;
                });
              }),
            ],
          )
        : expandButton(
            widget.expandText,
            isMaterial(context)
                ? Icons.expand_more
                : CupertinoIcons.chevron_down,
            widget.lineTextStyle, () {
            setState(() {
              expanded = true;
            });
          });
  }
}
