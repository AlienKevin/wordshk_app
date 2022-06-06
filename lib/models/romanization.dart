enum Romanization {
  jyutping,
  yaleNumbers,
  yaleDiacritics,
  cantonesePinyin,
  guangdong,
  sidneyLau,
  wongNumbers,
  wongDiacritics,
  ipa;

  get tsvColumn {
    switch (this) {
      case jyutping:
        return 6;
      case yaleNumbers:
        return 0;
      case yaleDiacritics:
        return 1;
      case cantonesePinyin:
        return 2;
      case guangdong:
        return 7;
      case sidneyLau:
        return 8;
      case wongNumbers:
        return 3;
      case wongDiacritics:
        return 4;
      case ipa:
        return 5;
    }
  }
}
