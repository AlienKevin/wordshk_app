// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wordshk/widgets/search_mode_button.dart';

import '../main.dart';
import '../models/search_mode.dart';

class SearchModeRadioListTile<T> extends StatelessWidget {
  /// Creates a combination of a list tile and a radio button.
  ///
  /// The radio tile itself does not maintain any state. Instead, when the radio
  /// button is selected, the widget calls the [onChanged] callback. Most
  /// widgets that use a radio button will listen for the [onChanged] callback
  /// and rebuild the radio tile with a new [groupValue] to update the visual
  /// appearance of the radio button.
  ///
  /// The following arguments are required:
  ///
  /// * [value] and [groupValue] together determine whether the radio button is
  ///   selected.
  /// * [onChanged] is called when the user selects this radio button.
  const SearchModeRadioListTile({
    Key? key,
    required this.value,
    required this.groupValue,
    required this.onChanged,
    required this.searchTextFieldFocusNode,
    this.activeColor,
    this.title,
    this.subtitle,
    this.isThreeLine = false,
    this.dense,
    this.secondary,
    this.selected = false,
    required this.autofocus,
    this.shape,
    this.tileColor,
    this.selectedTileColor,
    this.visualDensity,
    this.focusNode,
    this.enableFeedback,
  }) : super(key: key);

  /// The value represented by this radio button.
  final SearchMode value;

  /// The currently selected value for this group of radio buttons.
  ///
  /// This radio button is considered selected if its [value] matches the
  /// [groupValue].
  final SearchMode? groupValue;

  /// Called when the user selects this radio button.
  ///
  /// The radio button passes [value] as a parameter to this callback. The radio
  /// button does not actually change state until the parent widget rebuilds the
  /// radio tile with the new [groupValue].
  ///
  /// If null, the radio button will be displayed as disabled.
  ///
  /// The provided callback will not be invoked if this radio button is already
  /// selected.
  ///
  /// The callback provided to [onChanged] should update the state of the parent
  /// [StatefulWidget] using the [State.setState] method, so that the parent
  /// gets rebuilt; for example:
  ///
  /// ```dart
  /// RadioListTile<SingingCharacter>(
  ///   title: const Text('Lafayette'),
  ///   value: SingingCharacter.lafayette,
  ///   groupValue: _character,
  ///   onChanged: (SingingCharacter newValue) {
  ///     setState(() {
  ///       _character = newValue;
  ///     });
  ///   },
  /// )
  /// ```
  final ValueChanged<SearchMode?>? onChanged;

  /// focusNode of SearchBar's TextField
  final FocusNode searchTextFieldFocusNode;

  /// The color to use when this radio button is selected.
  ///
  /// Defaults to accent color of the current [Theme].
  final Color? activeColor;

  /// The primary content of the list tile.
  ///
  /// Typically a [Text] widget.
  final Widget? title;

  /// Additional content displayed below the title.
  ///
  /// Typically a [Text] widget.
  final Widget? subtitle;

  /// A widget to display on the opposite side of the tile from the radio button.
  ///
  /// Typically an [Icon] widget.
  final Widget? secondary;

  /// Whether this list tile is intended to display three lines of text.
  ///
  /// If false, the list tile is treated as having one line if the subtitle is
  /// null and treated as having two lines if the subtitle is non-null.
  final bool isThreeLine;

  /// Whether this list tile is part of a vertically dense list.
  ///
  /// If this property is null then its value is based on [ListTileThemeData.dense].
  final bool? dense;

  /// Whether to render icons and text in the [activeColor].
  ///
  /// No effort is made to automatically coordinate the [selected] state and the
  /// [checked] state. To have the list tile appear selected when the radio
  /// button is the selected radio button, set [selected] to true when [value]
  /// matches [groupValue].
  ///
  /// Normally, this property is left to its default value, false.
  final bool selected;

  /// {@macro flutter.widgets.Focus.autofocus}
  final bool autofocus;

  /// Defines the insets surrounding the contents of the tile.
  ///
  /// Insets the [Radio], [title], [subtitle], and [secondary] widgets
  /// in [RadioListTile].
  final EdgeInsetsGeometry contentPadding = EdgeInsets.zero;

  /// Whether this radio button is checked.
  ///
  /// To control this value, set [value] and [groupValue] appropriately.
  bool get checked => value == groupValue;

  /// If specified, [shape] defines the shape of the [RadioListTile]'s [InkWell] border.
  final ShapeBorder? shape;

  /// If specified, defines the background color for `RadioListTile` when
  /// [RadioListTile.selected] is false.
  final Color? tileColor;

  /// If non-null, defines the background color when [RadioListTile.selected] is true.
  final Color? selectedTileColor;

  /// Defines how compact the list tile's layout will be.
  ///
  /// {@macro flutter.material.themedata.visualDensity}
  final VisualDensity? visualDensity;

  /// {@macro flutter.widgets.Focus.focusNode}
  final FocusNode? focusNode;

  /// {@macro flutter.material.ListTile.enableFeedback}
  ///
  /// See also:
  ///
  ///  * [Feedback] for providing platform-specific feedback to certain actions.
  final bool? enableFeedback;

  @override
  Widget build(BuildContext context) {
    return MergeSemantics(
      child: ListTileTheme.merge(
        selectedColor: activeColor ?? Theme.of(context).toggleableActiveColor,
        child: ListTile(
          leading: secondary,
          title: title,
          subtitle: subtitle,
          trailing: Consumer<SearchModeState>(
              builder: (context, searchModeState, child) => SearchModeButton(
                    getMode: (_) => value,
                    highlighted: searchModeState.mode == value,
                    inAppBar: false,
                    onPressed: () {
                      searchModeState.updateSearchModeAndCloseSelector(
                          value, searchTextFieldFocusNode);
                    },
                  )),
          isThreeLine: isThreeLine,
          dense: dense,
          enabled: onChanged != null,
          shape: shape,
          tileColor: tileColor,
          selectedTileColor: selectedTileColor,
          onTap: onChanged != null
              ? () {
                  if (checked) {
                    onChanged!(null);
                    return;
                  } else {
                    onChanged!(value);
                  }
                }
              : null,
          selected: selected,
          autofocus: autofocus,
          contentPadding: contentPadding,
          visualDensity: visualDensity,
          focusNode: focusNode,
          enableFeedback: enableFeedback,
        ),
      ),
    );
  }
}
