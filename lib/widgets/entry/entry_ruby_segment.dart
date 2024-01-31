import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wordshk/states/entry_eg_jumpy_prs_state.dart';

import '../../models/entry.dart';
import '../../states/romanization_state.dart';
import 'entry_word.dart';

List<Widget> showRubySegment(RubySegment segment, Color textColor,
    Color linkColor, double rubySize, OnTapLink onTapLink, BuildContext context,
    {isLinked = false}) {
  final textColor_ = isLinked ? linkColor : textColor;
  late final Widget text;
  late final String prs;
  late final List<int?> prsTones;
  switch (segment.type) {
    case RubySegmentType.punc:
      text = Text.rich(TextSpan(
          text: segment.segment as String,
          style: TextStyle(fontSize: rubySize, height: 1, color: textColor_)));
      prs = "";
      prsTones = [6]; // empty pr defaults to 6 tones (this is arbitrary)
      break;
    case RubySegmentType.word:
      text = Text.rich(TextSpan(
          children: showWord(segment.segment.word as EntryWord),
          style: TextStyle(fontSize: rubySize, height: 1, color: textColor_)));
      prs = context.read<RomanizationState>().showPrs(segment.segment.prs);
      prsTones = segment.segment.prsTones;
      break;
    case RubySegmentType.linkedWord:
      return (segment.segment.words as List<RubySegmentWord>)
          .map((word) => showRubySegment(
                RubySegment(RubySegmentType.word, word),
                textColor,
                linkColor,
                rubySize,
                onTapLink,
                context,
                isLinked: true,
              ))
          .expand((i) => i)
          .map((seg) => GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () => onTapLink(segment.segment.toString()),
              child: seg))
          .toList();
  }
  final isJumpy = context.watch<EntryEgJumpyPrsState>().isJumpy;
  return [
    isJumpy
        ? Stack(
            children: [
              Positioned.fill(
                  bottom: rubySize * 2,
                  child: Container(
                    color: Theme.of(context).dividerColor.withOpacity(0.5),
                  )),
              Positioned.fill(
                  top: rubySize,
                  bottom: MediaQuery.of(context).textScaler.scale(rubySize) + 5,
                  child: Container(
                    color: Theme.of(context).dividerColor,
                  )),
              Column(children: [
                SelectionContainer.disabled(
                    child: SizedBox(
                  height: rubySize * 2,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children:
                          IterableZip([prs.split(" "), prsTones]).map((pair) {
                        final pr = pair[0] as String;
                        final tone = (pair[1] as int?) ?? 1;
                        final double yPos = ((tone == 1)
                            ? -0.125
                            : tone == 2
                                ? 0.1
                                : tone == 3
                                    ? 0.375
                                    : tone == 5
                                        ? 0.75
                                        : tone == 4
                                            ? 0.9
                                            : 0.875);
                        final double angle =
                            (tone == 1 || tone == 3 || tone == 6)
                                ? 0
                                : tone == 2
                                    ? -pi / 6.0
                                    : (tone == 5 ? -pi / 7.0 : pi / 7.0);
                        return Align(
                            alignment: FractionalOffset(0.5, yPos),
                            child: Transform(
                                alignment: Alignment.center,
                                transform: Matrix4.rotationZ(
                                    angle), // Convert degrees to radians
                                child: Text.rich(TextSpan(
                                    text: pr,
                                    style: TextStyle(
                                        fontSize: rubySize * 0.5,
                                        color: textColor)))));
                      }).toList()),
                )),
                const SizedBox(height: 5),
                text
              ])
            ],
          )
        : Column(children: [
            SelectionContainer.disabled(
                child: Text.rich(TextSpan(
                    text: prs,
                    style: TextStyle(
                        fontSize: rubySize * 0.5, color: textColor)))),
            text
          ])
  ];
}
