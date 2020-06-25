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
      String _path = join(documentsDirectory.path, 'database5.db');
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
        'CREATE TABLE Stage(stagenumber INTEGER PRIMARY KEY AUTOINCREMENT, description VARCHAR(255) NOT NULL)');
    db.execute(
        'CREATE TABLE User (coduser INTEGER  NOT NULL PRIMARY KEY AUTOINCREMENT, nombre VARCHAR(255) NOT NULL , mail VARCHAR(255) NOT NULL, usuario VARCHAR(15) NOT NULL,stagenumber INTEGER NOT NULL , FOREIGN KEY (stagenumber) REFERENCES Stage(stagenumber))');

    db.execute(
        'CREATE TABLE Meditation (codmed INTEGER PRIMARY KEY AUTOINCREMENT, duration DATETIME NOT NULL,recording VARCHAR(15), guided INTEGER NOT NULL )');

    db.execute(
        'CREATE TABLE Lesson(codlesson INTEGER PRIMARY KEY AUTOINCREMENT, slider VARCHAR(15) NOT NULL, description VARCHAR(50) NOT NULL, text TEXT ,stagenumber INTEGER NOT NULL, FOREIGN KEY (stagenumber) REFERENCES Stage (stagenumber))');

    db.execute(
        'CREATE TABLE MeditationsinProgress(cod_user INTEGER NOT NULL, codmed INTEGER NOT NULL, FOREIGN KEY (coduser) REFERENCES User(coduser), FOREIGN KEY (codmed) REFERENCES Meditation(codmed))');

    db.execute(
        'CREATE TABLE FinishedMeditation(coduser INTEGER NOT NULL, codmed INTEGER NOT NULL, FOREIGN KEY (coduser) REFERENCES User(coduser), FOREIGN KEY (codmed) REFERENCES Meditation(codmed))');

    db.execute(
        'CREATE TABLE LearnedLessons(codlesson INTEGER NOT NULL, coduser INTEGER NOT NULL,FOREIGN KEY (codlesson)  REFERENCES Lesson(codlesson), FOREIGN KEY(coduser) REFERENCES User(coduser))');
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

/** 
class DataBase {
  //Stages DB
  static ObservableList<Stage> stages = new ObservableList();
  //lessons DB
  static ObservableList<Lesson> lessons = new ObservableList<Lesson>();
  //users DB
  static ObservableList<User> users = new ObservableList<User>();
  //meditations DB. The map is for referencing their Ids.
  static ObservableMap<String, Meditation> allmeditations = new ObservableMap();
  //feed DB. One feed has the lists internally
  static Feed feed = new Feed();

// id for diferenciating the user. It is the position that the user has in the users list.

  //instantiate the database
  DataBase() {
    stages.addAll([
      new Stage(stageNumber: 1),
      new Stage(stageNumber: 2),
      new Stage(stageNumber: 3),
      new Stage(stageNumber: 4),
      new Stage(stageNumber: 5),
      new Stage(stageNumber: 6),
      new Stage(stageNumber: 7),
      new Stage(stageNumber: 8),
      new Stage(stageNumber: 9),
      new Stage(stageNumber: 10)
    ]);

    //We create three lessons per stage
    for (int i = 0; i < stages.length; i++) {
      Lesson lesson =
          new Lesson(quickdescription: "example lesson", stageNumber: i + 1);
      Lesson lesson2 = new Lesson(
          quickdescription: "peripheral vs awareness", stageNumber: i + 1);
      Lesson lesson3 = new Lesson(
          quickdescription: "the five hindrances", stageNumber: i + 1);
    }

    //Create few users
    User prueba = new User(
        nombrepila: "jose",
        mail: "jose@gmail.com",
        userName: "jose27",
        assignedStage: 1);

    User prueba2 = new User(
      nombrepila: "Ernest",
      mail: "ernest@gmail.com",
      userName: "ernie27",
      assignedStage: 2,
    );

    User prueba3 = new User(
      nombrepila: "Jaimito",
      mail: "jaimito@gmail.com",
      userName: "jaimito",
      assignedStage: 3,
    );

    User prueba4 = new User(
      nombrepila: "Carla",
      mail: "carla@gmail.com",
      userName: "carlita",
      assignedStage: 1,
    );

    //We create done meditations for each users
    new NonGuidedMeditation(duration: Duration(hours: 1), userId: 0);

    new NonGuidedMeditation(duration: Duration(hours: 1), userId: 1);
    new NonGuidedMeditation(duration: Duration(hours: 1), userId: 2);
    new GuidedMeditation(
        recording: 'Culadasa.mp3', duration: Duration(hours: 1), userId: 3);

    new GuidedMeditation(
        recording: 'Culadasa2.mp3', duration: Duration(hours: 1), userId: 3);

    new NonGuidedMeditation(duration: Duration(minutes: 20), userId: 3);
  }

  //Methods for referencing the database
  static ObservableList<Stage> getStages() => stages;

  static ObservableList<Lesson> getLessons() => lessons;

  static ObservableList<User> getUsers() => users;

  static ObservableMap<String, Meditation> addMeditation(Meditation m) =>
      meditations[m.id] = m;

  static void addLesson(Lesson l) => lessons.add(l);

  static void addUser(User u) {
    users.add(u);
  }

  static Stage getStage(int stageNumber) => stages[--stageNumber];

  static Feed getFeed() => feed;
} */
