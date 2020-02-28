import 'package:meditation_app/domain/model/feedModel.dart';
import 'package:meditation_app/domain/model/lessonModel.dart';
import 'package:meditation_app/domain/model/meditationModel.dart';
import 'package:meditation_app/domain/model/stageModel.dart';
import 'package:meditation_app/domain/model/userModel.dart';
import 'package:observable/observable.dart';
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
