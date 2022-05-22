import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:wordshk/main.dart';

import '../constants.dart';
import '../models/search_mode.dart';

class SearchModeButton extends StatelessWidget {
  final SearchMode Function(SearchMode) getMode;
  final bool highlighted;
  final bool inAppBar;
  final void Function() onPressed;

  const SearchModeButton(
      {Key? key,
      required this.getMode,
      required this.highlighted,
      required this.inAppBar,
      required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
        width: 38,
        margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
        decoration: BoxDecoration(
          border: Border.all(
              color: highlighted && inAppBar
                  ? theme.iconTheme.color!
                  : theme.textTheme.bodyLarge!.color!,
              width: 2.5),
          shape: BoxShape.rectangle,
          color: highlighted ? blueColor : null,
        ),
        child: IconButton(
            padding: const EdgeInsets.all(0),
            visualDensity: VisualDensity.compact,
            icon: Consumer<SearchModeState>(
                builder: (context, searchModeState, child) => Text(
                    translateSearchModeIcon(getMode(searchModeState.mode),
                        AppLocalizations.of(context)!),
                    style: theme.textTheme.titleMedium!.copyWith(
                        color: highlighted ? theme.iconTheme.color : null))),
            color: theme.iconTheme.color,
            disabledColor: theme.disabledColor.withOpacity(0),
            onPressed: onPressed));
  }
}
