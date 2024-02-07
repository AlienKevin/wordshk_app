import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:wordshk/src/rust/api/api.dart' show Script;

import '../../models/entry.dart';

class EntrySimsOrAnts extends StatelessWidget {
  final String label;
  final List<Segment> simsOrAnts;
  final List<String> simsOrAntsSimp;
  final Script script;
  final OnTapLink? onTapLink;

  const EntrySimsOrAnts(
      {Key? key,
      required this.label,
      required this.simsOrAnts,
      required this.simsOrAntsSimp,
      required this.script,
      required this.onTapLink})
      : super(key: key);

  @override
  Widget build(BuildContext context) => Visibility(
      visible: simsOrAnts.isNotEmpty,
      child: Text.rich(TextSpan(children: [
        TextSpan(
            text:
                "$label ⁠", // Use Word Joiner to mark this segment as non-splittable during selection
            style: Theme.of(context)
                .textTheme
                .bodySmall!
                .copyWith(fontWeight: FontWeight.w600)),
        ...(script == Script.traditional
                ? simsOrAnts
                : simsOrAnts
                    .asMap()
                    .entries
                    .map((simOrAnt) => Segment(
                        simOrAnt.value.type, simsOrAntsSimp[simOrAnt.key]))
                    .toList())
            .asMap()
            .entries
            .map((sim) {
          final seg = sim.value;
          return TextSpan(children: [
            seg.type == SegmentType.link
                ? TextSpan(
                    text: seg.segment,
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: onTapLink == null
                            ? null
                            : Theme.of(context).colorScheme.secondary),
                    recognizer: TapGestureRecognizer()
                      ..onTap = onTapLink == null
                          ? null
                          : () => onTapLink!(seg.segment))
                : TextSpan(text: seg.segment),
            TextSpan(text: sim.key == simsOrAnts.length - 1 ? "" : " · ")
          ]);
        })
      ])));
}
