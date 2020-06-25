import 'package:bloc_provider/bloc_provider.dart';
import 'package:meditation_app/domain/model/meditationModel.dart';
import 'package:rxdart/rxdart.dart';

//This class is for storing the duration choosed in the meditationscreen and sharing it to the other app.
class MeditationBloc extends Bloc {
  Duration d;

  final _durationchanges = BehaviorSubject<Duration>();

  Duration getDuration() => d;

  void setDuration(Duration d) => this.d = d;

  @override
  void dispose() {
    _durationchanges.close();
  }
}
