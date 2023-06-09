import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:meditation_app/presentation/pages/commonWidget/file_helpers.dart';
import 'package:uuid/uuid.dart';
import 'package:meditation_app/domain/entities/content_entity.dart';


List<IconData> faces = [
  Icons.sentiment_very_dissatisfied,
  Icons.sentiment_dissatisfied,
  Icons.sentiment_neutral,
  Icons.sentiment_satisfied_alt,
  Icons.sentiment_very_satisfied
];  

List<String> moods =  [
  'Very Bad',
  'Bad',
  'Neutral',
  'Good',
  'Very Good'
];


//HAY QUE CREAR CLASE GUIDEDMEDITATION
class Meditation extends FileContent {
  String coduser, notes;
  Duration duration;
  DateTime day;

  //PORQUE SE LLAMA CONTENT MAL NOMBRE !!!
  Map<dynamic, dynamic> content;
  Map<dynamic,dynamic> followalong;

  MeditationReport report;

  MeditationSettings meditationSettings = new MeditationSettings();

  //for referencing the user.
  //final String userId;
  Meditation(
      {
      @required this.duration,
      this.day,
      this.coduser,
      this.content,
      this.followalong,
      cod,
      type = 'meditation-practice',
      stagenumber,
      description,
      image,
      title,
      file = '',
      position,
      this.meditationSettings,
      createdBy,
      notes,
      isNew,
      total,
      report
      })
  : super(
      cod: cod,
      total: total,
      isNew: isNew,
      description: description,
      image: image,
      title: title,
      createdBy: createdBy,
      stagenumber: stagenumber,
      position: position,
      file:file,
      type: type
    ) {
      day == null ? day = DateTime.now() : null;
      meditationSettings == null ? meditationSettings = new MeditationSettings() : null;
    }

  void setDay(DateTime d) => this.day = d;


  factory Meditation.fromContent(FileContent c){
    Duration d;
    if(c.file != null){
      if(isAudio(c.file)){
  
      }
    }

    return Meditation(
      cod: c.cod,
      description: c.description,
      image: c.image,
      title: c.title,
      type:c.type,
      file:c.file,
      duration: d,
      stagenumber: c.stagenumber
    );
  }

  // ESOT DEBERÍA ESTAR EN MEDITATIONMODEL
  Map<String, dynamic> shortMeditation(){
    Map<String,dynamic> json = new Map();

    json['cod'] = this.cod;

    json['coduser']= this.coduser;


    json['duration'] = this.duration != null ? this.duration.inMinutes :  0;

    // LO HACEMOS ASI ??????
    json['day'] = this.day == null ? DateTime.now().millisecondsSinceEpoch : day.millisecondsSinceEpoch;

    if(this.title != null){
      json['title'] = this.title;
    }

    if(this.report != null){
      json['report'] = this.report.toJson();
    }

    return json; 
  }
}


// HAY QUE HACER ESTO !!!!!!!
class GuidedMeditation extends Meditation{
  


}

// ESTO DEBERÍA SER CONSTANTE EN TODOS !!
List<IntervalBell> ambientSounds = [
  IntervalBell(sound: 'assets/ambient_sounds/bonfire.mp3',name:'Bonfire',image:'assets/ambient_sounds/bonfire.jpg'),
  IntervalBell(sound: 'assets/ambient_sounds/ocean.mp3',name:'Ocean Waves ',image:'assets/ambient_sounds/ocean.jpg'),
  IntervalBell(sound: 'assets/ambient_sounds/rain.mp3',name: 'Rain', image:'assets/ambient_sounds/rain.jpg'),
  IntervalBell(sound: 'assets/ambient_sounds/thunderStorm.m4a',name: 'Thunder Storm', image:'assets/ambient_sounds/thunder.jpg'),
];

class MeditationPreset {
  int duration;
  double warmuptime;
  String name,cod, intervalBell;
  List<IntervalBell> bells = new List.empty(growable: true);

  IntervalBell ambientsound;

  MeditationSettings settings;

  MeditationPreset({this.intervalBell, this.name, this.cod, this.duration,this.warmuptime, this.ambientsound,
    this.settings
  }){
    if(cod == null){
      this.cod = Uuid().v1();
    }else {
      this.cod = cod;
    }
  }

  Map<String,dynamic> toJson(){
    return {
      'cod':cod,
      'name':name,
      'duration':duration,
      'intervalBell':intervalBell,
      'settings':settings.toJson(),
      'warmuptime':warmuptime,
      'bells': bells.length > 0 ? bells.map((b)=> b.toJson()).toList(): null,
      'ambientsound': ambientsound != null && ambientsound.name != null ? ambientsound.name : ''
    };
  }

