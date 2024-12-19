// This file performs setup of the PowerSync database
import 'dart:io';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:powersync/powersync.dart';
import 'package:wordshk/models/sync_mode.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

import './app_config.dart';
import './models/schema.dart';
import './supabase.dart';

final log = Logger('powersync-supabase');

/// Postgres Response codes that we cannot recover from by retrying.
final List<RegExp> fatalResponseCodes = [
  // Class 22 — Data Exception
  // Examples include data type mismatch.
  RegExp(r'^22...$'),
  // Class 23 — Integrity Constraint Violation.
  // Examples include NOT NULL, FOREIGN KEY and UNIQUE violations.
  RegExp(r'^23...$'),
  // INSUFFICIENT PRIVILEGE - typically a row-level security violation
  RegExp(r'^42501$'),
];

/// Use Supabase for authentication and data upload.
class SupabaseConnector extends PowerSyncBackendConnector {
  Future<void>? _refreshFuture;

  SupabaseConnector();

  /// Get a Supabase token to authenticate against the PowerSync instance.
  @override
  Future<PowerSyncCredentials?> fetchCredentials() async {
    // Wait for pending session refresh if any
    await _refreshFuture;

    // Use Supabase token for PowerSync
    final session = Supabase.instance.client.auth.currentSession;
    if (session == null) {
      // Not logged in
      return null;
    }

    // Use the access token to authenticate against PowerSync
    final token = session.accessToken;
    debugPrint('supabase session token is $token');

    // userId and expiresAt are for debugging purposes only
    final userId = session.user.id;
    final expiresAt = session.expiresAt == null
        ? null
        : DateTime.fromMillisecondsSinceEpoch(session.expiresAt! * 1000);
    return PowerSyncCredentials(
        endpoint: AppConfig.powersyncUrl,
        token: token,
        userId: userId,
        expiresAt: expiresAt);
  }

  @override
  void invalidateCredentials() {
    // Trigger a session refresh if auth fails on PowerSync.
    // Generally, sessions should be refreshed automatically by Supabase.
    // However, in some cases it can be a while before the session refresh is
    // retried. We attempt to trigger the refresh as soon as we get an auth
    // failure on PowerSync.
    //
    // This could happen if the device was offline for a while and the session
    // expired, and nothing else attempt to use the session it in the meantime.
    //
    // Timeout the refresh call to avoid waiting for long retries,
    // and ignore any errors. Errors will surface as expired tokens.
    _refreshFuture = Supabase.instance.client.auth
        .refreshSession()
        .timeout(const Duration(seconds: 5))
        .then((response) => null, onError: (error) => null);
  }

  // Upload pending changes to Supabase.
  @override
  Future<void> uploadData(PowerSyncDatabase database) async {
    // This function is called whenever there is data to upload, whether the
    // device is online or offline.
    // If this call throws an error, it is retried periodically.
    final transaction = await database.getNextCrudTransaction();
    if (transaction == null) {
      return;
    }

    final rest = Supabase.instance.client.rest;
    try {
      // Group operations by type and table
      final putOps = <String, List<Map<String, dynamic>>>{};
      final deleteOps = <String, List<String>>{};
      final patchOps = <CrudEntry>[];

      // Organize operations
      for (final op in transaction.crud) {
        switch (op.op) {
          case UpdateType.put:
            putOps.putIfAbsent(op.table, () => []);
            var data = Map<String, dynamic>.of(op.opData!);
            data['id'] = op.id;
            putOps[op.table]!.add(data);
          case UpdateType.patch:
            patchOps.add(op);
          case UpdateType.delete:
            deleteOps.putIfAbsent(op.table, () => []);
            deleteOps[op.table]!.add(op.id);
        }
      }

      debugPrint('Number of putOps: ${putOps.length}');
      debugPrint('Number of deleteOps: ${deleteOps.length}');
      debugPrint('Number of patchOps: ${patchOps.length}');

      // Execute bulk operations
      for (final table in putOps.keys) {
        await rest.from(table).upsert(putOps[table]!);
      }

      // Delete in batches to prevent 414 URI too long error on Android
      const batchSize = 100;
      for (final table in deleteOps.keys) {
        final ids = deleteOps[table]!;
        for (var i = 0; i < ids.length; i += batchSize) {
          final chunk = ids.sublist(i, min(i + batchSize, ids.length));
          await rest.from(table).delete().inFilter('id', chunk);
        }
      }

      // Execute PATCH operations individually since they can't be easily batched
      for (final op in patchOps) {
        await rest.from(op.table).update(op.opData!).eq('id', op.id);
      }

      await transaction.complete();
    } on PostgrestException catch (e) {
      if (e.code != null &&
          fatalResponseCodes.any((re) => re.hasMatch(e.code!))) {
        /// Instead of blocking the queue with these errors,
        /// discard the (rest of the) transaction.
        ///
        /// Note that these errors typically indicate a bug in the application.
        /// If protecting against data loss is important, save the failing records
        /// elsewhere instead of discarding, and/or notify the user.
        log.severe('Data upload error - discarding transaction', e);
        await transaction.complete();
      } else {
        debugPrint('Data upload error: $e');
        // Error may be retryable - e.g. network error or temporary server error.
        // Throwing an error here causes this call to be retried after a delay.
        rethrow;
      }
    }
  }
}

