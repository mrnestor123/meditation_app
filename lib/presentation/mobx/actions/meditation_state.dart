import 'dart:async';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:dartz/dartz.dart';
import 'package:meditation_app/core/error/failures.dart';
import 'package:meditation_app/data/models/meditationData.dart';
import 'package:meditation_app/domain/entities/database_entity.dart';
import 'package:meditation_app/domain/entities/meditation_entity.dart';
import 'package:meditation_app/domain/entities/user_entity.dart';
import 'package:meditation_app/domain/usecases/meditation/take_meditation.dart';
import 'package:mobx/mobx.dart';

part 'meditation_state.g.dart';

class MeditationState extends _MeditationState with _$MeditationState {
  MeditationState({MeditateUseCase meditate}) : super(meditate: meditate);
}

abstract class _MeditationState with Store {
  MeditateUseCase meditate;

  @observable
  User user;

  DataBase data;

  @observable
  MeditationModel selmeditation;

  @observable
  Future<Either<Failure, Meditation>> _meditationFuture;

  @observable
  String errorMessage = "";

  @observable
  Duration duration;

  Duration totalduration;

  @observable
  bool startedmeditation = false;

  @observable
  String state = 'initial';

  Timer timer;

  AssetsAudioPlayer assetsAudioPlayer = AssetsAudioPlayer();

  _MeditationState({this.meditate});

  @action
  void startMeditation(MeditationModel m, User u, DataBase d) {
    this.user = u;
    this.data = d;
    this.totalduration = m.duration;
    this.duration = m.duration;
    this.selmeditation = m;
    finishMeditation();
    //startTimer();
  }

  @action
  void startTimer() {
    this.state = 'started';
    var oneSec = new Duration(seconds: 1);
    timer = Timer.periodic(oneSec, (timer) {
      if (this.duration.inSeconds < 2) {
        finishMeditation();
        state = 'finished';
        timer.cancel();
      } else {
        duration = duration - oneSec;
      }
    });
  }

  @action
  void pause() {
    this.state = 'paused';
    timer.cancel();
  }

  @action
  Future finishMeditation() async {
    int currentposition = user.position;
    Either<Failure, User> meditation = await meditate.call(Params(meditation: selmeditation, user: user, d: data));
    assetsAudioPlayer.open(Audio("assets/audios/gong.mp3"));
    this.state = 'finished';
  }
}
