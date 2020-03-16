import 'package:meditation_app/domain/model/stageModel.dart';
import 'package:meditation_app/domain/services/databaseService.dart';
import 'package:rxdart/rxdart.dart';
/**
class StagesBloc {
  // final _allstages = BehaviorSubject<List<Stage>>();

  StagesBloc() {
    _init();
  }

  //List<Stage> getAllstages() => DataBaseConnection.getStages();

  void _init() async {
    _allstages.sink.add(this.getAllstages());
  }

  Stream<List<Stage>> get allStages => _allstages.stream;

  void dispose() {
    _allstages.close();
  }
}
**/
