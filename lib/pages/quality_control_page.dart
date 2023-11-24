import 'package:flutter/material.dart' hide NavigationDrawer;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../widgets/constrained_content.dart';

class QualityControlPage extends StatelessWidget {
  const QualityControlPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.qualityControl)),
      body: ConstrainedContent(
          child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Text(AppLocalizations.of(context)!.qualityControlText),
        ),
      )));
}
