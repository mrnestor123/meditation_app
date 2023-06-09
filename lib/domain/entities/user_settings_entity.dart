
import 'package:flutter/material.dart';
import 'package:meditation_app/domain/entities/meditation_entity.dart';

dynamic stagesettings = [
  'unlockall',
  'casual',
  'unlocklesson',
  'unlockmeditations'
];

// ESTO DENTRO DE USER_ENTITY !!!!
class UserSettings{
  List<String> allsettings = new List.empty(growable: true);
  MeditationSettings meditation;
  String progression;
  bool seenIntroCarousel = false;
  int lastMeditDuration = 0;
  TimeOfDay reminderTime;
  bool askedProgressionQuestions = false;
  //bool readTMI;
  


  UserSettings({
    this.meditation,
    this.progression, 
    this.seenIntroCarousel, 
    this.lastMeditDuration,
    this.askedProgressionQuestions = false,
    this.reminderTime
  });


  void getSettings(){
    return ; 
  }

  String getProgression() => this.progression;

  //PODEMOS comprobar que este dentro de lasp rogresiones posibles
  void setProgression(String name) => this.progression = name;

  bool unlocksMeditation() => progression == 'unlockmeditations' || progression == 'unlockall';
  bool unlocksLesson() => progression == 'unlocklesson' || progression == 'unlockall';


  factory UserSettings.empty() => UserSettings(progression: 'casual', meditation: MeditationSettings() );

  factory UserSettings.fromJson(Map<String, dynamic> json) =>
    UserSettings(
      progression: json['progression'] == null ? 'casual' : json['progression'],
      seenIntroCarousel: json['seenIntroCarousel'] == null ? false : json['seenIntroCarousel'],
      lastMeditDuration: json['lastMeditDuration'] == null ? 0 : json['lastMeditDuration'],
      reminderTime: json['reminderTime'] == null ? null : json['reminderTime'],
      meditation: json['meditation'] == null ? MeditationSettings() : MeditationSettings.fromJson(json['meditation']),
      askedProgressionQuestions: json['askedProgressionQuestions'] == null ? false : json['askedProgressionQuestions'],
      //readTMI: json['readTMI'] == null ? false : json['readTMI'],
      //meditSettings: json['meditSettings'] =
    );  

  Map<String, dynamic> toJson() => {
    "progression": progression == null ? null : progression,
    "seenIntroCarousel": seenIntroCarousel == null ? null : seenIntroCarousel,
    "lastMeditDuration": lastMeditDuration == null ? null : lastMeditDuration,
    "reminderTime": reminderTime == null ? null : reminderTime,
    "askedProgressionQuestions": askedProgressionQuestions == null ? false : askedProgressionQuestions,
    "new": true,
    "meditation": meditation == null ? null : meditation.toJson(),
  };
}

class MeditSettings {
  String finishgong;
  String alertgong;
}

class StageSettings {
  String progression;
}