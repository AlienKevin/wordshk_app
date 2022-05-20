import 'package:flutter/material.dart';

class CustomPageRoute extends MaterialPageRoute {
  CustomPageRoute({required Widget Function(BuildContext) builder})
      : super(builder: builder);

  @override
  Duration get transitionDuration => const Duration(milliseconds: 0);
}
