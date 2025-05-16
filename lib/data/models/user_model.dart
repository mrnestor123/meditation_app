// To parse this JSON data, do
//

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:meditation_app/data/models/lesson_model.dart';
import 'package:meditation_app/data/models/meditation_model.dart';
import 'package:meditation_app/data/models/stage_model.dart';
import 'package:meditation_app/domain/entities/content_entity.dart';
import 'package:meditation_app/domain/entities/meditation_entity.dart';
import 'package:meditation_app/domain/entities/stage_entity.dart';
import 'package:meditation_app/domain/entities/stats_entity.dart';
import 'package:meditation_app/domain/entities/user_entity.dart';
import 'package:meditation_app/domain/entities/user_settings_entity.dart';

import '../../domain/entities/database_entity.dart';


class UserModel extends User {
  UserModel({
    String coduser,
    @required int stagenumber,
    user,
    String nombre,
    String image,
    Stage stage,
    String role,
    String userimage,
    UserStats userStats,
    answeredquestions,
    settings,
    int version,
    unreadmessages,
    meditationTime,
    offline,
    lastmeditduration,
    userProgression,
    reminderTime,
    teacherInfo,
    showInLeaderboard,
    milestonenumber,
    email,
    stats
  }): super(
    coduser: coduser,
    user: user,
    image: image,
    settings: settings,
    role: role,
    stagenumber: stagenumber,
    nombre: nombre,
    milestonenumber: milestonenumber,
    stage: stage,
    answeredquestions: answeredquestions,
    userStats: userStats,
    userProgression: userProgression,
    teacherInfo: teacherInfo,
    email:email,
    offline:offline
  );

  factory UserModel.fromRawJson(String str) => UserModel.fromJson(json.decode(str),true);

  String toRawJson() => json.encode(toJson());

  factory UserModel.fromJson(Map<String, dynamic> json, [bool expand =false]) {

    UserModel u = UserModel(
      coduser: json["codUser"] == null ? json['coduser'] : json["coduser"],
      offline: json['offline'] != null ? json['offline']: false,
      nombre: json['userName'] !=  null ? json['userName']: json['nombre'],
      //seenIntroCarousel: json["seenIntroCarousel"] == null ? false : json['seenIntroCarousel'],
      image: json['image'],
      showInLeaderboard: json['showInLeaderboard'] == null ? true : json['showInLeaderboard'],
      email: json['email'] != null ? json['email']: null,
      // VERSIÓN IRÁ EN SETTINGS !!!
      version: json['version'] == null ? 0  : json['version'],
      stage:json['stage'] == null ? null : new StageModel.fromJson(json['stage']),
      stagenumber: json["stagenumber"] == null ? json['stageNumber'] != null ? json['stageNumber']: 1 : json["stagenumber"],
      role: json["role"] == null ? null : json["role"],
      milestonenumber: json['milestonenumber'] == null ? 1 : json['milestonenumber'],
      unreadmessages: json['unreadmessages'] == null ? new List.empty(growable:true) : json['unreadmessages'].cast<String>(),
      meditationTime: json['meditationtime'] != null ? DateTime.parse(json['meditationtime']) : null,
      answeredquestions: json['answeredquestions'] == null ? new Map() : json['answeredquestions'],
     // lastmeditduration: json['lastmeditduration'] == null ? 0 : json['lastmeditduration'],
     // reminderTime: json['reminderTime'] == null ? null : json['reminderTime'],

      settings: json['settings'] == null 
        ? UserSettings.empty() : 
        json['settings']['new'] != null ? 
        UserSettings.fromJson(json['settings']) :
        UserSettings.fromJson({
          'progression':json['settings']['progression'],
          'lastMeditDuration': json['lastMeditDuration'],
          'seenIntroCarousel': json['seenIntroCarousel'],
          'reminderTime': json['reminderTime']
        }),

      teacherInfo: json['teacherInfo'] != null ?
        TeacherInfo.fromJson(json['teacherInfo']) :
        json['role'] == 'teacher' ? 
        TeacherInfo.fromJson({
          'description':json['description'],
          'teachinghours': json['teachinghours'],
          'location': json['location'],
          'website': json['website'],
        }) : null,
      
      userProgression: json['userProgression'] != null  ? 
        UserProgression.fromJson(json['userProgression']): 
        UserProgression.fromJson({
          'stagenumber' : json["stagenumber"] == null ? json['stageNumber'] != null ? json['stageNumber'] :json['stagenumber'] : 1,
          'position': json['position'],
          'meditposition': json['meditposition'],
          'gameposition': json['gameposition'],
          'stagelessonsnumber': json['stagelessonsnumber'],
        }),

      
      userStats: json['stats'] == null ? UserStats.empty() : UserStats.fromJson(json['stats'])
    ); 
      
    if(expand){
      // BORRAR  ESTO  EN EL FUTURO !!!
      if(json['readLessons'] !=  null && json['readLessons'].length > 0 ||  json['readlessons'] != null && json['readlessons'].length > 0){
        for(var cod in json['readLessons'] != null ? json['readLessons']: json['readlessons']){
          u.contentDone.add(DoneContent(stagenumber: 1, cod: cod, type: 'lesson'));
        }
      }

      // solo  con expand !!!
      if(json['presets']!= null){
        for(var preset in json['presets'] ){
          u.presets.add(MeditationPreset.fromJson(preset));
        }
      }

      if(json['doneContent'] != null){
        for(var doneContent in json['doneContent']){
          u.contentDone.add(DoneContent.fromJson(doneContent));
        }
      }

      
      if(json['meditations'] != null && json['meditations'].length > 0) {
        // PODRÍAMOS AÑADIR LAS MEDITACIONES DESDE DONECONTENT ???
        for(var med in json ['meditations'] ){
          u.totalMeditations.add(MeditationModel.fromJson(med,true));
        }

        //esto porque lo hacemos aquii!!!
        u.totalMeditations.sort((a,b) => a.day != null && b.day != null ? a.day.compareTo(b.day) : -1);
        u.userStats.doneMeditations = u.totalMeditations.length;

        // HAY QUE AÑADIR EL CONTENIDO QUE SE HAYA HECHO QUE SEAN MEDITACIONES !!!

      }

      
      // MIRAR SI UN PROFESOR QUIERE SEGUIR Y QUE LE SIGAN !!
      if(u.isTeacher()){
        if(json['addedcontent']!= null){
          for(var content in json['addedcontent']){
            if(content['type'] == 'meditation-practice'){
              u.addedcontent.add(MeditationModel.fromJson(content));
            }else if(content['type']=='video'){
              u.addedcontent.add(Content.fromJson(content));
            }else{
              u.addedcontent.add(LessonModel.fromJson(content));
            }
          }
        }

        if(json['addedsections']!= null){
          for(var section in json['addedsections']){
            u.addedsections.add(Section.fromJson(section));
          }
        }
      }
    
      /*if(json['notifications']!=null){
        for(var not in json['notifications']){
          u.notifications.add(Notify.fromJson(not));
        }
      }*/

      u.inituser();

    }

    return u;
  }

