import 'package:flutter/material.dart';
import 'package:wordshk/constants.dart';

class ConstrainedContent extends StatelessWidget {
  final Widget child;
  const ConstrainedContent({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) => Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: wideScreenThreshold,
          ),
          child: child));
}
