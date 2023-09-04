import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/entry.dart';

class BookmarkState with ChangeNotifier {
  Database? _database;
  List<int> _bookmarks = [];

  BookmarkState() {
    _initDatabase();
  }

  Future<void> _initDatabase() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'bookmarkedEntries.db');

    _database = await openDatabase(path, version: 1, onCreate: (Database db, int version) async {
      await db.execute('CREATE TABLE bookmarks (id INTEGER PRIMARY KEY)');
    });

    _loadBookmarks();
  }

  Future<void> _loadBookmarks() async {
    List<Map<String, dynamic>> results = await _database!.query('bookmarks');
    _bookmarks = results.map((e) => e['id'] as int).toList();
    notifyListeners();
  }

  Future<void> addBookmark(int entryId) async {
    await _database!.insert('bookmarks', {'id': entryId});
    _bookmarks.add(entryId);
    notifyListeners();
  }

  Future<void> removeBookmark(int entryId) async {
    await _database!.delete('bookmarks', where: 'id = ?', whereArgs: [entryId]);
    _bookmarks.remove(entryId);
    notifyListeners();
  }

  bool isBookmarked(List<Entry> entryGroup) {
    return entryGroup.any((entry) => _bookmarks.contains(entry.id));
  }

  int getBookmarkedEntryIndex(List<Entry> entryGroup) {
    return entryGroup.indexWhere((entry) => _bookmarks.contains(entry.id));
  }

  Future<void> toggleBookmark(List<Entry> entryGroup, int entryIndex) async {
    final bookmarkedIndex = getBookmarkedEntryIndex(entryGroup);
    if (bookmarkedIndex < 0) {
      await addBookmark(entryGroup[entryIndex].id);
    } else {
      await removeBookmark(entryGroup[bookmarkedIndex].id);
    }
  }

  Future<void> disposeDatabase() async {
    await _database!.close();
  }

  @override
  void dispose() {
    disposeDatabase();
    super.dispose();
  }
}