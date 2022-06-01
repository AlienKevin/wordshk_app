import 'package:flutter/material.dart';

class PronunciationButton<Player> extends StatefulWidget {
  final Future<void> Function(Player) play;
  final void Function(Player) stop;
  final Player player;
  final Alignment alignment;

  const PronunciationButton(
      {Key? key,
      required this.player,
      required this.play,
      required this.stop,
      required this.alignment})
      : super(key: key);

  @override
  State<PronunciationButton> createState() => _PronunciationButtonState();
}

class _PronunciationButtonState extends State<PronunciationButton> {
  bool isPlaying = false;

  @override
  Widget build(BuildContext context) {
    return IconButton(
        visualDensity: VisualDensity.compact,
        tooltip: "Pronunciation",
        alignment: widget.alignment,
        icon: Icon(isPlaying ? Icons.stop_circle : Icons.volume_up),
        color: Theme.of(context).colorScheme.secondary,
        padding: EdgeInsets.zero,
        onPressed: () {
          isPlaying
              ? widget.stop(widget.player)
              : widget.play(widget.player).then((_) {
                  if (mounted) {
                    setState(() {
                      isPlaying = false;
                    });
                  }
                });
          setState(() {
            isPlaying = !isPlaying;
          });
        });
  }
}
