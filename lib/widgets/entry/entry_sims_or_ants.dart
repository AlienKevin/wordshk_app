import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:wordshk/widgets/scalable_text_span.dart';

import '../../bridge_generated.dart';
import '../../models/entry.dart';

class EntrySimsOrAnts extends StatelessWidget {
  final String label;
  final List<Segment> simsOrAnts;
  final List<String> simsOrAntsSimp;
  final Script script;
  final TextStyle lineTextStyle;
  final OnTapLink onTapLink;

  const EntrySimsOrAnts(
      {Key? key,
      required this.label,
      required this.simsOrAnts,
      required this.simsOrAntsSimp,
      required this.script,
      required this.lineTextStyle,
      required this.onTapLink})
      : super(key: key);

  @override
  Widget build(BuildContext context) => Visibility(
      visible: simsOrAnts.isNotEmpty,
      child: Builder(builder: (context) {
        return RichText(
            text: TextSpan(style: lineTextStyle, children: [
          WidgetSpan(
              child: RichText(
                  textScaleFactor: MediaQuery.of(context).textScaleFactor,
                  text: TextSpan(
                      text: label,
                      style: lineTextStyle.copyWith(
                          fontWeight: FontWeight.w600)))),
          const WidgetSpan(child: SizedBox(width: 10)),
          ...(script == Script.Traditional
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
                  ? ScalableTextSpan(context,
                      text: seg.segment,
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () => onTapLink(seg.segment))
                  : ScalableTextSpan(context, text: seg.segment),
              TextSpan(text: sim.key == simsOrAnts.length - 1 ? "" : " · ")
            ]);
          })
        ]));
      }));
}
