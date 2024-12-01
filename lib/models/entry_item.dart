import 'package:wordshk/models/schema.dart';
import 'package:powersync/sqlite3_common.dart' as sqlite;
import '../powersync.dart';

/// EntryItem represents a result row of a query on bookmarks or history tables.
///
/// This class is immutable - methods on this class do not modify the instance
/// directly. Instead, watch or re-query the data to get the updated item.
class EntryItem {
  final String id;
  final int entryId;
  final int time;
  final String tableName;

  EntryItem({
    required this.id,
    required this.entryId,
    required this.time,
    required this.tableName,
  });

  Future<void> delete() async {
    await db.execute('DELETE FROM $tableName WHERE id = ?', [id]);
  }
}
