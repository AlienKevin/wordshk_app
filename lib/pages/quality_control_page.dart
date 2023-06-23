import 'package:flutter/material.dart' hide NavigationDrawer;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../widgets/navigation_drawer.dart';

class QualityControlPage extends StatelessWidget {
  final bool useBackNavigation;

  const QualityControlPage({Key? key, required this.useBackNavigation})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.qualityControl)),
      drawer: useBackNavigation ? null : const NavigationDrawer(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Text(AppLocalizations.of(context)!.qualityControlText),
        ),
      ),
    );
  }
}
