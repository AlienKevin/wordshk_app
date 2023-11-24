import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:wordshk/states/entry_eg_font_size_state.dart';
import 'package:wordshk/widgets/constrained_content.dart';

import '../../models/font_size.dart';
import '../../utils.dart';
import '../../widgets/preferences/radio_list_tile.dart';
import '../../widgets/preferences/title.dart';

class EntryEgFontSizePreferencesPage extends StatelessWidget {
  const EntryEgFontSizePreferencesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final s = AppLocalizations.of(context)!;
    final size = context.watch<EntryEgFontSizeState>().size;

    onSizeChange(FontSize? newSize) {
      if (newSize != null) {
        context.read<EntryEgFontSizeState>().updateSize(newSize);
      }
    }

    sizeRadioListTile(FontSize value) => PreferencesRadioListTile<FontSize>(
        title: getFontSizeName(value, s), value: value, groupValue: size, onChanged: onSizeChange);

    return Scaffold(
        appBar: AppBar(title: Text(s.annotatedExample)),
        body: ConstrainedContent(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              PreferencesTitle(title: s.entryEgFontSize),
              sizeRadioListTile(FontSize.small),
              sizeRadioListTile(FontSize.medium),
              sizeRadioListTile(FontSize.large),
              sizeRadioListTile(FontSize.veryLarge),
            ]),
          ),
        ));
  }
}
