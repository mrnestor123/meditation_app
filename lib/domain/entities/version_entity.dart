
class Version {
  int versionNumber;
  String description;
  List<dynamic> content = new List.empty(growable: true);

  void updateVersion(){}

  Version.fromJson(Map<String, dynamic> json) {
    this.versionNumber= int.parse(json['versionNumber']);
    this.description= json['description'];
   //ESTO SE PUEDE HACER EN OTROS SITIOS
    if (json['content'] != null) {
      json['content'].forEach((v) {
        this.content.add(v);
      });
    }
  }
}