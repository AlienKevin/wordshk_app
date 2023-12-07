import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_web_browser/flutter_web_browser.dart';
import 'package:provider/provider.dart';
import 'package:wordshk/bridge_generated.dart';
import 'package:wordshk/constants.dart';
import 'package:wordshk/models/entry_language.dart';
import 'package:wordshk/models/pronunciation_method.dart';
import 'package:wordshk/models/speech_rate.dart';
import 'package:wordshk/states/entry_language_state.dart';
import 'package:wordshk/states/language_state.dart';

import 'models/font_size.dart';
import 'models/language.dart';

void openLink(String url) async {
  return FlutterWebBrowser.openWebPage(
    url: url,
    customTabsOptions: const CustomTabsOptions(
      colorScheme: CustomTabsColorScheme.dark,
      darkColorSchemeParams: CustomTabsColorSchemeParams(
        toolbarColor: blueColor,
        secondaryToolbarColor: whiteColor,
        navigationBarColor: whiteColor,
        navigationBarDividerColor: greyColor,
      ),
      shareState: CustomTabsShareState.on,
      instantAppsEnabled: true,
      showTitle: true,
      urlBarHidingEnabled: true,
    ),
    safariVCOptions: const SafariViewControllerOptions(
      barCollapsingEnabled: true,
      preferredBarTintColor: blueColor,
      preferredControlTintColor: whiteColor,
      dismissButtonStyle: SafariViewControllerDismissButtonStyle.close,
      modalPresentationCapturesStatusBarAppearance: true,
    ),
  );
}

switchKeyboardType(FocusNode focusNode) {
  focusNode.unfocus();
  WidgetsBinding.instance.addPostFrameCallback(
    (_) => focusNode.requestFocus(),
  );
}

String getRomanizationName(Romanization romanization, AppLocalizations s) {
  return switch (romanization) {
    Romanization.Jyutping => s.romanizationJyutping,
    Romanization.Yale => s.romanizationYale,
  };
}

String getRomanizationDescription(
    Romanization romanization, AppLocalizations s) {
  return switch (romanization) {
    Romanization.Jyutping => s.romanizationJyutpingDescription,
    Romanization.Yale => s.romanizationYaleDescription,
  };
}

String getEntryLanguageName(EntryLanguage language, AppLocalizations s) {
  switch (language) {
    case EntryLanguage.both:
      return s.entryLanguageBoth;
    case EntryLanguage.cantonese:
      return s.entryLanguageCantonese;
    case EntryLanguage.english:
      return s.entryLanguageEnglish;
  }
}

String getFontSizeName(FontSize size, AppLocalizations s) {
  switch (size) {
    case FontSize.small:
      return s.fontSizeSmall;
    case FontSize.medium:
      return s.fontSizeMedium;
    case FontSize.large:
      return s.fontSizeLarge;
    case FontSize.veryLarge:
      return s.fontSizeVeryLarge;
  }
}

String getPronunciationMethodName(
    PronunciationMethod method, AppLocalizations s) {
  switch (method) {
    case PronunciationMethod.tts:
      return s.pronunciationMethodTts;
    case PronunciationMethod.syllableRecordings:
      return s.pronunciationMethodSyllableRecordings;
  }
}

String getPronunciationMethodShortName(
    PronunciationMethod method, AppLocalizations s, Language language) {
  if (language == Language.en) {
    switch (method) {
      case PronunciationMethod.tts:
        return s.pronunciationMethodTtsShort;
      case PronunciationMethod.syllableRecordings:
        return s.pronunciationMethodSyllableRecordingsShort;
    }
  } else {
    switch (method) {
      case PronunciationMethod.tts:
        return s.pronunciationMethodTts;
      case PronunciationMethod.syllableRecordings:
        return s.pronunciationMethodSyllableRecordings;
    }
  }
}

Script getScript(BuildContext context) =>
    context.read<LanguageState>().language == Language.zhHans
        ? Script.Simplified
        : Script.Traditional;

String getSpeechRateName(SpeechRate rate, AppLocalizations s) {
  switch (rate) {
    case SpeechRate.verySlow:
      return s.speechRateVerySlow;
    case SpeechRate.slow:
      return s.speechRateSlow;
    case SpeechRate.normal:
      return s.speechRateNormal;
  }
}

bool isEngDef(BuildContext context) {
  final entryLanguage = context.read<EntryLanguageState>().language;
  final language = context.read<LanguageState>().language;
  return entryLanguage == EntryLanguage.english ||
      (entryLanguage == EntryLanguage.both && language == Language.en);
}

List<TextSpan> showDefSummary(
    BuildContext context, List<String> defs, textStyle) {
  defSpan(String text, {required bool bold}) => TextSpan(
      text: text
          .replaceAll(RegExp(r'[;；].+'), "")
          .replaceAll(RegExp(r'\(.+\)'), "")
          .replaceAll(RegExp(r'（.+）'), ""),
      style: textStyle.copyWith(
          fontSize: Theme.of(context).textTheme.bodySmall!.fontSize,
          fontWeight: bold ? FontWeight.bold : FontWeight.normal));
  return (defs.length == 1
      ? [defSpan(defs[0], bold: false)]
      : defs
          .mapIndexed((i, def) => [
                defSpan("${i > 0 ? "  " : ""}${i + 1} ", bold: true),
                defSpan(def, bold: false)
              ])
          .expand((x) => x)
          .toList());
}
