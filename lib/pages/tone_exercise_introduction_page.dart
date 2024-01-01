import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:provider/provider.dart';
import 'package:wordshk/states/exercise_introduction_state.dart';
import 'package:wordshk/widgets/constrained_content.dart';
import 'package:wordshk/widgets/preferences/title.dart';

import '../widgets/syllable_pronunciation_button.dart';

class ToneExerciseIntroductionPage extends StatelessWidget {
  final bool openedInExercise;

  const ToneExerciseIntroductionPage({Key? key, required this.openedInExercise})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final s = AppLocalizations.of(context)!;

    const pageDecoration = PageDecoration(
      titlePadding: EdgeInsets.only(top: 0.0, bottom: 0.0),
      contentMargin: EdgeInsets.all(32.0),
    );
    return IntroductionScreen(
        safeAreaList: const [false, false, true, true],
        onDone: () {
          // Go back to previous tone exercise if there is any
          Navigator.pop(context);
          if (!openedInExercise) {
            context.go("/exercise/tone");
            context
                .read<ExerciseIntroductionState>()
                .setToneExerciseIntroduced();
          }
        },
        showSkipButton: false,
        skipOrBackFlex: 0,
        nextFlex: 0,
        showBackButton: true,
        back: const Icon(Icons.arrow_back),
        next: const Icon(Icons.arrow_forward),
        done: Text(openedInExercise ? s.backToExercise : s.startExercise,
            style: const TextStyle(fontWeight: FontWeight.w600)),
        pages: [
          PageViewModel(
            titleWidget: ConstrainedContent(
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: PreferencesTitle(title: s.toneExercise)),
            ),
            bodyWidget: ConstrainedContent(
              child: SingleChildScrollView(
                child: Column(children: [
                  Text(s.toneExerciseIntroductionText1),
                  Stack(children: [
                    SizedBox(
                      height: 300,
                      width: 270,
                      child: CustomPaint(
                        size: const Size(270, 330),
                        painter: ToneContourPainter(
                            strokeColor:
                                Theme.of(context).textTheme.bodyMedium!.color!),
                      ),
                    ),
                    const Positioned(
                      right: 105,
                      top: 37,
                      child: Column(
                        children: [
                          SyllablePronunciationButton(
                            prs: [
                              ["si1"],
                            ],
                            alignment: Alignment.bottomCenter,
                            atHeader: true,
                            large: false,
                          ),
                        ],
                      ),
                    ),
                    const Positioned(
                      right: 146,
                      top: 98,
                      child: Column(
                        children: [
                          SyllablePronunciationButton(
                            prs: [
                              ["si2"],
                            ],
                            alignment: Alignment.bottomCenter,
                            atHeader: true,
                            large: false,
                          ),
                        ],
                      ),
                    ),
                    const Positioned(
                      right: 106,
                      top: 157,
                      child: Column(
                        children: [
                          SyllablePronunciationButton(
                            prs: [
                              ["si3"],
                            ],
                            alignment: Alignment.bottomCenter,
                            atHeader: true,
                            large: false,
                          ),
                        ],
                      ),
                    ),
                    const Positioned(
                      right: 146,
                      top: 188,
                      child: Column(
                        children: [
                          SyllablePronunciationButton(
                            prs: [
                              ["si5"],
                            ],
                            alignment: Alignment.bottomCenter,
                            atHeader: true,
                            large: false,
                          ),
                        ],
                      ),
                    ),
                    const Positioned(
                      right: 106,
                      top: 218,
                      child: Column(
                        children: [
                          SyllablePronunciationButton(
                            prs: [
                              ["si6"],
                            ],
                            alignment: Alignment.bottomCenter,
                            atHeader: true,
                            large: false,
                          ),
                        ],
                      ),
                    ),
                    const Positioned(
                      right: 106,
                      top: 248,
                      child: Column(
                        children: [
                          SyllablePronunciationButton(
                            prs: [
                              ["si4"],
                            ],
                            alignment: Alignment.bottomCenter,
                            atHeader: true,
                            large: false,
                          ),
                        ],
                      ),
                    ),
                  ])
                ]),
              ),
            ),
            decoration: pageDecoration,
          ),
          PageViewModel(
            titleWidget: ConstrainedContent(
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: PreferencesTitle(title: s.toneExercise)),
            ),
            bodyWidget: ConstrainedContent(
              child: SingleChildScrollView(
                child: Column(children: [
                  Text(s.toneExerciseIntroductionText2),
                  Stack(children: [
                    SizedBox(
                      width: 270,
                      height: 300,
                      child: CustomPaint(
                        size: const Size(270, 300),
                        painter: Tone4ContourPainter(
                            strokeColor:
                                Theme.of(context).textTheme.bodyMedium!.color!),
                      ),
                    ),
                    const Positioned(
                      right: 106,
                      top: 38,
                      child: Column(
                        children: [
                          SyllablePronunciationButton(
                            prs: [
                              ["si1"],
                            ],
                            alignment: Alignment.bottomCenter,
                            atHeader: true,
                            large: false,
                          ),
                        ],
                      ),
                    ),
                    const Positioned(
                      right: 180,
                      top: 98,
                      child: Column(
                        children: [
                          SyllablePronunciationButton(
                            prs: [
                              ["si2"],
                            ],
                            alignment: Alignment.bottomCenter,
                            atHeader: true,
                            large: false,
                          ),
                        ],
                      ),
                    ),
                    const Positioned(
                      right: 106,
                      top: 158,
                      child: Column(
                        children: [
                          SyllablePronunciationButton(
                            prs: [
                              ["si3"],
                            ],
                            alignment: Alignment.bottomCenter,
                            atHeader: true,
                            large: false,
                          ),
                        ],
                      ),
                    ),
                    const Positioned(
                      right: 136,
                      top: 98,
                      child: Column(
                        children: [
                          SyllablePronunciationButton(
                            prs: [
                              ["si5"],
                            ],
                            alignment: Alignment.bottomCenter,
                            atHeader: true,
                            large: false,
                          ),
                        ],
                      ),
                    ),
                    const Positioned(
                      right: 82,
                      top: 218,
                      child: Column(
                        children: [
                          SyllablePronunciationButton(
                            prs: [
                              ["si6"],
                            ],
                            alignment: Alignment.bottomCenter,
                            atHeader: true,
                            large: false,
                          ),
                        ],
                      ),
                    ),
                    const Positioned(
                      right: 130,
                      top: 218,
                      child: Column(
                        children: [
                          SyllablePronunciationButton(
                            prs: [
                              ["si4"],
                            ],
                            alignment: Alignment.bottomCenter,
                            atHeader: true,
                            large: false,
                          ),
                        ],
                      ),
                    ),
                  ])
                ]),
              ),
            ),
            decoration: pageDecoration,
          ),
        ]);
  }
}

