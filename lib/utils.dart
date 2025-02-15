import 'dart:io';
import 'dart:math';
import 'dart:ui';

import 'package:collection/collection.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_web_browser/flutter_web_browser.dart';
import 'package:provider/provider.dart';
import 'package:wordshk/constants.dart';
import 'package:wordshk/models/entry_language.dart';
import 'package:wordshk/models/search_result_type.dart';
import 'package:wordshk/models/speech_rate.dart';
import 'package:wordshk/states/entry_language_state.dart';
import 'package:wordshk/states/language_state.dart';
import 'package:wordshk/states/romanization_state.dart';

import 'models/font_size.dart';
import 'models/language.dart';
import 'models/search_bar_position.dart';
import 'models/summary_def_language.dart';
import 'src/rust/api/api.dart';

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

String getSearchResultTypeName(
        SearchResultType type, BuildContext context, AppLocalizations s) =>
    switch (type) {
      SearchResultType.pr =>
        getRomanizationName(context.read<RomanizationState>().romanization, s),
      SearchResultType.variant => s.searchResultsCategoryCantonese,
      SearchResultType.mandarinVariant => s.searchResultsCategoryMandarin,
      SearchResultType.english => s.searchResultsCategoryEnglish,
      SearchResultType.eg => s.searchResultsCategoryExample
    };

String getRomanizationName(Romanization romanization, AppLocalizations s) {
  return switch (romanization) {
    Romanization.jyutping => s.romanizationJyutping,
    Romanization.yale => s.romanizationYale,
  };
}

String getRomanizationDescription(
    Romanization romanization, AppLocalizations s) {
  return switch (romanization) {
    Romanization.jyutping => s.romanizationJyutpingDescription,
    Romanization.yale => s.romanizationYaleDescription,
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

String getScriptName(Script script, AppLocalizations s) {
  switch (script) {
    case Script.simplified:
      return s.scriptSimplified;
    case Script.traditional:
      return s.scriptTraditional;
  }
}

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

String getSearchBarPositionName(
    SearchBarPosition position, AppLocalizations s) {
  switch (position) {
    case SearchBarPosition.top:
      return s.top;
    case SearchBarPosition.bottom:
      return s.bottom;
  }
}

SummaryDefLanguage watchSummaryDefLanguage(BuildContext context) {
  final entryLanguage = context.watch<EntryLanguageState>().language;
  final language = context.watch<LanguageState>().language;
  return (entryLanguage == EntryLanguage.english ||
          (entryLanguage == EntryLanguage.both && language == Language.en))
      ? SummaryDefLanguage.english
      : SummaryDefLanguage.cantonese;
}

List<TextSpan> showDefSummary(
    BuildContext context, List<String> defs, textStyle) {
  defSpan(String text, {required bool bold}) {
    return TextSpan(
        text: text,
        style: textStyle.copyWith(
            fontSize: Theme.of(context).textTheme.bodySmall!.fontSize,
            fontWeight: bold ? FontWeight.bold : FontWeight.normal));
  }

  return (defs.length == 1
      ? [
          defSpan(
              defs[0]
                  .replaceAll(RegExp(r'\(.+?\)'), "")
                  .replaceAll(RegExp(r'（.+?）'), "")
                  .trim(),
              bold: false)
        ]
      : defs
          .mapIndexed((i, def) {
            return [
              defSpan("${i > 0 ? "  " : ""}${i + 1} ", bold: true),
              defSpan(
                  def
                      .replaceAll(RegExp(r'[;；].+'), "")
                      .replaceAll(RegExp(r'\(.+?\)'), "")
                      .replaceAll(RegExp(r'（.+?）'), "")
                      .trim(),
                  bold: false)
            ];
          })
          .expand((x) => x)
          .toList());
}

void drawDashedLine(
    {required Canvas canvas,
    required Offset p1,
    required Offset p2,
    required int dashWidth,
    required int dashSpace,
    required Paint paint}) {
  // Get normalized distance vector from p1 to p2
  var dx = p2.dx - p1.dx;
  var dy = p2.dy - p1.dy;
  final magnitude = sqrt(dx * dx + dy * dy);
  dx = dx / magnitude;
  dy = dy / magnitude;

  // Compute number of dash segments
  final steps = magnitude ~/ (dashWidth + dashSpace);

  var startX = p1.dx;
  var startY = p1.dy;

  for (int i = 0; i < steps; i++) {
    final endX = startX + dx * dashWidth;
    final endY = startY + dy * dashWidth;
    canvas.drawLine(Offset(startX, startY), Offset(endX, endY), paint);
    startX += dx * (dashWidth + dashSpace);
    startY += dy * (dashWidth + dashSpace);
  }
}

bool getIsPhone() {
  final firstView = WidgetsBinding.instance.platformDispatcher.views.first;
  final logicalShortestSide =
      firstView.physicalSize.shortestSide / firstView.devicePixelRatio;
  return logicalShortestSide <= 600;
}

class TokenCounts {
  int chinese;
  int english;
  int punctuation;

  TokenCounts({this.chinese = 0, this.english = 0, this.punctuation = 0});

  int get total => chinese + english + punctuation;

  @override
  String toString() {
    return 'TokenCounts{chinese: $chinese, english: $english, punctuation: $punctuation}';
  }
}

TokenCounts countTokens(String text) {
  final TokenCounts counts = TokenCounts();

  // Regular expressions for matching Chinese characters, English words, and punctuations
  final RegExp regexChinese = RegExp(r'[\u4e00-\u9fff]');
  final RegExp regexEnglish = RegExp(r"\b[a-zA-Z']+\b");
  final RegExp regexPunctuation = RegExp(r'[.,/#!$%^&*;:{}=\-_`~()]');

  // Split text into potential tokens
  var tokens = text.split(' ');

  for (var token in tokens) {
    // Count Chinese characters
    var matchesChinese = regexChinese.allMatches(token);
    counts.chinese += matchesChinese.length;

    // Count English words
    if (regexEnglish.hasMatch(token)) {
      counts.english++;
    }

    // Count punctuations
    var matchesPunctuation = regexPunctuation.allMatches(token);
    counts.punctuation += matchesPunctuation.length;
  }

  return counts;
}
