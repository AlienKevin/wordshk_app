import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' hide Ink;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:google_mlkit_digital_ink_recognition/google_mlkit_digital_ink_recognition.dart';
import 'package:provider/provider.dart';
import 'package:wordshk/constants.dart';
import 'package:wordshk/states/input_mode_state.dart';

import '../models/input_mode.dart';

class DigitalInkView extends StatefulWidget {
  final void Function(String) typeCharacter;
  final void Function() backspace;
  final void Function() moveToEndOfSelection;

  const DigitalInkView({
    Key? key,
    required this.typeCharacter,
    required this.backspace,
    required this.moveToEndOfSelection,
  }) : super(key: key);

  @override
  DigitalInkViewState createState() => DigitalInkViewState();
}

enum DownloadEndStatus {
  success,
  failure,
}

class DigitalInkViewState extends State<DigitalInkView> {
  final DigitalInkRecognizerModelManager _modelManager =
      DigitalInkRecognizerModelManager();
  final String _language = 'zh-Hani-HK';
  late final DigitalInkRecognizer _digitalInkRecognizer =
      DigitalInkRecognizer(languageCode: _language);
  final Ink _ink = Ink();
  List<StrokePoint> _points = [];
  final List<String> _recognizedCharacters = [];

  @override
  void dispose() {
    _digitalInkRecognizer.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final showFailedToDownloadModel = Card(
      child: Padding(
        padding: const EdgeInsets.only(left: 10.0, top: 10.0, right: 10.0),
        child: Column(children: [
          Row(children: [
            const SizedBox(width: 6),
            Icon(Icons.warning_amber_outlined,
                color: Theme.of(context).textTheme.bodySmall!.color),
            const SizedBox(width: 16),
            Expanded(
                child: Text(
                    AppLocalizations.of(context)!.inkModelFailedToDownload,
                    style: Theme.of(context).textTheme.bodySmall!))
          ]),
          Container(
            alignment: AlignmentDirectional.centerEnd,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: OverflowBar(
              overflowAlignment: OverflowBarAlignment.end,
              spacing: 8,
              children: [
                TextButton(
                  onPressed: () {
                    // rebuild FutureBuilder<DownloadEndStatus>
                    setState(() {});
                  },
                  child: Text(AppLocalizations.of(context)!.tryAgain,
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          color: Theme.of(context).colorScheme.secondary)),
                ),
                TextButton(
                  onPressed: () {
                    context
                        .read<InputModeState>()
                        .updateInputMode(InputMode.done);
                  },
                  child: Text(AppLocalizations.of(context)!.dismiss,
                      style: Theme.of(context).textTheme.bodySmall!.copyWith(
                          color: Theme.of(context).colorScheme.secondary)),
                )
              ],
            ),
          )
        ]),
      ),
    );

    final showDownloadingModel = Center(
        child: Padding(
      padding:
          const EdgeInsets.symmetric(vertical: appBarHeight, horizontal: 20),
      child: Column(children: [
        const CircularProgressIndicator(),
        const SizedBox(height: 20),
        SizedBox(
            width: 250,
            child: Text(AppLocalizations.of(context)!.inkModelDownloading))
      ]),
    ));

    final candidatesFont = Theme.of(context).textTheme.headlineMedium!.copyWith(
        color: MediaQuery.of(context).platformBrightness == Brightness.light
            ? blackColor
            : whiteColor);

