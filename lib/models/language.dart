import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' show Locale;

enum Language {
  en,
  zhHans,
  zhHant,
  yue;

  Locale get toLocale {
    if (kDebugMode) {
      print("toLocale called on $this");
    }
    switch (this) {
      case Language.en:
        return const Locale.fromSubtags(languageCode: 'en');
      case Language.zhHans:
        return const Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hans');
      case Language.zhHant:
        return const Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hant');
      case Language.yue:
        return const Locale.fromSubtags(languageCode: 'yue');
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
