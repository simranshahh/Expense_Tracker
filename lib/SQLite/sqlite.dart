// ignore_for_file: avoid_print, prefer_const_constructors, unused_import

import 'dart:io';

import 'package:myfinance/view/JsonModels/createaccount.dart';
import 'package:myfinance/view/JsonModels/profilepicturemodel.dart';
import 'package:myfinance/view/JsonModels/transactionmodel.dart';
import 'package:myfinance/view/JsonModels/users.dart';
import 'package:path/path.dart';
// import 'package:permission_handler/permission_handler.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:flutter_file_manager/file_manager.dart';

class DatabaseHelper {
  final databaseName = "myfin.db";

  String noteTable =
      "CREATE TABLE notes (noteId INTEGER PRIMARY KEY AUTOINCREMENT, noteTitle TEXT NOT NULL, noteContent TEXT NOT NULL, createdAt TEXT DEFAULT CURRENT_TIMESTAMP)";

  String users =
      "create table users (usrId INTEGER PRIMARY KEY AUTOINCREMENT, usrName TEXT UNIQUE, usrPassword TEXT, usrPhone TEXT, usrAddress TEXT)";

  String createaccount =
      "create table auto_account (account_id INTEGER PRIMARY KEY AUTOINCREMENT,user_id INTEGER, account_name varchar, account_address varchar, account_phone varchar(10), account_category varchar, FOREIGN KEY(user_id) REFERENCES users(usrId))";

  String transactionTable =
      "create table auto_transaction (id INTEGER PRIMARY KEY AUTOINCREMENT, from_id INTEGER, to_id INTEGER, amount NUMERIC DECIMAL(10,3), remarks TEXT, created_at TEXT DEFAULT CURRENT_TIMESTAMP, CONSTRAINT from_id_account_fkey FOREIGN KEY (from_id) REFERENCES auto_account(account_id),  CONSTRAINT to_id_account_fkey FOREIGN KEY (to_id) REFERENCES auto_account(account_id))";

  String pictureTable =
      "create table picture_Table (photoId INTEGER PRIMARY KEY, pImage BLOB)";

  final storage = FlutterSecureStorage();

  Future<Database> initDB() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, databaseName);

    print(path);
    print('myfin.db');

    return openDatabase(path, version: 1, onCreate: (db, version) async {
      List<Map> result = await db
          .rawQuery("SELECT name FROM sqlite_master WHERE type='table'");
      print(result);
      print(transactioncreate);
      print(gettransaction);
      await db.execute(users);
      await db.execute(noteTable);
      await db.execute(createaccount);
      await db.execute(transactionTable);
      await db.execute(pictureTable);
    });
  }

  Future<String> getDatabasePath() async {
    final databasePath = await getDatabasesPath();
    return join(databasePath, databaseName);
  }

//login
  Future<bool> login(Users user) async {
    final Database db = await initDB();

    var result = await db.rawQuery(
        "select * from users where usrName = '${user.usrName}' AND usrPassword = '${user.usrPassword}'");
    if (result.isNotEmpty) {
      await storage.write(key: 'usrName', value: user.usrName);
      await storage.write(key: 'usrPassword', value: user.usrPassword);
      // await copyDatabaseToExternalStorage();
      // await backupDatabase();

      return true;
    } else {
      return false;
    }
  }

  Future<Users?> getCurrentUser() async {
    final String? usrName = await storage.read(key: 'usrName');
    final String? usrPassword = await storage.read(key: 'usrPassword');

    if (usrName != null && usrPassword != null) {
      final Database db = await initDB();

      var result = await db.rawQuery(
          "SELECT * FROM users WHERE usrName = ? AND usrPassword = ?",
          [usrName, usrPassword]);

      if (result.isNotEmpty) {
        return Users.fromMap(result
            .first); // Assuming fromMap is a method to map DB result to Users object
      }
    }
    return null;
  }

  Future<Users?> getUserByCredentials(
      String usrName, String usrPassword) async {
    final Database db = await initDB();
    var result = await db.rawQuery(
        "SELECT * FROM users WHERE usrName = ? AND usrPassword = ?",
        [usrName, usrPassword]);
    if (result.isNotEmpty) {
      return Users.fromMap(result.first);
    }
    return null;
  }

  //Sign up
  Future<int> signup(Users user) async {
    final Database db = await initDB();
    // await backupDatabase();
    // await copyDatabaseToExternalStorage();
    return db.insert('users', user.toMap());
  }

  Future<int> signupAndReturnId(Users user) async {
    final Database db = await initDB();
    // await backupDatabase();
    // await copyDatabaseToExternalStorage();
    return db.insert('users', user.toMap());
  }
  //CRUD Methods

  // Create Account
  Future<int> accountcreate(CreateAccountModel account,
      {String? accountName}) async {
    final Database db = await initDB();
    return db.insert('auto_account', account.toMap());
  }

