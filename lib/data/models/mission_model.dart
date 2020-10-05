import 'package:meditation_app/domain/entities/mission.dart';

class MissionModel extends Mission {
  String codmission;
  String description;
  String image;
  String type;
  String requirement;
  bool requiredmission;
  bool done;
  int xp;

  MissionModel(
      {this.codmission,
      this.description,
      this.type,
      this.image,
      this.requirement,
      this.requiredmission,
      this.done,
      this.xp})
      : super(
            codmission: codmission,
            description: description,
            type: type,
            requirement: requirement,
            requiredmission: requiredmission,
            done: done,
            image: image,
            xp: xp);

  factory MissionModel.fromJson(Map<String, dynamic> json) {
    MissionModel m = MissionModel(
        codmission: json['codmission'] == null ? null : json['codmission'],
        description: json['description'] == null ? null : json['description'],
        type: json['type'] == null ? null : json['type'],
        image: json['image'] == null ? null : json['image'],
        requirement: json['requirement'] == null ? null : json['requirement'],
        requiredmission: json['required'] == null ? null : json['required'],
        done: json['done'] == null ? false : json['done'],
        xp: json['xp'] == null ? null : json['xp']);
    m.requirements = json["requirements"];
    return m;
  }

  Map<String, dynamic> toJson() => {
        "codmission": codmission == null ? null : codmission,
        "description": description == null ? null : description,
        "type": type == null ? null : type,
        "requirement": requirement == null ? null : requirement,
        "image": image == null ? null : image,
        "done": done == null ? false : done,
        "xp": xp == null ? null : xp,
        "required": requiredmission == null ? null : requiredmission,
        "requirements":
            requirements == null ? null : requirements.map((e) => e).toList()
      };

}
