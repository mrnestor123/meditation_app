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

  UserModel({
    this.coduser,
    this.nombre,
    @required this.mail,
    @required this.usuario,
    @required this.password,
    @required this.stagenumber,
    this.level,
    this.stage
  }) : super(
            coduser: coduser,
            nombre: nombre,
            mail: mail,
            password: password,
            level: level,
            usuario: usuario,
            stagenumber: stagenumber,
            stage:stage);

  factory UserModel.fromRawJson(String str) =>
      UserModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        coduser: json["coduser"] == null ? null : json["coduser"],
        nombre: json["nombre"] == null ? null : json["nombre"],
        password: json["password"] == null ? null : json["password"],
        level: json["level"] == null ? null : Level(level: json["level"]["level"],xpgoal: json["level"]["xpgoal"],levelxp: json["level"]["levelxp"]),
        mail: json["mail"] == null ? null : json["mail"],
        usuario: json["usuario"] == null ? null : json["usuario"],
        stagenumber: json["stagenumber"] == null ? null : json["stagenumber"],
      );

  Map<String, dynamic> toJson() => {
        "coduser": coduser == null ? null : coduser,
        "nombre": nombre == null ? null : nombre,
        "password": password == null ? null : password,
        "mail": mail == null ? null : mail,
        "level": level == null ? null : level.toJson(),
        "usuario": usuario == null ? null : usuario,
        "stagenumber": stagenumber == null ? null : stagenumber,
      };
}
