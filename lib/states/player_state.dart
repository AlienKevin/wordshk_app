import 'dart:async';
import 'dart:io';

import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:just_audio/just_audio.dart';
import 'package:wordshk/states/speech_rate_state.dart';

import '../models/player.dart';
import '../models/speech_rate.dart';

class PlayerState with ChangeNotifier {
  final FlutterTts ttsPlayer = FlutterTts();
  late AudioPlayer syllablesPlayer = AudioPlayer();
  Player? currentPlayer;
  bool playerStoppedDueToSwitch = false;

  PlayerState() {
    (() async {
      await ttsPlayer.setSharedInstance(true);
      await ttsPlayer.setLanguage("zh-HK");
      await ttsPlayer.setSpeechRate(0.5);
      await ttsPlayer.setVolume(Platform.isIOS ? 0.3 : 1.0);
      await ttsPlayer.setPitch(1.0);
      await ttsPlayer.isLanguageAvailable("zh-HK");
    })();
  }

  Future<bool> play(Player newPlayer, SpeechRateState speechRateState) async {
    if (currentPlayer != null) {
      await stopHelper();
      if (currentPlayer == newPlayer) {
        currentPlayer = null;
        notifyListeners();
        playerStoppedDueToSwitch = false;
        return true; // break
      } else {
        playerStoppedDueToSwitch = true;
      }
    }
    currentPlayer = newPlayer;
    notifyListeners();
    switch (newPlayer) {
      case TtsPlayer():
        await ttsPlay(newPlayer, speechRateState);
        break;
      case SyllablesPlayer():
        await syllablesPlay(newPlayer, speechRateState);
        break;
    }
    return false;
  }

  refreshPlayerState() async {
    await stop();
    currentPlayer = null;
    playerStoppedDueToSwitch = false;
    notifyListeners();
  }

  Future<void> syllablesPlay(SyllablesPlayer player, SpeechRateState speechRateState) async {
    await syllablesPlayer.setAudioSource(ConcatenatingAudioSource(
        children: player.prs
            .mapIndexed((index, syllables) => [
                  ...syllables.map((syllable) => AudioSource.uri(Uri.parse(
                      "asset:///assets/jyutping_female/$syllable.mp3"))),
                  ...(index == player.prs.length - 1
                      ? <AudioSource>[]
                      : [
                          AudioSource.uri(Uri.parse(
                              "asset:///assets/silence_800ms.mp3"))
                        ])
                ])
            .expand((syllable) => syllable)
            .toList()));
    syllablesPlayer.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        if (!playerStoppedDueToSwitch) {
          currentPlayer = null;
          notifyListeners();
        } else {
          playerStoppedDueToSwitch = false;
        }
      }
    });
    final rate = player.atHeader
        ? speechRateState.entryHeaderRate
        : speechRateState.entryEgRate;
    final speed = rate == SpeechRate.verySlow
        ? 0.8
        : rate == SpeechRate.slow
            ? 1.2
            : 1.5;
    final volume = Platform.isIOS ? 0.1 : 1.0;
    await syllablesPlayer.setSpeed(speed);
    await syllablesPlayer.setVolume(volume);
    await syllablesPlayer.seek(Duration.zero, index: 0);
    await syllablesPlayer.play();
  }

  Future<void> ttsPlay(TtsPlayer player, SpeechRateState speechRateState) async {
    final rate = player.atHeader
        ? speechRateState.entryHeaderRate
        : speechRateState.entryEgRate;

    final speed = rate == SpeechRate.verySlow
        ? 0.15
        : rate == SpeechRate.slow
            ? 0.3
            : 0.5;
    await ttsPlayer.setSpeechRate(speed);
    await ttsPlayer.speak(player.text);
    ttsPlayer.setCompletionHandler(() {
      if (!playerStoppedDueToSwitch) {
        currentPlayer = null;
        notifyListeners();
      } else {
        playerStoppedDueToSwitch = false;
      }
    });
  }

  stop() async {
    if (currentPlayer != null) {
      await stopHelper();
      currentPlayer = null;
    }
  }

  stopHelper() async {
    switch (currentPlayer!) {
      case TtsPlayer():
        await ttsPlayer.stop();
        break;
      case SyllablesPlayer():
        await syllablesPlayer.stop();
        break;
    }
  }
}
