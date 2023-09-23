import "dart:math";

import 'package:chiclet/chiclet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:wordshk/constants.dart';

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

class ExercisePageState extends State<ExercisePage> {
  final ValueNotifier<Tone4?> selectedTone = ValueNotifier(null);
  int syllableIndex = Random().nextInt(jyutpingFemaleSyllableNames.length);
  List<String> syllables = jyutpingFemaleSyllableNames.toList();
  bool? isCorrect;

  @override
  void initState() {
    super.initState();
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
                [syllables[syllableIndex]],
              ],
              alignment: Alignment.bottomCenter,
              atHeader: true,
              large: true,
            ),
            SizedBox(
                height:
                    Theme.of(context).textTheme.displaySmall!.fontSize! * 2),
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
                height:
                    Theme.of(context).textTheme.displaySmall!.fontSize! * 2),
            ElevatedButton(
              onPressed: (selectedTone.value == null)
                  ? null
                  : () {
                      setState(() {
                        isCorrect = syllables[syllableIndex]
                            .endsWith(selectedTone.value.toString());
                      });
                    },
              style: ElevatedButton.styleFrom(elevation: 10),
              child: Text("Check"),
            ),
          ],
        ),
      ),
    );
  }

  Widget toneButton(Tone4 tone) {
    return ValueListenableBuilder<Tone4?>(
      valueListenable: selectedTone,
      builder: (context, value, child) => ChicletOutlinedButton(
        onPressed: () {
          setState(() {
            if (value == tone) {
              selectedTone.value = null;
            } else {
              selectedTone.value = tone;
            }
          });
        },
        isPressed: selectedTone.value == tone,
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
              tone: tone,
              strokeWidth: selectedTone.value == tone ? 12 : 4),
          size: const Size.square(50.0),
        ),
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
