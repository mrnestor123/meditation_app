import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:meditation_app/core/error/exception.dart';
import 'package:meditation_app/data/models/lesson_model.dart';
import 'package:meditation_app/data/models/meditationData.dart';
import 'package:meditation_app/data/models/mission_model.dart';
import 'package:meditation_app/data/models/stageData.dart';
import 'package:meditation_app/data/models/userData.dart';
import 'package:meditation_app/domain/entities/stage_entity.dart';
import 'package:meditation_app/domain/entities/user_entity.dart';
import 'package:observable/observable.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class UserLocalDataSource {
  /// Gets the cached [User] which was gotten the last time
  /// the user connected to the phone.
  Future<UserModel> getUser([String usuario]);

  Future<void> cacheUser(UserModel userToCache);

  Future logout();

  Future<void> addMeditation(MeditationModel meditation, UserModel user);

  Future takeLesson(UserModel user);

  Future updateData(UserModel user);
}

const CACHED_USER = 'CACHED_USER';
const CACHED_MEDITATIONS = 'CACHED_MEDITATIONS';
const CACHED_LESSONS = 'CACHED_LESSONS';
const CACHED_STAGE = 'CACHED_STAGE';
const REQUIRED_MISSIONS = 'REQUIRED_MISSIONS';
const OPTIONAL_MISSIONS = 'OPTIONAL_MISSIONS';

class UserLocalDataSourceImpl implements UserLocalDataSource {
  final SharedPreferences sharedPreferences;

  List<String> usermeditations = new List<String>();
  List<String> userlessons = new List<String>();
  List<String> stagemissions = new List<String>();
  Stage cachedStage;

  UserLocalDataSourceImpl({@required this.sharedPreferences});

  @override
  Future updateData(UserModel user) async {
    final jsonUser =
        sharedPreferences.setString(CACHED_USER, json.encode(user.toJson()));

    StageModel stage = user.stage;
    sharedPreferences.setString(CACHED_STAGE, json.encode(stage.toJson()));

    if (jsonUser == null) {
      throw CacheException();
    }
  }

  //Añadimos el usuario a la cache con su nombre de usuario.
  @override
  Future<void> cacheUser(UserModel userToCache) async {
    sharedPreferences.setString(CACHED_USER, json.encode(userToCache.toJson()));

    for (MeditationModel m in userToCache.totalMeditations) {
      usermeditations.add(m.toRawJson());
    }

    sharedPreferences.setStringList(CACHED_MEDITATIONS, usermeditations);

    StageModel stage = userToCache.stage;
    sharedPreferences.setString(CACHED_STAGE, stage.toRawJson());
  }

  Future addMeditation(MeditationModel meditation, UserModel user) async {
    final jsonUser = sharedPreferences.getString(CACHED_USER);

    if (jsonUser != null) {
      usermeditations.add(json.encode(meditation.toJson()));
      await sharedPreferences.setStringList(
          CACHED_MEDITATIONS, usermeditations);
      updateData(user);
    } else {
      throw CacheException();
    }
  }

  Future<List<MeditationModel>> getUserMeditations() async {
    List<MeditationModel> usermeditations = new List();
    final meditations = sharedPreferences.getStringList(CACHED_MEDITATIONS);
    for (var m in meditations) {
      usermeditations.add(new MeditationModel.fromJson(json.decode(m)));
    }
    return usermeditations;
  }

  @override
  Future<UserModel> getUser([String usuario]) async {

    final jsonUser = sharedPreferences.getString(CACHED_USER);
    if (jsonUser != null) {
      UserModel user = UserModel.fromJson(json.decode(jsonUser));

      if (sharedPreferences.getString(CACHED_STAGE) != null) {
        user.setStage(new StageModel.fromRawJson(
            sharedPreferences.getString(CACHED_STAGE)));
      }

      if (sharedPreferences.getStringList(CACHED_MEDITATIONS) != null) {
        usermeditations = sharedPreferences.getStringList(CACHED_MEDITATIONS);

        if (usermeditations != null && usermeditations.length > 0) {
          user.setMeditations((usermeditations)
              .map((meditation) =>
                  MeditationModel.fromJson(json.decode(meditation)))
              .toList());
        }
      }
      return Future.value(user);
    } else {
      throw Exception();
    }
  }

  @override
  Future logout() async {
    sharedPreferences.clear();
    if (usermeditations.length > 0) {
      usermeditations.clear();
    }
    if (userlessons.length > 0) userlessons.clear();
    return sharedPreferences.clear();
  }

  //iteramos sobre las lecciones del usuario y cambiamos la lista
  @override
  Future<void> takeLesson(UserModel user) async {
    sharedPreferences.setString(CACHED_USER, user.toRawJson());
  }
}
