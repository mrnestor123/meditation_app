import 'package:flutter_test/flutter_test.dart';
import 'package:meditation_app/data/models/lesson_model.dart';
import 'package:meditation_app/data/models/meditationData.dart';
import 'package:meditation_app/data/models/mission_model.dart';
import 'package:meditation_app/data/models/userData.dart';
import 'package:meditation_app/domain/entities/lesson_entity.dart';
import 'package:meditation_app/domain/entities/level.dart';
import 'package:meditation_app/domain/entities/meditation_entity.dart';
import 'package:meditation_app/domain/entities/mission.dart';

//This test is for checking when a meditation is done if its added to the users meditations and to the currentmeditations Feed.
void main() {
  test('Meditation and lesson testing', () {
    MissionModel m = new MissionModel(type:"meditation",xp:100,requirement:"time",done:false);
    //el requerimiento será meditar 20 min
    m.requirements=[20];
    MissionModel u = new MissionModel(type:"lesson",xp:100,requirement:"list",done:false);
    //el requerimiento será leerse estas dos lecciones
    u.requirements = ["1","2"];
    UserModel user = new UserModel(level: Level(), nombre:"ernest",mail: 'jose@gmail.com', usuario: 'ernest', password: 'xxx', stagenumber: 1);
    user.setRequiredMissions([m,u]);

    MeditationModel m1 = new MeditationModel(duration: Duration(minutes: 10),day:new DateTime(2020));
    Meditation m5 = new MeditationModel(duration: Duration(minutes: 10),day: new DateTime(2020));
    MeditationModel m2 = new MeditationModel(duration: Duration(minutes: 5),day:new DateTime(2020).add(Duration(days: 1)));
    MeditationModel m3 = new MeditationModel(duration: Duration(minutes: 5),day:new DateTime(2020).add(Duration(days: 2)));
    MeditationModel m4 = new MeditationModel(duration: Duration(minutes: 5),day:new DateTime(2020).add(Duration(days: 3)));
    
    user.takeMeditation(m1);user.takeMeditation(m5);user.takeMeditation(m2);user.takeMeditation(m3);user.takeMeditation(m4);
    expect(user.meditationstreak == 4,true);

    MeditationModel m6 = new MeditationModel(duration: Duration(minutes: 5),day:new DateTime(2020).add(Duration(days: 5)));
    user.takeMeditation(m6);
    expect(user.meditationstreak == 1,true);
    LessonModel l =new LessonModel(codlesson: "1", description: "description test", text: null, xp: 100, title: "Test lesson");
    user.takeLesson(l);user.takeLesson(l); user.takeLesson(l);
    expect(user.lessonslearned.length ==1 ,true);
  });
}
