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
    Key? key,
    required this.player,
    required this.alignment,
    this.large = false,
  }) : super(key: key);

  @override
  State<PronunciationButton> createState() => PronunciationButtonState();
}

class PronunciationButtonState extends State<PronunciationButton> {
  void triggerPlay() {
    context
        .read<PlayerState>()
        .play(widget.player, context.read<SpeechRateState>());
  }

  @override
  Widget build(BuildContext context) {
    return widget.large
        ? SizedBox(
            height: Theme.of(context).textTheme.displaySmall!.fontSize! * 4,
            width: Theme.of(context).textTheme.displaySmall!.fontSize! * 4,
            child: ElevatedButton(
              onPressed: triggerPlay,
              child: Icon(
                  context.watch<PlayerState>().currentPlayer == widget.player
                      ? isMaterial(context)
                          ? Icons.stop_circle
                          : CupertinoIcons.stop_circle_fill
                      : PlatformIcons(context).volumeUp,
                  size: Theme.of(context).textTheme.displaySmall!.fontSize! *
                      1.5),
            ),
          )
        : IconButton(
            iconSize: Theme.of(context).textTheme.bodyMedium!.fontSize!,
            constraints: BoxConstraints(maxHeight: Theme.of(context).textTheme.bodyMedium!.fontSize!),
            visualDensity: VisualDensity.compact,
            tooltip: "Pronunciation",
            alignment: widget.alignment,
            icon:
                Icon(context.watch<PlayerState>().currentPlayer == widget.player
                    ? isMaterial(context)
                        ? Icons.stop_circle
                        : CupertinoIcons.stop_circle_fill
                    : PlatformIcons(context).volumeUp),
            color: Theme.of(context).colorScheme.secondary,
            padding: const EdgeInsets.only(left: 5),
            onPressed: triggerPlay);
  }
}
