import 'dart:io';

import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_sqlite/models/note.dart';

class DatabaseHelper {
  static DatabaseHelper _databaseHelper;
  static Database _database;

  String noteTable = 'note_table';
  String colId = 'id';
  String colTitle = 'title';
  String colDescription = 'description';
  String colPriority = 'priority';
  String colDate = 'date';
  DatabaseHelper._createInstance();
  factory DatabaseHelper(){
    if (_databaseHelper == null){
      _databaseHelper = DatabaseHelper._createInstance();
    }
    return _databaseHelper;
  }
  Future<Database> get database async{
    if(_database == null){
      _database = await initializeDatabase();
    }
    return _database;
  }
  Future<Database> initializeDatabase() async{
    //Get the directory path
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'notes.db';

    //Open/Create the database at a given path
    var notesDatabase = openDatabase(path,version: 1,onCreate: _createDb);
    return notesDatabase;
  }
  void _createDb(Database db,int newVersion) async {
    await db.execute('CREATE TABLE $noteTable('
        '$colId INTEGER PRIMARY KEY AUTOINCREMENT, '
        '$colTitle TEXT, $colDescription TEXT, '
        '$colPriority INTEGER, '
        '$colDate TEXT)');
  }
  //Read
  Future<List<Map<String, dynamic>>> getNoteMapList() async{
    Database db = await this.database;
//    var result = await db.rawQuery('select * from $noteTable order by $colPriority ASC');
    var result = await db.query(noteTable,orderBy: '$colPriority');
    return result;
  }
  //Insert
  Future<int> insertNote(Note note) async{
    Database db = await this.database;
    var result = await db.insert(noteTable,note.toMap());
    return result;
  }
  //Update
  Future<int> updateNote(Note note) async{
    Database db = await this.database;
    var result = await db.update(noteTable,note.toMap(),where: '$colId = ?', whereArgs: [note.id]);
    return result;
  }
  //Delete
  Future<int> deleteNote(int id) async{
    Database db = await this.database;
    var result = await db.rawDelete('DELETE from $noteTable WHERE $colId = $id');
    return result;
  }

  //Count
  Future<int> getCount(Note note) async{
    Database db = await this.database;
    List<Map<String, dynamic>> x = await db.rawQuery('SELECT COUNT(*) from $noteTable');
    int result = Sqflite.firstIntValue(x);
    return result;
  }

//  Get the 'Map List' and convert to Note List
  Future<List<Note>> getNoteList() async{
    var noteMapList = await getNoteMapList();
    int count = noteMapList.length;

    List<Note> noteList = List<Note>();
    for(int i=0;i<count;i++){
      noteList.add(Note.formMapObject(noteMapList[i]));
    }
    return noteList;
  }
}