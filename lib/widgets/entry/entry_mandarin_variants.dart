import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../models/entry.dart';

class EntryMandarinVariants extends StatelessWidget {
  final String label;
  final List<MandarinVariant> mandarinVariants;

  const EntryMandarinVariants(
      {Key? key, required this.label, required this.mandarinVariants})
      : super(key: key);

  @override
  Widget build(BuildContext context) => Visibility(
      visible: mandarinVariants.isNotEmpty,
      child: Text.rich(TextSpan(children: [
        TextSpan(
            text:
                "$label ⁠", // Use Word Joiner to mark this segment as non-splittable during selection
            style: Theme.of(context)
                .textTheme
                .bodySmall!
                .copyWith(fontWeight: FontWeight.w600)),
        ...mandarinVariants.asMap().entries.map((entry) {
          final variantIndex = entry.key;
          final variant = entry.value;
          return TextSpan(children: [
            TextSpan(
                text: variant.wordSimp,
                style: Theme.of(context).textTheme.bodyMedium),
            TextSpan(
                text: variantIndex == mandarinVariants.length - 1 ? "" : " · ")
          ]);
        }),
        WidgetSpan(
          alignment: PlaceholderAlignment.aboveBaseline,
          baseline: TextBaseline.ideographic,
          child: InkWell(
              child: SvgPicture.asset("assets/genai_icon.svg",
                  semanticsLabel: 'Generative AI Icon',
                  width: Theme.of(context).textTheme.bodySmall!.fontSize,
                  colorFilter: ColorFilter.mode(
                      Theme.of(context).colorScheme.secondary,
                      BlendMode.srcIn)),
              onTap: () {
                final buttonTextColor =
                    MediaQuery.of(context).platformBrightness ==
                            Brightness.light
                        ? Theme.of(context).colorScheme.secondary
                        : Theme.of(context).colorScheme.onPrimary;

                showDialog(
                  useRootNavigator: false,
                  context: context,
                  builder: (_) => AlertDialog(
                    content: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 200),
                        child: const Text(
                            "普通话翻译由人工智能生成，仅供参考。如有错漏敬请谅解，我们会持续改善翻译质量。")),
                    actions: [
                      TextButton(
                        child: Text("OK",
                            style: TextStyle(color: buttonTextColor)),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  ),
                );
              }),
        ),
      ])));
}
