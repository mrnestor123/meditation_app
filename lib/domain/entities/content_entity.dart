import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class Content {
  String cod, title, description, image, type;
  int stagenumber;

  Content({cod, @required this.stagenumber, this.title, this.description, this.image, this.type}) {
    if (cod == null) {
      var uuid = Uuid();
      this.cod = uuid.v1();
    } else {
      this.cod = cod;
    }
  }

  // funciones ?? 
  //takecontent ????
  // edit ????



}
