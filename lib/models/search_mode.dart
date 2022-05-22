import 'package:flutter_gen/gen_l10n/app_localizations.dart';

enum SearchMode {
  pr,
  variant,
  combined,
  english,
}

translateSearchMode(SearchMode searchMode, AppLocalizations context) {
  switch (searchMode) {
    case SearchMode.variant:
      return context.searchModeVariant;
    case SearchMode.pr:
      return context.searchModePr;
    case SearchMode.combined:
      return context.searchModeCombined;
    case SearchMode.english:
      return context.searchModeEnglish;
  }
}

translateSearchModeIcon(
    SearchMode searchMode, AppLocalizations appLocalizations) {
  final String str;
  switch (searchMode) {
    case SearchMode.pr:
      str = appLocalizations.searchModePrIcon;
      break;
    case SearchMode.variant:
      str = appLocalizations.searchModeVariantIcon;
      break;
    case SearchMode.combined:
      str = appLocalizations.searchModeCombinedIcon;
      break;
    case SearchMode.english:
      str = appLocalizations.searchModeEnglishIcon;
      break;
  }
  return str;
}
