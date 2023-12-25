import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:provider/provider.dart';
import 'package:wordshk/custom_page_route.dart';
import 'package:wordshk/pages/quality_control_page.dart';
import 'package:wordshk/states/bookmark_state.dart';

import '../../models/entry.dart';
import '../../states/player_state.dart';
import '../../utils.dart';

class EntryActionButtons extends StatelessWidget {
  final List<Entry>? entryGroup;
  final int? entryIndex;
  final bool isLoading;
  final bool hasError;
  final bool inAppBar;
  const EntryActionButtons(
      {Key? key,
      required this.entryGroup,
      required this.entryIndex,
      required this.isLoading,
      required this.hasError,
      this.inAppBar = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Visibility(
          maintainSize: inAppBar,
          maintainAnimation: true,
          maintainState: true,
          visible:
              !(isLoading || hasError || entryGroup![entryIndex!].published),
          child: Container(
            color: inAppBar ? null : Theme.of(context).primaryColor,
            child: IconButton(
              onPressed: () {
                context.read<PlayerState>().stop();
                showDialog(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                          icon: Icon(isMaterial(context)
                              ? Icons.warning_amber_outlined
                              : CupertinoIcons.exclamationmark_triangle),
                          iconColor:
                              Theme.of(context).textTheme.bodyMedium!.color!,
                          content: Text(
                              AppLocalizations.of(context)!.unpublishedWarning),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                                Navigator.push(
                                  context,
                                  CustomPageRoute(
                                      builder: (context) =>
                                          const QualityControlPage()),
                                );
                              },
                              child:
                                  Text(AppLocalizations.of(context)!.learnMore),
                            ),
                            const SizedBox(width: 10),
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child:
                                  Text(AppLocalizations.of(context)!.dismiss),
                            ),
                          ],
                        ));
              },
              icon: Icon(isMaterial(context)
                  ? Icons.warning_amber_outlined
                  : CupertinoIcons.exclamationmark_triangle),
            ),
          )),
      !(isLoading || hasError)
          ? Container(
              color: inAppBar ? null : Theme.of(context).primaryColor,
              child: Row(
                children: [
                  IconButton(
                      onPressed: () {
                        context
                            .read<BookmarkState>()
                            .toggleItem(entryGroup!, entryIndex!);
                      },
                      icon: context
                              .watch<BookmarkState>()
                              .isItemInStore(entryGroup!)
                          ? Icon(PlatformIcons(context).bookmarkSolid)
                          : Icon(PlatformIcons(context).bookmarkOutline)),
                  IconButton(
                      onPressed: () {
                        if (kDebugMode) {
                          print(entryGroup![entryIndex!].id);
                        }
                        openLink(
                            "https://words.hk/zidin/v/${entryGroup![entryIndex!].id}");
                        context.read<PlayerState>().stop();
                      },
                      icon: Icon(PlatformIcons(context).edit)),
                ],
              ),
            )
          : const SizedBox.shrink()
    ]);
  }
}
