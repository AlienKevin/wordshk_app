// Copyright (c) 2017, Spencer. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:provider/provider.dart';
import 'package:wordshk/src/rust/api/api.dart';
import 'package:wordshk/states/input_mode_state.dart';
import 'package:wordshk/utils.dart';

import '../constants.dart';
import '../models/input_mode.dart';
import '../states/romanization_state.dart';
import '../states/search_query_state.dart';

typedef TextFieldSubmitCallback = void Function(String value);
typedef TextFieldChangeCallback = void Function(String value);
typedef SetStateCallback = void Function(void Function());

class SearchBar extends StatefulWidget implements PreferredSizeWidget {
  /// Whether or not the search bar should close on submit. Defaults to true.
  final bool closeOnSubmit;

  /// Whether the text field should be cleared when it is submitted
  final bool clearOnSubmit;

  /// A void callback which takes a string as an argument, this is fired every time the search is submitted. Do what you want with the result.
  final TextFieldSubmitCallback? onSubmitted;

  /// A void callback which gets fired on close button press.
  final VoidCallback? onClosed;

  /// A callback which is fired when clear button is pressed.
  final VoidCallback? onCleared;

  /// A callback which is invoked each time the text field's value changes
  final TextFieldChangeCallback? onChanged;

  const SearchBar({
    this.onSubmitted,
    this.closeOnSubmit = false,
    this.clearOnSubmit = false,
    this.onChanged,
    this.onClosed,
    this.onCleared,
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => IsSearching();

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(appBarHeight);
}

class IsSearching extends State<SearchBar> {
  /// The controller to be used in the textField.
  TextEditingController controller = TextEditingController();

  /// focusNode for the textField.
  FocusNode focusNode = FocusNode();

  /// Whether search is currently active.
  final ValueNotifier<bool> isSearching = ValueNotifier(true);

  /// Whether the clear button should be active (fully colored) or inactive (greyed out)
  bool _clearActive = false;

  /// Whether or not the search bar should add a clear input button, defaults to true.
  bool showClearButton = true;

  late StreamSubscription<bool> keyboardSubscription;

  @override
  void initState() {
    super.initState();

    var keyboardVisibilityController = KeyboardVisibilityController();

    // Subscribe
    keyboardSubscription =
        keyboardVisibilityController.onChange.listen((bool visible) {
      if (!visible) {
        focusNode.unfocus();
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<InputModeState>().setSearchFieldFocusNode(focusNode);
      context.read<SearchQueryState>().setSearchBarCallbacks(
          typeCharacter, backspace, moveToEndOfSelection);

      controller.addListener(() {
        if (controller.text.isEmpty) {
          // If clear is already disabled, don't disable it
          if (_clearActive) {
            setState(() {
              _clearActive = false;
            });
          }
        }
        // If clear is already enabled, don't enable it
        else if (!_clearActive) {
          setState(() {
            _clearActive = true;
          });
        }
      });
      controller.text = context.read<SearchQueryState>().query;
    });
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the widget tree.
    // This also removes the _printLatestValue listener.
    controller.dispose();
    super.dispose();
  }

  /// Initializes the search bar.
  ///
  /// This adds a route that listens for onRemove (and stops the search when that happens), and then calls [setState] to rebuild and start the search.
  void beginSearch() {
    setState(() {
      isSearching.value = true;
    });
    final inputModeState = context.read<InputModeState>();
    if (inputModeState.mode == InputMode.done) {
      inputModeState.updateInputMode(InputMode.keyboard);
    }
  }

  String addDiacriticToVowel(String diacritic, String vowel) {
    return switch ((diacritic, vowel)) {
      // macron
      ('̄', 'a') => 'ā',
      ('̄', 'e') => 'ē',
      ('̄', 'o') => 'ō',
      ('̄', 'i') => 'ī',
      ('̄', 'u') => 'ū',
      // acute accent
      ('́', 'a') => 'á',
      ('́', 'e') => 'é',
      ('́', 'o') => 'ó',
      ('́', 'i') => 'í',
      ('́', 'u') => 'ú',
      // grave accent
      ('̀', 'a') => 'à',
      ('̀', 'e') => 'è',
      ('̀', 'o') => 'ò',
      ('̀', 'i') => 'ì',
      ('̀', 'u') => 'ù',
      _ => throw Exception(
          'Invalid arguments to addDiacriticToVowel. Found diacritic=$diacritic and vowel=$vowel')
    };
  }

  void typeDiacritic(String diacritic) {
    final baseOffset = controller.selection.baseOffset;
    final extentOffset = controller.selection.extentOffset;
    final query = controller.text;
    // delete selection and add character in place of selection
    final start = query.substring(0, baseOffset);
    final startWithDiacritic = switch (start) {
      "" => diacritic,
      _ when 'aeiou'.contains(start[start.length - 1]) =>
        start.substring(0, start.length - 1) +
            addDiacriticToVowel(diacritic, start[start.length - 1]),
      _ => start + diacritic,
    };
    final newQuery = startWithDiacritic + query.substring(extentOffset);
    controller.value = TextEditingValue(
        text: newQuery,
        selection: TextSelection.collapsed(
            offset: baseOffset + startWithDiacritic.length - start.length));
    context.read<SearchQueryState>().updateSearchQuery(newQuery);
    if (widget.onChanged != null) {
      widget.onChanged!(newQuery);
    }
  }

  void typeDigit(int digit) {
    final baseOffset = controller.selection.baseOffset;
    final extentOffset = controller.selection.extentOffset;
    final query = controller.text;
    // delete selection and add character in place of selection
    final newQuery = query.substring(0, baseOffset) +
        digit.toString() +
        query.substring(extentOffset);
    controller.value = TextEditingValue(
        text: newQuery,
        selection: TextSelection.collapsed(offset: baseOffset + 1));
    context.read<SearchQueryState>().updateSearchQuery(newQuery);
    if (widget.onChanged != null) {
      widget.onChanged!(newQuery);
    }
  }

  void typeCharacters(String characters) {
    final baseOffset = controller.selection.baseOffset;
    final extentOffset = controller.selection.extentOffset;
    final query = controller.text;
    // delete selection and add character in place of selection
    final newQuery = query.substring(0, baseOffset) +
        characters +
        query.substring(extentOffset);
    controller.value = TextEditingValue(
        text: newQuery,
        selection: TextSelection(
            baseOffset: baseOffset,
            extentOffset: baseOffset + characters.length));
    context.read<SearchQueryState>().updateSearchQuery(newQuery);
    if (widget.onChanged != null) {
      widget.onChanged!(newQuery);
    }
  }

  void typeCharacter(String character) {
    final baseOffset = controller.selection.baseOffset;
    final extentOffset = controller.selection.extentOffset;
    final query = controller.text;
    // delete selection and add character in place of selection
    final newQuery = query.substring(0, baseOffset) +
        character +
        query.substring(extentOffset);
    controller.value = TextEditingValue(
        text: newQuery,
        selection: TextSelection(
            baseOffset: baseOffset, extentOffset: baseOffset + 1));
    context.read<SearchQueryState>().updateSearchQuery(newQuery);
    if (widget.onChanged != null) {
      widget.onChanged!(newQuery);
    }
  }

  void backspace() {
    final baseOffset = controller.selection.baseOffset;
    final extentOffset = controller.selection.extentOffset;
    final query = controller.text;
    late final String newQuery;
    // has selection
    if (extentOffset - baseOffset > 0) {
      // delete selection
      newQuery = query.substring(0, baseOffset) + query.substring(extentOffset);
      controller.value = TextEditingValue(
          text: newQuery,
          selection: TextSelection.collapsed(offset: baseOffset));
    }
    // no selection, delete character before cursor
    else if (baseOffset - 1 >= 0) {
      newQuery =
          query.substring(0, baseOffset - 1) + query.substring(baseOffset);
      controller.value = TextEditingValue(
          text: newQuery,
          selection: TextSelection.collapsed(offset: baseOffset - 1));
    } else {
      return;
    }
    if (widget.onChanged != null) {
      widget.onChanged!(newQuery);
    }
  }

  void moveToEndOfSelection() {
    final extentOffset = controller.selection.extentOffset;
    controller.selection = TextSelection.collapsed(offset: extentOffset);
  }

  Widget diacriticButton(String diacritic) => Expanded(
        child: IconButton(
            visualDensity: VisualDensity.compact,
            // Trim the beginning "combining dotted circle" (U+25CC)
            onPressed: () => typeDiacritic(diacritic.substring(1)),
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                    Theme.of(context).canvasColor)),
            icon: Text(diacritic,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge!)),
      );

  /// Builds the search bar!
  ///
  /// The leading will always be a back button.
  /// backgroundColor is determined by the value of inBar
  /// title is always a [TextField] with the key 'SearchBarTextField', and various text stylings based on [inBar]. This is also where [onSubmitted] has its listener registered.
  ///
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    Color? buttonColor = theme.textTheme.bodyMedium!.color;
    final textColor = theme.textTheme.bodyMedium!.color;

    final s = AppLocalizations.of(context)!;

    final romanization = context.watch<RomanizationState>().romanization;
    final romanizationName = getRomanizationName(romanization, s);

    final textField = ConstrainedBox(
        constraints: BoxConstraints(
            maxWidth: max(wideScreenThreshold * 2 / 3,
                MediaQuery.of(context).size.width * 1 / 3)),
        child: SizedBox(
            height: 48,
            child: TextField(
              textAlignVertical: TextAlignVertical.center,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: textColor),
              focusNode: focusNode,
              onTap: beginSearch,
              key: const Key('SearchBarTextField'),
              autocorrect: false,
              enableSuggestions: true,
              keyboardType:
                  context.watch<InputModeState>().mode == InputMode.keyboard
                      ? TextInputType.text
                      : TextInputType.none,
              decoration: InputDecoration(
                isDense: true,
                filled: true,
                fillColor: Theme.of(context).canvasColor,
                contentPadding: const EdgeInsets.only(left: 20),
                hintText: s.searchDictionaryHint(romanizationName),
                suffixIcon: // Show an icon if clear is not active, so there's no ripple on tap
                    Wrap(children: [
                  IconButton(
                      icon: const Icon(Icons.brush),
                      onPressed: () {
                        context
                            .read<InputModeState>()
                            .updateInputMode(InputMode.ink);
                      }),
                  ...(showClearButton && _clearActive
                      ? [
                          IconButton(
                              icon: Icon(
                                  PlatformIcons(context).clearThickCircled,
                                  semanticLabel: "Clear"),
                              color: buttonColor,
                              disabledColor: theme.disabledColor.withOpacity(0),
                              onPressed: !_clearActive
                                  ? null
                                  : () {
                                      widget.onCleared?.call();
                                      controller.clear();
                                      FocusScope.of(context)
                                          .requestFocus(focusNode);
                                      context
                                          .read<SearchQueryState>()
                                          .updateSearchQuery("");
                                    })
                        ]
                      : [])
                ]),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  borderSide: const BorderSide(width: 2.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  borderSide:
                      BorderSide(width: 2.0, color: theme.colorScheme.primary),
                ),
              ),
              onChanged: (query) {
                context.read<SearchQueryState>().updateSearchQuery(query);
                widget.onChanged?.call(query);
              },
              onSubmitted: (String val) async {
                if (widget.closeOnSubmit) {
                  await Navigator.maybePop(context);
                }

                if (widget.clearOnSubmit) {
                  controller.clear();
                }
                widget.onSubmitted?.call(val);
              },
              autofocus: false,
              controller: controller,
            )));

    return switch (romanization) {
      Romanization.jyutping => textField,
      Romanization.yale => Column(mainAxisSize: MainAxisSize.min, children: [
          textField,
          const SizedBox(height: 10),
          ConstrainedBox(
            constraints: BoxConstraints(
                maxWidth: max(wideScreenThreshold * 1 / 3,
                    MediaQuery.of(context).size.width * 1 / 3)),
            child: Row(children: [
              diacriticButton("◌̄"),
              const SizedBox(width: 10),
              diacriticButton("◌́"),
              const SizedBox(width: 10),
              diacriticButton("◌̀"),
            ]),
          )
        ]),
    };
  }
}
