import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:provider/provider.dart';

import '../states/player_state.dart';

class PronunciationButton extends StatefulWidget {
  final void Function(int) play;
  final Alignment alignment;
  final bool large;

  const PronunciationButton({
    Key? key,
    required this.play,
    required this.alignment,
    this.large = false,
  }) : super(key: key);

  @override
  State<PronunciationButton> createState() => _PronunciationButtonState();
}

class _PronunciationButtonState extends State<PronunciationButton> {
  int? playerKey;

  @override
  Widget build(BuildContext context) {
    return widget.large
        ? SizedBox(
            height: Theme.of(context).textTheme.displaySmall!.fontSize! * 4,
            width: Theme.of(context).textTheme.displaySmall!.fontSize! * 4,
            child: ElevatedButton(
              child: Icon(
                  playerKey != null &&
                          context.watch<PlayerState>().playerKey == playerKey
                      ? isMaterial(context)
                          ? Icons.stop_circle
                          : CupertinoIcons.stop_circle_fill
                      : PlatformIcons(context).volumeUp,
                  size: Theme.of(context).textTheme.displaySmall!.fontSize! *
                      1.5),
              onPressed: () {
                if (playerKey == null) {
                  setState(() {
                    playerKey = context.read<PlayerState>().getPlayerKey();
                  });
                }
                widget.play(playerKey!);
              },
            ),
          )
        : IconButton(
            visualDensity: VisualDensity.compact,
            tooltip: "Pronunciation",
            alignment: widget.alignment,
            icon: Icon(playerKey != null &&
                    context.watch<PlayerState>().playerKey == playerKey
                ? isMaterial(context)
                    ? Icons.stop_circle
                    : CupertinoIcons.stop_circle_fill
                : PlatformIcons(context).volumeUp),
            color: Theme.of(context).colorScheme.secondary,
            padding: EdgeInsets.zero,
            onPressed: () {
              if (playerKey == null) {
                setState(() {
                  playerKey = context.read<PlayerState>().getPlayerKey();
                });
              }
              widget.play(playerKey!);
            },
          );
  }
}
