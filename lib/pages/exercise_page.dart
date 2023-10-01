import "dart:math";

import 'package:draw_on_path/draw_on_path.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:sentry/sentry.dart';
import 'package:wordshk/constants.dart';

import '../states/romanization_state.dart';
import '../widgets/pronunciation_button.dart';
import '../widgets/syllable_pronunciation_button.dart';

class ExercisePage extends StatefulWidget {
  const ExercisePage({super.key});

  @override
  ExercisePageState createState() => ExercisePageState();
}

enum Tone4 {
  highLevel,
  rising,
  lowLevel,
  falling,
}

enum Tone6 {
  t1,
  t2,
  t3,
  t4,
  t5,
  t6,
}

Tone6? tone6FromString(String s) {
  return switch (s) {
    "1" => Tone6.t1,
    "2" => Tone6.t2,
    "3" => Tone6.t3,
    "4" => Tone6.t4,
    "5" => Tone6.t5,
    "6" => Tone6.t6,
    _ => null,
  };
}

bool tone4MatchesTone6(Tone4 tone4, Tone6 tone6) {
  return switch ((tone4, tone6)) {
    (Tone4.highLevel, Tone6.t1) ||
    (Tone4.rising, Tone6.t2 || Tone6.t5) ||
    (Tone4.lowLevel, Tone6.t3 || Tone6.t6) ||
    (Tone4.falling, Tone6.t4) =>
      true,
    _ => false,
  };
}

sealed class ExerciseState {
  final int expectedSyllableIndex;
  Tone4 selectedTone = Tone4.lowLevel;

  ExerciseState(
      {required this.expectedSyllableIndex, required this.selectedTone});
}

class ThinkingState implements ExerciseState {
  @override
  final int expectedSyllableIndex;
  @override
  Tone4 selectedTone;
  ThinkingState(
      {required this.expectedSyllableIndex, required this.selectedTone});
}

class CheckedState implements ExerciseState {
  @override
  final int expectedSyllableIndex;
  @override
  Tone4 selectedTone;
  final bool isCorrect;
  CheckedState(
      {required this.expectedSyllableIndex,
      required this.selectedTone,
      required this.isCorrect});
}

