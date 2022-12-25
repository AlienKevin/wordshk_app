import 'package:flutter/material.dart';

class PreferencesRadioListTile<T> extends StatelessWidget {
  final String title;
  final String? subtitle;
  final T value;
  final T? groupValue;
  final void Function(T?) onChanged;
  const PreferencesRadioListTile(
      {required this.title,
      this.subtitle,
      required this.value,
      this.groupValue,
      required this.onChanged,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) => RadioListTile<T>(
        title: Text(title),
        subtitle: subtitle == null
            ? null
            : Text(subtitle!, style: Theme.of(context).textTheme.bodySmall),
        value: value,
        groupValue: groupValue,
        onChanged: onChanged,
        visualDensity: VisualDensity.compact,
        contentPadding: EdgeInsets.zero,
        activeColor: Theme.of(context).colorScheme.secondary,
      );
}