/// Global reference to the database
late PowerSyncDatabase db;

bool isLoggedIn() {
  return Supabase.instance.client.auth.currentSession?.accessToken != null;
}

/// id of the user currently logged in
String getUserId() {
  // Consider options like https://dev.fingerprint.com/docs/identification-vs-fingerprintjs
  // for  generating a local-only identity.
  return Supabase.instance.client.auth.currentSession?.user.id ??
      '00000000-0000-0000-0000-000000000000'; // default ID supplied for local-only mode
}

Future<String> getDatabasePath() async {
  const dbFilename = 'powersync-demo-local-only.db';
  // getApplicationSupportDirectory is not supported on Web
  if (kIsWeb) {
    return dbFilename;
  }
  final dir = await getApplicationSupportDirectory();
  return join(dir.path, dbFilename);
}

Future<void> openDatabase() async {
  await _openDatabase();

  await loadSupabase();
  if (isLoggedIn()) {
    // If the user is already logged in, connect immediately.
    // Otherwise, connect once logged via login/signup view.
    await connectDatabase();
  } else {
    // If database is empty, check by querying tables properly
    final isEmpty =
        (await db.execute('SELECT COUNT(*) as count FROM $bookmarksTable'))
                    .first['count'] ==
                0 &&
            (await db.execute('SELECT COUNT(*) as count FROM $historyTable'))
                    .first['count'] ==
                0;

    if (isEmpty) {
      final databasesPath = await getApplicationDocumentsDirectory();
      // Check and copy bookmarks
      final bookmarksDbPath = join(databasesPath.path, 'bookmarkedEntries.db');
      if (await File(bookmarksDbPath).exists()) {
        final bookmarksDb = await sqflite.openDatabase(bookmarksDbPath);
        final bookmarks = await bookmarksDb.query(bookmarksTable);
        await db.executeBatch(
            'INSERT INTO $bookmarksTable (id, entry_id, time, owner_id) VALUES (uuid(), ?, ?, ?)',
            bookmarks
                .map((bookmark) => [
                      bookmark['id'],
                      DateTime.fromMillisecondsSinceEpoch(
                              bookmark['time'] as int,
                              isUtc: true)
                          .toIso8601String(),
                      getUserId()
                    ])
                .toList());
        await bookmarksDb.close();
      }

      // Check and copy history
      final historyDbPath = join(databasesPath.path, 'historyEntries.db');
      if (await File(historyDbPath).exists()) {
        final historyDb = await sqflite.openDatabase(historyDbPath);
        final history = await historyDb.query(historyTable);
        await db.executeBatch(
            'INSERT INTO $historyTable (id, entry_id, time, owner_id) VALUES (uuid(), ?, ?, ?)',
            history
                .map((entry) => [
                      entry['id'],
                      DateTime.fromMillisecondsSinceEpoch(entry['time'] as int,
                              isUtc: true)
                          .toIso8601String(),
                      getUserId()
                    ])
                .toList());
        await historyDb.close();
      }
    }
  }
}

Future<void> _openDatabase() async {
  var isSyncMode = await getSyncEnabled();
  db = PowerSyncDatabase(
      schema: makeSchema(synced: isSyncMode),
      path: await getDatabasePath(),
      logger: attachedLogger);
  await db.initialize();
}

Future<void> connectDatabase() async {
  if (!isLoggedIn()) {
    log.severe("Can't connect database without being signed in");
  }
  SupabaseConnector? currentConnector;
  var isSyncMode = await getSyncEnabled();

  if (!isSyncMode) {
    await switchToSyncedSchema(db, getUserId());
  }

  currentConnector = SupabaseConnector();
  await db.connect(connector: currentConnector);

  Supabase.instance.client.auth.onAuthStateChange.listen((data) async {
    final AuthChangeEvent event = data.event;
    if (event == AuthChangeEvent.signedOut) {
      // Implicit sign out - disconnect, but don't delete data
      currentConnector = null;
      await db.disconnect();
    } else if (event == AuthChangeEvent.tokenRefreshed) {
      // Supabase token refreshed - trigger token refresh for PowerSync.
      currentConnector?.prefetchCredentials();
    }
  });
}

/// Explicit sign out - clear database and log out.
Future<void> logout() async {
  await Supabase.instance.client.auth.signOut();
  await Supabase.instance.dispose();
  await db.disconnectAndClear();

  // Resetting app so that no-sync mode works again
  await setSyncEnabled(false);
  await openDatabase();
}
