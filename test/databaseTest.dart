import 'package:flutter_test/flutter_test.dart';
import 'package:meditation_app/domain/model/lessonModel.dart';
import 'package:meditation_app/domain/model/meditationModel.dart';
import 'package:meditation_app/domain/model/userModel.dart';
import 'package:meditation_app/resources/database.dart';

void main() {
  test('DataBase testing', () {
    //We instantiate the database
    new DataBase();

    User added = new User(
        nombrepila: "monstruo",
        mail: "monstruo@gmail.com",
        userName: "esteve23",
        assignedStage: 4);

    new Lesson(quickdescription: "New Lesson", stageNumber: 2);

    new GuidedMeditation(
        duration: Duration(minutes: 30),
        userId: added.id,
        recording: "metalking.mp3");

    new NonGuidedMeditation(duration: Duration(minutes: 20), userId: added.id);

    new NonGuidedMeditation(duration: Duration(minutes: 10), userId: added.id);

    expect(DataBase.getLessons().length, 31);
    expect(DataBase.getUsers().length, 5);
    expect(DataBase.getStage(2).lessons.length, 4);
    expect(DataBase.getUsers()[added.id].totalMeditations.length, 3);
    expect(DataBase.getFeed().getUsers().length, 5);
  });
}
