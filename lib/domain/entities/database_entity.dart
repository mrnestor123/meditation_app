//Objeto para almacenar información de la base de datos

import 'package:meditation_app/domain/entities/stage_entity.dart';
import 'package:meditation_app/domain/entities/user_entity.dart';
import 'package:mobx/mobx.dart';

//habrá que ir añadiéndole datos
class DataBase {
  ObservableList<Stage> stages = new ObservableList();
  ObservableList<User> users = new ObservableList();
  String version;
  String versionnotes;

  DataBase();

  //habrá que implementar un método update, etc etc.
}
