import 'package:flutter/material.dart' hide NavigationDrawer;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:wordshk/states/exercise_introduction_state.dart';
import 'package:wordshk/widgets/constrained_content.dart';

class ExercisePage extends StatelessWidget {
  const ExercisePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.exercise),
      ),
      body: ConstrainedContent(
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                elevation: 5.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: ListTile(
                  title: Text(AppLocalizations.of(context)!.toneExercise),
                  tileColor: Theme.of(context).cardColor,
                  onTap: () {
                    if (context
                        .read<ExerciseIntroductionState>()
                        .toneExerciseIntroduced) {
                      context.go("/exercise/tone");
                    } else {
                      context.go(
                          "/exercise/tone/introduction?openedInExercise=false");
                    }
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                elevation: 5.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: ListTile(
                  title: Text("Stories"),
                  tileColor: Theme.of(context).cardColor,
                  onTap: () {
                    context.go("/exercise/stories");
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
