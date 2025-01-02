import 'dart:async';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:powersync/sqlite3_common.dart' as sqlite;
import '../powersync.dart';

/// EntryItems represents a collection of entry items (bookmarks or history).
///
/// This class manages watching and modifying collections of entry items.
class EntryItemsState extends ChangeNotifier {
  final String tableName;
  List<int> _items = [];

  StreamSubscription<List<sqlite.Row>>? _subscription;

  EntryItemsState({required this.tableName}) {
    watchChanges();
  }

  @override
  void dispose() {
    super.dispose();
    _subscription?.cancel();
  }

  List<int> get items => _items;

  void watchChanges() {
    debugPrint('entry_items_state.dart: watchChanges');
    _subscription?.cancel();
    _subscription = db
        .watch('SELECT * FROM $tableName ORDER BY time DESC')
        .listen((results) {
      _items = removeDuplicates(
          results.map((row) => row['entry_id'] as int).toList());
      notifyListeners();
      debugPrint(
          "$tableName changed and now has ${_items.length} items (${results.length} before deduplication)");
    });
  }

  Future<void> addItem(int entryId) async {
    if (isItemInStore(entryId)) {
      await db.execute('''
      UPDATE $tableName SET time = datetime()
      WHERE entry_id = ?''', [entryId]);
    } else {
      await db.execute('''
      INSERT INTO $tableName (id, time, entry_id, owner_id)
      VALUES (uuid(), datetime(), ?, ?)
    ''', [entryId, getUserId()]);
    }
  }

  Future<void> clearItems() async {
    await db.execute('DELETE FROM $tableName');
  }

  Future<void> removeItem(int entryId) async {
    await removeItems([entryId]);
  }

  Future<void> removeItems(List<int> entryIds, {int batchSize = 500}) async {
    if (entryIds.isEmpty) return;

    // debugPrint('Removing ${entryIds.length} items from $tableName');
    // Delete in batches to avoid too many parameters in IN clause
    for (var i = 0; i < entryIds.length; i += batchSize) {
      final batchIds = entryIds.sublist(i, min(i + batchSize, entryIds.length));
      final placeholders = List.filled(batchIds.length, '?').join(',');
      await db.execute(
        'DELETE FROM $tableName WHERE entry_id IN ($placeholders)',
        batchIds,
      );
    }
  }

  Future<void> toggleItem(int entryId) async {
    if (isItemInStore(entryId)) {
      removeItem(entryId);
    } else {
      addItem(entryId);
    }
  }

  bool isItemInStore(entryId) {
    return _items.contains(entryId);
  }
}

List<T> removeDuplicates<T>(List<T> inputList) {
  final seen = <T>{};
  final result = <T>[];
  for (var element in inputList) {
    if (seen.add(element)) {
      result.add(element);
    }
  }
  return result;
}
