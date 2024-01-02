import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:provider/provider.dart';
import 'package:wordshk/states/speech_rate_state.dart';

import '../models/player.dart';
import '../states/player_state.dart';

class PronunciationButton extends StatefulWidget {
  final Player player;
  final Alignment alignment;
  final bool large;

  const PronunciationButton({
    super.key,
    required this.player,
    required this.alignment,
    this.large = false,
  });

  @override
  State<PronunciationButton> createState() => PronunciationButtonState();
}

class PronunciationButtonState extends State<PronunciationButton> {
  void triggerPlay() {
    context
        .read<PlayerState>()
        .play(widget.player, context.read<SpeechRateState>());
  }

  // TODO: Pass unique keys to each PronunciationButton
  // CAUTION: currently relying player to not be regenerated in a rebuild
  // to make the object (pointer) comparison work between currentPlayer and player.
  // We manually pass in the key for SyllablesPlayers in the ToneExercisePage
  // because the widget containing the player is rebuilt when the user advances
  // to the next exercise question.
  icon({double? size}) =>
      Consumer<PlayerState>(builder: (context, playerState, child) {
        return Icon(
          playerState.currentPlayer == widget.player
              ? isMaterial(context)
                  ? Icons.stop_circle
                  : CupertinoIcons.stop_circle_fill
              : PlatformIcons(context).volumeUp,
          size: size,
        );
      });

  @override
  Widget build(BuildContext context) {
    final displaySmallSize =
        Theme.of(context).textTheme.displaySmall!.fontSize!;
    return widget.large
        ? SizedBox(
            height: displaySmallSize * 4,
            width: displaySmallSize * 4,
            child: ElevatedButton(
                onPressed: triggerPlay,
                child: icon(size: displaySmallSize * 1.5),
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(displaySmallSize),
                ))),
          )
        : ConstrainedBox(
            constraints: BoxConstraints(
                maxHeight:
                    Theme.of(context).textTheme.bodyMedium!.fontSize! * 1.5),
            child: IconButton(
                iconSize:
                    Theme.of(context).textTheme.bodyMedium!.fontSize! * 1.5,
                visualDensity: VisualDensity.compact,
                tooltip: "Pronunciation",
                alignment: widget.alignment,
                icon: icon(),
                color: Theme.of(context).colorScheme.secondary,
                padding: const EdgeInsets.only(left: 5),
                onPressed: triggerPlay),
          );
  }
}
