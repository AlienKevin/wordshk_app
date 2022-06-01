import 'dart:async';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:wordshk/widgets/pronunciation_button.dart';

import '../../constants.dart';
import '../../models/entry.dart';

class EntryVariant extends StatelessWidget {
  final Variant variant;
  final TextStyle variantTextStyle;
  final TextStyle prTextStyle;

  const EntryVariant({
    Key? key,
    required this.variant,
    required this.variantTextStyle,
    required this.prTextStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final prs = variant.prs.split(", ");
    return Row(children: [
      SelectableText.rich(
        TextSpan(text: variant.word),
        style: variantTextStyle,
      ),
      const SizedBox(width: 10),
      ...prs.takeWhile((pr) => !pr.contains("!")).expand((pr) => [
            SelectableText.rich(
              TextSpan(text: pr),
              style: prTextStyle,
              // selectionWidthStyle: BoxWidthStyle.max,
            ),
            Visibility(
              visible: jyutpingFemaleSyllableNames.containsAll(pr.split(" ")),
              child: Builder(builder: (context) {
                return PronunciationButton(
                  player: AudioPlayer(),
                  play: (player) async {
                    final completer = Completer<void>();
                    await (player as AudioPlayer).setAudioSource(
                        ConcatenatingAudioSource(
                            children: pr
                                .split(" ")
                                .map((syllable) => AudioSource.uri(Uri.parse(
                                    "asset:///assets/jyutping_female/$syllable.mp3")))
                                .toList()));
                    player.playerStateStream.listen((state) {
                      if (state.processingState == ProcessingState.completed) {
                        completer.complete();
                      }
                    });
                    await player.seek(Duration.zero, index: 0);
                    await player.play();
                    return completer.future;
                  },
                  stop: (player) async {
                    await (player as AudioPlayer).stop();
                  },
                  alignment: Alignment.center,
                );
              }),
            )
          ])
    ]);
  }
}
