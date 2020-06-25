// To parse this JSON data, do
//
//final user = userFromJson(jsonString);

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:meditation_app/domain/entities/auth/email_address.dart';
import 'package:meditation_app/domain/entities/user_entity.dart';

class UserModel extends User {
  final int stagenumber;
  final String coduser,nombre, usuario, password;
  final String mail;

  UserModel({
    this.coduser,
    @required this.nombre,
    @required this.mail,
    @required this.usuario,
    @required this.password,
    @required this.stagenumber,
  }) : super(
            coduser: coduser,
            nombre: nombre,
            mail: mail,
            password: password,
            usuario: usuario,
            stagenumber: stagenumber);

  factory UserModel.fromRawJson(String str) =>
      UserModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        coduser: json["coduser"] == null ? null : json["coduser"],
        nombre: json["nombre"] == null ? null : json["nombre"],
        password: json["password"] == null ? null : json["password"],
        mail: json["mail"] == null ? null : json["mail"],
        usuario: json["usuario"] == null ? null : json["usuario"],
        stagenumber: json["stagenumber"] == null ? null : json["stagenumber"],
      );

  Map<String, dynamic> toJson() => {
        "coduser": coduser == null ? null : coduser,
        "nombre": nombre == null ? null : nombre,
        "nombre": password == null ? null : password,
        "mail": mail == null ? null : mail,
        "usuario": usuario == null ? null : usuario,
        "stagenumber": stagenumber == null ? null : stagenumber,
      };
}
