import 'dart:async';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/expense.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance =  DatabaseHelper.internal();

  factory DatabaseHelper() => _instance;

  final String tableExpense = 'expenseTable';
  final String columnId = 'id';
  final String columnTitle = 'title';
  final String columnValue = 'value';
  final String columnDate = 'date';
  final String columnColor = 'color';
  final String columnCategory = 'category';

  static Database _db;

  DatabaseHelper.internal();

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();

    return _db;
  }

  initDb() async {
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'expenses.db');

    // await deleteDatabase(path); // just for testing

    var db = await openDatabase(path, version: 4, onCreate: _onCreate, onUpgrade: _onUpgrade);
    return db;
  }

  void _onCreate(Database db, int newVersion) async {
    await db.execute(
        'CREATE TABLE $tableExpense($columnId INTEGER PRIMARY KEY, $columnTitle TEXT, $columnValue NUMERIC(10,2), $columnDate TEXT, $columnColor TEXT, $columnCategory TEXT)');
  }

  void _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if(oldVersion < newVersion) {
      // db.execute('ALTER TABLE $tableExpense ADD COLUMN color TEXT;');
    }
  }

  Future<int> saveExpense(Expense tr) async {
    var dbClient = await db;
    var result = await dbClient.insert(tableExpense, tr.toMap());

    print(await dbClient.query('expenseTable'));

    return result;
  }

  Future<int> getNextId() async {
    var dbClient = await db;
    var table = await dbClient.rawQuery("SELECT MAX(id)+1 as id FROM $tableExpense");
    int id = table.first["id"];
    if (id == null) id = 1;
    return  id;
  }

  Future<List> getAllExpenses() async {
    var dbClient = await db;
    var result = await dbClient.query(tableExpense, columns: [columnId, columnTitle, columnValue, columnDate, columnColor, columnCategory], orderBy: 'date desc');

    return result.toList();
  }

  Future<int> getCount() async {
    var dbClient = await db;
    return Sqflite.firstIntValue(await dbClient.rawQuery('SELECT COUNT(*) FROM $tableExpense'));
  }

  Future<Expense> getExpense(int id) async {
    var dbClient = await db;
    List<Map> result = await dbClient.query(tableExpense,
        columns: [columnId, columnTitle, columnValue, columnDate, columnColor, columnCategory],
        where: '$columnId = ?',
        whereArgs: [id]);


    if (result.length > 0) {
      return new Expense.fromMap(result.first);
    }

    return null;
  }

  Future<int> deleteExpense(int id) async {
    var dbClient = await db;
    return await dbClient.delete(tableExpense, where: '$columnId = ?', whereArgs: [id]);

  }

  Future<int> updateExpense(Expense tr) async {
    var dbClient = await db;
    return await dbClient.update(tableExpense, tr.toMap(), where: "$columnId = ?", whereArgs: [tr.id]);

  }

  Future close() async {
    var dbClient = await db;
    return dbClient.close();
  }

}