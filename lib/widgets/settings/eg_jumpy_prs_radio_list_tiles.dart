import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:wordshk/models/entry.dart';
import 'package:wordshk/states/entry_eg_jumpy_prs_state.dart';
import 'package:wordshk/states/language_state.dart';

import '../../src/rust/api/api.dart';
import '../entry/entry_ruby_line.dart';

class EgIsJumpyPrsRadioListTiles extends StatelessWidget {
  const EgIsJumpyPrsRadioListTiles({super.key});

  @override
  Widget build(BuildContext context) {
    final s = AppLocalizations.of(context)!;
    final isJumpy = context.watch<EntryEgJumpyPrsState>().isJumpy;

    onIsJumpyChange(bool? newIsJumpy) {
      if (newIsJumpy != null) {
        context.read<EntryEgJumpyPrsState>().updateIsJumpy(newIsJumpy);
      }
    }

    final isTraditional =
        context.watch<LanguageState>().getScript() == Script.traditional;

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      SwitchListTile(
        value: isJumpy,
        onChanged: onIsJumpyChange,
        title: Text(s.entryEgJumpyPrs,
            style: Theme.of(context).textTheme.bodyMedium),
        controlAffinity: ListTileControlAffinity.leading,
        activeColor: Theme.of(context).colorScheme.onPrimary,
        activeTrackColor: Theme.of(context).colorScheme.secondary,
        inactiveTrackColor:
            Theme.of(context).colorScheme.secondary.withAlpha(150),
        visualDensity: VisualDensity.compact,
        contentPadding: const EdgeInsets.symmetric(horizontal: 0),
      ),
      Divider(height: Theme.of(context).textTheme.bodyLarge!.fontSize! * 2),
      Center(
        child: EntryRubyLine(
          line: RubyLine.fromJson(jsonDecode(
              '[{"L":[[[["N","${isTraditional ? '舉' : '举'}"]],["geoi2"]] ,[[["N","${isTraditional ? '個' : '个'}"]],["go3"]], [[["N","例"]],["lai6"]], [[["N","子"]],["zi2"]]]}]')),
          textColor: Theme.of(context).textTheme.bodyLarge!.color!,
          linkColor: Theme.of(context).textTheme.bodyLarge!.color!,
          rubyFontSize: Theme.of(context).textTheme.bodyLarge!.fontSize! * 2,
          onTapLink: null,
          showPrsButton: false,
        ),
      ),
    ]);
  }
}
