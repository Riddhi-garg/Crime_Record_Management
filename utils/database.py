import pymysql
from pymysql.cursors import DictCursor
import sqlite3
import os
import re
from config import Config

# Global variable to track active engine mode ('mysql' or 'sqlite')
DB_ENGINE = None
SQLITE_DB_PATH = os.path.join(os.path.dirname(os.path.dirname(__file__)), 'database', 'crms_local.db')

def convert_mysql_to_sqlite_schema(sql_content):
    """
    Converts MySQL DDL statements to SQLite compatible syntax.
    Handles ENUMs, AUTO_INCREMENT, ENGINE=InnoDB, timestamps, etc.
    """
    sql = sql_content
    # Remove MySQL database creation commands
    sql = re.sub(r'CREATE DATABASE.*?;', '', sql, flags=re.IGNORECASE)
    sql = re.sub(r'USE .*?;', '', sql, flags=re.IGNORECASE)
    
    # Replace AUTO_INCREMENT with SQLite auto increment syntax
    # e.g., user_id INT AUTO_INCREMENT PRIMARY KEY -> user_id INTEGER PRIMARY KEY AUTOINCREMENT
    sql = re.sub(r'(\w+)\s+INT\s+AUTO_INCREMENT\s+PRIMARY\s+KEY', r'\1 INTEGER PRIMARY KEY AUTOINCREMENT', sql, flags=re.IGNORECASE)
    sql = re.sub(r'(\w+)\s+INT\s+AUTOINCREMENT\s+PRIMARY\s+KEY', r'\1 INTEGER PRIMARY KEY AUTOINCREMENT', sql, flags=re.IGNORECASE)
    
    # Replace CREATE OR REPLACE VIEW with DROP VIEW + CREATE VIEW
    sql = sql.replace('CREATE OR REPLACE VIEW case_summary_view', 'DROP VIEW IF EXISTS case_summary_view; CREATE VIEW case_summary_view')
    sql = sql.replace('CREATE OR REPLACE VIEW officer_workload_view', 'DROP VIEW IF EXISTS officer_workload_view; CREATE VIEW officer_workload_view')
    
    sql = sql.replace('ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;', ';')
    sql = sql.replace('ENGINE=InnoDB DEFAULT CHARSET=utf8mb4', '')
    
    # Replace ENUM(...) with VARCHAR(100)
    sql = re.sub(r'ENUM\([^)]+\)', 'VARCHAR(100)', sql, flags=re.IGNORECASE)
    
    # Replace TIMESTAMP with DATETIME but protect CURRENT_TIMESTAMP
    sql = sql.replace('TIMESTAMP', 'DATETIME')
    sql = sql.replace('CURRENT_DATETIME', 'CURRENT_TIMESTAMP')
    
    return sql

def get_mysql_connection():
    """Attempt to establish connection to MySQL database."""
    try:
        conn = pymysql.connect(
            host=Config.DB_HOST,
            port=Config.DB_PORT,
            user=Config.DB_USER,
            password=Config.DB_PASSWORD,
            database=Config.DB_NAME,
            cursorclass=DictCursor,
            autocommit=False,
            connect_timeout=3
        )
        return conn
    except Exception as e:
        return None

def init_db():
    """
    Initialize database. Checks if MySQL is accessible.
    If MySQL is not available, initializes SQLite local database using schema.sql and sample_data.sql.
    """
    global DB_ENGINE
    mysql_conn = get_mysql_connection()
    if mysql_conn:
        DB_ENGINE = 'mysql'
        mysql_conn.close()
        print("[CRMS DB] Connected successfully to MySQL server.")
        return True
    
    # Fallback to SQLite
    DB_ENGINE = 'sqlite'
    print("[CRMS DB] MySQL not available. Initializing SQLite dual-engine fallback database...")
    
    schema_path = os.path.join(os.path.dirname(os.path.dirname(__file__)), 'database', 'schema.sql')
    sample_path = os.path.join(os.path.dirname(os.path.dirname(__file__)), 'database', 'sample_data.sql')
    
    # Initialize SQLite database
    os.makedirs(os.path.dirname(SQLITE_DB_PATH), exist_ok=True)
    conn = sqlite3.connect(SQLITE_DB_PATH)
    cursor = conn.cursor()
    
    # Read schema.sql
    if os.path.exists(schema_path):
        with open(schema_path, 'r', encoding='utf-8') as f:
            schema_sql = f.read()
        
        # Clean statements for SQLite
        sqlite_schema = convert_mysql_to_sqlite_schema(schema_sql)
        # Remove single-line comments (-- comment)
        schema_clean = re.sub(r'--.*$', '', sqlite_schema, flags=re.MULTILINE)
        for stmt in schema_clean.split(';'):
            stmt = stmt.strip()
            if stmt and not stmt.startswith('SET '):
                try:
                    cursor.execute(stmt)
                except Exception as ex:
                    pass
        conn.commit()
    
    # Populate sample data if users table is empty
    try:
        cursor.execute("SELECT COUNT(*) FROM users")
        user_count = cursor.fetchone()[0]
    except Exception:
        user_count = 0
        
    if user_count == 0 and os.path.exists(sample_path):
        with open(sample_path, 'r', encoding='utf-8') as f:
            sample_sql = f.read()
        
        # Clean sample data for SQLite
        sample_clean = re.sub(r'SET FOREIGN_KEY_CHECKS = \d;', '', sample_sql)
        sample_clean = sample_clean.replace('USE crime_record_management;', '')
        sample_clean = sample_clean.replace('TRUNCATE TABLE', 'DELETE FROM')
        # Remove single-line comments (-- comment)
        sample_clean = re.sub(r'--.*$', '', sample_clean, flags=re.MULTILINE)
        
        for stmt in sample_clean.split(';'):
            stmt = stmt.strip()
            if stmt:
                try:
                    cursor.execute(stmt)
                except Exception as ex:
                    pass
        conn.commit()
        
    conn.close()
    print("[CRMS DB] SQLite database initialized successfully at:", SQLITE_DB_PATH)
    return True

