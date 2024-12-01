import json
import sqlite3
import time
import os

def create_db(db_path, table_name):
    conn = sqlite3.connect(db_path)
    c = conn.cursor()
    c.execute(f'''CREATE TABLE IF NOT EXISTS {table_name}
                 (id INTEGER PRIMARY KEY, time INTEGER)''')
    conn.commit()
    return conn

def insert_entries(conn, table_name, entry_ids, start_time):
    c = conn.cursor()
    for i, entry_id in enumerate(entry_ids):
        timestamp = start_time + (i * 1000) # Increment by 1 second (1000ms)
        c.execute(f"INSERT INTO {table_name} (id, time) VALUES (?, ?)", 
                 (entry_id, timestamp))
    conn.commit()

def main():
    # Get entry IDs from dict.json
    with open('dict.json') as f:
        data = json.load(f)
        entry_ids = [int(k) for k in data.keys()]

    start_time = int(time.time() * 1000)  # Current time in milliseconds

    os.makedirs('dbs', exist_ok=True)

    # Create and populate bookmarks database
    bookmarks_conn = create_db('dbs/bookmarkedEntries.db', 'bookmarks')
    insert_entries(bookmarks_conn, 'bookmarks', entry_ids, start_time)
    bookmarks_conn.close()

    # Create and populate history database
    history_conn = create_db('dbs/historyEntries.db', 'history') 
    insert_entries(history_conn, 'history', entry_ids, start_time)
    history_conn.close()

if __name__ == '__main__':
    main()
