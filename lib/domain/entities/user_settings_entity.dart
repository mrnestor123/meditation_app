
dynamic stagesettings = [
  'unlockall',
  'casual',
  'unlocklesson',
  'unlockmeditations'
];


class UserSettings{

  List<String> allsettings = new List.empty(growable: true);
  MeditSettings meditSettings;

  String progression;


  UserSettings({this.meditSettings,this.progression});

  void getSettings(){
    return ; 
  }

  String getProgression() => this.progression;

  //PODEMOS comprobar que este dentro de lasp rogresiones posibles
  void setProgression(String name) => this.progression = name;

  bool unlocksMeditation() => progression == 'unlockmeditations' || progression == 'unlockall';
  bool unlocksLesson() => progression == 'unlocklesson' || progression == 'unlockall';


  factory UserSettings.empty() => UserSettings(progression: 'casual');

  factory UserSettings.fromJson(Map<String, dynamic> json) =>
    UserSettings(
      progression: json['progression'] == null ? 'casual' : json['progression']
    );  

  Map<String, dynamic> toJson() => {
    "progression": progression == null ? null : progression,
  };
  
}

class MeditSettings {
  String finishgong;
  String alertgong;
}

class StageSettings {
  String progression;
}