class SQLiteDictCursor:
    """Wrapper around sqlite3 row_factory to emulate dictionary cursor."""
    def __init__(self, cursor):
        self.cursor = cursor

    def fetchall(self):
        rows = self.cursor.fetchall()
        if not rows:
            return []
        cols = [column[0] for column in self.cursor.description]
        return [dict(zip(cols, row)) for row in rows]

    def fetchone(self):
        row = self.cursor.fetchone()
        if not row:
            return None
        cols = [column[0] for column in self.cursor.description]
        return dict(zip(cols, row))

    @property
    def lastrowid(self):
        return self.cursor.lastrowid

    @property
    def rowcount(self):
        return self.cursor.rowcount

def execute_query(sql, params=None, fetchall=False, fetchone=False, commit=False):
    """
    Executes raw SQL query using active DB_ENGINE (MySQL or SQLite).
    Translates '%s' placeholder to '?' automatically if SQLite is active.
    Returns results as dictionary / dictionary list or inserted id/affected rows.
    """
    global DB_ENGINE
    if DB_ENGINE is None:
        init_db()

    params = params or ()
    
    if DB_ENGINE == 'mysql':
        conn = get_mysql_connection()
        if not conn:
            raise Exception("Failed to connect to MySQL database.")
        try:
            with conn.cursor() as cursor:
                cursor.execute(sql, params)
                if commit:
                    conn.commit()
                    last_id = cursor.lastrowid
                    conn.close()
                    return last_id or True
                
                if fetchone:
                    res = cursor.fetchone()
                    conn.close()
                    return res
                if fetchall:
                    res = cursor.fetchall()
                    conn.close()
                    return res
                
                conn.close()
                return True
        except Exception as e:
            conn.rollback()
            conn.close()
            raise e

    else:
        # SQLite Engine
        conn = sqlite3.connect(SQLITE_DB_PATH)
        # Replace %s with ? for SQLite compatibility
        sqlite_sql = sql.replace('%s', '?')
        # Replace NOW() or CURRENT_TIMESTAMP functions if needed
        sqlite_sql = sqlite_sql.replace('NOW()', "DATETIME('now', 'localtime')")
        
        cursor = conn.cursor()
        try:
            cursor.execute(sqlite_sql, params)
            if commit:
                conn.commit()
                last_id = cursor.lastrowid
                conn.close()
                return last_id or True
            
            dict_cur = SQLiteDictCursor(cursor)
            if fetchone:
                res = dict_cur.fetchone()
                conn.close()
                return res
            if fetchall:
                res = dict_cur.fetchall()
                conn.close()
                return res
                
            conn.close()
            return True
        except Exception as e:
            conn.rollback()
            conn.close()
            raise e

def execute_transaction(query_list):
    """
    Executes multiple SQL queries inside a single database transaction.
    If any query fails, the entire transaction is rolled back.
    query_list format: [(sql_1, params_1), (sql_2, params_2), ...]
    """
    global DB_ENGINE
    if DB_ENGINE is None:
        init_db()

    if DB_ENGINE == 'mysql':
        conn = get_mysql_connection()
        if not conn:
            raise Exception("Failed to connect to MySQL database.")
        try:
            last_id = None
            with conn.cursor() as cursor:
                for item in query_list:
                    if isinstance(item, tuple):
                        sql, params = item
                    else:
                        sql, params = item, ()
                    
                    # Support using last_id in subsequent queries
                    if '{LAST_ID}' in sql and last_id:
                        sql = sql.replace('{LAST_ID}', str(last_id))
                        
                    cursor.execute(sql, params)
                    if cursor.lastrowid:
                        last_id = cursor.lastrowid
                        
            conn.commit()
            conn.close()
            return True
        except Exception as e:
            conn.rollback()
            conn.close()
            raise e
    else:
        conn = sqlite3.connect(SQLITE_DB_PATH)
        cursor = conn.cursor()
        try:
            last_id = None
            for item in query_list:
                if isinstance(item, tuple):
                    sql, params = item
                else:
                    sql, params = item, ()
                
                sqlite_sql = sql.replace('%s', '?').replace('NOW()', "DATETIME('now', 'localtime')")
                if '{LAST_ID}' in sqlite_sql and last_id:
                    sqlite_sql = sqlite_sql.replace('{LAST_ID}', str(last_id))
                    
                cursor.execute(sqlite_sql, params)
                if cursor.lastrowid:
                    last_id = cursor.lastrowid
                    
            conn.commit()
            conn.close()
            return True
        except Exception as e:
            conn.rollback()
            conn.close()
            raise e
