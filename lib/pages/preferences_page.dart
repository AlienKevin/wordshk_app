import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:wordshk/models/language.dart';

import '../main.dart';
import '../models/entry_language.dart';
import '../models/pronunciation_method.dart';
import '../models/romanization.dart';
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

    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.preferences)),
      drawer: const NavigationDrawer(),
      body: SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.all(20),
            child:
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(AppLocalizations.of(context)!.language,
                  style: Theme.of(context).textTheme.titleLarge),
              languageRadioListTile('廣東話（香港）', Language.zhHantHK),
              languageRadioListTile('English', Language.en),
              languageRadioListTile('中文（中国大陆）', Language.zhHansCN),
              languageRadioListTile('中文（台灣）', Language.zhHantTW),
              const SizedBox(height: 10),
              Text(AppLocalizations.of(context)!.entryExplanationsLanguage,
                  style: Theme.of(context).textTheme.titleLarge),
              entryLanguageRadioListTile(
                  AppLocalizations.of(context)!.entryLanguageCantonese,
                  EntryLanguage.cantonese),
              entryLanguageRadioListTile(
                  AppLocalizations.of(context)!.entryLanguageEnglish,
                  EntryLanguage.english),
              entryLanguageRadioListTile(
                  AppLocalizations.of(context)!.entryLanguageBoth,
                  EntryLanguage.both),
              Text(AppLocalizations.of(context)!.entryEgPronunciationMethod,
                  style: Theme.of(context).textTheme.titleLarge),
              entryPronunciationMethodRadioListTile(
                  AppLocalizations.of(context)!.pronunciationMethodTts,
                  PronunciationMethod.tts),
              entryPronunciationMethodRadioListTile(
                  AppLocalizations.of(context)!
                      .pronunciationMethodSyllableRecordings,
                  PronunciationMethod.syllableRecordings),
              Text(AppLocalizations.of(context)!.romanization,
                  style: Theme.of(context).textTheme.titleLarge),
              romanizationRadioListTile(
                  AppLocalizations.of(context)!.romanizationJyutping,
                  Romanization.jyutping),
              romanizationRadioListTile(
                  AppLocalizations.of(context)!.romanizationYaleNumbers,
                  Romanization.yaleNumbers),
              romanizationRadioListTile(
                  AppLocalizations.of(context)!.romanizationYaleDiacritics,
                  Romanization.yaleDiacritics),
              romanizationRadioListTile(
                  AppLocalizations.of(context)!.romanizationCantonesePinyin,
                  Romanization.cantonesePinyin),
              romanizationRadioListTile(
                  AppLocalizations.of(context)!.romanizationGuangdong,
                  Romanization.guangdong),
              romanizationRadioListTile(
                  AppLocalizations.of(context)!.romanizationSidneyLau,
                  Romanization.sidneyLau),
              romanizationRadioListTile(
                  AppLocalizations.of(context)!.romanizationWongNumbers,
                  Romanization.wongNumbers),
              romanizationRadioListTile(
                  AppLocalizations.of(context)!.romanizationWongDiacritics,
                  Romanization.wongDiacritics),
              romanizationRadioListTile(
                  AppLocalizations.of(context)!.romanizationIpa,
                  Romanization.ipa),
              romanizationRadioListTile(
                  AppLocalizations.of(context)!.romanizationPenkyampNumbers,
                  Romanization.penkyampNumbers),
              romanizationRadioListTile(
                  AppLocalizations.of(context)!.romanizationPenkyampDiacritics,
                  Romanization.penkyampDiacritics),
            ])),
      ),
    );
  }
}
