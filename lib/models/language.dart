import 'package:flutter/material.dart' show Locale;

enum Language {
  en,
  zhHansCN,
  zhHantTW,
  zhHantHK;

  Locale get toLocale {
    switch (this) {
      case Language.en:
        return const Locale.fromSubtags(languageCode: 'en');
      case Language.zhHansCN:
        return const Locale.fromSubtags(
            languageCode: 'zh', scriptCode: 'Hans', countryCode: 'CN');
      case Language.zhHantTW:
        return const Locale.fromSubtags(
            languageCode: 'zh', scriptCode: 'Hant', countryCode: 'TW');
      case Language.zhHantHK:
        return const Locale.fromSubtags(
            languageCode: 'zh', scriptCode: 'Hant', countryCode: 'HK');
    }
  }
}
