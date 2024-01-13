import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';

class MySettingsSwitchTile extends SettingsTile {
  final bool initialValue;
  final dynamic Function(bool)? onToggle;
  final String label;

  MySettingsSwitchTile(
      {Key? key,
      required this.label,
      required this.initialValue,
      this.onToggle})
      : super(key: key, title: Text(label));

  @override
  Widget build(BuildContext context) => SettingsTile.switchTile(
        initialValue: initialValue,
        onToggle: onToggle,
        title: Text(label),
        activeSwitchColor: Theme.of(context).colorScheme.secondary,
      );
}
