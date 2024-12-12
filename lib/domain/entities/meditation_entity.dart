import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:meditation_app/domain/entities/stats_entity.dart';
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
  dynamic content;
  Map<dynamic,dynamic> followalong;

  MeditationReport report;
  MeditationSettings meditationSettings = new MeditationSettings();

  //for referencing the user.
  //final String userId;
  Meditation({
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
    group,
    this.meditationSettings,
    createdBy,
    notes,
    isNew,
    total,
    report
  })
  : super(
    cod: cod,
    group:group,
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
  
  List<Metric> metrics = new List.empty(growable: true);

  String metricsType;

  
  MeditationSettings({
    this.warmuptime = 0, this.ambientvolume = 100,
    this.startingBell  = 'None', this.endingBell = 'Gong', this.metricsType='basic',
    this.isUnlimited=false, this.bellsvolume= 100, 
    this.metrics, this.ambientsound, this.addSixStepPreparation = false
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
      "metrics": metrics != null && metrics.length > 0 ? metrics.map((m)=> m.toJson()).toList() : null,
      'metricsType':metricsType,
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
      metricsType: json['metricsType'] != null ? json['metricsType'] : 'basic',
      bellsvolume:json['bellsvolume']!= null ? json['bellsvolume'].toDouble(): 100,
    );

    if(json['metrics'] != null && json['metrics'].length > 0){
      for(var metric in json['metrics']){
        m.metrics.add(Metric.fromJson(metric));
      }
    }

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



// TYPES CAN BE 
// TEXT, NUMERIC, PERCENTAGE
class Metric {
  dynamic value;
  String name, type;

  IconData icon;

  Metric({this.value, this.name, this.type = 'text', this.icon});

  // to json
  Map<String,dynamic> toJson(){
    return {
      'value':value,
      'name':name
    };
  }

  factory Metric.fromJson(json){

    if(json['type']== 'numeric'){
      return NumericMetric.fromJson(json);
    }else {
      return TextMetric.fromJson(json);
    }
  }
}



class NumericMetric extends Metric{
  // value debería de ser int
  //de 1 a 10, de 0 a 100 
  int max, min, step;

  NumericMetric({this.max=10, this.min=1, this.step=1, value, name, type='numeric', icon})
  : super( value: value, type:type,  icon:icon, name: name );

  // to json
  Map<String,dynamic> toJson(){
    return {
      'value':value,
      'name':name,
      'max':max,
      'min':min,
      'step':step
    };
  }

  factory NumericMetric.fromJson(json){
    return NumericMetric(
      value: json['value'],
      name: json['name'],
      max: json['max'],
      min: json['min'],
      step: json['step']
    );
  }
}



// a list  of options to choose from
class OptionsMetric extends Metric {

  List<String> options;

  OptionsMetric({name, value, type = 'options', icon, this.options})
    : super(value: value, name: name, type: type, icon: icon);

  // to json
  Map<String,dynamic> toJson(){
    return {
      'value':value,
      'name':name,
      'options':options,
      'type':type,
    };
  }

  factory OptionsMetric.fromJson(json){
    return OptionsMetric(
      value: json['value'],
      name: json['name'],
      type: json['type'],
    );
  }

}


class Item {
  String header, description;

  Item({this.header, this.description});

  Map<String,dynamic> toJson(){
    return {
      'header':header,
      'description':description
    };
  }

  factory Item.fromJson(json){
    return Item(
      header: json['header'],
      description: json['description']
    );
  }

}


class TextMetric extends Metric {

  String hint;

  // VALUE IS A TEXT HERE
  TextMetric({name, value, type = 'text', icon, hint}): super(value: value, name: name, type: type, icon: icon);

  // to json
  Map<String,dynamic> toJson(){
    return {
      'value':value,
      'name':name,
      'hint':hint,
      'type':type,
    };
  }

  factory TextMetric.fromJson(json){
    return TextMetric(
      value: json['value'],
      name: json['name'],
      hint: json['hint']
    );
  }

}



class MeditationReport {
  String text; 
  int stage, mentalState, effort;

  List<String> feelings = new List.empty(growable: true);
  List<String> distractions = new  List.empty(growable: true);
  List<Metric> metrics = new List.empty(growable: true);
  
  dynamic overallSatisfaction;

  MeditationReport({
    this.text = '', 
    this.effort,
    this.stage,
    this.feelings,
    this.mentalState =0,
    this.metrics,
    this.overallSatisfaction
  });

  Map<String,dynamic> toJson(){
    Map<String,dynamic> json = new Map();

    if(stage != null){
      this.metrics.add(NumericMetric(name: 'Stage', value: stage, type:'numeric', icon:  Icons.terrain ));
    }

    if(text != null && text != ''){
      this.metrics.add(TextMetric(name: 'Notes', value: text, icon: Icons.note));
    }

    if(this.metrics != null && this.metrics.length > 0){
      json['metrics'] = this.metrics.map((m)=> m.toJson()).toList();
    }
       
    return json;
  }


  factory MeditationReport.fromJson(json){
    MeditationReport m = new  MeditationReport();  

    m.metrics  = new List.empty(growable: true);

    if(json['text'] != null && json['text'] != ''){
      m.metrics.add(
        TextMetric(name: 'Notes', value: json['text'], icon: Icons.note)
      );
    }

    if(json['notes']!= null  && json['notes'] != ''){
      m.metrics.add(
        TextMetric(name: 'Notes', value: json['notes'], icon: Icons.note)
      );
    }

    if(json['stage'] != null){
      m.metrics.add(
        NumericMetric(name: 'Stage', value: json['stage'], icon: Icons.terrain)
      );
    }
     
    if(json['metrics'] != null){
      if(json['metrics'] is Map){
        m.metrics.add(Metric.fromJson(json['metrics']));
      } else {
        for(var metric in json['metrics']){
          m.metrics.add(Metric.fromJson(metric));
        }
      }
    }

    return m;
  }
}


