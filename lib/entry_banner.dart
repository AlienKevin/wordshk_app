import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:wordshk/quality_control_page.dart';

import 'constants.dart';
import 'custom_page_route.dart';

class EntryBanner extends StatefulWidget {
  final bool published;

  const EntryBanner({
    Key? key,
    required this.published,
  }) : super(key: key);

  @override
  State<EntryBanner> createState() => _EntryBannerState();
}

class _EntryBannerState extends State<EntryBanner> {
  bool closed = false;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: !widget.published && !closed,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.only(left: 10.0, top: 10.0, right: 10.0),
          child: Column(children: [
            Row(children: [
              const SizedBox(width: 6),
              Icon(Icons.warning_amber_outlined,
                  color: Theme.of(context).textTheme.bodySmall!.color),
              const SizedBox(width: 16),
              Expanded(
                  child: Text(AppLocalizations.of(context)!.unpublishedWarning,
                      style: Theme.of(context).textTheme.bodySmall!))
            ]),
            Container(
              alignment: AlignmentDirectional.centerEnd,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: OverflowBar(
                overflowAlignment: OverflowBarAlignment.end,
                spacing: 8,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        CustomPageRoute(
                            builder: (context) => const QualityControlPage(
                                useBackNavigation: true)),
                      );
                    },
                    child: Text(AppLocalizations.of(context)!.learnMore,
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            color: Theme.of(context).colorScheme.secondary)),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        closed = true;
                      });
                    },
                    child: Text(AppLocalizations.of(context)!.dismiss,
                        style: Theme.of(context).textTheme.bodySmall!.copyWith(
                            color: Theme.of(context).colorScheme.secondary)),
                  )
                ],
              ),
            )
          ]),
        ),
      ),
    );
  }
}
