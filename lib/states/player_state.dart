import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:audio_session/audio_session.dart';
import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:just_audio/just_audio.dart';
import 'package:sentry/sentry_io.dart';
import 'package:wordshk/states/speech_rate_state.dart';
import 'package:crypto/crypto.dart';

import '../models/player.dart';
import '../models/speech_rate.dart';

class PlayerState with ChangeNotifier {
  Completer<AudioPlayer> onlineTtsPlayer = Completer();
  Completer<FlutterTts> ttsPlayer = Completer();
  Completer<AudioPlayer> syllablesPlayer = Completer();
  Completer<AudioPlayer> urlPlayer = Completer();
  Completer<AudioSession> session = Completer();
  Player? currentPlayer;
  bool playerStoppedDueToSwitch = false;

  PlayerState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final sessionValue = await AudioSession.instance;
      await sessionValue.configure(const AudioSessionConfiguration.speech());
      sessionValue.interruptionEventStream.listen((event) async {
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
      session.complete(sessionValue);

      syllablesPlayer.complete(AudioPlayer());
      urlPlayer.complete(AudioPlayer());
      onlineTtsPlayer.complete(AudioPlayer());

      final ttsPlayerValue = FlutterTts();
      await ttsPlayerValue.setSharedInstance(true);
      await ttsPlayerValue.setLanguage("zh-HK");
      await ttsPlayerValue.setSpeechRate(0.5);
      await ttsPlayerValue.setVolume(1.0);
      await ttsPlayerValue.setPitch(1.0);
      await ttsPlayerValue.isLanguageAvailable("zh-HK");
      ttsPlayerValue.setCompletionHandler(() {
        if (!playerStoppedDueToSwitch) {
          currentPlayer = null;
          notifyListeners();
        } else {
          playerStoppedDueToSwitch = false;
        }
      });
      ttsPlayer.complete(ttsPlayerValue);
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
      case OnlineTtsPlayer():
        await onlineTtsPlay(newPlayer, speechRateState);
        break;
      case TtsPlayer():
        await ttsPlay(newPlayer, speechRateState);
        break;
      case SyllablesPlayer():
        await syllablesPlay(newPlayer, speechRateState);
        break;
      case UrlPlayer():
        await urlPlay(newPlayer);
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

  Future<void> urlPlay(UrlPlayer player) async {
    final player_ = await urlPlayer.future;
    await player_.setUrl(player.url);

    player_.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        if (!playerStoppedDueToSwitch) {
          currentPlayer = null;
          notifyListeners();
        } else {
          playerStoppedDueToSwitch = false;
        }
      }
    });

    await player_.play();
  }

  Future<void> syllablesPlay(
      SyllablesPlayer player, SpeechRateState speechRateState) async {
    try {
      await (await syllablesPlayer.future)
          .setAudioSource(ConcatenatingAudioSource(
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
    final volume = Platform.isIOS ? 0.6 : 1.0;

    final player_ = await syllablesPlayer.future;
    await player_.setSpeed(speed);
    await player_.setVolume(volume);
    await player_.seek(Duration.zero, index: 0);

    player_.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        if (!playerStoppedDueToSwitch) {
          currentPlayer = null;
          notifyListeners();
        } else {
          playerStoppedDueToSwitch = false;
        }
      }
    });
    await player_.play();
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
    final player_ = await ttsPlayer.future;
    await player_.setSpeechRate(speed);
    if (await (await session.future).setActive(true)) {
      await player_.speak(player.text);
    } else {
      // The request was denied and the app should not play audio
      // e.g. a phone call is in progress.
      currentPlayer = null;
      notifyListeners();
      return;
    }
  }

  Future<void> onlineTtsPlay(
      OnlineTtsPlayer player, SpeechRateState speechRateState) async {
    assert(!player.atHeader); // Only support playing egs for now
    final rate = speechRateState.entryEgRate;

    final speed = rate == SpeechRate.verySlow
        ? 0.6
        : rate == SpeechRate.slow
            ? 0.8
            : 1.0;

    final url =
        'http://wordshk.cn/${sha256.convert(utf8.encode(player.text.replaceAll(' ', '')))}.mp3';
    print("player_state[online tts text]: ${player.text}");
    print("player_state[online tts url]: $url");
    final player_ = await onlineTtsPlayer.future;
    try {
      await player_.setUrl(url);
      await player_.setSpeed(speed);
    } on PlayerException catch (e) {
      if (kDebugMode) {
        print("player_state[online tts load error]: $e");
      }
      Sentry.captureMessage("player_state[online tts load error]: $e");
      currentPlayer = null;
      notifyListeners();
      return;
    }

    player_.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        if (!playerStoppedDueToSwitch) {
          currentPlayer = null;
          notifyListeners();
        } else {
          playerStoppedDueToSwitch = false;
        }
      }
    });
    await player_.play();
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
      case OnlineTtsPlayer():
        await (await onlineTtsPlayer.future).stop();
        break;
      case TtsPlayer():
        await (await ttsPlayer.future).stop();
        break;
      case SyllablesPlayer():
        await (await syllablesPlayer.future).stop();
        break;
      case UrlPlayer():
        await (await urlPlayer.future).stop();
        break;
    }
  }
}
