//Objeto para almacenar información de la base de datos

import 'package:meditation_app/domain/entities/request_entity.dart';
import 'package:meditation_app/domain/entities/stage_entity.dart';
import 'package:meditation_app/domain/entities/user_entity.dart';
import 'package:meditation_app/domain/entities/version_entity.dart';
import 'package:mobx/mobx.dart';

import 'lesson_entity.dart';
import 'meditation_entity.dart';

//habrá que ir añadiéndole datos
class DataBase {
  //PODRIAN SER LISTS?? NO CAMBIAN  CREO !!
  ObservableList<Stage> stages = new ObservableList();
  ObservableList<User> users = new ObservableList();
  ObservableList<Request> requests = new ObservableList();
  ObservableList<Meditation> nostagemeditations = new ObservableList();
  ObservableList<Lesson> nostagelessons = new ObservableList();

  //ALGO MOMENTÁNEO PARA HACER 
  List<Phase> phases = new List.empty(growable: true);


  List<Version> versions = new List.empty(growable: true);
  Version lastVersion;


  DataBase();

  void addVersion(Version v){
    print('Adding version');
    versions.add(v);
  }

  void getLastVersion(){
    Version last = versions[0];

    for(Version v in versions){
      if(last.versionNumber < v.versionNumber){
        last = v;
      }
    }

    this.lastVersion = last;

  }

  //habrá que implementar un método update, etc etc.
}
