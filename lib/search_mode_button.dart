import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'constants.dart';
import 'main.dart';

class SearchModeButton extends StatelessWidget {
  const SearchModeButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Container(
      width: 38,
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      decoration: BoxDecoration(
        border: Border.all(color: whiteColor, width: 2),
        shape: BoxShape.rectangle,
      ),
      child: IconButton(
          padding: const EdgeInsets.all(0),
          visualDensity: VisualDensity.compact,
          icon: Consumer<SearchModeState>(
            builder: (context, searchModeState, child) =>
                Text(searchModeToString(searchModeState.mode)),
          ),
          color: Theme.of(context).iconTheme.color,
          disabledColor: Theme.of(context).disabledColor.withOpacity(0),
          onPressed: context.read<SearchModeState>().toggleSearchModeSelector));
}
