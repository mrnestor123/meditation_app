import 'package:flutter_test/flutter_test.dart';
import 'package:meditation_app/data/models/lesson_model.dart';
import 'package:meditation_app/data/models/meditationData.dart';
import 'package:meditation_app/data/models/mission_model.dart';
import 'package:meditation_app/data/models/userData.dart';
import 'package:meditation_app/domain/entities/lesson_entity.dart';
import 'package:meditation_app/domain/entities/level.dart';
import 'package:meditation_app/domain/entities/meditation_entity.dart';
import 'package:meditation_app/domain/entities/mission.dart';
import 'package:meditation_app/domain/entities/user_entity.dart';

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

    //el método meditar devuelve una lista con las misiones que se ha pasado. Debería devolver una.
    List<Mission> meditmission = user.takeMeditation(new MeditationModel(duration: Duration(minutes: 20)));
    List<Mission> lessonmission = user.takeLesson(new LessonModel(codlesson: "1", description: "description test", text: null, xp: 100, title: "Test lesson"));
    List<Mission> lesson2mission = user.takeLesson(new LessonModel(codlesson: "2", description: "description test", text: null, xp: 100, title: "Test lesson"));
    
    expect(user.stagenumber == 2, true);
    expect(user.level.levelxp > 0 ,true);
    expect(meditmission.length ==1 , true);
    expect(lessonmission.length ==1, false);
    expect(lesson2mission.length ==1, true);
  });
}
