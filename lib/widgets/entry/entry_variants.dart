import 'package:expandable/expandable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import '../../bridge_generated.dart' show Script;
import '../../models/entry.dart';
import '../expandable.dart';
import 'entry_variant.dart';

class EntryVariants extends StatelessWidget {
  final List<Variant> variants;
  final List<Variant> variantsSimp;
  final Script script;
  final TextStyle variantTextStyle;
  final TextStyle prTextStyle;
  final TextStyle lineTextStyle;

  const EntryVariants(
      {Key? key,
      required this.variants,
      required this.variantsSimp,
      required this.script,
      required this.variantTextStyle,
      required this.prTextStyle,
      required this.lineTextStyle})
      : super(key: key);

  @override
  Widget build(BuildContext context) => variants.length <= 1
      ? SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: EntryVariant(
            variant:
                script == Script.Simplified ? variantsSimp[0] : variants[0],
            variantTextStyle: variantTextStyle,
            prTextStyle: prTextStyle,
          ))
      : ExpandableNotifier(
          child: applyExpandableTheme(Expandable(
              collapsed: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        EntryVariant(
                          variant: script == Script.Simplified
                              ? variantsSimp[0]
                              : variants[0],
                          variantTextStyle: variantTextStyle,
                          prTextStyle: prTextStyle,
                        ),
                        Builder(builder: (context) {
                          return expandButton(
                              AppLocalizations.of(context)!.entryMoreVariants,
                              isMaterial(context)
                                  ? Icons.expand_more
                                  : CupertinoIcons.chevron_down,
                              lineTextStyle.copyWith(
                                  color:
                                      Theme.of(context).colorScheme.secondary));
                        })
                      ])),
              expanded: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: variants
                                .asMap()
                                .entries
                                .map((variant) => EntryVariant(
                                      variant: script == Script.Simplified
                                          ? variantsSimp[variant.key]
                                          : variant.value,
                                      variantTextStyle: variantTextStyle,
                                      prTextStyle: prTextStyle,
                                    ))
                                .toList())),
                    Builder(builder: (context) {
                      return expandButton(
                          AppLocalizations.of(context)!.entryCollapseVariants,
                          isMaterial(context)
                              ? Icons.expand_less
                              : CupertinoIcons.chevron_up,
                          lineTextStyle.copyWith(
                              color: Theme.of(context).colorScheme.secondary));
                    })
                  ]))));
}
