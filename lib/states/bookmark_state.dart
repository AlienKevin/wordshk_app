import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:wordshk/main.dart';

import '../models/entry.dart';

typedef RemoveBookmarkCallback = void Function(int entryId);

class BookmarkState with ChangeNotifier {
  List<int> _bookmarks = [];
  final List<RemoveBookmarkCallback> _onRemoveListeners = [];

  BookmarkState() {
    _loadBookmarks();
  }

  // Methods to add and remove listeners
  void registerRemoveBookmarkListener(RemoveBookmarkCallback listener) {
    _onRemoveListeners.add(listener);
  }

  void unregisterRemoveBookmarkListener(RemoveBookmarkCallback listener) {
    _onRemoveListeners.remove(listener);
  }

  List<int> get bookmarks => _bookmarks;

  Future<void> _loadBookmarks() async {
    final db = await bookmarkDatabase;
    List<Map<String, dynamic>> results = List<Map<String, dynamic>>.from(await db.query('bookmarks'));
    // sort by ordering more recent bookmarks first
    results.sort((a, b) => b['time'] - a['time']);
    _bookmarks = results.map((e) => e['id'] as int).toList();
    notifyListeners();
  }

  Future<void> addBookmark(int entryId) async {
    final db = await bookmarkDatabase;
    final result = await db.insert(
      'bookmarks',
      {'id': entryId, 'time': DateTime.now().millisecondsSinceEpoch},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    if (kDebugMode) {
      print("addBookmark: $result");
    }
    _bookmarks.insert(0, entryId);
    notifyListeners();
  }

  Future<void> removeBookmark(int entryId) async {
    final db = await bookmarkDatabase;
    await db.delete('bookmarks', where: 'id = ?', whereArgs: [entryId]);
    _bookmarks.remove(entryId);
    for (final listener in _onRemoveListeners) {
      listener(entryId);
    }
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
}