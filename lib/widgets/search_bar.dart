// Copyright (c) 2017, Spencer. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:provider/provider.dart';
import 'package:wordshk/states/input_mode_state.dart';
import 'package:wordshk/states/search_romanization_state.dart';
import 'package:wordshk/states/speech_recognition_state.dart';
import 'package:wordshk/utils.dart';
import 'package:wordshk/widgets/search_mode_button.dart';
import 'package:wordshk/widgets/search_mode_radio_list_tile.dart';

import '../bridge_generated.dart' show Romanization;
import '../constants.dart';
import '../models/input_mode.dart';
import '../models/search_mode.dart';
import '../states/search_mode_state.dart';
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

    context.read<InputModeState>().setSearchFieldFocusNode(focusNode);
    context
        .read<SearchQueryState>()
        .setSearchBarCallbacks(typeCharacter, backspace, moveToEndOfSelection);

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

    var keyboardVisibilityController = KeyboardVisibilityController();

    // Subscribe
    keyboardSubscription =
        keyboardVisibilityController.onChange.listen((bool visible) {
      if (!visible) {
        focusNode.unfocus();
      }
    });

    context.read<SpeechRecognitionState>().setOnResult(typeCharacters);
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

  Widget digitButton(int digit) =>
      button(() => typeDigit(digit), Text(digit.toString()));

  Widget inkInputModeButton() => button(() {
        context.read<InputModeState>().updateInputMode(InputMode.ink);
      },
          Icon(isMaterial(context)
              ? Icons.brush
              : CupertinoIcons.pencil_outline));

  Widget speechInputModeButton() => button(
      () => showSpeechRecognitionDialog(context),
      Icon(isMaterial(context) ? Icons.mic_rounded : CupertinoIcons.mic_fill));

  Widget button(void Function() onPressed, Widget child) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 3),
        child: ElevatedButton(
            onPressed: onPressed,
            child: child,
            style: ButtonStyle(
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              minimumSize: MaterialStateProperty.all(Size.zero),
              textStyle: MaterialStateProperty.all(
                  Theme.of(context).textTheme.bodyLarge),
              foregroundColor: MaterialStateProperty.all(
                  MediaQuery.of(context).platformBrightness == Brightness.light
                      ? blackColor
                      : whiteColor),
              backgroundColor: MaterialStateProperty.all(
                  MediaQuery.of(context).platformBrightness == Brightness.light
                      ? whiteColor
                      : Colors.grey[700]),
              visualDensity: VisualDensity.compact,
              padding: MaterialStateProperty.all(
                  const EdgeInsets.symmetric(horizontal: 10.5, vertical: 12)),
            )),
      );

  /// Creates the [KeyboardActionsConfig] to hook up the fields
  /// and their focus nodes to our [FormKeyboardActions].
  KeyboardActionsConfig _buildKeyboardActionsConfig(BuildContext context) {
    return KeyboardActionsConfig(
      keyboardActionsPlatform: KeyboardActionsPlatform.ALL,
      keyboardBarColor:
          MediaQuery.of(context).platformBrightness == Brightness.light
              ? Colors.grey[200]
              : Colors.grey[900],
      nextFocus: false,
      actions: [
        KeyboardActionsItem(
          focusNode: focusNode,
          displayActionBar:
              context.watch<InputModeState>().mode == InputMode.keyboard,
          displayArrows: false,
          displayDoneButton: false,
          toolbarButtons: [
            (_) => digitButton(1),
            (_) => digitButton(2),
            (_) => digitButton(3),
            (_) => digitButton(4),
            (_) => digitButton(5),
            (_) => digitButton(6),
            (_) => const Spacer(),
            (_) => inkInputModeButton(),
            (_) => speechInputModeButton(),
          ],
          toolbarAlignment: MainAxisAlignment.start,
        ),
      ],
    );
  }

  /// Builds the search bar!
  ///
  /// The leading will always be a back button.
  /// backgroundColor is determined by the value of inBar
  /// title is always a [TextField] with the key 'SearchBarTextField', and various text stylings based on [inBar]. This is also where [onSubmitted] has its listener registered.
  ///
  @override
  AppBar build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    Color? buttonColor = theme.textTheme.bodyMedium!.color;
    final textColor = theme.textTheme.bodyMedium!.color;

    final searchRomanization =
        context.watch<SearchRomanizationState>().romanization;
    final searchRomanizationName =
        getRomanizationName(searchRomanization, AppLocalizations.of(context)!);
    late final String searchRomanizationExample;
    switch (searchRomanization) {
      case Romanization.Jyutping:
        searchRomanizationExample = "hou2 coi2";
        break;
      case Romanization.YaleNumbers:
        searchRomanizationExample = "hou2 choi2";
        break;
      case Romanization.CantonesePinyin:
        searchRomanizationExample = "hou2 tsoi2";
        break;
      case Romanization.SidneyLau:
        searchRomanizationExample = "ho2 choi2";
        break;
      default:
        throw "Unsupported romanization $searchRomanization in search_bar.dart";
    }

    searchModeRadioListTile(
            SearchMode mode, String subtitle, SearchMode groupMode) =>
        SearchModeRadioListTile(
          activeColor: blueColor,
          title: Text(
            translateSearchMode(
                mode, searchRomanizationName, AppLocalizations.of(context)!),
            textAlign: TextAlign.end,
          ),
          subtitle: Text(subtitle, textAlign: TextAlign.end),
          value: mode,
          groupValue: groupMode,
          onChanged: (SearchMode? value) {
            if (value != null) {
              context
                  .read<SearchModeState>()
                  .updateSearchModeAndCloseSelector(value);
            } else {
              context.read<SearchModeState>().toggleSearchModeSelector();
            }
          },
          searchTextFieldFocusNode: focusNode,
          autofocus: true,
        );

    return AppBar(
      titleSpacing: 0.0,
      title: !isSearching.value
          ? null
          : Consumer<SearchModeState>(
              builder: (context, searchModeState, child) => Padding(
                padding: const EdgeInsets.only(right: 10, top: 2),
                child: SizedBox(
                    height: 42,
                    child: KeyboardActions(
                        config: _buildKeyboardActionsConfig(context),
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
                          enableSuggestions: false,
                          keyboardType: context.watch<InputModeState>().mode ==
                                  InputMode.keyboard
                              ? TextInputType.text
                              : TextInputType.none,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Theme.of(context).canvasColor,
                            contentPadding:
                                const EdgeInsets.only(left: 8, top: -4),
                            hintText: translateSearchMode(
                                searchModeState.mode,
                                searchRomanizationName,
                                AppLocalizations.of(context)!),
                            hintStyle: TextStyle(
                              color: textColor,
                            ),
                            suffixIcon: // Show an icon if clear is not active, so there's no ripple on tap
                                showClearButton
                                    ? IconButton(
                                        icon: Icon(PlatformIcons(context).clear,
                                            semanticLabel: "Clear"),
                                        color: buttonColor,
                                        disabledColor:
                                            theme.disabledColor.withOpacity(0),
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
                                    : null,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            border: InputBorder.none,
                          ),
                          onChanged: (query) {
                            context
                                .read<SearchQueryState>()
                                .updateSearchQuery(query);
                            if (widget.onChanged != null) {
                              widget.onChanged!(query);
                            }
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
                          autofocus: true,
                          controller: controller,
                        ))),
              ),
            ),
      actions: [
        Consumer<SearchModeState>(
            builder: (context, searchModeState, child) => PortalTarget(
                visible: searchModeState.showSearchModeSelector,
                anchor: const Aligned(
                  follower: Alignment.topRight,
                  target: Alignment.bottomRight,
                  offset: Offset(0, 4),
                ),
                portalFollower: Material(
                    color: Theme.of(context).canvasColor,
                    child: Container(
                      width: 270,
                      height: 290,
                      decoration: BoxDecoration(
                        border: Border(
                          left:
                              BorderSide(width: 2.0, color: theme.dividerColor),
                          bottom:
                              BorderSide(width: 2.0, color: theme.dividerColor),
                        ),
                        color: Theme.of(context).canvasColor,
                      ),
                      child: Consumer<SearchModeState>(
                          builder: (context, searchModeState, child) => Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: <Widget>[
                                    searchModeRadioListTile(
                                        SearchMode.combined,
                                        "好彩/$searchRomanizationExample/lucky",
                                        searchModeState.mode),
                                    const Divider(thickness: 2),
                                    searchModeRadioListTile(SearchMode.variant,
                                        "好彩", searchModeState.mode),
                                    const Divider(thickness: 2),
                                    searchModeRadioListTile(
                                        SearchMode.pr,
                                        searchRomanizationExample,
                                        searchModeState.mode),
                                    const Divider(thickness: 2),
                                    searchModeRadioListTile(SearchMode.english,
                                        "lucky", searchModeState.mode),
                                  ])),
                    )),
                child: SearchModeButton(
                  getMode: (mode) => mode,
                  highlighted: true,
                  inAppBar: true,
                  onPressed: () => context
                      .read<SearchModeState>()
                      .toggleSearchModeSelector(),
                ))),
      ],
    );
  }
}
