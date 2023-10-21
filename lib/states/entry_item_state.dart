import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../models/entry.dart';

typedef RemoveItemCallback = void Function(int entryId);

class EntryItemState with ChangeNotifier {
  final String tableName;
  final Future<Database> Function() getDatabase;
  List<int> _items = [];
  final List<RemoveItemCallback> _onRemoveListeners = [];

  EntryItemState({required this.tableName, required this.getDatabase}) {
    _loadItems();
  }

  // Methods to add and remove listeners
  void registerRemoveItemListener(RemoveItemCallback listener) {
    _onRemoveListeners.add(listener);
  }

  void unregisterRemoveItemListener(RemoveItemCallback listener) {
    _onRemoveListeners.remove(listener);
  }

  List<int> get items => _items;

  static Future<Database> createDatabase({required String tableName, required String databaseName}) async {
    final databasesPath = await getApplicationDocumentsDirectory();

    String databasePath = join(databasesPath.path, '$databaseName.db');
    Database database = await openDatabase(databasePath, version: 1,
        onCreate: (Database db, int version) async {
          if (kDebugMode) {
            print("Create database");
          }
          await db.execute(
              'CREATE TABLE $tableName (id INTEGER PRIMARY KEY, time INTEGER)');
        });
    return database;
  }

  Future<void> _loadItems() async {
    final db = await getDatabase();
    List<Map<String, dynamic>> results = List<Map<String, dynamic>>.from(await db.query(tableName));
    // sort by ordering more recent items first
    results.sort((a, b) => b['time'] - a['time']);
    _items = results.map((e) => e['id'] as int).toList();
    notifyListeners();
  }

  Future<void> addItem(int entryId) async {
    final db = await getDatabase();
    final result = await db.insert(
      tableName,
      {'id': entryId, 'time': DateTime.now().millisecondsSinceEpoch},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    if (kDebugMode) {
      print("added to $tableName: $result");
    }
    _items.insert(0, entryId);
    notifyListeners();
  }

  Future<void> removeItem(int entryId) async {
    final db = await getDatabase();
    await db.delete(tableName, where: 'id = ?', whereArgs: [entryId]);
    _items.remove(entryId);
    for (final listener in _onRemoveListeners) {
      listener(entryId);
    }
    notifyListeners();
  }

  bool isItemInStore(List<Entry> entryGroup) {
    return entryGroup.any((entry) => _items.contains(entry.id));
  }

  int getItemEntryIndex(List<Entry> entryGroup) {
    return entryGroup.indexWhere((entry) => _items.contains(entry.id));
  }

  Future<void> toggleItem(List<Entry> entryGroup, int entryIndex) async {
    final itemIndex = getItemEntryIndex(entryGroup);
    if (itemIndex < 0) {
      await addItem(entryGroup[entryIndex].id);
    } else {
      await removeItem(entryGroup[itemIndex].id);
    }
  }
}