    final showSketchPad = SizedBox(
      height: 250,
      child: Stack(children: [
        Positioned.fill(
          child: GestureDetector(
            onPanStart: (DragStartDetails details) {
              _ink.strokes.add(Stroke());
            },
            onPanUpdate: (DragUpdateDetails details) {
              setState(() {
                final localPosition = details.localPosition;
                _points = List.from(_points)
                  ..add(StrokePoint(
                    x: localPosition.dx,
                    y: localPosition.dy,
                    t: DateTime.now().millisecondsSinceEpoch,
                  ));
                if (_ink.strokes.isNotEmpty) {
                  _ink.strokes.last.points = _points.toList();
                }
              });
            },
            onPanEnd: (DragEndDetails details) {
              _points.clear();
              _recognizeCharacter();
              setState(() {});
            },
            child: CustomPaint(
              painter: Signature(
                  ink: _ink,
                  brightness: MediaQuery.of(context).platformBrightness),
              size: Size.infinite,
            ),
          ),
        ),
        Positioned(
          top: 0,
          right: 0,
          child: IconButton(
              onPressed: () {
                _clearPad();
                widget.backspace();
              },
              icon: Icon(isMaterial(context)
                  ? Icons.backspace
                  : CupertinoIcons.delete_left_fill),
              color: Theme.of(context).colorScheme.secondary),
        ),
        ...(_recognizedCharacters.isNotEmpty
            ? [
                Positioned(
                  top: 0,
                  child: Center(
                      child: SizedBox(
                    height: candidatesFont.fontSize!,
                    child: Wrap(
                        children: _recognizedCharacters
                            .map((character) => Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 5),
                                  child: OutlinedButton(
                                    onPressed: () {
                                      widget.typeCharacter(character);
                                      _clearPad();
                                      widget.moveToEndOfSelection();
                                    },
                                    style: OutlinedButton.styleFrom(
                                      minimumSize: Size(
                                          candidatesFont.fontSize!,
                                          candidatesFont.fontSize!),
                                      padding: EdgeInsets.zero,
                                      side: BorderSide.none,
                                    ),
                                    child:
                                        Text(character, style: candidatesFont),
                                  ),
                                ))
                            .toList()),
                  )),
                )
              ]
            : []),
      ]),
    );

    return FutureBuilder<DownloadEndStatus>(
        future: _modelManager.isModelDownloaded(_language).then((isDownloaded) {
          if (!isDownloaded) {
            return _modelManager.downloadModel(_language).then((isDownloaded) =>
                isDownloaded
                    ? DownloadEndStatus.success
                    : DownloadEndStatus.failure);
          } else {
            return DownloadEndStatus.success;
          }
        }),
        builder:
            (BuildContext context, AsyncSnapshot<DownloadEndStatus> snapshot) =>
                (snapshot.hasData
                    ? (snapshot.data! == DownloadEndStatus.success
                        ? showSketchPad
                        : showFailedToDownloadModel)
                    : showDownloadingModel));
  }

  void _clearPad() {
    setState(() {
      _ink.strokes.clear();
      _points.clear();
      _recognizedCharacters.clear();
    });
  }

  void _undoStroke() {
    if (_ink.strokes.isNotEmpty) {
      setState(() {
        _ink.strokes.removeLast();
      });
      if (_ink.strokes.isNotEmpty) {
        _recognizeCharacter();
      }
    }
  }

  Future<void> _recognizeCharacter() async {
    try {
      final rawCandidates = await _digitalInkRecognizer.recognize(_ink);
      final candidates = rawCandidates
          .where((candidate) => candidate.text.length == 1)
          .take(6)
          .map((candidate) => candidate.text)
          .toList();
      _recognizedCharacters.clear();
      _recognizedCharacters.addAll(candidates);
      if (candidates.isNotEmpty) {
        widget.typeCharacter(candidates[0]);
      }
      setState(() {});
    } catch (e) {
      // do nothing

      // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      //   content: Text(e.toString()),
      // ));
    }
  }
}

class Signature extends CustomPainter {
  Ink ink;
  Brightness brightness;

  Signature({required this.ink, required this.brightness});

  @override
  void paint(Canvas canvas, Size size) {
    // Draw background
    final Gradient backgroundGradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        brightness == Brightness.light ? whiteColor : blackColor,
        brightness == Brightness.light ? lightGreyColor : darkGreyColor
      ],
    );
    final Shader backgroundShader = backgroundGradient
        .createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    final Paint backgroundPaint = Paint()..shader = backgroundShader;
    canvas.drawRect(
        Rect.fromLTWH(0, 0, size.width, size.height), backgroundPaint);

    final strokeColor =
        brightness == Brightness.light ? blackColor : lightGreyColor;

    final Gradient gradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        brightness == Brightness.light ? lightGreyColor : darkGreyColor,
        strokeColor
      ], // Define your gradient colors here
    );

    // Draw strokes
    final Shader shader =
        gradient.createShader(Rect.fromLTWH(0, 0, size.width, size.height / 3));

    final Paint paint = Paint()
      ..color = strokeColor
      ..shader = shader
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 4.0;

    for (final stroke in ink.strokes) {
      for (int i = 0; i < stroke.points.length - 1; i++) {
        final p1 = stroke.points[i];
        final p2 = stroke.points[i + 1];
        canvas.drawLine(Offset(p1.x.toDouble(), p1.y.toDouble()),
            Offset(p2.x.toDouble(), p2.y.toDouble()), paint);
      }
    }
  }

  @override
  bool shouldRepaint(Signature oldDelegate) => true;
}
