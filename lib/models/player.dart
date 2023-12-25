sealed class Player {
  final bool atHeader;

  Player({required this.atHeader});
}

class TtsPlayer extends Player {
  final String text;

  TtsPlayer({required this.text, required super.atHeader});
}

class SyllablesPlayer extends Player {
  final List<List<String>> prs;

  SyllablesPlayer({required this.prs, required super.atHeader});
}
