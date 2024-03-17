import 'package:flutter/foundation.dart';

sealed class Player {
  final bool atHeader;
  final Key? key;

  Player({required this.atHeader, this.key});

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is Player) {
      if (key == null || other.key == null) {
        return false; // Consider players with null keys as non-equal
      }
      return other.key == key;
    }
    return false;
  }

  @override
  int get hashCode => key?.hashCode ?? super.hashCode;
}

class TtsPlayer extends Player {
  final String text;

  TtsPlayer({required this.text, required super.atHeader, super.key});
}

class SyllablesPlayer extends Player {
  final List<List<String>> prs;

  SyllablesPlayer({required this.prs, required super.atHeader, super.key});
}

class UrlPlayer extends Player {
  final String url;

  UrlPlayer({required this.url, required super.atHeader, super.key});
}
