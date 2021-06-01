// To parse this JSON data, do
//
//final user = userFromJson(jsonString);

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:meditation_app/data/models/stageData.dart';
import 'package:meditation_app/domain/entities/action_entity.dart';
import 'package:meditation_app/domain/entities/stage_entity.dart';
import 'package:meditation_app/domain/entities/stats_entity.dart';
import 'package:meditation_app/domain/entities/user_entity.dart';
import 'package:mobx/mobx.dart';

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
      bool classic,
      int meditposition,
      UserStats userStats,
      stats})
      : super(
            coduser: coduser,
            user: user,
            image: image,
            role: role,
            stagenumber: stagenumber,
            nombre: nombre,
            position: position,
            meditposition: meditposition,
            stage: stage,
            classic: classic,
            userStats: userStats);

  factory UserModel.fromRawJson(String str) =>
      UserModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory UserModel.fromJson(Map<String, dynamic> json) {
    UserModel u = UserModel(
        coduser: json["coduser"] == null ? null : json["coduser"],
        nombre: json['nombre'] == null ? null : json['nombre'],
        position: json['position'] == null ? 0 : json['position'],
        meditposition: json['meditposition'] == null ? 0 : json['meditposition'],
        image: json['image'] == null ? null : json['image'],
        stage:json['stage'] == null ? null : new StageModel.fromJson(json['stage']),
        stagenumber: json["stagenumber"] == null ? null : json["stagenumber"],
        role: json["role"] == null ? null : json["role"],
        classic: json["classic"] == null ? true : json["classic"],
        userStats:json['stats'] == null ? UserStats.empty() : UserStats.fromJson(json['stats'])
      );

      u.setActions(json['todayactions'], true);
      u.setActions(json['thisweekactions'], true);
      // también se podría hacer algo así para saber quien te sigue?? !!! HACER PARA EL FUTURO!!!
      u.setFollowedUsers(json['following'] != null ? json['following'] : []);
      //HACER INIT USER AQUI ????
    return u;
  }

  Map<String, dynamic> toJson() => {
        "coduser": coduser == null ? null : coduser,
        "role": role == null ? null : role,
        "stagenumber": stagenumber == null ? null : stagenumber,
        "position": position == null ? null : position,
        "meditposition": meditposition == null ? null : meditposition,
        "nombre": nombre == null ? null : nombre,
        "classic": classic == null ? null : classic,
        'stats': userStats == null ? null : userStats.toJson(),
        'image': image == null ? null : image,
        "following": following.map((element) => element.coduser).toList(),
        "todayactions": todayactions.map((action) => action.toJson()).toList(),
        "thisweekactions": thisweekactions.map((action) => action.toJson()).toList(), 
      };
}
