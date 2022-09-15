// To parse this JSON data, do
//

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:meditation_app/data/models/lesson_model.dart';
import 'package:meditation_app/data/models/meditationData.dart';
import 'package:meditation_app/data/models/stageData.dart';
import 'package:meditation_app/domain/entities/content_entity.dart';
import 'package:meditation_app/domain/entities/meditation_entity.dart';
import 'package:meditation_app/domain/entities/message.dart';
import 'package:meditation_app/domain/entities/notification_entity.dart';
import 'package:meditation_app/domain/entities/stage_entity.dart';
import 'package:meditation_app/domain/entities/stats_entity.dart';
import 'package:meditation_app/domain/entities/user_entity.dart';
import 'package:meditation_app/domain/entities/user_settings_entity.dart';

class UserModel extends User {
  UserModel(
      {String coduser,
      @required int stagenumber,
      user,
      String nombre,
      String image,
      Stage stage,
      String role,
      int position,
      int meditposition,
      int gameposition,
      String userimage,
      UserStats userStats,
      answeredquestions,
      followed,
      settings,
      description,
      teachinghours,
      location,
      website,
      int stagelessonsnumber,
      int version,
      unreadmessages,
      seenIntroCarousel,
      meditationTime,
      stats})
      : super(
        meditationTime:meditationTime,
        coduser: coduser,
        user: user,
        gameposition: gameposition,
        image: image,
        version:version,
        unreadmessages: unreadmessages,
        settings: settings,
        description:description,
        teachinghours: teachinghours,
        location: location,
        website:website,
        role: role,
        stagenumber: stagenumber,
        nombre: nombre,
        position: position,
        meditposition: meditposition,
        stage: stage,
        followed:followed,
        answeredquestions: answeredquestions,
        userStats: userStats,
        seenIntroCarousel: seenIntroCarousel,
        stagelessonsnumber: stagelessonsnumber
      );

  factory UserModel.fromRawJson(String str) => UserModel.fromJson(json.decode(str),true);

  String toRawJson() => json.encode(toJson());

  factory UserModel.fromJson(Map<String, dynamic> json, [bool expand =false]) {
    UserModel u = UserModel(
        coduser: json["coduser"],
        nombre: json['nombre'],
        seenIntroCarousel: json["seenIntroCarousel"] == null ? false : json['seenIntroCarousel'],
        position: json['position'] == null ? 0 : json['position'],
        gameposition: json['gameposition'] == null ? 0 : json['gameposition'],
        meditposition: json['meditposition'] == null ? 0 : json['meditposition'],
        image: json['image'],
        version: json['version'] == null ? 0  : json['version'],
        settings: json['settings'] == null ? UserSettings.empty() : UserSettings.fromJson(json['settings']),
        //ESTO HACE FALTA??
        followed: json['followed'],
        stagelessonsnumber: json['stagelessonsnumber'] == null ? json['stagenumber'] == null ? 1 : json['stagenumber'] : json['stagelessonsnumber'],
        stage:json['stage'] == null ? null : new StageModel.fromJson(json['stage']),
        stagenumber: json["stagenumber"] == null ? 1 : json["stagenumber"],
        role: json["role"] == null ? null : json["role"],
        description: json['description'],
        unreadmessages:json['unreadmessages'] == null ? new List.empty(growable:true) : json['unreadmessages'].cast<String>(),
        teachinghours:json['teachinghours'],
        location: json['location'],
        website: json['website'],
        meditationTime: json['meditationtime'] != null ? DateTime.parse(json['meditationtime']):null,
        answeredquestions: json['answeredquestions'] == null ? new Map() : json['answeredquestions'],
        userStats:json['stats'] == null ? UserStats.empty() : UserStats.fromJson(json['stats'])
      ); 

      
    if(expand){
      if(json['readlessons'] != null && json['readlessons'].length > 0){
        u.setReadLessons(json['readlessons']);
      }

      if(json['presets']!= null){
        for(var preset in json['presets'] ){
          u.presets.add(MeditationPreset.fromJson(preset));
        }
      }

      if(json['doneContent'] != null){
        for(var doneContent in json['doneContent']){
          u.contentDone.add(Content.fromJson(doneContent));
        }
      }

      if(json['meditations'] != null) {
        
        for(var med in json['meditations'] ){
          u.totalMeditations.add(MeditationModel.fromJson(med,true));
        }

        //esto porque lo hacemos aquii!!!
        u.totalMeditations.sort((a,b)=> a.day.compareTo(b.day));
        u.userStats.total.meditations = u.totalMeditations.length;
      }

      // MIRAR SI UN PROFESOR QUIERE SEGUIR Y QUE LE SIGAN !!
      if(u.isTeacher()){
        if(json['students']!= null){
          for(var user in json['students']){
            u.students.add(UserModel.fromJson(user,false));
          }
        }

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

        if(json['files']!= null){
          try{
            for(var file in json['files']){
              u.files.add(File.fromUri(Uri.file(file)));
            }
          }catch(e){
            print(e);
          }
        }
      }else{
        // SE PUEDE SEGUIR A UN PROFESOR !!! YO DIRÍA QUE SIII
        if(json['following']!=null){
          for(var user in json['following']){
            //MEJORABLE !!
            u.following.add(UserModel.fromJson(user));
          }
        }

          
        if(json['followsyou']!=null){
          for(var user in json['followsyou']){
            //MEJORABLE !!
            u.followers.add(UserModel.fromJson(user));
          }
        }
      }

      
      if(json['notifications']!=null){
        for(var not in json['notifications']){
          u.notifications.add(Notify.fromJson(not));
        }
      }
    
      if(json['messages']!=null){
        for(var msg in json['messages']){
          u.messages.add(Message.fromJson(msg));
        }
      }
      
    }


    //  u.setMeditations(json['meditations'] != null ? json['meditations'] : []);
    //  u.setFollowedUsers(json['following'] != null ? json['following'] : []);
    //  u.setFollowsYou(json['followsyou'] != null ? json['followsyou'] : []);

    return u;
  }

