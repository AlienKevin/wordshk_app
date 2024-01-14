import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:provider/provider.dart';

import '../../constants.dart';
import '../../models/entry.dart';
import '../../states/bookmark_state.dart';

class EntryLabels extends StatelessWidget {
  final int entryId;
  final List<Pos> poses;
  final List<Label> labels;

  const EntryLabels(
      {Key? key,
      required this.entryId,
      required this.poses,
      required this.labels})
      : super(key: key);

  @override
  Widget build(BuildContext context) => Visibility(
        visible: poses.isNotEmpty || labels.isNotEmpty,
        child: Builder(
            builder: (context) => Padding(
                padding: const EdgeInsets.only(top: 5),
                child: Wrap(
                  spacing: 5,
                  children: [
                    ...[
                      poses
                          .map((pos) =>
                              translatePos(pos, AppLocalizations.of(context)!))
                          .join("/"),
                      ...labels.map((label) =>
                          translateLabel(label, AppLocalizations.of(context)!))
                    ].map((label) => Chip(
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        visualDensity: VisualDensity.compact,
                        shape: const RoundedRectangleBorder(
                            side: BorderSide(style: BorderStyle.none),
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        padding: EdgeInsets.zero,
                        labelPadding: const EdgeInsets.only(
                            left: 10, right: 10, bottom: 2),
                        labelStyle: Theme.of(context)
                            .textTheme
                            .bodySmall!
                            .copyWith(
                                color:
                                    MediaQuery.of(context).platformBrightness ==
                                            Brightness.dark
                                        ? Colors.white
                                        : Colors.black),
                        backgroundColor: label ==
                                translateLabel(
                                    Label.vulgar, AppLocalizations.of(context)!)
                            ? redColor
                            : Theme.of(context).splashColor,
                        label: Text(label))),
                    ConstrainedBox(
                      constraints: BoxConstraints(
                          maxHeight: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .fontSize! *
                              1.5),
                      child: IconButton(
                          color: Theme.of(context).textTheme.bodyMedium!.color,
                          iconSize: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .fontSize! *
                              1.5,
                          visualDensity: VisualDensity.compact,
                          onPressed: () {
                            context.read<BookmarkState>().toggleItem(entryId);
                          },
                          icon: context
                                  .watch<BookmarkState>()
                                  .isItemInStore(entryId)
                              ? Icon(PlatformIcons(context).bookmarkSolid)
                              : Icon(PlatformIcons(context).bookmarkOutline)),
                    ),
                  ],
                ))),
      );
}
