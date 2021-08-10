import 'package:flutter_test/flutter_test.dart';
import 'package:meditation_app/data/datasources/remote_data_source.dart';
import 'package:meditation_app/data/models/meditationData.dart';
import 'package:meditation_app/domain/entities/content_entity.dart';
import 'package:meditation_app/domain/entities/database_entity.dart';
import 'package:meditation_app/domain/entities/lesson_entity.dart';
import 'package:meditation_app/domain/entities/meditation_entity.dart';
import 'package:meditation_app/domain/entities/stage_entity.dart';
import 'package:meditation_app/domain/entities/stats_entity.dart';
import 'package:meditation_app/domain/entities/user_entity.dart';
import 'package:mobx/mobx.dart';

void main() {
  Stage one = new Stage(stagenumber: 1, image: 'stage1', 
    stobjectives: StageObjectives(totaltime: 240,meditationfreetime: 20,meditationcount: 2,lecciones: 8, streak: 6),
  );

  for (int i = 0; i < 7; i++) {
    one.addLesson(new Lesson(title: 'Lesson ' + i.toString(), description: 'test', text: []));
    one.addMeditation(new Meditation(duration: Duration(hours: 15), title: 'Guided meditation '+ i.toString()));
  }

  User user = new User(
      nombre: "ernest", 
      stagenumber: 1, 
      meditposition: 0,
      stage: one, 
      userStats: UserStats.empty()
  );

  DataBase d = new DataBase();
  
  d.stages.add(one);
  d.stages.add(one);  

  Meditation m = Meditation(duration: Duration(minutes: 240));

  //a lo mejor hay que checkear mas casos
  test('meditations ', () {
    

    Meditation m0 = new Meditation(duration: Duration(minutes: 15), day: DateTime.now());
    user.takeMeditation(m0);

    expect(user.userStats.stage.maxstreak, 1);
    expect(user.userStats.total.maxstreak, 1);
    expect(user.userStats.streak, 1);
    expect(user.userStats.meditationtime[DateTime.now().day.toString() + '-' + DateTime.now().month.toString()], 15);

    Meditation m2 = new Meditation(duration: Duration(minutes:20),day:DateTime.now());
    user.takeMeditation(m2); 
    user.takeMeditation(m2);

    expect(user.userStats.meditationtime[DateTime.now().day.toString() + '-' + DateTime.now().month.toString()], 55);
    expect(user.userStats.streak, 1);

    Meditation m1 = new Meditation(duration: Duration(minutes:20),day:DateTime.now().add(Duration(days:2)));
    user.takeMeditation(m1);  

    Meditation m3 = new Meditation(duration: Duration(minutes:20),day:DateTime.now().add(Duration(days:2)), title:"Guided meditation");
    user.takeMeditation(m3);  

    expect(user.userStats.stage.guidedmeditations, 1);
    expect(user.userStats.total.meditations, 5);
    expect(user.userStats.stage.maxstreak, 1);
    expect(user.userStats.streak, 1);

    Meditation m4 = new Meditation(duration: Duration(minutes:20),day:DateTime.now().add(Duration(days:3)), title:"Guided meditation");
    user.takeMeditation(m4);  

    expect(user.userStats.streak, 2);

    Meditation m5 = new Meditation(duration: Duration(minutes:20),day:DateTime.now().add(Duration(days:4)), title:"Guided meditation");
    user.takeMeditation(m5);

    expect(user.userStats.streak, 3);
    expect(user.userStats.streak, 3);
  

    Meditation m6 = new Meditation(duration: Duration(minutes:20),day:DateTime.now().add(Duration(days:6)), title:"Guided meditation");
    user.takeMeditation(m6);  

    expect(user.userStats.streak, 1);
    expect(user.userStats.stage.timemeditated, 155 );

  });

  test('update stage', () {
    for(Lesson l in one.path){
      //HAY QUE ELIMINAR D DE TAKE LESSON
      user.takeLesson(l, d); 
    } 
    

    for(Meditation m in one.meditpath){
      user.takeMeditation(m,d);
    }


  });

  test('update stage by lesson', (){

  });

  test('update stage by free meditation', (){
  });

  test('update stage by guided meditation', (){

  });


  test('lessons', () {
    









  });
}


