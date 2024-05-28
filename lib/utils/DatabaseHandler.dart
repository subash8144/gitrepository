
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:repository/constants/tableProperties.dart';
import 'package:repository/ui/Home/HomeModel.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;

class DatabaseHandler {

  String queryBuilder(
      String operationMode, String tableName, String attributes) {
    late String query;
    if (operationMode == "CREATE") {
      query = "CREATE TABLE $tableName($attributes)";
    }
    return query;
  }

  Future<Database> initializeDB() async {
    String path = await getDatabasesPath();
    return openDatabase(
      p.join(path, 'repositories.db'),
      onCreate: (database, version) async {
        await database.execute((queryBuilder(
            "CREATE", TableObjects.repositories, TableObjects.repositoriesAttributes)));
      },
      version: 1,
    );
  }

  Future<List<Map<String, dynamic>>> getUserRepositories(DateTime date) async{
    final dateString = date.toIso8601String().split('T').first;
      final db = await initializeDB();
      final List<Map<String, dynamic>> data = await db.rawQuery("select * from repositories WHERE date = '$dateString'");
      return data;
  }

  Future insertRepositories(List<Item> response, DateTime date) async {
    final dateString = date.toIso8601String().split('T').first;
    List<Map<String, String?>> data = response.map((e) => {
      "name" : e.name,
      "desc" : e.description ?? "",
      "date" : dateString
    }).toList();
    try {
      final db = await initializeDB();
      Batch batch = db.batch();
      for (int i = 0; i < data.length; i++) {
        batch.insert(
          TableObjects.repositories,
          data[i],
        );
      }
      await batch.commit(noResult: true);
    } catch (e, s) {
      debugPrint(e.toString());
    }
  }
}