  Map<String, dynamic> toJson() => {
        "coduser": coduser == null ? null : coduser,
        "role": role == null ? null : role,
        "stagenumber": stagenumber == null ? 1 : stagenumber,
        "position": position == null ? 0 : position,
        "meditposition": meditposition == null ? 0 : meditposition,
        "gameposition": gameposition == null ? 0 : gameposition,
        "nombre": nombre == null ? null : nombre,
        'stats': userStats == null ? null : userStats.toJson(),
        'image': image == null ? '' : image,
        "stagelessonsnumber": stagelessonsnumber == null ? 1 : stagelessonsnumber,
        'description': description,
        'teachinghours':teachinghours, 
        'location':location,
        "seenIntroCarousel":seenIntroCarousel,
        'website': website,
        "settings": settings == null ? null: settings.toJson(),
        "following": following.map((user) => user.coduser).toList(),
        "unreadmessages":unreadmessages.map((e)=> e).toList(),
        "meditationtime": meditationTime != null ? meditationTime.toIso8601String():null,
        //MENSAJES Y ACTIONS MUCHO JSON !!!!
        "students": students.map((stud)=> stud.coduser).toList(),
     //   'messages': messages.map((msg)=> msg.toJson()).toList(), 
        "followsyou": followers.map((user) => user.coduser).toList(),
        "answeredquestions": answeredquestions,
        "version": version
      };


  Map<String, dynamic> updateFields() => {
    "stagenumber": stagenumber == null ? 1 : stagenumber,
    "position": position == null ? 0 : position,
    "meditposition": meditposition == null ? 0 : meditposition,
    "gameposition": gameposition == null ? 0 : gameposition,
    "nombre": nombre == null ? null : nombre,
    'stats': userStats == null ? null : userStats.toJson(),
    'image': image == null ? '' : image,
    "stagelessonsnumber": stagelessonsnumber == null ? 1 : stagelessonsnumber,
    'description': description,
    'teachinghours':teachinghours, 
    'location':location,
    "seenIntroCarousel":seenIntroCarousel,
    "students": students.map((stud)=> stud.coduser).toList(),
    'website': website,
    "settings": settings == null ? null : settings.toJson(),
    "presets": presets == null ? null : presets.map((e) => e.toJson()).toList(),
    "answeredquestions": answeredquestions,
    "version": version
  };
}
