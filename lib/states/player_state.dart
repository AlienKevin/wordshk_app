import 'dart:async';
import 'dart:io';

import 'package:audio_session/audio_session.dart';
import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:just_audio/just_audio.dart';
import 'package:sentry/sentry_io.dart';
import 'package:wordshk/states/speech_rate_state.dart';

import '../models/player.dart';
import '../models/speech_rate.dart';

class PlayerState with ChangeNotifier {
  late final FlutterTts ttsPlayer;
  late final AudioPlayer syllablesPlayer;
  late final AudioSession session;
  Player? currentPlayer;
  bool playerStoppedDueToSwitch = false;

  PlayerState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      session = await AudioSession.instance;
      await session.configure(const AudioSessionConfiguration.speech());
      session.interruptionEventStream.listen((event) async {
        if (event.begin) {
          switch (event.type) {
            case AudioInterruptionType.duck:
            case AudioInterruptionType.pause:
            case AudioInterruptionType.unknown:
              // Another app started playing audio and we should pause.
              await stop();
              break;
          }
        } else {
          switch (event.type) {
            case AudioInterruptionType.duck:
            case AudioInterruptionType.pause:
            case AudioInterruptionType.unknown:
              // The interruption ended but we should not resume.
              // For now we don't resume and let the user manually replays.
              await stop();
              break;
          }
        }
      });

      syllablesPlayer = AudioPlayer();

      ttsPlayer = FlutterTts();
      await ttsPlayer.setSharedInstance(true);
      await ttsPlayer.setLanguage("zh-HK");
      await ttsPlayer.setSpeechRate(0.5);
      await ttsPlayer.setVolume(Platform.isIOS ? 0.3 : 1.0);
      await ttsPlayer.setPitch(1.0);
      await ttsPlayer.isLanguageAvailable("zh-HK");
      ttsPlayer.setCompletionHandler(() {
        if (!playerStoppedDueToSwitch) {
          currentPlayer = null;
          notifyListeners();
        } else {
          playerStoppedDueToSwitch = false;
        }
      });
    });
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

  Future<void> syllablesPlay(
      SyllablesPlayer player, SpeechRateState speechRateState) async {
    try {
      await syllablesPlayer.setAudioSource(ConcatenatingAudioSource(
          children: player.prs
              .mapIndexed((index, syllables) => [
                    ...syllables.map((syllable) => AudioSource.uri(Uri.parse(
                        "asset:///assets/jyutping_female/$syllable.mp3"))),
                    ...(index == player.prs.length - 1
                        ? <AudioSource>[]
                        : [
                            AudioSource.uri(
                                Uri.parse("asset:///assets/silence_800ms.mp3"))
                          ])
                  ])
              .expand((syllable) => syllable)
              .toList()));
    } on PlayerException catch (e) {
      if (kDebugMode) {
        print(
            "player_state[syllable audio load error]: error code=${e.code} message=${e.message}");
      }
      currentPlayer = null;
      notifyListeners();
      Sentry.captureMessage(
          "player_state[syllable audio load error]: error code=${e.code} message=${e.message}");
    } on PlayerInterruptedException catch (e) {
      // This call was interrupted since another audio source was loaded or the
      // player was stopped or disposed before this audio source could complete
      // loading.
      if (kDebugMode) {
        print("player_state[syllable audio load interrupted]: ${e.message}");
      }
      currentPlayer = null;
      notifyListeners();
    } catch (e) {
      // Fallback for all other errors
      if (kDebugMode) {
        print("player_state[syllable audio load error]: $e");
      }
      currentPlayer = null;
      notifyListeners();
      Sentry.captureMessage("player_state[syllable audio load error]: $e");
    }
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
    await syllablesPlayer.play();
  }

  Future<void> ttsPlay(
      TtsPlayer player, SpeechRateState speechRateState) async {
    final rate = player.atHeader
        ? speechRateState.entryHeaderRate
        : speechRateState.entryEgRate;

    final speed = rate == SpeechRate.verySlow
        ? 0.15
        : rate == SpeechRate.slow
            ? 0.3
            : 0.5;
    await ttsPlayer.setSpeechRate(speed);
    if (await session.setActive(true)) {
      await ttsPlayer.speak(player.text);
    } else {
      // The request was denied and the app should not play audio
      // e.g. a phone call is in progress.
      currentPlayer = null;
      notifyListeners();
      return;
    }
  }

  stop() async {
    if (currentPlayer != null) {
      await stopHelper();
      currentPlayer = null;
      notifyListeners();
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
