import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:powersync/powersync.dart';
import 'package:powersync/sqlite3_common.dart' as sqlite;
import '../powersync.dart';
import '../models/entry_item.dart';

typedef RemoveItemCallback = void Function(int entryId);
typedef AddItemCallback = Future<void> Function(int entryId);
typedef LoadedItemsCallback = void Function();

/// EntryItems represents a collection of entry items (bookmarks or history).
///
/// This class manages watching and modifying collections of entry items.
class EntryItemsState extends ChangeNotifier {
  final String tableName;
  final List<RemoveItemCallback> _onRemoveListeners = [];
  final List<AddItemCallback> _onAddListeners = [];
  final List<LoadedItemsCallback> _onLoadedListeners = [];
  List<int> _items = [];

  EntryItemsState({required this.tableName}) {
    _loadItems();
  }

  void registerLoadedItemsListener(LoadedItemsCallback listener) {
    _onLoadedListeners.add(listener);
  }

  void unregisterLoadedItemsListener(LoadedItemsCallback listener) {
    _onLoadedListeners.remove(listener);
  }

  void registerRemoveItemListener(RemoveItemCallback listener) {
    _onRemoveListeners.add(listener);
  }

  void unregisterRemoveItemListener(RemoveItemCallback listener) {
    _onRemoveListeners.remove(listener);
  }

  void registerAddItemListener(AddItemCallback listener) {
    _onAddListeners.add(listener);
  }

  void unregisterAddItemListener(AddItemCallback listener) {
    _onAddListeners.remove(listener);
  }

  List<int> get items => _items;

  Future<void> _loadItems() async {
    final results =
        await db.getAll('SELECT * FROM $tableName ORDER BY time DESC');
    _items =
        removeDuplicates(results.map((row) => row['entry_id'] as int).toList());
    for (final listener in _onLoadedListeners) {
      listener();
    }
    notifyListeners();
  }

  Future<void> addItem(int entryId) async {
    await db.execute(
      'INSERT INTO $tableName (id, entry_id, time, owner_id) VALUES (?, ?, ?, ?)',
      [uuid.v4(), entryId, DateTime.now().millisecondsSinceEpoch, getUserId()],
    );
    _items.insert(0, entryId);
    for (final listener in _onAddListeners) {
      await listener(entryId);
    }
    notifyListeners();
  }

  Future<void> removeItem(int entryId) async {
    await removeItems([entryId]);
  }

  Future<void> removeItems(List<int> entryIds) async {
    if (entryIds.isEmpty) return;

    // debugPrint('Removing ${entryIds.length} items from $tableName');
    // Delete in batches of 100 to avoid too many parameters in IN clause
    for (var i = 0; i < entryIds.length; i += 100) {
      final batchIds = entryIds.sublist(i, min(i + 100, entryIds.length));
      final placeholders = List.filled(batchIds.length, '?').join(',');
      await db.execute(
        'DELETE FROM $tableName WHERE entry_id IN ($placeholders)',
        batchIds,
      );
      
      // Update state and notify listeners for this batch
      _items.removeWhere((id) => batchIds.contains(id));
      for (final entryId in batchIds) {
        for (final listener in _onRemoveListeners) {
          listener(entryId);
        }
      }
      notifyListeners();
    }
    // debugPrint('Removed ${entryIds.length} items from $tableName');
  }

  bool isItemInStore(int entryId) {
    return _items.contains(entryId);
  }

  Future<void> toggleItem(int entryId) async {
    if (!isItemInStore(entryId)) {
      await addItem(entryId);
    } else {
      await removeItem(entryId);
    }
  }
}

List<T> removeDuplicates<T>(List<T> inputList) {
  final seen = <T>{};
  return inputList.where((element) => seen.add(element)).toList();
}
