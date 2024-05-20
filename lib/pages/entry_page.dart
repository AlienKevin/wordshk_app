import 'dart:convert';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:wordshk/states/language_state.dart';
import 'package:wordshk/widgets/constrained_content.dart';

import '../models/embedded.dart';
import '../models/entry.dart';
import '../src/rust/api/api.dart';
import '../states/player_state.dart';
import '../widgets/entry/entry.dart';

class EntryPage extends StatefulWidget {
  final int id;
  final bool showFirstEntryInGroupInitially;
  final int? defIndex;
  final Embedded embedded;

  const EntryPage({
    Key? key,
    required this.id,
    required this.showFirstEntryInGroupInitially,
    this.defIndex,
    this.embedded = Embedded.topLevel,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _EntryPageState();
}

class _EntryPageState extends State<EntryPage> {
  int? initialEntryIndex;
  List<Entry>? entryGroup;
  bool hasError = false;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    () async {
      try {
        final json = await getEntryGroupJson(id: widget.id);
        if (!mounted) {
          return;
        }
        setState(() {
          entryGroup = json
              .map((entryJson) => Entry.fromJson(jsonDecode(entryJson)))
              .toList();
          initialEntryIndex = widget.showFirstEntryInGroupInitially
              ? 0
              : entryGroup!.indexWhere((entry) => entry.id == widget.id);
          isLoading = false;
        });
      } catch (err) {
        if (kDebugMode) {
          print(err);
        }
        if (!mounted) {
          return;
        }
        setState(() {
          hasError = true;
          isLoading = false;
        });
      }
    }();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
        // detect user pressing back button
        canPop: true,
        onPopInvoked: (didPop) {
          // TODO: wait for go_router to be fixed: https://github.com/flutter/flutter/issues/138737
          if (didPop) {
            context.read<PlayerState>().refreshPlayerState();
          }
        },
        child: Scaffold(
          body: switch (widget.embedded) {
            Embedded.topLevel =>
              SafeArea(child: ConstrainedContent(child: showEntry())),
            Embedded.embedded || Embedded.nestedInEmbedded => showEntry(),
          },
        ));
  }

  showEntry() {
    if (hasError) {
      log("Entry page failed to load due to an error.");
      return Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(children: [
          Text(AppLocalizations.of(context)!.entryFailedToLoad),
          const SizedBox(height: 20),
          ElevatedButton(
              onPressed: () {
                context.go("/");
              },
              child: Text(AppLocalizations.of(context)!.backToSearch))
        ]),
      );
    } else if (isLoading) {
      return Container();
    } else {
      return EntryWidget(
        entryGroup: entryGroup!,
        initialEntryIndex: initialEntryIndex!,
        initialDefIndex: widget.defIndex,
        onTapLink: (entryVariant) {
          log("Tapped on link $entryVariant");
          getEntryId(
                  query: entryVariant,
                  script: context.read<LanguageState>().getScript())
              .then((id) {
            context.read<PlayerState>().refreshPlayerState();
            if (id == null) {
              context.push("/entry/not-published/$entryVariant");
            } else {
              final embedded = widget.embedded == Embedded.embedded ||
                      widget.embedded == Embedded.nestedInEmbedded
                  ? Embedded.nestedInEmbedded
                  : Embedded.topLevel;
              // TODO: Figure out how to use ShellRouter from GoRouter
              // context.push("/entry/id/$id?showFirstInGroup=true&embedded=${embedded.name}");
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => EntryPage(
                          id: id,
                          showFirstEntryInGroupInitially: true,
                          embedded: embedded,
                        )),
              );
            }
          });
        },
      );
    }
  }
}
