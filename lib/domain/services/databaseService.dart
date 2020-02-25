//This class is for simulating a DataBase. In the future, this class will access the database and handle all the operations in there.
import 'package:meditation_app/domain/model/lessonModel.dart';
import 'package:meditation_app/domain/model/meditationModel.dart';
import 'package:meditation_app/domain/model/stageModel.dart';
import 'package:meditation_app/domain/model/userModel.dart';
import 'package:meditation_app/resources/database.dart';
import 'package:observable/observable.dart';

//This class is for connecting with the database. Every request to the DB MUST pass from this class.
class DataBaseConnection {
  static int userCount = 0;

  static ObservableList<Stage> getStages() => DataBase.getStages();

  static ObservableList<Lesson> getLessons() => DataBase.getLessons();

  static ObservableList<User> getUsers() => DataBase.getUsers();

  static ObservableList<Meditation> getMeditations() =>
      DataBase.getMeditations();

  //Adds the lesson to the DB then it adds it to the users lessons and to the stage lessons.
  static void addLesson(Lesson l) {
    DataBase.addLesson(l);
    DataBase.getStage(l.getStageNumber()).addLesson(l);
  }

  //We add the user to the DB. We populate the users' lists with remaining lessons from the stage. We add it to the feed
  //We also assign an id to the user
  static void addUser(User u) {
    Stage assigned = DataBaseConnection.getStage(u.assignedStage);
    u.remainingLessons.addAll(assigned.lessons);
    u.setFeed(DataBase.getFeed());
    u.setId(userCount++);

    DataBase.addUser(u);
    assigned.addPerson(u);
  }

//When a user has started meditating, it gets added to the
  static void userStartedMeditating(User u, Meditation m) {
    //we add the meditation for referencing in the feed.
    DataBase.addMeditation(m);
    DataBase.getFeed().incrMeditations(m.id);
  }

//When the user stops the meditation in progress. It is deleted from the feed and removed from the meditations in progress.
  static void userStoppedMeditating(User u, Meditation m, bool finished) {
    DataBase.getFeed().decrMeditations(m.id);
    //We update the database where this meditation is stored.
    DataBase.addMeditation(m);
  }

  static Stage getStage(int number) => DataBase.getStage(number);
}
