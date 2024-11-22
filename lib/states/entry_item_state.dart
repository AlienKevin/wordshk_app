import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

typedef RemoveItemCallback = void Function(int entryId);
typedef AddItemCallback = Future<void> Function(int entryId);
typedef LoadedItemsCallback = void Function();

class EntryItemState with ChangeNotifier {
  final String tableName;
  final Future<Database> Function() getDatabase;
  List<int> _items = [];
  final List<RemoveItemCallback> _onRemoveListeners = [];
  final List<AddItemCallback> _onAddListeners = [];
  final List<LoadedItemsCallback> _onLoadedListeners = [];

  EntryItemState({required this.tableName, required this.getDatabase}) {
    _loadItems();
  }

  // Methods to add and remove listeners
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

  static Future<Database> createDatabase(
      {required String tableName, required String databaseName}) async {
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
    List<Map<String, dynamic>> results =
        List<Map<String, dynamic>>.from(await db.query(tableName));
    // sort by ordering more recent items first
    results.sort((a, b) => b['time'] - a['time']);
    _items = results.map((e) => e['id'] as int).toList();
    for (final listener in _onLoadedListeners) {
      listener();
    }
    notifyListeners();
  }

  Future<void> updateItem(int entryId) async {
    if (_items.contains(entryId)) {
      // remove and add again to update time
      await removeItem(entryId);
      await addItem(entryId);
    } else {
      await addItem(entryId);
    }
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
    for (final listener in _onAddListeners) {
      await listener(entryId);
    }
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
