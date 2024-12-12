
import 'package:flutter/material.dart';
import 'package:meditation_app/domain/entities/meditation_entity.dart';
import 'package:meditation_app/presentation/pages/commonWidget/date_tostring.dart';

dynamic stagesettings = [
  'unlockall',
  'casual',
  'unlocklesson',
  'unlockmeditations'
];

// ESTO DENTRO DE USER_ENTITY !!!!
class UserSettings {
  List<String> allsettings = new List.empty(growable: true);
  MeditationSettings meditation;
  String progression;
  bool seenIntroCarousel = false;
  bool acceptMails = false;
  int lastMeditDuration = 0;
  TimeOfDay reminderTime;
  bool askedProgressionQuestions = false;
  bool hideInLeaderboard = false;
  DateTime lastMessageSent;

  UserSettings({
    this.meditation,
    this.progression, 
    this.seenIntroCarousel, 
    this.lastMeditDuration,
    this.askedProgressionQuestions = false,
    this.hideInLeaderboard = false,
    this.lastMessageSent,
    this.acceptMails,
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
      acceptMails: json['acceptMails'] == null ? null : json['acceptMails'],
      hideInLeaderboard: json['hideInLeaderboard'] == null ? false : json['hideInLeaderboard'],
      lastMessageSent: json['lastMessageSent'] == null ? null : DateTime.parse(json['lastMessageSent']),
      meditation: json['meditation'] == null ? MeditationSettings() : MeditationSettings.fromJson(json['meditation']),
      askedProgressionQuestions: json['askedProgressionQuestions'] == null ? false : json['askedProgressionQuestions'],
      //readTMI: json['readTMI'] == null ? false : json['readTMI'],
      //meditSettings: json['meditSettings'] =
    );  

  Map<String, dynamic> toJson() => {
    "progression": progression == null ? null : progression,
    "seenIntroCarousel": seenIntroCarousel == null ? null : seenIntroCarousel,
    "lastMeditDuration": lastMeditDuration == null ? null : lastMeditDuration,
    "hideInLeaderboard": hideInLeaderboard == null ? null : hideInLeaderboard,
    "acceptMails": acceptMails == null ? null : acceptMails,
    "reminderTime": reminderTime == null ? null : reminderTime,
    "lastMessageSent": lastMessageSent == null ? null : lastMessageSent.toIso8601String(),
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