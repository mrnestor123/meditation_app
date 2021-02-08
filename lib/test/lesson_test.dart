import 'package:flutter_test/flutter_test.dart';
import 'package:meditation_app/data/models/lesson_model.dart';
import 'package:meditation_app/data/models/meditationData.dart';
import 'package:meditation_app/data/models/mission_model.dart';
import 'package:meditation_app/data/models/userData.dart';
import 'package:meditation_app/domain/entities/lesson_entity.dart';
import 'package:meditation_app/domain/entities/level.dart';
import 'package:meditation_app/domain/entities/meditation_entity.dart';
import 'package:meditation_app/domain/entities/mission.dart';
import 'package:meditation_app/domain/entities/stage_entity.dart';
import 'package:meditation_app/domain/entities/user_entity.dart';
import 'package:mobx/mobx.dart';

//This test is for checking when a meditation is done if its added to the users meditations and to the currentmeditations Feed.
void main() {
  test('Meditation and lesson testing', () {
    Map<String, List<Lesson>> lessons = new Map();

    for (int i = 0; i < 7; i++) {
      if (lessons[i.toString()] == null) {
        lessons[i.toString()] = new ObservableList();
      }
      lessons[i.toString()].add(new Lesson(
          title: 'Lesson ' + i.toString(), description: 'test', text: []));
    }

    Stage one = new Stage(stagenumber: 1, image: 'stage1', objectives: {
      'totaltime': 240,
      'meditation': {'count': 5, 'time': 20},
      'streak': 7,
      'lecciones':8
    });

    one.path = lessons;

    User user = new User(nombre: "ernest", stagenumber: 1, stage: one, stats: {
      'total': {'lecciones': 0, 'meditaciones': 0, 'maxstreak': 0, 'tiempo': 0},
      'etapa': {
        'lecciones': 0,
        'medittiempo': 0,
        'meditguiadas': 0,
        'maxstreak': 0,
        'tiempo': 0
      },
      'racha': 0,
      'ultimosleidos': [],
      'lastmeditated': ''
    });

    Meditation m0 = new MeditationModel(
        duration: Duration(minutes: 10), day: DateTime.now());
    user.takeMeditation(m0);


    MeditationModel m1 = new MeditationModel(
        duration: Duration(minutes: 10),
        day: DateTime.now().add(Duration(days: 1)));
    user.takeMeditation(m1);


    MeditationModel m2 = new MeditationModel(
        duration: Duration(minutes: 20),
        day: DateTime.now().add(Duration(days: 2)));
    user.takeMeditation(m2);


    MeditationModel m3 = new MeditationModel(
        duration: Duration(minutes: 20),
        day: DateTime.now().add(Duration(days: 3)));
    user.takeMeditation(m3);


    MeditationModel m4 = new MeditationModel(
        duration: Duration(minutes: 5),
        day: DateTime.now().add(Duration(days: 3)));
    user.takeMeditation(m4);


    MeditationModel m5 = new MeditationModel(
        duration: Duration(minutes: 5),
        day: DateTime.now().add(Duration(days: 4)));
    user.takeMeditation(m5);


    MeditationModel m6 = new MeditationModel(
        duration: Duration(minutes: 20),
        day: DateTime.now().add(Duration(days: 4)));
    user.takeMeditation(m6);

    MeditationModel m7 = new MeditationModel(
        duration: Duration(minutes: 50),
        day: DateTime.now().add(Duration(days: 5)));
    user.takeMeditation(m7);

    one.checkifPassedStage(user);

    MeditationModel m8 = new MeditationModel(
        duration: Duration(minutes: 50),
        day: DateTime.now().add(Duration(days: 6)));
    user.takeMeditation(m8);

    MeditationModel m9 = new MeditationModel(
        duration: Duration(minutes: 50),
        day:  DateTime.now().add(Duration(days: 6)));
    user.takeMeditation(m9);

    expect(user.stats['racha'] == 7, true);


    MeditationModel m10 = new MeditationModel(
        duration: Duration(minutes: 50),
        day: DateTime.now().add(Duration(days: 7)));
    user.takeMeditation(m10);

    MeditationModel m11 = new MeditationModel(
        duration: Duration(minutes: 50),
        day: DateTime.now().add(Duration(days: 8)));
    user.takeMeditation(m11);

    one.path.forEach((key, value) {
      value.forEach((element) {
        user.takeLesson(element);
      });
    });

    one.checkifPassedStage(user);

  });
}
