import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:wordshk/models/entry.dart';
import 'package:wordshk/states/entry_eg_jumpy_prs_state.dart';

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

    RubyLine exampleRubyLine(Script script) => RubyLine([
          RubySegment(
              RubySegmentType.word,
              RubySegmentWord(
                  EntryWord([
                    EntryText(
                        EntryTextStyle.normal,
                        switch (script) {
                          Script.traditional => "舉",
                          Script.simplified => "举",
                        })
                  ]),
                  const ["geoi2"],
                  const [2])),
          RubySegment(
              RubySegmentType.word,
              RubySegmentWord(
                  EntryWord([
                    EntryText(
                        EntryTextStyle.normal,
                        switch (script) {
                          Script.traditional => "個",
                          Script.simplified => "个",
                        })
                  ]),
                  const ["go3"],
                  const [3])),
          const RubySegment(
              RubySegmentType.word,
              RubySegmentWord(
                  EntryWord([EntryText(EntryTextStyle.normal, "例")]),
                  ["lai6"],
                  [6])),
          const RubySegment(
              RubySegmentType.word,
              RubySegmentWord(
                  EntryWord([EntryText(EntryTextStyle.normal, "子")]),
                  ["zi2"],
                  [2]))
        ]);

    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      SwitchListTile(
        value: isJumpy,
        onChanged: onIsJumpyChange,
        title: Text(s.entryEgJumpyPrs,
            style: Theme.of(context).textTheme.bodyMedium),
        controlAffinity: ListTileControlAffinity.leading,
        activeColor: Theme.of(context).colorScheme.onPrimary,
        activeTrackColor: Theme.of(context).colorScheme.secondary,
        trackOutlineColor:
            WidgetStateProperty.all(Theme.of(context).colorScheme.secondary),
        inactiveThumbColor: Theme.of(context).colorScheme.secondary,
        inactiveTrackColor: const Color.fromARGB(0, 0, 0, 0),
        visualDensity: VisualDensity.compact,
        contentPadding: const EdgeInsets.symmetric(horizontal: 0),
      ),
      Divider(height: Theme.of(context).textTheme.bodyLarge!.fontSize! * 2),
      Center(
        child: EntryRubyLine(
          lineSimp: exampleRubyLine(Script.simplified),
          lineTrad: exampleRubyLine(Script.traditional),
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
