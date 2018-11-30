import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'dart:async';
import '../models/item_model.dart';
import 'repository.dart';

class NewsDbProvider implements Source, Cache {
  Database db;

  NewsDbProvider() {
    init();
  }

  void init() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, "items.db"); // folder reference
    // create db
    db = await openDatabase(
        // either open existing or create it using onCreate
        path,
        version: 1, // schema of db if you change the schema of db in between.
        onCreate: (Database newDb, int version) {
      // intial setup of db
      // 3" helps to have a multi line text
      // data types in SQL is different from Dart. Need conversion
      // Blob can be any type. Sqllite has no boolean
      newDb.execute(""" 
          CREATE TABLE Items
          (
            id INTEGER PRIMARY KEY,
            type TEXT,
            by TEXT,
            time INTEGER,
            text TEXT,
            parent INTEGER,
            kids BLOB,
            dead INTEGER,
            deleted INTEGER,
            url TEXT,
            score INTEGER,
            title TEXT,
            descendants INTEGER
          )
       """);
    });
  }

  Future<ItemModel> fetchItem(int id) async {
    final maps = await db.query(
      "Items",
      columns: null, // list of columns in ['title','id'] etc
      where:
          "id = ?", // ? will be replaced by the first element in the whereArgs
      whereArgs: [id],
    ); // returns a key value pairs from db
    if (maps.length > 0) {
      return ItemModel.fromDb(maps.first); // expecting only one map
    }
    return null;
  }

  Future<int> addItem(ItemModel item) {
    // we are not waiting for the result. So no need for await.
    return db.insert("Items",
        item.toMap()); // why int as return type ? because thats what db returns
  }
  // putting it for abstract class stuff
  Future<List<int>> fetchTopIds() {
    return null;
  }
}

final newsDbProvider = NewsDbProvider(); // to preventing creating multiple isntances
