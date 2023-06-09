


import 'package:meditation_app/domain/entities/request_entity.dart';


// puede ser un feed de hoy o de la semana pasada
class Feed {

  List<Request> requests = new List.empty(growable: true);


  Feed();

}