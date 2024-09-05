import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:wordshk/states/text_size_state.dart';
import 'package:wordshk/widgets/constrained_content.dart';

class TextSizeSettingsPage extends StatelessWidget {
  const TextSizeSettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final s = AppLocalizations.of(context)!;
    final textSizeState = context.watch<TextSizeState>();
    final size = textSizeState.getTextSize();
    const min_text_size = 50;
    const max_text_size = 300;

    return Scaffold(
      appBar: AppBar(title: Text(s.textSize)),
      body: ConstrainedContent(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  RotatedBox(
                    quarterTurns: 3,
                    child: SizedBox(
                      width: 400, // Doubled the height to make it 2x taller
                      child: SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          trackHeight: 16.0,
                          inactiveTrackColor:
                              Theme.of(context).colorScheme.onSurface,
                          thumbShape: const RoundSliderThumbShape(
                              enabledThumbRadius: 20.0),
                        ),
                        child: Slider(
                          min: min_text_size.toDouble(),
                          max: max_text_size.toDouble(),
                          divisions: (max_text_size - min_text_size) ~/ 10,
                          value: size.toDouble(),
                          onChanged: (value) {
                            textSizeState.updateTextSize(value.round());
                          },
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Text('${s.textSize}\n$size%',
                      style: Theme.of(context).textTheme.titleMedium),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