  factory MeditationPreset.fromJson(Map<String,dynamic> json){
    MeditationPreset m = MeditationPreset(
      cod: json['cod'],
      name: json['name'],
      duration: json['duration'],
      intervalBell: json['intervalBell'],
      settings: json['settings'] != null ?
        MeditationSettings.fromJson(json['settings']) : 
        MeditationSettings(
          warmuptime: json['warmuptime'] != null ? json['warmuptime'].toDouble() : null,
          ambientsound: json['ambientsound'] != null ? ambientSounds.firstWhere((element) => element.name ==  json['ambientsound'],orElse: ()=> null)  : null
        ),
      warmuptime: json['warmuptime'] != null ? json['warmuptime'].toDouble() : null,
      ambientsound: json['ambientsound'] != null ? ambientSounds.firstWhere((element) => element.name ==  json['ambientsound'],orElse: ()=> null) : null,
    );

    if(json['bells'] != null && json['bells'].length > 0){
      for(var bell in json['bells']){
        m.settings.bells.add(IntervalBell.fromJson(bell));
      }
    }

    return m;
  }
}


class MeditationSettings{
  double warmuptime, ambientvolume, bellsvolume;
  IntervalBell ambientsound;

  // PARA CUANDO SE AÑADA
  bool addSixStepPreparation, noDuration, isUnlimited;

  String startingBell, endingBell;
  
  List<IntervalBell> bells = new List.empty(growable: true);
  
  MeditationSettings({
    this.warmuptime = 0, this.ambientvolume = 100,
    this.startingBell  = 'None', this.endingBell = 'Gong',
    this.isUnlimited=false, this.bellsvolume= 100, 
    this.ambientsound, this.addSixStepPreparation = false
  });


  Map<String,dynamic> toJson(){
    return {
      'warmuptime':warmuptime,
      'ambientvolume':ambientvolume,
      'bellsvolume':bellsvolume,
      'isUnlimited':isUnlimited,
      'ambientsound':ambientsound != null ? ambientsound.name : null,
      'startingBell':startingBell,
      'endingBell':endingBell,
      'addSixStepPreparation':addSixStepPreparation,
      'bells': bells.length > 0 ? bells.map((bell)=> bell.toJson()).toList() : null
    };
  }

  factory MeditationSettings.fromJson(json){
    MeditationSettings m = new MeditationSettings(
      warmuptime: json['warmuptime'] != null ? json['warmuptime'].toDouble() : null,
      isUnlimited: json['isUnlimited'] != null ? json['isUnlimited']: false,
      ambientsound: json['ambientsound'] != null ? ambientSounds.firstWhere((element) => element.name ==  json['ambientsound'],orElse: ()=> null)  : null,
      addSixStepPreparation: json['addSixStepPreparation'] !=  null ? json['addSixStepPreparation']: false,
      ambientvolume:json['bellsvolume']!= null ? json['bellsvolume'].toDouble(): 100,
      startingBell: json['startingBell'] != null ? json['startingBell'] : 'None',
      endingBell: json['endingBell'] != null ? json['endingBell'] : 'Gong',


      bellsvolume:json['bellsvolume']!= null ? json['bellsvolume'].toDouble(): 100,
    );

    if(json['bells'] != null && json['bells'].length > 0){
      for(var bell in json['bells']){
        m.bells.add(IntervalBell.fromJson(bell));
      }
    }
      

    return m;
  }


}



// CAMBIAR INTERVALBELL POR SOUND !!!
class IntervalBell{
  // DE MOMENTO SIEMPRE ES EL MISMO
  String sound; 
  int playAt;
  String name;
  String image;
  bool repeat, disabled;

  IntervalBell({this.sound,this.playAt, this.name, this.image,this.repeat = false, this.disabled = false});

  //  GUARDAR LA IMAGEN ???
  Map<String,dynamic> toJson(){
    return {
      'sound':sound,
      'playAt':playAt,
      'name':name,
      'repeat': repeat,
    };
  }

  factory IntervalBell.fromJson(json){
    return IntervalBell(
      sound: json['sound'],
      playAt: json['playAt'],
      name: json['name'],
      repeat: json['repeat']
    );
  }
}


class MeditationReport{

  String text; 
  int mindWandering, forgetting, overallSatisfaction, stage;

  List<String> feelings = new List.empty(growable: true);
  List<String> distractions = new  List.empty(growable: true);

  MeditationReport({
    this.text = '', 
    this.mindWandering, 
    this.forgetting, 
    this.overallSatisfaction,
    this.stage,
    this.feelings,
    this.distractions
  });



  Map<String,dynamic> toJson(){
    Map<String,dynamic> json = new Map();

    json['feelings'] = feelings;

    if(text != null && text != ''){
      json['text'] = text;
    }

    if(stage != null){
      json['stage'] = stage;
    }

    if(distractions!= null && distractions.length > 0){
      json['distractions'] = distractions;
    }

    return json;
  }


  factory MeditationReport.fromJson(json){
    return MeditationReport(
      text: json['notes'] != null ?  json['notes'] : json['text'],
      mindWandering: json['mindWandering'],
      forgetting: json['forgetting'],
      feelings: json['feelings'] != null ? json['feelings'].cast<String>() : null,


      stage: json['stage'],
      overallSatisfaction: json['overallSatisfaction'],
    );
  }


}