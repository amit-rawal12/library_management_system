/*import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('library.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(
      path,
      version: 2,
      onCreate: _createDB,
      onUpgrade: _onUpgrade,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE books (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        author TEXT,
        isbn TEXT,
        quantity INTEGER
      )
    ''');

    await db.execute('''
      CREATE TABLE transactions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        bookId INTEGER,
        memberName TEXT,
        memberPhone TEXT,
        memberAddress TEXT,
        issuedDate TEXT,
        returnDate TEXT,
        FOREIGN KEY (bookId) REFERENCES books (id)
      )
    ''');
  }

  Future<void> updateTransactionReturnDate(int id, String returnDate) async {
    final db = await instance.database;
    await db.update(
      'transactions',
      {'returnDate': returnDate},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Handle future upgrades here
    if (oldVersion < 2) {
      print("Upgrading database to version $newVersion");
    }
  }

  Future<int> insertBook(Map<String, dynamic> row) async {
    try {
      Database db = await instance.database;
      return await db.insert('books', row);
    } catch (e) {
      print("Error inserting book: $e");
      return -1;
    }
  }

  Future<List<Map<String, dynamic>>> queryAllBooks() async {
    try {
      Database db = await instance.database;
      return await db.query('books');
    } catch (e) {
      print("Error querying books: $e");
      return [];
    }
  }

  Future<int> updateBook(Map<String, dynamic> row) async {
    try {
      Database db = await instance.database;
      int id = row['id'];
      return await db.update('books', row, where: 'id = ?', whereArgs: [id]);
    } catch (e) {
      print("Error updating book: $e");
      return -1;
    }
  }

  Future<int> deleteBook(int id) async {
    try {
      Database db = await instance.database;
      return await db.delete('books', where: 'id = ?', whereArgs: [id]);
    } catch (e) {
      print("Error deleting book: $e");
      return -1;
    }
  }

  Future<int> insertTransaction(Map<String, dynamic> row) async {
    try {
      Database db = await instance.database;
      return await db.insert('transactions', row);
    } catch (e) {
      print("Error inserting transaction: $e");
      return -1;
    }
  }

  Future<List<Map<String, dynamic>>> queryAllTransactions() async {
    try {
      Database db = await instance.database;
      return await db.query('transactions');
    } catch (e) {
      print("Error querying transactions: $e");
      return [];
    }
  }


}*/

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('library.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(
      path,
      version: 3,
      onCreate: _createDB,
      onUpgrade: _onUpgrade,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE books (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        author TEXT,
        isbn TEXT,
        quantity INTEGER
      )
    ''');

    await db.execute('''
      CREATE TABLE transactions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        bookId INTEGER,
        memberName TEXT,
        memberPhone TEXT,
        memberAddress TEXT,
        issuedDate TEXT,
        returnDate TEXT,
        paymentAmount REAL,
        FOREIGN KEY (bookId) REFERENCES books (id)
      )
    ''');

    await db.execute('''
      CREATE TABLE members (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        phone TEXT,
        address TEXT,
        membershipType TEXT,
        membershipExpiryDate TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE reservations (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        bookId INTEGER,
        memberId INTEGER,
        reservationDate TEXT,
        FOREIGN KEY (bookId) REFERENCES books (id),
        FOREIGN KEY (memberId) REFERENCES members (id)
      )
    ''');
  }

  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('ALTER TABLE transactions ADD COLUMN paymentAmount REAL');
    }
    if (oldVersion < 3) {
      await db.execute('''
        CREATE TABLE members (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT,
          phone TEXT,
          address TEXT,
          membershipType TEXT,
          membershipExpiryDate TEXT
        )
      ''');
      await db.execute('''
        CREATE TABLE reservations (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          bookId INTEGER,
          memberId INTEGER,
          reservationDate TEXT,
          FOREIGN KEY (bookId) REFERENCES books (id),
          FOREIGN KEY (memberId) REFERENCES members (id)
        )
      ''');
    }
  }

  Future<int> insertBook(Map<String, dynamic> row) async {
    try {
      Database db = await instance.database;
      return await db.insert('books', row);
    } catch (e) {
      print("Error inserting book: $e");
      return -1;
    }
  }

  Future<List<Map<String, dynamic>>> queryAllBooks() async {
    try {
      Database db = await instance.database;
      return await db.query('books');
    } catch (e) {
      print("Error querying books: $e");
      return [];
    }
  }

  Future<int> updateBook(Map<String, dynamic> row) async {
    try {
      Database db = await instance.database;
      int id = row['id'];
      return await db.update('books', row, where: 'id = ?', whereArgs: [id]);
    } catch (e) {
      print("Error updating book: $e");
      return -1;
    }
  }

  Future<int> deleteBook(int id) async {
    try {
      Database db = await instance.database;
      return await db.delete('books', where: 'id = ?', whereArgs: [id]);
    } catch (e) {
      print("Error deleting book: $e");
      return -1;
    }
  }

  Future<int> insertTransaction(Map<String, dynamic> row) async {
    try {
      Database db = await instance.database;
      return await db.insert('transactions', row);
    } catch (e) {
      print("Error inserting transaction: $e");
      return -1;
    }
  }

  Future<List<Map<String, dynamic>>> queryAllTransactions() async {
    try {
      Database db = await instance.database;
      return await db.query('transactions');
    } catch (e) {
      print("Error querying transactions: $e");
      return [];
    }
  }

  Future<void> updateTransactionReturnDate(int id, String returnDate) async {
    final db = await instance.database;
    await db.update(
      'transactions',
      {'returnDate': returnDate},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> insertMember(Map<String, dynamic> row) async {
    try {
      Database db = await instance.database;
      return await db.insert('members', row);
    } catch (e) {
      print("Error inserting member: $e");
      return -1;
    }
  }

  Future<List<Map<String, dynamic>>> queryAllMembers() async {
    try {
      Database db = await instance.database;
      return await db.query('members');
    } catch (e) {
      print("Error querying members: $e");
      return [];
    }
  }

  Future<int> insertReservation(Map<String, dynamic> row) async {
    try {
      Database db = await instance.database;
      return await db.insert('reservations', row);
    } catch (e) {
      print("Error inserting reservation: $e");
      return -1;
    }
  }

  Future<List<Map<String, dynamic>>> queryAllReservations() async {
    try {
      Database db = await instance.database;
      return await db.query('reservations');
    } catch (e) {
      print("Error querying reservations: $e");
      return [];
    }
  }
}

