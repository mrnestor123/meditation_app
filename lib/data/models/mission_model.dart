import 'package:meditation_app/domain/entities/mission.dart';

class MissionModel extends Mission {
  String codmission;
  String description;
  String image;
  String type;
  String requirement;
  int xp;

  MissionModel(
      {this.codmission,
      this.description,
      this.type,
      this.image,
      this.requirement,
      this.xp})
      : super(
            codmission: codmission,
            description: description,
            type: type,
            requirement: requirement,
            image: image,
            xp: xp);

  factory MissionModel.fromJson(Map<String, dynamic> json) {
    MissionModel m = MissionModel(
        codmission: json['codmission'] == null ? null : json['codmission'],
        description: json['description'] == null ? null : json['description'],
        type: json['type'] == null ? null : json['type'],
        image: json['image'] == null ? null : json['image'],
        requirement: json['requirement'] == null ? null : json['requirement'],
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
        "xp": xp == null ? null : xp
      };
}
