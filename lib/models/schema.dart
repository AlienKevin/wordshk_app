import 'package:powersync/powersync.dart';
import 'package:wordshk/models/sync_mode.dart';

/// Schema for entry item tables (bookmarks and history)
/// Each table has an id (entry id) and timestamp fields
/// The schema supports both local-only and sync-enabled modes

const bookmarksTable = 'bookmarks';
const historyTable = 'history';

Schema makeSchema({synced = bool}) {
  String syncedName(String table) {
    if (synced) {
      return table;
    } else {
      return "inactive_synced_$table";
    }
  }

  String localName(String table) {
    if (synced) {
      return "inactive_local_$table";
    } else {
      return table;
    }
  }

  final tables = [
    const Table(bookmarksTable, [
      Column.integer('entry_id'),
      Column.integer('time'),
      Column.text('owner_id')
    ]),
    const Table(historyTable, [
      Column.integer('entry_id'),
      Column.integer('time'),
      Column.text('owner_id')
    ])
  ];

  return Schema([
    for (var table in tables)
      Table(table.name, table.columns, viewName: syncedName(table.name)),
    for (var table in tables)
      Table.localOnly('local_${table.name}', table.columns,
          viewName: localName(table.name))
  ]);
}

switchToSyncedSchema(PowerSyncDatabase db, String userId) async {
  await db.updateSchema(makeSchema(synced: true));

  // needed to ensure that watches/queries are aware of the updated schema
  await db.refreshSchema();
  await setSyncEnabled(true);

  await db.writeTransaction((tx) async {
    // Copy local-only data to the sync-enabled views
    await tx.execute(
        'INSERT INTO $bookmarksTable(id, entry_id, time, owner_id) SELECT id, entry_id, time, owner_id FROM inactive_local_$bookmarksTable');
    await tx.execute(
        'INSERT INTO $historyTable(id, entry_id, time, owner_id) SELECT id, entry_id, time, owner_id FROM inactive_local_$historyTable');

    // Delete the local-only data
    await tx.execute('DELETE FROM inactive_local_$bookmarksTable');
    await tx.execute('DELETE FROM inactive_local_$historyTable');
  });
}
