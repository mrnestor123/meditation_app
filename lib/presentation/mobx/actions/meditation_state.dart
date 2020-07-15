
import 'package:dartz/dartz.dart';
import 'package:meditation_app/core/error/failures.dart';
import 'package:meditation_app/domain/entities/meditation_entity.dart';
import 'package:meditation_app/domain/usecases/meditation/take_meditation.dart';
import 'package:mobx/mobx.dart';

part 'meditation_state.g.dart';

class MeditationState extends _MeditationState with _$MeditationState {
 MeditationState() : super();
}

abstract class _MeditationState with Store {

  MeditateUseCase _meditateusecase;

  @observable
  var user;

  @observable
  Future<Either<Failure, Meditation>> _meditationFuture;

  @observable
  String errorMessage = "";

  @observable
  Duration duration;

  @observable
  bool startedmeditation = false;

  @observable
  String meditationphase= 'initial';

  _MeditationState() {
  }

  @action
  void startMeditation(Duration duration){
    this.duration = duration;
    meditationphase = 'started';
    print('startedmeditation ' + startedmeditation.toString());
  }

  @action 
  void finishMeditation(){
    meditationphase = 'finished';
  }
}
  