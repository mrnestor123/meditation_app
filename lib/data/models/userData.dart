// To parse this JSON data, do
//
//final user = userFromJson(jsonString);

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:meditation_app/data/models/stageData.dart';
import 'package:meditation_app/domain/entities/stage_entity.dart';
import 'package:meditation_app/domain/entities/user_entity.dart';

class UserModel extends User {
  int stagenumber, position, minutesmeditated, meditposition;
  String coduser, role, nombre, image;
  var user;
  Stage stage;
  Map<String, dynamic> stats = {};
  bool classic;

  UserModel(
      {this.coduser,
      @required this.stagenumber,
      this.user,
      this.nombre,
      this.image,
      this.stage,
      this.role,
      this.position,
      this.classic,
      this.meditposition,
      this.stats})
      : super(
            coduser: coduser,
            user: user,
            role: role,
            stagenumber: stagenumber,
            nombre: nombre,
            position: position,
            meditposition: meditposition,
            stage: stage,
            classic: classic,
            stats: stats);

  factory UserModel.fromRawJson(String str) =>
      UserModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
      coduser: json["coduser"] == null ? null : json["coduser"],
      nombre: json['nombre'] == null ? null : json['nombre'],
      position: json['position'] == null ? 0 : json['position'],
      meditposition: json['meditposition'] == null ? 0 : json['meditposition'],
      image: json['image'] == null ? null : json['image'],
      stage:
          json['stage'] == null ? null : new StageModel.fromJson(json['stage']),
      stagenumber: json["stagenumber"] == null ? null : json["stagenumber"],
      role: json["role"] == null ? null : json["role"],
      classic: json["classic"] == null ? true : json["classic"],
      stats: json['stats'] == null ? null : json['stats']);

  Map<String, dynamic> toJson() => {
        "coduser": coduser == null ? null : coduser,
        "role": role == null ? null : role,
        "stagenumber": stagenumber == null ? null : stagenumber,
        "position": position == null ? null : position,
        "meditposition": meditposition == null ? null : meditposition,
        "nombre": nombre == null ? null : nombre,
        "classic": classic == null ? null : classic,
        'stats': stats == null ? null : stats,
        'image': image == null ? null : image
      };
}