class ExercisePageState extends State<ExercisePage> {
  List<String> syllables = jyutpingFemaleSyllableNames.toList();
  ExerciseState state = ThinkingState(
      selectedTone: Tone4.lowLevel,
      expectedSyllableIndex:
          Random().nextInt(jyutpingFemaleSyllableNames.length));
  final GlobalKey<PronunciationButtonState> pronunciationButtonKey =
      GlobalKey<PronunciationButtonState>();
  // item 2 is the default selected tone: low level tone
  final ScrollController _scrollController = FixedExtentScrollController(initialItem: 2);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      pronunciationButtonKey.currentState?.triggerPlay();
    });
  }

  Tone6? getExpectedTone6() {
    final syllable = syllables[state.expectedSyllableIndex];
    final toneNumber = syllable[syllable.length - 1];
    return tone6FromString(toneNumber);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.toneExercise),
      ),
      body: Center(
        child: Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          alignment: WrapAlignment.center,
          runSpacing: Theme.of(context).textTheme.displayMedium!.fontSize! / 2,
          children: [
            SyllablePronunciationButton(
              buttonKey: pronunciationButtonKey,
              prs: [
                [syllables[state.expectedSyllableIndex]],
              ],
              alignment: Alignment.bottomCenter,
              atHeader: true,
              large: true,
            ),
            SizedBox(
              height: 100,
              child: ListWheelScrollView(
                itemExtent: 100,
                clipBehavior: Clip.antiAlias,
                physics: const PageScrollPhysics(),
                controller: _scrollController,
                onSelectedItemChanged: (index) async {
                  print(index);
                  final tone = switch (index) {
                    0 => Tone4.highLevel,
                    1 => Tone4.rising,
                    2 => Tone4.lowLevel,
                    3 => Tone4.falling,
                    _ => await (() async {
                      await Sentry.captureMessage("Tone exercise selected tone index $index outside the range from 0 to 3");
                      return state.selectedTone;
                    })(),
                  };
                  print(tone);
                  setState(() {
                    state.selectedTone = tone;
                  });
                },
                children: [
                  toneButton(Tone4.highLevel),
                  toneButton(Tone4.rising),
                  toneButton(Tone4.lowLevel),
                  toneButton(Tone4.falling),
                ],
              ),
            ),
            SizedBox(
                height: Theme.of(context).textTheme.displayMedium!.fontSize! / 2,
                child: Center(
                    child: Text(switch (state) {
                  CheckedState(isCorrect: true) => AppLocalizations.of(context)!
                      .correctTone(context
                          .read<RomanizationState>()
                          .showPrs([syllables[state.expectedSyllableIndex]])),
                  CheckedState(isCorrect: false) =>
                    AppLocalizations.of(context)!.shouldBeTone(context
                        .read<RomanizationState>()
                        .showPrs([syllables[state.expectedSyllableIndex]])),
                  _ => ""
                }))),
            ElevatedButton(
              onPressed: switch (state) {
                ThinkingState(selectedTone: final selectedTone) =>
                  () async {
                    final tone6 = getExpectedTone6();
                    if (tone6 == null) {
                      // This shouldn't happen
                      await Sentry.captureMessage(
                          "Tone exercise generated a syllable without ending tone number: ${syllables[state.expectedSyllableIndex]}");
                      // Set to correct because we don't have a ground truth tone number anyways
                      setState(() {
                        state = CheckedState(
                            expectedSyllableIndex: state.expectedSyllableIndex,
                            selectedTone: state.selectedTone,
                            isCorrect: true);
                      });
                    } else {
                      final isCorrect = tone4MatchesTone6(selectedTone, tone6);
                      setState(() {
                        state = CheckedState(
                            expectedSyllableIndex: state.expectedSyllableIndex,
                            selectedTone: state.selectedTone,
                            isCorrect: isCorrect);
                      });
                    }
                  },
                CheckedState() => () {
                    setState(() {
                      state = ThinkingState(
                          expectedSyllableIndex: Random()
                              .nextInt(jyutpingFemaleSyllableNames.length),
                          selectedTone: Tone4.lowLevel);
                    });

                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      pronunciationButtonKey.currentState?.triggerPlay();
                      // item 2 is the default selected tone: low level tone
                      _scrollController.jumpTo(2 * 100.0);
                    });
                  },
              },
              style: ElevatedButton.styleFrom(elevation: 10),
              child: switch (state) {
                ThinkingState() => Text(AppLocalizations.of(context)!.check),
                CheckedState() => Text(AppLocalizations.of(context)!.next),
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget toneButton(Tone4 tone) {
    final syllable = syllables[state.expectedSyllableIndex];
    final syllableWithoutTone = syllable.substring(0, syllable.length - 1);
    return Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey, width: 5),
          borderRadius: BorderRadius.circular(12),
          color: Theme.of(context)
              .elevatedButtonTheme
              .style
              ?.backgroundColor
              ?.resolve({}),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(7),
          child: CustomPaint(
            painter: ToneLinePainter(
                tone: tone, syllable: syllableWithoutTone, strokeWidth: 12),
            size: const Size.square(50.0),
          ),
        ));
  }
}

class ToneLinePainter extends CustomPainter {
  final Tone4 tone;
  final String syllable;
  final double strokeWidth;

  ToneLinePainter(
      {required this.tone,
      required this.strokeWidth,
      required this.syllable});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = strokeWidth;

    final startPoint = Offset(
        -strokeWidth,
        switch (tone) {
          Tone4.highLevel => strokeWidth / 2,
          Tone4.rising => 0.5 * size.height,
          Tone4.lowLevel => 0.5 * size.height,
          Tone4.falling => 0.5 * size.height,
        });
    final endPoint = Offset(
        size.width,
        switch (tone) {
          Tone4.highLevel => strokeWidth / 2,
          Tone4.rising => 0.2,
          Tone4.lowLevel => 0.5 * size.height,
          Tone4.falling => 1.0 * size.height,
        });

    var path = Path();
    path.moveTo(startPoint.dx, startPoint.dy);
    path.lineTo(endPoint.dx, endPoint.dy);
    canvas.drawTextOnPath(
        (tone == Tone4.falling || tone == Tone4.rising) ? "  $syllable" : "   $syllable", path,
        textAlignment: tone == Tone4.falling ? TextAlignment.bottom : TextAlignment.up,
        textStyle: TextStyle(fontSize: 22, height: tone == Tone4.falling ? 2.5 : 1.4, letterSpacing: -1));
    canvas.drawLine(startPoint, endPoint, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
