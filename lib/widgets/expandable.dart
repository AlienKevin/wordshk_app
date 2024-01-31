import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

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

class _MyExpandableState extends State<MyExpandable>
    with SingleTickerProviderStateMixin {
  bool expanded = false;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300), // Adjust the duration as needed
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void toggleExpand() {
    setState(() {
      expanded = !expanded;
      if (expanded) {
        _controller.forward(); // Expand animation
      } else {
        _controller.reverse(); // Collapse animation
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SelectionContainer.disabled(
          child: GestureDetector(
            onTap: toggleExpand,
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(text: expanded ? widget.collapseText : widget.expandText, style: widget.lineTextStyle),
                  WidgetSpan(
                    child: RotationTransition(
                      turns: Tween<double>(begin: 0, end: 0.5).animate(_controller), // Rotate icon
                      child: Icon(
                        isMaterial(context) ? Icons.expand_more : CupertinoIcons.chevron_down,
                        color: widget.lineTextStyle.color!,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        expanded ? widget.child : const SizedBox.shrink(),
      ],
    );
  }
}
