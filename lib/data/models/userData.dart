// To parse this JSON data, do
//
//final user = userFromJson(jsonString);

import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:meditation_app/data/models/stageData.dart';
import 'package:meditation_app/domain/entities/stage_entity.dart';
import 'package:meditation_app/domain/entities/user_entity.dart';

class UserModel extends User {
  int stagenumber, position, minutesmeditated;
  String coduser, role;
  FirebaseUser user;
  StageModel stage;
  Map<String, dynamic> stats = {};

  UserModel(
      {this.coduser,
      @required this.stagenumber,
      this.user,
      this.stage,
      this.role,
      this.position,
      this.stats})
      : super(
            coduser: coduser,
            user: user,
            role: role,
            stagenumber: stagenumber,
            position: position,
            stage: stage,
            stats:stats);

  factory UserModel.fromRawJson(String str) =>
      UserModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        coduser: json["coduser"] == null ? null : json["coduser"],
        user: json["user"] == null ? null : json["user"],
        position: json['position'] == null ? 0 : json['position'],
        stagenumber: json["stagenumber"] == null ? null : json["stagenumber"],
        role: json["role"] == null ? null : json["role"],
        stats: json['stats'] == null ? null : json['stats']
      );

  Map<String, dynamic> toJson() => {
        "coduser": coduser == null ? null : coduser,
        "role": role == null ? null : role,
        "stagenumber": stagenumber == null ? null : stagenumber,
        "position" : position == null ? null : position,
        'stats': stats == null ? null: stats
      };
}
