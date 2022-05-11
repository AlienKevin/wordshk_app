// Copyright (c) 2017, Spencer. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'constants.dart';

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

  /// The type of keyboard to use for editing the search bar text. Defaults to 'TextInputType.text'.
  final TextInputType keyboardType;

  const SearchBar({
    this.onSubmitted,
    this.closeOnSubmit = false,
    this.clearOnSubmit = false,
    this.onChanged,
    this.onClosed,
    this.onCleared,
    this.keyboardType = TextInputType.text,
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

  @override
  void initState() {
    super.initState();
    controller.addListener(() {
      log("Controller addListener activated.");
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
  void beginSearch(context) {
    // ModalRoute.of(context)!
    //     .addLocalHistoryEntry(LocalHistoryEntry(onRemove: () {
    // setState(() {
    //   isSearching.value = false;
    // });
    // }));

    setState(() {
      isSearching.value = true;
    });
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
    Color? buttonColor = theme.iconTheme.color;

    return AppBar(
      leading: !isSearching.value
          ? null
          : IconButton(
              icon: const BackButtonIcon(),
              color: buttonColor,
              tooltip: MaterialLocalizations.of(context).backButtonTooltip,
              onPressed: () {
                widget.onClosed?.call();
                controller.clear();
                Navigator.maybePop(context);
              }),
      title: !isSearching.value
          ? null
          : Directionality(
              textDirection: Directionality.of(context),
              child: TextField(
                style: const TextStyle(color: whiteColor),
                focusNode: focusNode,
                onTap: () => beginSearch(context),
                cursorColor: whiteColor,
                key: const Key('SearchBarTextField'),
                keyboardType: widget.keyboardType,
                decoration: InputDecoration(
                    hintText:
                        AppLocalizations.of(context)!.searchDictionaryHintText,
                    hintStyle: const TextStyle(
                      color: whiteColor,
                    ),
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    border: InputBorder.none),
                onChanged: widget.onChanged,
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
              ),
            ),
      actions: !showClearButton
          ? null
          : <Widget>[
              // Show an icon if clear is not active, so there's no ripple on tap
              IconButton(
                  icon: const Icon(Icons.clear, semanticLabel: "Clear"),
                  color: buttonColor,
                  disabledColor: theme.disabledColor.withOpacity(0),
                  onPressed: !_clearActive
                      ? null
                      : () {
                          widget.onCleared?.call();
                          controller.clear();
                          FocusScope.of(context).requestFocus(focusNode);
                        }),
            ],
    );
  }
}
