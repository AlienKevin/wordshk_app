import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:just_audio/just_audio.dart';
import 'package:wordshk/widgets/pronunciation_button.dart';

import '../constants.dart';

class SyllablePronunciationButton extends StatelessWidget {
  final List<String> prs;
  final Alignment alignment;

  const SyllablePronunciationButton(
      {Key? key, required this.prs, required this.alignment})
      : super(key: key);

  @override
  Widget build(BuildContext context) => Visibility(
        visible: jyutpingFemaleSyllableNames.containsAll(prs),
        child: Builder(builder: (context) {
          return PronunciationButton(
            player: AudioPlayer(),
            play: (player) async {
              final completer = Completer<void>();
              await (player as AudioPlayer).setAudioSource(
                  ConcatenatingAudioSource(
                      children: prs
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
            alignment: alignment,
          );
        }),
      );
}
