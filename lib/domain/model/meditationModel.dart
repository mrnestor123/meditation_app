import 'package:flutter/material.dart';
import 'package:meditation_app/domain/model/userModel.dart';
import 'package:meditation_app/domain/services/databaseService.dart';
import 'package:uuid/uuid.dart';
import 'package:uuid/uuid_util.dart';

import 'feedModel.dart';
/**
class Meditation {
  Duration totalduration, meditationtime;
  String ambientsong, id;
  bool completed;
  //for referencing the user.
  int userId;
  int reminderBell;
  var uuid = new Uuid(options: {'grng': UuidUtil.cryptoRNG});

  Meditation({id, @required this.totalduration, @required userId}) {
    completed = false;
    meditationtime = new Duration(minutes: 0);
    id = uuid.v1();
  }
}

class GuidedMeditation extends Meditation {
  String recording;

  GuidedMeditation(
      {id,
      @required userId,
      @required duration,
      @required this.recording,
      ambientsong,
      reminderBell})
      : super(id: id, userId: userId, totalduration: duration);
}

class NonGuidedMeditation extends Meditation {
  NonGuidedMeditation({id, @required duration, @required userId})
      : super(
          id: id,
          totalduration: duration,
          userId: userId,
        );
}**/
