import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_web_browser/flutter_web_browser.dart';
import 'package:wordshk/bridge_generated.dart';
import 'package:wordshk/constants.dart';

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
  late final String name;
  switch (romanization) {
    case Romanization.Jyutping:
      name = s.romanizationJyutping;
      break;
    case Romanization.YaleNumbers:
      name = s.romanizationYaleNumbers;
      break;
    case Romanization.YaleDiacritics:
      name = s.romanizationYaleDiacritics;
      break;
    case Romanization.CantonesePinyin:
      name = s.romanizationCantonesePinyin;
      break;
    case Romanization.Guangdong:
      name = s.romanizationGuangdong;
      break;
    case Romanization.SidneyLau:
      name = s.romanizationSidneyLau;
      break;
    case Romanization.Ipa:
      name = s.romanizationIpa;
      break;
  }
  return name;
}
