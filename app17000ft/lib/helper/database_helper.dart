import 'dart:async';
import 'dart:io' as io;
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as path;
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';
import 'package:app17000ft/services/network_manager.dart';
import 'package:app17000ft/tourDetails/tour_model.dart';
import 'package:app17000ft/forms/school_enrolment/school_enrolment_model.dart';

final NetworkManager networkManager = Get.put(NetworkManager());
class SqfliteDatabaseHelper {
  SqfliteDatabaseHelper.internal();
  static final SqfliteDatabaseHelper instance = SqfliteDatabaseHelper.internal();
  factory SqfliteDatabaseHelper() => instance;

  // Name of the tables
  static const tourDetails = 'tour_details';
  static const schoolEnrolment = 'new_enrolmentCollection';
  static const _dbName = "app17000ft.db";
  static const _dbVersion = 2; // Increment this when you make schema changes

  static Database? _db;

  // Function for initializing the database
  Future<Database> get db async {
    if (_db != null) {
      return _db!;
    }
    _db = await init();
    return _db!;
  }

  // Perform tasks
  Future<Database> init() async {
    var dbPath = await getDatabasesPath();
    String dbPathHomeWorkout = path.join(dbPath, _dbName);

    bool dbExists = await io.File(dbPathHomeWorkout).exists();

    if (!dbExists) {
      ByteData data = await rootBundle.load(path.join("assets/", _dbName));
      List<int> bytes = data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
      await io.File(dbPathHomeWorkout).writeAsBytes(bytes, flush: true);
    }

    return await openDatabase(
      dbPathHomeWorkout,
      version: _dbVersion,
      onUpgrade: _onUpgrade,
      onCreate: _onCreate,
    );
  }

  void _onCreate(Database db, int version) async {
    print('oncreate is called $version');
    await _createTables(db);
  }

  void _onUpgrade(Database db, int oldVersion, int newVersion) async {
    print('onUpgrade is called from $oldVersion to $newVersion');
    if (oldVersion < newVersion) {
      if (oldVersion == 1 && newVersion == 2) {
        await _createTables(db);
      }
      // Add more migration steps if needed for future versions
    }
  }

  Future<void> _createTables(Database db) async {
    await db.execute('''
      CREATE TABLE IF NOT EXISTS $schoolEnrolment (
        id TEXT PRIMARY KEY,
        tourId TEXT,
        school TEXT,
        registerImage TEXT,
        enrolmentData TEXT,
        remarks TEXT,
        createdAt TEXT,
        submittedBy TEXT
      );
    ''');

    await db.execute('''
      CREATE TABLE IF NOT EXISTS $tourDetails (
        id TEXT PRIMARY KEY,
        tourName TEXT,
        description TEXT,
        date TEXT
      );
    ''');
  }

  // Function to reset the database
  Future<void> resetDatabase() async {
    var dbPath = await getDatabasesPath();
    String dbPathHomeWorkout = path.join(dbPath, _dbName);
    await deleteDatabase(dbPathHomeWorkout);
    _db = await init();
  }

  // Delete function for deleting records from table
  Future<int> delete(String? tableName, {String? where, List<dynamic>? whereArgs}) async {
    final dbClient = await db;
    if (tableName == null) {
      throw ArgumentError("tableName cannot be null");
    }

    print('delete is called $tableName');

    String sql = "DELETE FROM $tableName";
    if (where != null) {
      sql += " WHERE $where";
    }

    try {
      return await dbClient.rawDelete(sql, whereArgs);
    } catch (e) {
      print('Error executing delete: $e');
      rethrow;
    }
  }

  // Delete function for deleting specific records from table
  Future<int> queryDelete({String? arg, String? table, String? field}) async {
    final dbClient = await db;
    if (table == null || field == null || arg == null) {
      throw ArgumentError("Arguments cannot be null");
    }

    print('query delete is called');

    try {
      return await dbClient.rawDelete('DELETE FROM $table WHERE $field = ?', [arg]);
    } catch (e) {
      print('Error executing query delete: $e');
      rethrow;
    }
  }
}

class LocalDbController {
  final conn = SqfliteDatabaseHelper.instance;

  // Check internet connectivity
  static Future<bool> isInternet() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      return networkManager.connectionType.value == 1;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return networkManager.connectionType.value == 2;
    } else {
      return false;
    }
  }

  // Function for insert query
  Future<int> addData({
    TourDetails? tourDetails,
    EnrolmentCollectionModel? enrolmentCollectionModel,
  }) async {
    var dbClient = await conn.db;
    int result = 1;
    try {
      if (tourDetails != null) {
        print('tourDetails called to insert');
        result = await dbClient.insert(
          SqfliteDatabaseHelper.tourDetails,
          tourDetails.toJson(),
        );
      } else if (enrolmentCollectionModel != null) {
        print('enrolmentCollectionModel called to insert');
        result = await dbClient.insert(
          SqfliteDatabaseHelper.schoolEnrolment,
          enrolmentCollectionModel.toJson(),
        );
      }
    } catch (e) {
      result = -1;
    }
    return result;
  }

  // Fetch CDPO form records from local db
  Future<List<TourDetails>> fetchLocalTourDetails() async {
    var dbClient = await conn.db;
    List<TourDetails> tourList = [];
    try {
      List<Map<String, dynamic>> maps = await dbClient.rawQuery('SELECT * FROM ${SqfliteDatabaseHelper.tourDetails}');
      for (var element in maps) {
        tourList.add(TourDetails.fromJson(element));
      }
    } catch (e) {
      print("Exception occurred while fetching tourDetails form records: $e");
    }
    return tourList;
  }

  //fetch Local Enrolment DATa

  // Fetch CDPO form records from local db
  Future<List<EnrolmentCollectionModel>> fetchLocalEnrolmentRecord() async {
    var dbClient = await conn.db;
    List<EnrolmentCollectionModel> tourList = [];
    try {
      List<Map<String, dynamic>> maps = await dbClient.rawQuery('SELECT * FROM ${SqfliteDatabaseHelper.schoolEnrolment}');
      for (var element in maps) {
        tourList.add(EnrolmentCollectionModel.fromJson(element));
      }
    } catch (e) {
      print("Exception occurred while fetching enrolmentCollection form records: $e");
    }
    return tourList;
  }
}
