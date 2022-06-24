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
  Stage one = new Stage(
    stagenumber: 1, image: 'stage1', 
    stobjectives: StageObjectives(
      totaltime: 100,
      meditationfreetime: 20,
      meditguiadas: 0,
      meditationcount: 2,
      lecciones: 0, 
      streak: 3
    ),
  );

  for (int i = 0; i < 6; i++) {
    one.addLesson(new Lesson(title: 'Lesson ' + i.toString(), description: 'test', text: [], position: i,stagenumber: 1));
    one.addMeditation(new Meditation(duration: Duration(minutes: 5), title: 'Guided meditation '+ i.toString(),position: i,stagenumber: 1));
  }

  User user = new User(
    nombre: "ernest", 
    stagenumber: 1, 
    meditposition: 0,
    position: 1,
    stage: one, 
    userStats: UserStats.empty()
  );

  DataBase d = new DataBase();
  
  d.stages.add(one);
  d.stages.add(one);


  Meditation m = Meditation(duration: Duration(minutes: 240));

  //a lo mejor hay que checkear mas casos
  /*
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

    Meditation m3 = new Meditation(duration: Duration(minutes:20),day:DateTime.now().add(Duration(days:2)), title:"Guided meditation", stagenumber: 1);
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
  */

  // HACER TESTS PARA COMPROBAR SI SE SUBE DE ETAPA !!!
  test('update stage', () {
  
    print({'GOT LESSON',user.passedObjectives});
    
    for(Meditation m in one.meditpath.sublist(0,one.meditpath.length-1)){
      user.takeMeditation(m,d);
    }

    
    print(user.passedObjectives);


    expect(user.userStats.stage.guidedmeditations, 5);  

    Meditation m1 = new Meditation(duration: Duration(minutes:5),day:DateTime.now().add(Duration(days:1)));
    Meditation m2 = new Meditation(duration: Duration(minutes:5),day:DateTime.now().add(Duration(days:2)));
    Meditation m3 = new Meditation(duration: Duration(minutes:5),day:DateTime.now().add(Duration(days:1)));

    
    user.takeMeditation(m1);
    user.takeMeditation(m2);
    user.takeMeditation(m3);

    print(user.passedObjectives);

    user.takeMeditation(one.meditpath[one.meditpath.length-1],d);

    print(user.passedObjectives);


    for(Lesson l in one.path){
      //HAY QUE ELIMINAR D DE TAKE LESSON
      user.takeLesson(l, d); 
    } 


    Meditation m4 = new Meditation(duration: Duration(minutes:60),day:DateTime.now().add(Duration(days:2)));

    user.takeMeditation(m4, d);

    print(user.passedObjectives);


    expect(user.stagenumber == 2, true);
    


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