  Map<String, dynamic> toJson() => {
    // only add non null fields
    "coduser": coduser == null ? null : coduser,
    "role": role == null ? null : role,
    "stagenumber": stagenumber == null ? 1 : stagenumber,
    "nombre": nombre == null ? null : nombre,
    "userName": nombre == null ? null :  nombre,
    'stats': userStats == null ? null : userStats.toJson(),
    'image': image == null ? '' : image,
    "userProgression": userProgression == null ? null : userProgression.toJson(),
    "teacherInfo": teacherInfo == null ? null : teacherInfo.toJson(),
    "settings": settings == null ? null: settings.toJson(),
    "milestonenumber": milestonenumber == null ? 1 : milestonenumber,
    "answeredquestions": answeredquestions,
    "version": version
  };

  Map<String, dynamic> updateFields(){
    Map<String,dynamic>  json = new Map();

    if(stagenumber != null){
      json["stagenumber"] = stagenumber;
    }

    
    json["stagenumber"] = stagenumber == null ? 1 : stagenumber;

    
    if(userStats != null){
      json['stats'] = userStats == null ? null : userStats.toJson();
    }
    

    if(image != null){
      json['image'] = image == null ? '' : image;
    }
    

    if(userProgression != null){
      json["userProgression"] = userProgression == null ? null : userProgression.toJson();
    }

    
    if(settings != null){
      json["settings"] = settings == null ? null : settings.toJson();
    }
    

    if(version != null){
      json['version'] = version == null ? 0 : version;
    }
    
    
    json['milestonenumber'] = milestonenumber == null ? 1 : milestonenumber;

    if(teacherInfo != null){
      json["teacherInfo"] = teacherInfo.toJson();
    }

    if(answeredquestions != null && answeredquestions.length > 0){
      json["answeredquestions"] = answeredquestions;
    }

    if(presets != null){
      json['presets'] = presets.map((preset)=> preset.toJson()).toList();
    }

    return json;
  }
}
