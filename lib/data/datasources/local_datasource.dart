import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:meditation_app/data/models/meditationData.dart';
import 'package:meditation_app/data/models/userData.dart';
import 'package:meditation_app/domain/entities/stage_entity.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/error/exception.dart';
import '../../domain/entities/meditation_entity.dart';
import '../../domain/entities/user_entity.dart';

abstract class UserLocalDataSource {
  /// Gets the cached  which was gotten the last time
  Future<String> getUser([String usuario]);

  Future<void> cacheUser(UserModel userToCache);

  Future<UserModel> getCachedUser();

  Future<List<Meditation>> getCachedMeditations();

  Future<void> addMeditationReport(Meditation m, MeditationReport report);

  Future cacheMeditation(Meditation m, User u);

  Future logout();
}

const CACHED_USER = 'CACHED_USER';
const QUICK_USER = 'QUICK_USER';
const CACHED_MEDITATIONS = 'CACHED_MEDITATIONS';
const CACHED_PRESETS = 'CACHED_PRESETS';
const LAST_MEDIT_DURATION = 'LAST_MEDIT_DURATION';

//puede ser que guarde demasiadas cosas en la cachee !!
class UserLocalDataSourceImpl implements UserLocalDataSource {
  final SharedPreferences sharedPreferences;
  Stage cachedStage;

  UserLocalDataSourceImpl({@required this.sharedPreferences});

  //Añadimos el usuario a la cache con su nombre de usuario.
  @override
  Future<void> cacheUser(UserModel userToCache) async {

    // SOLO GUARDAMOS EL  ID DEL USUARIO
    sharedPreferences.setString(CACHED_USER, json.encode(userToCache.coduser));

    // LOS GUARDAMOS ASI !!!
    saveUser(userToCache);
  }

  @override
  Future<String> getUser([String usuario]) async {
    //
    //sharedPreferences.clear();
    final jsonUser = sharedPreferences.getString(CACHED_USER);
    if (jsonUser != null) {
      return Future.value(json.decode(jsonUser));
    } else {
      throw CacheException();
    }
  }
  
  @override
  Future<UserModel> getCachedUser() async {
    final jsonUser = sharedPreferences.getString(QUICK_USER);
    
    if (jsonUser != null) {
      return Future.value(UserModel.fromJson(json.decode(jsonUser),true));
    }
  }

  @override
  Future logout() async {
    return sharedPreferences.clear();   
  }

  @override
  Future<List<Meditation>> getCachedMeditations() async {
    List<String> meditations =  sharedPreferences.getStringList(CACHED_MEDITATIONS);

    if(meditations != null){
      List<Meditation> med = new List.empty(growable: true);

      for(String m in meditations){
        med.add(MeditationModel.fromJson(json.decode(m)));
      }

      sharedPreferences.setStringList(CACHED_MEDITATIONS, []);

      return med;
    }else{
      return [];   
    }
  }

  void saveUser(User userToCache) {
    sharedPreferences.setString(QUICK_USER, json.encode({
      'coduser': userToCache.coduser,
      'stats': userToCache.userStats.toJson(),
      'presets': userToCache.presets.map((e) => e.toJson()).toList(),
      'settings':userToCache.settings.toJson(),
      "meditations": userToCache.totalMeditations
        .slice(0, userToCache.totalMeditations.length > 15 ? 15 : userToCache.totalMeditations.length)
        .map((e) => e.shortMeditation())
        .toList(),
      'offline':true
    }));
  }

  @override
  Future cacheMeditation(Meditation m, User userToCache) async {
    //sharedPreferences.clear();

    List<String> l = sharedPreferences.getStringList(CACHED_MEDITATIONS);

    if(l  ==  null){
      l = new List.empty(growable: true);
    }

    l.add(json.encode(m.shortMeditation()));

    saveUser(userToCache);


    sharedPreferences.setStringList(CACHED_MEDITATIONS,l);    
  }

  @override
  Future addMeditationReport(Meditation m, MeditationReport report) async{
    List<String> meditations = sharedPreferences.getStringList(CACHED_MEDITATIONS);

    if(meditations != null && meditations.length > 0){
      for(int i = 0; i < meditations.length; i++){
        MeditationModel med = MeditationModel.fromJson(json.decode(meditations[i]));
        if(med.cod == m.cod){
          med.report = report;
          meditations[i] = json.encode(med.shortMeditation());
          break;
        }
      }
      sharedPreferences.setStringList(CACHED_MEDITATIONS, meditations);
    }
  }
}
