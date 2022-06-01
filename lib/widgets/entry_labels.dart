import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../constants.dart';
import '../models/entry.dart';

class EntryLabels extends StatelessWidget {
  final List<Label> labels;
  final TextStyle lineTextStyle;

  const EntryLabels(
      {Key? key, required this.labels, required this.lineTextStyle})
      : super(key: key);

  @override
  Widget build(BuildContext context) => Visibility(
        visible: labels.isNotEmpty,
        child: Builder(builder: (context) {
          return RichText(
              text: TextSpan(children: [
            WidgetSpan(
                child: RichText(
                    textScaleFactor: MediaQuery.of(context).textScaleFactor,
                    text: TextSpan(
                        text: "[" + AppLocalizations.of(context)!.label + "]",
                        style: lineTextStyle.copyWith(
                            fontWeight: FontWeight.bold)))),
            ...labels
                .map((label) => [
                      const WidgetSpan(child: SizedBox(width: 10)),
                      WidgetSpan(
                          child: Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Chip(
                            materialTapTargetSize:
                                MaterialTapTargetSize.shrinkWrap,
                            visualDensity: VisualDensity.compact,
                            shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            padding: EdgeInsets.zero,
                            labelPadding: const EdgeInsets.only(
                                left: 10, right: 10, bottom: 2),
                            labelStyle:
                                lineTextStyle.copyWith(color: whiteColor),
                            backgroundColor: greyColor,
                            label: Text(translateLabel(
                                label, AppLocalizations.of(context)!))),
                      ))
                    ])
                .expand((i) => i)
          ]));
        }),
      );
}
