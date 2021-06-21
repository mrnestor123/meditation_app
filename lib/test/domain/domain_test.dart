import 'package:flutter_test/flutter_test.dart';
import 'package:meditation_app/data/models/meditationData.dart';
import 'package:meditation_app/domain/entities/content_entity.dart';
import 'package:meditation_app/domain/entities/lesson_entity.dart';
import 'package:meditation_app/domain/entities/meditation_entity.dart';
import 'package:meditation_app/domain/entities/stage_entity.dart';
import 'package:meditation_app/domain/entities/user_entity.dart';
import 'package:mobx/mobx.dart';


void main() {
  Stage one = new Stage(stagenumber: 1, image: 'stage1', 
    objectives: {
        'totaltime': 240,
        'meditation': {'count': 5, 'time': 20},
        'streak': 7,
        'lecciones':8
    });
  
  test('meditations ', () {
    User user = new User(nombre: "ernest", stagenumber: 1, 
    stage: one, 
    stats: {
      'total': {'lecciones': 0, 'meditaciones': 0, 'maxstreak': 0, 'tiempo': 0},
      'etapa': {
        'lecciones': 0,
        'medittiempo': 0,
        'meditguiadas': 5,
        'maxstreak': 0,
        'tiempo': 0
      },
      'meditationtime': {},
      'racha': 5,
      'ultimosleidos': [],
      'lastmeditated': DateTime.now().subtract(Duration(days: 1)).toIso8601String()
    });
    Meditation m0 = new Meditation(duration: Duration(minutes: 15), day: DateTime.now());
    user.takeMeditation(m0);

    expect(user.stats['etapa']['maxstreak'], 6);
    expect(user.stats['total']['maxstreak'], 6);
    expect(user.stats['racha'], 6);
    expect(user.stats['meditationtime'][DateTime.now().day.toString() + '-' + DateTime.now().month.toString()], 15);

    Meditation m2 = new Meditation(duration: Duration(minutes:20),day:DateTime.now());
    user.takeMeditation(m2); 


    expect(user.stats['meditationtime'][DateTime.now().day.toString() + '-' + DateTime.now().month.toString()], 35);
    expect(user.stats['racha'], 6);

    Meditation m1 = new Meditation(duration: Duration(minutes:20),day:DateTime.now().add(Duration(days:2)));
    user.takeMeditation(m1);  


    
    Meditation m3 = new Meditation(duration: Duration(minutes:20),day:DateTime.now().add(Duration(days:2)), title:"Guided meditation");
    user.takeMeditation(m3);  

    expect(user.stats['etapa']['meditguiadas'], 6);
    expect(user.stats['total']['meditaciones'],4);
    expect(user.stats['etapa']['maxstreak'], 6);
    expect(user.stats['racha'], 1);

    print(user.stats['meditationtime']);



  });

  test('update stage', () {
    List<Content> lessons = ObservableList<Content>();
    for (int i = 0; i < 7; i++) {
      lessons.add(new Lesson(title: 'Lesson ' + i.toString(), description: 'test', text: []));
    }
    Stage one = new Stage(stagenumber: 1, image: 'stage1', 
    objectives: {
        'totaltime': 240,
        'meditation': {'count': 5, 'time': 20},
        'streak': 7,
        'lecciones':8
    });

    one.path = lessons;
  });


  test('lessons', () {
    









  });
}


