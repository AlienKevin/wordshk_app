import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:wordshk/widgets/constrained_content.dart';

class EntryNotPublishedPage extends StatelessWidget {
  final String entryVariant;

  const EntryNotPublishedPage({Key? key, required this.entryVariant})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.entryNotPublished),
      ),
      body: ConstrainedContent(
        child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Text(AppLocalizations.of(context)!
                    .entryNotPublishedText(entryVariant)),
                const SizedBox(
                  height: 30,
                ),
                ElevatedButton(
                  onPressed: () {
                    // Navigate back to first route when tapped.
                    Navigator.pop(context);
                  },
                  child: const Text('Go back'),
                ),
              ],
            )),
      ),
    );
  }
}
