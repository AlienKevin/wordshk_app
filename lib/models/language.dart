import 'package:flutter/material.dart' show Locale;

enum Language {
  en,
  zhHans,
  zhHant,
  yue;

  Locale get toLocale {
    switch (this) {
      case Language.en:
        return const Locale.fromSubtags(languageCode: 'en');
      case Language.zhHans:
        return const Locale.fromSubtags(
            languageCode: 'zh', scriptCode: 'Hans');
      case Language.zhHant:
        return const Locale.fromSubtags(
            languageCode: 'zh', scriptCode: 'Hant');
      case Language.yue:
        return const Locale.fromSubtags(
            languageCode: 'zh', scriptCode: 'Hant', countryCode: 'HK');
    }
  }

  @override
  String toString() {
    switch (this) {
      case Language.en:
        return "English";
      case Language.zhHans:
        return "简体中文";
      case Language.zhHant:
        return "繁體中文";
      case Language.yue:
        return "廣東話";
    }
  }
}
