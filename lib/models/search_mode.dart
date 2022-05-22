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
