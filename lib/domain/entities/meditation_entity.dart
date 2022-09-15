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

  MeditationSettings meditationSettings;

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
    //"title": this.title == null ? null : this.title,
    "duration": this.duration == null ? null : duration.inMinutes,
    //"recording": this.recording == null ? null : this.recording,
    "day": this.day == null ? null : day.millisecondsSinceEpoch
  };

}


// HAY QUE HACER ESTO !!!!!!!
class GuidedMeditation extends Meditation{
  


}


class MeditationPreset {
  int duration;
  double warmuptime;
  String name,cod, intervalBell;
  List<IntervalBell> bells = new List.empty(growable: true);

  MeditationPreset({this.intervalBell, this.name, this.cod, this.duration,this.warmuptime}){
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
      'warmuptime':warmuptime,
      'bells': bells.length > 0 ? bells.map((b)=> b.toJson()).toList(): null
    };
  }

  factory MeditationPreset.fromJson(Map<String,dynamic> json){
    MeditationPreset m = MeditationPreset(
      cod: json['cod'],
      name: json['name'],
      duration: json['duration'],
      intervalBell: json['intervalBell'],
      warmuptime: json['warmuptime'] != null ? json['warmuptime'].toDouble() : null
    );

    if(json['bells'] != null && json['bells'].length > 0){
      for(var bell in json['bells']){
        m.bells.add(IntervalBell.fromJson(bell));
      }
    }

    return m;


  }
}


class MeditationSettings{
  double warmuptime;
  
  List<IntervalBell> bells = new List.empty(growable: true);
  
  MeditationSettings({this.warmuptime = 0});
}


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