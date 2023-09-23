import "dart:math";

import 'package:chiclet/chiclet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:sentry/sentry.dart';
import 'package:wordshk/constants.dart';

import '../states/romanization_state.dart';
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
  Tone4? selectedTone;

  ExerciseState(
      {required this.expectedSyllableIndex, required this.selectedTone});
}

class ThinkingState implements ExerciseState {
  @override
  final int expectedSyllableIndex;
  @override
  Tone4? selectedTone;
  ThinkingState(
      {required this.expectedSyllableIndex, required this.selectedTone});
}

class CheckedState implements ExerciseState {
  @override
  final int expectedSyllableIndex;
  @override
  Tone4? selectedTone;
  final bool isCorrect;
  CheckedState(
      {required this.expectedSyllableIndex,
      required this.selectedTone,
      required this.isCorrect});
}

class ExercisePageState extends State<ExercisePage> {
  List<String> syllables = jyutpingFemaleSyllableNames.toList();
  ExerciseState state = ThinkingState(
      selectedTone: null,
      expectedSyllableIndex:
          Random().nextInt(jyutpingFemaleSyllableNames.length));

  @override
  void initState() {
    super.initState();
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SyllablePronunciationButton(
              prs: [
                [syllables[state.expectedSyllableIndex]],
              ],
              alignment: Alignment.bottomCenter,
              atHeader: true,
              large: true,
            ),
            SizedBox(
                height:
                    Theme.of(context).textTheme.displaySmall!.fontSize!),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                toneButton(Tone4.highLevel),
                SizedBox(
                    width: Theme.of(context).textTheme.displaySmall!.fontSize!),
                toneButton(Tone4.rising),
              ],
            ),
            SizedBox(
                height: Theme.of(context).textTheme.displaySmall!.fontSize!),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                toneButton(Tone4.lowLevel),
                SizedBox(
                    width: Theme.of(context).textTheme.displaySmall!.fontSize!),
                toneButton(Tone4.falling),
              ],
            ),
            SizedBox(
                height: Theme.of(context).textTheme.displaySmall!.fontSize!,
                child: Center(
                    child: Text(switch (state) {
                  CheckedState(isCorrect: true) =>
                    "✅ Correct: ${context.read<RomanizationState>().showPrs([
                          syllables[state.expectedSyllableIndex]
                        ])}",
                  CheckedState(isCorrect: false) =>
                    "❌ Should be: ${context.read<RomanizationState>().showPrs([
                          syllables[state.expectedSyllableIndex]
                        ])}",
                  _ => ""
                }))),
            ElevatedButton(
              onPressed: switch (state) {
                ThinkingState(selectedTone: final selectedTone)
                    when selectedTone != null =>
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
                ThinkingState() => null,
                CheckedState() => () {
                    setState(() {
                      state = ThinkingState(
                          expectedSyllableIndex: Random()
                              .nextInt(jyutpingFemaleSyllableNames.length),
                          selectedTone: null);
                    });
                  },
              },
              style: ElevatedButton.styleFrom(elevation: 10),
              child: switch (state) {
                ThinkingState() => Text("Check"),
                CheckedState() => Text("Next"),
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget toneButton(Tone4 tone) {
    return ChicletOutlinedButton(
      onPressed: switch (state) {
        ThinkingState() => () {
            setState(() {
              if (state.selectedTone == tone) {
                state.selectedTone = null;
              } else {
                state.selectedTone = tone;
              }
            });
          },
        _ => null,
      },
      isPressed: state.selectedTone == tone,
      width: 100,
      height: 100,
      buttonHeight: 8,
      borderColor: Theme.of(context)
          .elevatedButtonTheme
          .style
          ?.backgroundColor
          ?.resolve({})?.withAlpha(150),
      backgroundColor: Theme.of(context)
          .elevatedButtonTheme
          .style
          ?.backgroundColor
          ?.resolve({}),
      splashFactory: InkRipple.splashFactory,
      child: CustomPaint(
        painter: ToneLinePainter(
            tone: tone, strokeWidth: state.selectedTone == tone ? 12 : 4),
        size: const Size.square(50.0),
      ),
    );
  }
}

class ToneLinePainter extends CustomPainter {
  final Tone4 tone;
  final double strokeWidth;

  ToneLinePainter({required this.tone, required this.strokeWidth});

  @override
  void paint(Canvas canvas, Size size) {
    final boundaryPaint = Paint()
      ..color = Colors.grey
      ..strokeWidth = 2.0;

    canvas.drawLine(const Offset(0, 0), Offset(size.width, 0), boundaryPaint);
    canvas.drawLine(
        Offset(0, size.height), Offset(size.width, size.height), boundaryPaint);

    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = strokeWidth;

    final startPoint = Offset(
        0,
        switch (tone) {
          Tone4.highLevel => 0,
          Tone4.rising => 0.5 * size.height,
          Tone4.lowLevel => 0.5 * size.height,
          Tone4.falling => 0.5 * size.height,
        });
    final endPoint = Offset(
        size.width,
        switch (tone) {
          Tone4.highLevel => 0,
          Tone4.rising => 0,
          Tone4.lowLevel => 0.5 * size.height,
          Tone4.falling => 1.0 * size.height,
        });

    canvas.drawLine(startPoint, endPoint, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
