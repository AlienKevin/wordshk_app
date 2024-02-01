import 'package:flutter/material.dart';
import 'package:wordshk/src/rust/api/api.dart' show Script;

import '../../models/entry.dart';
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
      ? EntryVariant(
          variant: script == Script.simplified ? variantsSimp[0] : variants[0],
          variantTextStyle: variantTextStyle,
          prTextStyle: prTextStyle,
        )
      : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: variants
              .asMap()
              .entries
              .map((variant) => EntryVariant(
                    variant: script == Script.simplified
                        ? variantsSimp[variant.key]
                        : variant.value,
                    variantTextStyle: variantTextStyle,
                    prTextStyle: prTextStyle,
                  ))
              .toList());
}
