import 'package:uuid/uuid.dart';

class Mission {
  String codmission;
  String description;
  String image;

  //meditation-count means total meditations. meditation-streak means days consecutively meditating
  // type = lesson || meditation 
  String type;

  bool done;
  bool requiredmission;

  //requirement can be time,count,streak,list,single(for reading single lesson)
  String requirement;

  //requirements can be a list with the codes of the lessons, when having to read different lessons.
  List<dynamic> requirements;
  int xp;

  Mission({this.codmission, this.image, this.description, this.xp, this.type,
      this.requirement,this.done,this.requiredmission}) {
    if (codmission == null) {
      var uuid = Uuid();
      this.codmission = uuid.v1();
    }
  }
  
  void passed() => this.done = true;

}
