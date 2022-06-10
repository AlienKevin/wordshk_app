import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:wordshk/models/language.dart';

import '../../bridge_generated.dart' show Romanization;
import '../models/entry_language.dart';
import '../models/pronunciation_method.dart';
import '../states/entry_language_state.dart';
import '../states/language_state.dart';
import '../states/pronunciation_method_state.dart';
import '../states/romanization_state.dart';
import '../states/search_romanization_state.dart';
import '../widgets/navigation_drawer.dart';

class PreferencesPage extends StatelessWidget {
  const PreferencesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final language = context.watch<LanguageState>().language;
    final entryLanguage = context.watch<EntryLanguageState>().language;
    final egPronunciationMethod =
        context.watch<PronunciationMethodState>().entryEgMethod;
    final romanization = context.watch<RomanizationState>().romanization;
    final searchRomanization =
        context.watch<SearchRomanizationState>().romanization;

    onLanguageChange(Language? newLanguage) {
      if (newLanguage != null) {
        context.read<LanguageState>().updateLanguage(newLanguage);
      }
    }

    onEntryLanguageChange(EntryLanguage? newLanguage) {
      if (newLanguage != null) {
        context.read<EntryLanguageState>().updateLanguage(newLanguage);
      }
    }

    onEntryEgPronunciationMethodChange(PronunciationMethod? newMethod) {
      if (newMethod != null) {
        context
            .read<PronunciationMethodState>()
            .updatePronunciationMethod(newMethod);
      }
    }

    onRomanizationChange(Romanization? newRomanization) {
      if (newRomanization != null) {
        context.read<RomanizationState>().updateRomanization(newRomanization);
      }
    }

    onSearchRomanizationChange(Romanization? newRomanization) {
      if (newRomanization != null) {
        context
            .read<SearchRomanizationState>()
            .updateRomanization(newRomanization);
      }
    }

    languageRadioListTile(String title, Language value) =>
        RadioListTile<Language>(
          title: Text(title),
          value: value,
          groupValue: language,
          onChanged: onLanguageChange,
          visualDensity: VisualDensity.compact,
          contentPadding: EdgeInsets.zero,
          activeColor: Theme.of(context).colorScheme.secondary,
        );

    entryLanguageRadioListTile(String title, EntryLanguage value) =>
        RadioListTile<EntryLanguage>(
          title: Text(title),
          value: value,
          groupValue: entryLanguage,
          onChanged: onEntryLanguageChange,
          visualDensity: VisualDensity.compact,
          contentPadding: EdgeInsets.zero,
          activeColor: Theme.of(context).colorScheme.secondary,
        );

    entryPronunciationMethodRadioListTile(
            String title, PronunciationMethod value) =>
        RadioListTile<PronunciationMethod>(
          title: Text(title),
          value: value,
          groupValue: egPronunciationMethod,
          onChanged: onEntryEgPronunciationMethodChange,
          visualDensity: VisualDensity.compact,
          contentPadding: EdgeInsets.zero,
          activeColor: Theme.of(context).colorScheme.secondary,
        );

    romanizationRadioListTile(String title, Romanization value) =>
        RadioListTile<Romanization>(
          title: Text(title),
          value: value,
          groupValue: romanization,
          onChanged: onRomanizationChange,
          visualDensity: VisualDensity.compact,
          contentPadding: EdgeInsets.zero,
          activeColor: Theme.of(context).colorScheme.secondary,
        );

    searchRomanizationRadioListTile(String title, Romanization value) =>
        RadioListTile<Romanization>(
          title: Text(title),
          value: value,
          groupValue: searchRomanization,
          onChanged: onSearchRomanizationChange,
          visualDensity: VisualDensity.compact,
          contentPadding: EdgeInsets.zero,
          activeColor: Theme.of(context).colorScheme.secondary,
        );

    title(String title) => [
          Text(title, style: Theme.of(context).textTheme.titleLarge),
          const Divider()
        ];

    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.preferences)),
      drawer: const NavigationDrawer(),
      body: SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.all(20),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              ...title(AppLocalizations.of(context)!.language),
              languageRadioListTile('廣東話（香港）', Language.zhHantHK),
              languageRadioListTile('English', Language.en),
              languageRadioListTile('中文（中国大陆）', Language.zhHansCN),
              languageRadioListTile('中文（台灣）', Language.zhHantTW),
              const SizedBox(height: 10),
              ...title(AppLocalizations.of(context)!.entryExplanationsLanguage),
              entryLanguageRadioListTile(
                  AppLocalizations.of(context)!.entryLanguageBoth,
                  EntryLanguage.both),
              entryLanguageRadioListTile(
                  AppLocalizations.of(context)!.entryLanguageCantonese,
                  EntryLanguage.cantonese),
              entryLanguageRadioListTile(
                  AppLocalizations.of(context)!.entryLanguageEnglish,
                  EntryLanguage.english),
              const SizedBox(height: 10),
              ...title(
                  AppLocalizations.of(context)!.entryEgPronunciationMethod),
              entryPronunciationMethodRadioListTile(
                  AppLocalizations.of(context)!.pronunciationMethodTts,
                  PronunciationMethod.tts),
              entryPronunciationMethodRadioListTile(
                  AppLocalizations.of(context)!
                      .pronunciationMethodSyllableRecordings,
                  PronunciationMethod.syllableRecordings),
              const SizedBox(height: 10),
              ...title(AppLocalizations.of(context)!.entryRomanization),
              romanizationRadioListTile(
                  AppLocalizations.of(context)!.romanizationJyutping,
                  Romanization.Jyutping),
              romanizationRadioListTile(
                  AppLocalizations.of(context)!.romanizationYaleNumbers,
                  Romanization.YaleNumbers),
              romanizationRadioListTile(
                  AppLocalizations.of(context)!.romanizationYaleDiacritics,
                  Romanization.YaleDiacritics),
              romanizationRadioListTile(
                  AppLocalizations.of(context)!.romanizationCantonesePinyin,
                  Romanization.CantonesePinyin),
              romanizationRadioListTile(
                  AppLocalizations.of(context)!.romanizationGuangdong,
                  Romanization.Guangdong),
              romanizationRadioListTile(
                  AppLocalizations.of(context)!.romanizationSidneyLau,
                  Romanization.SidneyLau),
              romanizationRadioListTile(
                  AppLocalizations.of(context)!.romanizationIpa,
                  Romanization.Ipa),
              const SizedBox(height: 10),
              ...title(AppLocalizations.of(context)!.searchRomanization),
              searchRomanizationRadioListTile(
                  AppLocalizations.of(context)!.romanizationJyutping,
                  Romanization.Jyutping),
              searchRomanizationRadioListTile(
                  AppLocalizations.of(context)!.romanizationYaleNumbers,
                  Romanization.YaleNumbers),
              searchRomanizationRadioListTile(
                  AppLocalizations.of(context)!.romanizationCantonesePinyin,
                  Romanization.CantonesePinyin),
              searchRomanizationRadioListTile(
                  AppLocalizations.of(context)!.romanizationSidneyLau,
                  Romanization.SidneyLau),
            ])),
      ),
    );
  }
}
