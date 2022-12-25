import 'package:flutter/material.dart';

class TextScaleFactorClamper extends StatelessWidget {
  const TextScaleFactorClamper({super.key, required this.child, this.maxScaleFactor = 1.5});
  final Widget child;
  final double maxScaleFactor;

  @override
  Widget build(BuildContext context) {
    final mediaQueryData = MediaQuery.of(context);
    final num constrainedTextScaleFactor =
    mediaQueryData.textScaleFactor.clamp(1.0, maxScaleFactor);

    return MediaQuery(
      data: mediaQueryData.copyWith(
        textScaleFactor: constrainedTextScaleFactor as double?,
      ),
      child: child,
    );
  }
}