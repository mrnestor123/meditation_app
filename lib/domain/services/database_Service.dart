import 'dart:async';
import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

abstract class DB {
  static Database _db;

  static int get _version => 1;

  static Future<void> init() async {
    if (_db != null) {
      print('DB is not null');
      return;
    }

    try {
      Directory documentsDirectory = await getApplicationDocumentsDirectory();
      String _path = join(documentsDirectory.path, 'database3.db');
      print('que pasa ');
      print(_path);
      _db = await openDatabase(_path,
          version: _version, onCreate: onCreate, onConfigure: _onConfigure);
    } catch (ex) {
      print(ex);
    }
  }

  static void onCreate(Database db, int version) async {
    db.execute(
        'CREATE TABLE Stage(stagenumber INTEGER PRIMARY KEY NOT NULL, description VARCHAR(255) NOT NULL)');
    db.execute(
        'CREATE TABLE User (cod_user INTEGER  NOT NULL PRIMARY KEY , nombre VARCHAR(255) NOT NULL , mail STRING NOT NULL, usuario VARCHAR(15) NOT NULL,  FOREIGN KEY (stagenumber) REFERENCES Stage(stagenumber))');

    db.execute(
        'CREATE TABLE Meditation (cod_med INTEGER PRIMARY KEY NOT NULL, duration DATETIME NOT NULL,recording VARCHAR(15), guided INTEGER NOT NULL )');

    db.execute(
        'CREATE TABLE Lesson(cod_lesson INTEGER PRIMARY KEY NOT NULL, slider VARCHAR(15) NOT NULL, description VARCHAR(50) NOT NULL, text TEXT ,FOREIGN KEY (stagenumber) REFERENCES Stage (stagenumber))');

    db.execute(
        'CREATE TABLE MeditationsinProgress(FOREIGN KEY (cod_user) REFERENCES User(cod_user), FOREIGN KEY (cod_med) REFERENCES Meditation(cod_med))');

    db.execute(
        'CREATE TABLE FinishedMeditation(FOREIGN KEY (cod_user) REFERENCES User(cod_user), FOREIGN KEY (cod_med) REFERENCES Meditation(cod_med))');

    db.execute(
      'CREATE TABLE LearnedLessons(FOREIGN KEY (cod_lesson)  REFERENCES Lesson(cod_lesson), FOREIGN KEY(cod_user) REFERENCES User(cod_user)',
    );
  }

  static Future _onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }

  /**static Future<List<Map<String, dynamic>>> query(String table) async =>
      _db.query(table);

  static Future<int> insert(String table) async => 
      //await _db.insert(table);

  static Future<int> update(String table, Model model) async => await _db
      //.update(table, model.toMap(), where: 'id = ?', whereArgs: [model.id]);

  static Future<int> delete(String table, Model model) async =>
      await _db.delete(table, where: 'id = ?', whereArgs: [model.id]);
  **/
}
