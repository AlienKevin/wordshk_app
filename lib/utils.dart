import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_web_browser/flutter_web_browser.dart';
import 'package:wordshk/bridge_generated.dart';
import 'package:wordshk/constants.dart';
import 'package:wordshk/models/entry_language.dart';
import 'package:wordshk/models/pronunciation_method.dart';

import 'models/font_size.dart';

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
  switch (romanization) {
    case Romanization.Jyutping:
      return s.romanizationJyutping;
    case Romanization.YaleNumbers:
      return s.romanizationYaleNumbers;
    case Romanization.YaleDiacritics:
      return s.romanizationYaleDiacritics;
    case Romanization.CantonesePinyin:
      return s.romanizationCantonesePinyin;
    case Romanization.Guangdong:
      return s.romanizationGuangdong;
    case Romanization.SidneyLau:
      return s.romanizationSidneyLau;
    case Romanization.Ipa:
      return s.romanizationIpa;
  }
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
