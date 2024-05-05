import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart' hide Ink;

class DigitalInkViewFoss extends StatelessWidget {
  const DigitalInkViewFoss({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.only(left: 10.0, top: 10.0, right: 10.0),
          child: Row(children: [
            const SizedBox(width: 6),
            Icon(Icons.warning_amber_outlined,
                color: Theme.of(context).textTheme.bodySmall!.color),
            const SizedBox(width: 16),
            Expanded(
                child: Text(
                    AppLocalizations.of(context)!
                        .inkModelUnsupportedInTheFdroidVersion,
                    style: Theme.of(context).textTheme.bodySmall!))
          ]),
        ),
      ),
    );
  }
}
