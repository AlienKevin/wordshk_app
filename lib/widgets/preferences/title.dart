import 'package:flutter/material.dart';

class PreferencesTitle extends StatelessWidget {
  final String title;

  const PreferencesTitle({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) =>
      Text(title, style: Theme.of(context).textTheme.titleLarge);
}
