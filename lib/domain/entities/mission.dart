import 'package:uuid/uuid.dart';

class Mission {
  String codmission;
  String description;
  String image;

  // type = lesson || meditation || streak
  String type;
  bool done;

  //requirement can be two week streak, 15 min meditation, totaltime, totalmeditations
  String requirement;

  //requirements can be a list with the codes of the lessons, when having to read all the lessons.
  List<dynamic> requirements;
  int xp;

  Mission({this.codmission, this.image, this.description, this.xp, this.type,
      this.requirement,this.done}) {
    if (codmission == null) {
      var uuid = Uuid();
      this.codmission = uuid.v1();
    }
  }
}
