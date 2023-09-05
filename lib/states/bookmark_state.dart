import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/entry.dart';

class BookmarkState with ChangeNotifier {
  Database? _database;
  List<int> _bookmarks = [];

  BookmarkState() {
    _initDatabase();
  }

  List<int> get bookmarks => _bookmarks;

  Future<void> _initDatabase() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'bookmarkedEntries.db');

    // Avoid errors caused by flutter upgrade.
    WidgetsFlutterBinding.ensureInitialized();

    _database = await openDatabase(path, version: 1, onCreate: (Database db, int version) async {
      await db.execute('CREATE TABLE bookmarks (id INTEGER PRIMARY KEY, time INTEGER)');
    });

    _loadBookmarks();
  }

  Future<void> _loadBookmarks() async {
    List<Map<String, dynamic>> results = await _database!.query('bookmarks');
    // sort by ordering more recent bookmarks first
    results.sort((a, b) => b['time'] - a['time']);
    _bookmarks = results.map((e) => e['id'] as int).toList();
    notifyListeners();
  }

  Future<void> addBookmark(int entryId) async {
    await _database!.insert('bookmarks', {'id': entryId, 'time': DateTime.now().millisecondsSinceEpoch});
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