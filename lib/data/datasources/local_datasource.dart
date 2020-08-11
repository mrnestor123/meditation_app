import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:meditation_app/core/error/exception.dart';
import 'package:meditation_app/data/models/lesson_model.dart';
import 'package:meditation_app/data/models/meditationData.dart';
import 'package:meditation_app/data/models/mission_model.dart';
import 'package:meditation_app/data/models/userData.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class UserLocalDataSource {
  /// Gets the cached [User] which was gotten the last time
  /// the user connected to the phone.
  Future<UserModel> getUser([String usuario]);

  Future<void> cacheUser(UserModel userToCache);

  Future logout();

  Future<void> addMeditation(MeditationModel meditation, UserModel user);

  Future takeLesson(LessonModel lesson, UserModel user);

  Future updateData(UserModel user);

  Future updateMission(MissionModel m);
}

const CACHED_USER = 'CACHED_USER';
const CACHED_MEDITATIONS = 'CACHED_MEDITATIONS';
const CACHED_LESSONS = 'CACHED_LESSONS';
const REQUIRED_MISSIONS = 'REQUIRED_MISSIONS';
const OPTIONAL_MISSIONS = 'OPTIONAL_MISSIONS';

class UserLocalDataSourceImpl implements UserLocalDataSource {
  final SharedPreferences sharedPreferences;

  List<String> usermeditations;
  List<String> userlessons;
  List<String> requiredmissions;
  List<String> optionalmissions;

  UserLocalDataSourceImpl({@required this.sharedPreferences});

  @override
  Future updateData(UserModel user) async {
    final jsonUser =
        sharedPreferences.setString(CACHED_USER, json.encode(user.toJson()));

    if (jsonUser == null) {
      throw CacheException();
    }
  }

  //Añadimos el usuario a la cache con su nombre de usuario.
  @override
  Future<void> cacheUser(UserModel userToCache) async {
    await sharedPreferences.clear();
    sharedPreferences.setString(CACHED_USER, json.encode(userToCache.toJson()));

    usermeditations = userToCache.totalMeditations
        .map((meditation) => json.encode(meditation.toJson()))
        .toList();
    userlessons = userToCache.lessonslearned
        .map((lesson) => json.encode(lesson.toJson()))
        .toList();

    requiredmissions= userToCache.requiredmissions.map((mission) => json.encode(mission.toJson())).toList();


    sharedPreferences.setStringList(CACHED_LESSONS, userlessons);
    sharedPreferences.setStringList(CACHED_MEDITATIONS, usermeditations);
    sharedPreferences.setStringList(REQUIRED_MISSIONS, requiredmissions);

  }

  Future<void> addMeditation(MeditationModel meditation, UserModel user) async {
    final jsonUser = sharedPreferences.getString(CACHED_USER);
    if (jsonUser != null) {
      usermeditations.add(json.encode(meditation.toJson()));
      final added = await sharedPreferences.setStringList(
          CACHED_MEDITATIONS, usermeditations);

      if (!added) {
        throw CacheException;
      }

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
    sharedPreferences.clear();
    final jsonUser = sharedPreferences.getString(CACHED_USER);
    if (jsonUser != null) {
      final user = UserModel.fromJson(json.decode(jsonUser));
      if (usuario == null || usuario != null && user.usuario == usuario) {
        if (sharedPreferences.getStringList(CACHED_LESSONS) != null) {
          userlessons = sharedPreferences.getStringList(CACHED_LESSONS);
          user.setLearnedLessons((userlessons)
              .map((lesson) => LessonModel.fromJson((json.decode(lesson))))
              .toList());
        }
        if (sharedPreferences.getStringList(CACHED_MEDITATIONS) != null) {
          usermeditations = sharedPreferences.getStringList(CACHED_MEDITATIONS);
          user.setMeditations((usermeditations)
              .map((meditation) =>
                  MeditationModel.fromJson(json.decode(meditation)))
              .toList());
        }
        if (sharedPreferences.getStringList(REQUIRED_MISSIONS) != null) {
          requiredmissions = sharedPreferences.getStringList(REQUIRED_MISSIONS);
          user.setRequiredMissions((requiredmissions)
              .map((mission) => MissionModel.fromJson(json.decode(mission)))
              .toList());
        }
        return Future.value(user);
      } else {
        throw Exception();
      }
    } else {
      throw Exception();
    }
  }

  @override
  Future logout() async {
    return sharedPreferences.clear();
  }

  @override
  Future<void> takeLesson(LessonModel lesson, UserModel user) async {
    userlessons.add(lesson.toRawJson());
    final added =
        await sharedPreferences.setStringList(CACHED_LESSONS, userlessons);
    updateData(user);

    if (!added) {
      throw CacheException;
    }
  }

  @override
  Future updateMission(MissionModel m) {
    // TODO: implement updateMission
    throw UnimplementedError();
  }
}
