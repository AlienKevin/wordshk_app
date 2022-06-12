import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:wordshk/models/language.dart';

import '../../bridge_generated.dart' show Romanization;
import '../models/entry_language.dart';
import '../models/font_size.dart';
import '../models/pronunciation_method.dart';
import '../states/entry_eg_font_size_state.dart';
import '../states/entry_eg_jumpy_prs_state.dart';
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
    final entryEgRubySize = context.watch<EntryEgFontSizeState>().size;
    final romanization = context.watch<RomanizationState>().romanization;
    final isJumpy = context.watch<EntryEgJumpyPrsState>().isJumpy;
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

    onEntryEgRubySizechange(FontSize? newSize) {
      if (newSize != null) {
        context.read<EntryEgFontSizeState>().updateSize(newSize);
      }
    }

    onRomanizationChange(Romanization? newRomanization) {
      if (newRomanization != null) {
        context.read<RomanizationState>().updateRomanization(newRomanization);
      }
    }

    onEntryEgJumpyPrsChange(bool? newIsJumpy) {
      if (newIsJumpy != null) {
        context.read<EntryEgJumpyPrsState>().updateIsJumpy(newIsJumpy);
      }
    }

    onSearchRomanizationChange(Romanization? newRomanization) {
      if (newRomanization != null) {
        context
            .read<SearchRomanizationState>()
            .updateRomanization(newRomanization);
      }
    }

    radioListTile<T>(String title, T value, T? groupValue,
            void Function(T?) onChanged) =>
        RadioListTile<T>(
          title: Text(title),
          value: value,
          groupValue: groupValue,
          onChanged: onChanged,
          visualDensity: VisualDensity.compact,
          contentPadding: EdgeInsets.zero,
          activeColor: Theme.of(context).colorScheme.secondary,
        );

    languageRadioListTile(String title, Language value) =>
        radioListTile<Language>(title, value, language, onLanguageChange);

    entryLanguageRadioListTile(String title, EntryLanguage value) =>
        radioListTile<EntryLanguage>(
            title, value, entryLanguage, onEntryLanguageChange);

    entryPronunciationMethodRadioListTile(
            String title, PronunciationMethod value) =>
        radioListTile<PronunciationMethod>(title, value, egPronunciationMethod,
            onEntryEgPronunciationMethodChange);

    entryEgRubySizeRadioListTile(String title, FontSize value) =>
        radioListTile<FontSize>(
            title, value, entryEgRubySize, onEntryEgRubySizechange);

    romanizationRadioListTile(String title, Romanization value) =>
        radioListTile<Romanization>(
            title, value, romanization, onRomanizationChange);

    searchRomanizationRadioListTile(String title, Romanization value) =>
        radioListTile<Romanization>(
            title, value, searchRomanization, onSearchRomanizationChange);

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
              ...title(AppLocalizations.of(context)!.entryEgFontSize),
              entryEgRubySizeRadioListTile(
                  AppLocalizations.of(context)!.fontSizeSmall, FontSize.small),
              entryEgRubySizeRadioListTile(
                  AppLocalizations.of(context)!.fontSizeMedium,
                  FontSize.medium),
              entryEgRubySizeRadioListTile(
                  AppLocalizations.of(context)!.fontSizeLarge, FontSize.large),
              entryEgRubySizeRadioListTile(
                  AppLocalizations.of(context)!.fontSizeVeryLarge,
                  FontSize.veryLarge),
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
              ...title(AppLocalizations.of(context)!.entryEgJumpyPrs),
              SwitchListTile(
                title: Text(isJumpy
                    ? AppLocalizations.of(context)!.enabled
                    : AppLocalizations.of(context)!.disabled),
                value: isJumpy,
                onChanged: onEntryEgJumpyPrsChange,
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: EdgeInsets.zero,
              ),
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
