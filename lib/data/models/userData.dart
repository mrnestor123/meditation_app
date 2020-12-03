// To parse this JSON data, do
//
//final user = userFromJson(jsonString);

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:meditation_app/data/models/lesson_model.dart';
import 'package:meditation_app/data/models/stageData.dart';
import 'package:meditation_app/domain/entities/auth/email_address.dart';
import 'package:meditation_app/domain/entities/level.dart';
import 'package:meditation_app/domain/entities/stage_entity.dart';
import 'package:meditation_app/domain/entities/user_entity.dart';
import 'package:observable/observable.dart';

import 'meditationData.dart';

class UserModel extends User {
  int stagenumber;
  String coduser;
  String nombre, usuario, password;
  String mail;
  Level level;
  Stage stage;
  int meditationstreak = 0;

  // user || admin || moderator 
  String role;

  //May be a string with 1 hour, 30 sec, 20 min ...
  String timeMeditated = "";

  //We only need minutes meditated for the total minutes;
  int minutesMeditated = 0;

  UserModel(
      {this.coduser,
      this.nombre,
      @required this.mail,
      @required this.usuario,
      @required this.password,
      @required this.stagenumber,
      this.level,
      this.stage,
      this.meditationstreak,
      this.role,
      this.minutesMeditated})
      : super(
            coduser: coduser,
            nombre: nombre,
            mail: mail,
            password: password,
            level: level,
            role: role,
            usuario: usuario,
            stagenumber: stagenumber,
            stage: stage,
            meditationstreak: meditationstreak,
            minutesMeditated: minutesMeditated);

  factory UserModel.fromRawJson(String str) =>
      UserModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        coduser: json["coduser"] == null ? null : json["coduser"],
        nombre: json["nombre"] == null ? null : json["nombre"],
        password: json["password"] == null ? null : json["password"],
        level: json["level"] == null
            ? null
            : Level(
                level: json["level"]["level"],
                xpgoal: json["level"]["xpgoal"],
                levelxp: json["level"]["levelxp"]),
        mail: json["mail"] == null ? null : json["mail"],
        usuario: json["usuario"] == null ? null : json["usuario"],
        stagenumber: json["stagenumber"] == null ? null : json["stagenumber"],
        role: json["role"] == null ? null : json["role"],
        meditationstreak:
            json["meditationstreak"] == null ? 0 : json["meditationstreak"],
        minutesMeditated:
            json["minutesMeditated"] == null ? 0 : json["minutesMeditated"],
      );

  Map<String, dynamic> toJson() => {
        "coduser": coduser == null ? null : coduser,
        "nombre": nombre == null ? null : nombre,
        "password": password == null ? null : password,
        "mail": mail == null ? null : mail,
        "level": level == null ? null : level.toJson(),
        "role": role == null ? null : role,
        "usuario": usuario == null ? null : usuario,
        "stagenumber": stagenumber == null ? null : stagenumber,
        "minutesMeditated": minutesMeditated == null ? 0 : minutesMeditated,
        "meditationstreak": meditationstreak == null ? 0 : meditationstreak
      };
}