class ToneContourPainter extends CustomPainter {
  final Color strokeColor;

  ToneContourPainter({required this.strokeColor});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = strokeColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0;

    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
    );

    final double width = size.width;
    final double height = size.height;
    final double unit = height / 5;

    // Define the tone contours
    final Map<int, List<Offset>> toneContours = {
      1: [Offset(0, unit), Offset(width, unit)],
      2: [Offset(0, 3 * unit), Offset(width, unit)],
      3: [Offset(0, 3 * unit), Offset(width, 3 * unit)],
      4: [Offset(0, 4 * unit), Offset(width, 5 * unit)],
      5: [Offset(0, 4 * unit), Offset(width, 3 * unit)],
      6: [Offset(0, 4 * unit), Offset(width, 4 * unit)],
    };

    // Draw the tone contours and labels
    for (int tone in toneContours.keys) {
      final List<Offset> points = toneContours[tone]!;
      for (int i = 0; i < points.length - 1; i++) {
        canvas.drawLine(
          points[i],
          points[i + 1],
          paint,
        );

        // Draw the tone number
        final middlePoint = Offset(
          (points[i].dx + points[i + 1].dx) / 2,
          (points[i].dy + points[i + 1].dy) / 2 -
              12, // Adjusted y-coordinate to place the number above the line
        );
        textPainter.text = TextSpan(
          text: tone.toString(),
          style: TextStyle(color: strokeColor, fontSize: 20),
        );
        textPainter.layout();
        textPainter.paint(
          canvas,
          middlePoint - Offset(textPainter.width / 2, textPainter.height / 2),
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class Tone4ContourPainter extends CustomPainter {
  final Color strokeColor;

  Tone4ContourPainter({required this.strokeColor});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = strokeColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0;

    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
    );

    final double width = size.width;
    final double height = size.height;
    final double unit = height / 5;

    // Define the tone contours
    final Map<int, List<Offset>> toneContours = {
      1: [Offset(0, unit), Offset(width, unit)],
      2: [Offset(0, 3 * unit), Offset(width, unit)],
      3: [Offset(0, 3 * unit), Offset(width, 3 * unit)],
      6: [Offset(0, 4 * unit), Offset(width, 4 * unit)],
    };

    // Draw the tone contours and labels
    for (int tone in toneContours.keys) {
      final List<Offset> points = toneContours[tone]!;
      for (int i = 0; i < points.length - 1; i++) {
        canvas.drawLine(
          points[i],
          points[i + 1],
          paint,
        );

        // Draw the tone number
        final middlePoint = Offset(
          (points[i].dx + points[i + 1].dx) / 2,
          (points[i].dy + points[i + 1].dy) / 2 -
              12, // Adjusted y-coordinate to place the number above the line
        );
        textPainter.text = TextSpan(
          text: tone == 2
              ? "2      5                  "
              : tone == 6
                  ? "4      6"
                  : tone.toString(),
          style: TextStyle(color: strokeColor, fontSize: 20),
        );
        textPainter.layout();
        textPainter.paint(
          canvas,
          middlePoint - Offset(textPainter.width / 2, textPainter.height / 2),
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
