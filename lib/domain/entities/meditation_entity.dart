import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:meditation_app/presentation/pages/commonWidget/file_helpers.dart';
import 'package:uuid/uuid.dart';
import 'package:meditation_app/domain/entities/content_entity.dart';

//HAY QUE CREAR CLASE GUIDEDMEDITATION
class Meditation extends Content {
  String coduser;
  Duration duration;
  DateTime day;

  //PORQUE SE LLAMA CONTENT MAL NOMBRE !!!
  Map<dynamic, dynamic> content;
  Map<dynamic,dynamic> followalong;

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
      isNew,
      total
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


  factory Meditation.fromContent(Content c){
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


  Map<String, dynamic> shortMeditation() => { 
    "coduser":this.coduser == null ? null : this.coduser,
    "cod": this.cod  == null  ?  null : this.cod,
    //"isUnlimited": this.meditationSettings.isUnlimited == null ? false : this.isUnlimited,
    //"title": this.title == null ? null : this.title,
    "duration": this.duration == null ? null : duration.inMinutes,
    //"recording": this.recording == null ? null : this.recording,
    "day": this.day == null ? null : day.millisecondsSinceEpoch
  };
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
  double warmuptime,ambientvolume,bellsvolume;
  IntervalBell ambientsound;

  // PARA CUANDO SE AÑADA
  bool addSixStepPreparation, noDuration,isUnlimited;
  
  List<IntervalBell> bells = new List.empty(growable: true);
  
  MeditationSettings({this.warmuptime = 0, this.ambientvolume = 100,this.isUnlimited=false, this.bellsvolume= 100, this.ambientsound, this.addSixStepPreparation = false});


  Map<String,dynamic> toJson(){
    return {
      'warmuptime':warmuptime,
      'ambientvolume':ambientvolume,
      'bellsvolume':bellsvolume,
      'isUnlimited':isUnlimited,
      'ambientsound':ambientsound != null ? ambientsound.name : null,
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
  bool repeat;

  IntervalBell({this.sound,this.playAt, this.name, this.image,this.repeat = false});

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