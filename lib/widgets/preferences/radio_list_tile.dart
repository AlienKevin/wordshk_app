import 'package:flutter/material.dart';

class PreferencesRadioListTile<T> extends StatelessWidget {
  final String title;
  final T value;
  final T? groupValue;
  final void Function(T?) onChanged;
  const PreferencesRadioListTile(
      this.title, this.value, this.groupValue, this.onChanged,
      {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) => RadioListTile<T>(
        title: Text(title),
        value: value,
        groupValue: groupValue,
        onChanged: onChanged,
        visualDensity: VisualDensity.compact,
        contentPadding: EdgeInsets.zero,
        activeColor: Theme.of(context).colorScheme.secondary,
      );
}
