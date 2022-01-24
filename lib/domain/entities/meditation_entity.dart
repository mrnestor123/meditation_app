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

  Map<dynamic, dynamic> content;
  Map<dynamic,dynamic> followalong;

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
      type,
      stagenumber,
      description,
      image,
      title,
      file,
      position,
      createdBy
      //this.userId
      })
      : super(cod: cod,
            description: description,
            image: image,
            title: title,
            createdBy: createdBy,
            stagenumber: stagenumber,
            position: position,
            file:file,
            type: type) {
        day == null ? day = DateTime.now() : null;
    }

  void setDay(DateTime d) => this.day = d;


  factory Meditation.fromContent(Content c){
    Duration d;
    if(c.file != null){
      if(isAudio(c.file)){
        // HAY QUE   MIRAR LA DURACIÓN
  //    AssetsAudioPlayer assetsAudioPlayer = new AssetsAudioPlayer();

//      d = assetsAudioPlayer.current.value.audio.duration;
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


}


// HAY QUE HACER ESTO !!!!!!!
class GuidedMeditation extends Meditation{
  


}