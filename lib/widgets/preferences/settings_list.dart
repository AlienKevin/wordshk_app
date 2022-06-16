import 'package:flutter/material.dart';
import 'package:settings_ui/settings_ui.dart';

class MySettingsList extends StatelessWidget {
  final List<AbstractSettingsSection> sections;

  const MySettingsList({Key? key, required this.sections}) : super(key: key);

  @override
  Widget build(BuildContext context) => SettingsList(
      lightTheme: SettingsThemeData(
        titleTextColor: Theme.of(context).colorScheme.secondary,
      ),
      darkTheme: SettingsThemeData(
        titleTextColor: Theme.of(context).colorScheme.secondary,
      ),
      sections: sections);
}