//get account
  Future<List<CreateAccountModel>> getaccount() async {
    final Database db = await initDB();
    List<Map<String, Object?>> result = await db.query('auto_account');
    return result.map((e) => CreateAccountModel.fromMap(e)).toList();
  }

  Future<int> insertProfilePicture(ProfilepictureModel profilePicture) async {
    var dbClient = await initDB();
    return await dbClient.insert('picture_Table', profilePicture.toMap());
  }

  Future<ProfilepictureModel?> getProfilePicture(String usrId) async {
    var dbClient = await initDB();

    var result = await dbClient
        .query('picture_Table', where: 'photoId = ?', whereArgs: [usrId]);
    if (result.isNotEmpty) {
      return ProfilepictureModel.fromMap(result.first);
    }
    return null;
  }

  //create transaction
  Future<int> transactioncreate(
    TransactionModel transaction,
  ) async {
    final Database db = await initDB();
    return db.insert(
      'auto_transaction',
      transaction.toMap(),
    );
  }

  //get transaction
  Future<List<TransactionModel>> gettransaction() async {
    final Database db = await initDB();
    List<Map<String, Object?>> result = await db.query('auto_transaction');
    return result.map((e) => TransactionModel.fromMap(e)).toList();
  }
  //get users

  Future<List<Users>> getUsers() async {
    final Database db = await initDB();
    List<Map<String, Object?>> result = await db.query('users');
    return result.map((e) => Users.fromMap(e)).toList();
  }

  Future<List<CreateAccountModel>> getAccountsByCategory(
      String category) async {
    final db = await initDB();
    final List<Map<String, dynamic>> result = await db.rawQuery(
        'SELECT * FROM auto_account WHERE account_category = ?', [category]);
    return result.map((item) => CreateAccountModel.fromMap(item)).toList();
  }

  Future<List<CreateAccountModel>> getAccountsByCategoryAndUser(
      String category, int userId) async {
    final Database db = await initDB();
    final List<Map<String, dynamic>> maps = await db.query(
      'auto_account',
      where: 'account_category = ? AND user_id = ?',
      whereArgs: [category, userId],
    );

    return List.generate(maps.length, (i) {
      return CreateAccountModel.fromMap(maps[i]);
    });
  }

  Future<Object> getTotalExpenses() async {
    final Database db = await initDB();
    var result =
        await db.rawQuery("SELECT SUM(amount) as total FROM auto_transaction");
    if (result.isNotEmpty) {
      return result.first["total"] ?? 0;
    }
    return 0;
  }

  Future<int> updateDetails(
    String name,
    String address,
    String contact,
    String password,
    id,
  ) async {
    final Database db = await initDB();

    return db.rawUpdate(
        'UPDATE users SET usrName = ?, usrAddress = ?, usrPhone = ?, usrPassword = ? WHERE usrId = ?',
        [name, address, contact, password, id]);
  }

  Future<Users?> getUserById(int userId) async {
    final db = await initDB();
    final List<Map<String, dynamic>> maps = await db.query(
      'users',
      where: 'usrId = ?',
      whereArgs: [userId],
    );

    if (maps.isNotEmpty) {
      return Users.fromMap(maps.first);
    } else {
      return null;
    }
  }
}
