import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:wordshk/models/search_bar_position.dart';
import 'package:wordshk/states/search_bar_position_state.dart';
import 'package:wordshk/widgets/constrained_content.dart';

import '../../widgets/settings/title.dart';

class SearchBarPositionSettingsPage extends StatelessWidget {
  const SearchBarPositionSettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final s = AppLocalizations.of(context)!;

    return Scaffold(
        appBar: AppBar(title: Text(s.search)),
        body: ConstrainedContent(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              SettingsTitle(
                  title: AppLocalizations.of(context)!.searchBarPosition),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () {
                      context
                          .read<SearchBarPositionState>()
                          .updateSearchBarPosition(SearchBarPosition.top);
                    },
                    child: Column(children: [
                      Text(AppLocalizations.of(context)!.top),
                      const SizedBox(height: 10),
                      SvgPicture.asset("assets/search_bar_position.svg",
                          semanticsLabel: 'Search Bar Position Top',
                          width: 100,
                          colorFilter: context
                                      .watch<SearchBarPositionState>()
                                      .getSearchBarPosition() ==
                                  SearchBarPosition.top
                              ? ColorFilter.mode(
                                  Theme.of(context).colorScheme.primary,
                                  BlendMode.srcIn)
                              : null),
                      Radio(
                        value: SearchBarPosition.top,
                        groupValue: context
                            .watch<SearchBarPositionState>()
                            .getSearchBarPosition(),
                        onChanged: (value) {
                          if (value != null) {
                            context
                                .read<SearchBarPositionState>()
                                .updateSearchBarPosition(SearchBarPosition.top);
                          }
                        },
                      ),
                    ]),
                  ),
                  GestureDetector(
                      onTap: () {
                        context
                            .read<SearchBarPositionState>()
                            .updateSearchBarPosition(SearchBarPosition.bottom);
                      },
                      child: Column(children: [
                        Text(AppLocalizations.of(context)!.bottom),
                        const SizedBox(height: 10),
                        Transform.rotate(
                          angle: math.pi,
                          child: SvgPicture.asset(
                            "assets/search_bar_position.svg",
                            semanticsLabel: 'Search Bar Position Bottom',
                            width: 100,
                            colorFilter: context
                                        .watch<SearchBarPositionState>()
                                        .getSearchBarPosition() ==
                                    SearchBarPosition.bottom
                                ? ColorFilter.mode(
                                    Theme.of(context).colorScheme.primary,
                                    BlendMode.srcIn)
                                : null,
                          ),
                        ),
                        Radio(
                          value: SearchBarPosition.bottom,
                          groupValue: context
                              .watch<SearchBarPositionState>()
                              .getSearchBarPosition(),
                          onChanged: (value) {
                            if (value != null) {
                              context
                                  .read<SearchBarPositionState>()
                                  .updateSearchBarPosition(
                                      SearchBarPosition.bottom);
                            }
                          },
                        ),
                      ]))
                ],
              ),
            ]),
          ),
        ));
  }
}
