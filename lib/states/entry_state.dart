import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../src/rust/api/api.dart' show getEntryId;
import 'language_state.dart';

class EntryState extends ChangeNotifier {
  String? selectedContent;
  int? entryId;
  (String, int?)? entryIdCache;

  void setSelectedContent(String? content, BuildContext context) async {
    if (content != null) {
      if (entryIdCache?.$1 == content) {
        entryId = entryIdCache!.$2;
      } else {
        entryId = await getEntryId(
            query: content, script: context.read<LanguageState>().getScript());
        entryIdCache = (content, entryId);
      }
    } else {
      entryId = null;
    }
    selectedContent = content;
    notifyListeners();
  }
}
