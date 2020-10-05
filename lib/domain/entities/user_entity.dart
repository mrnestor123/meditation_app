import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:meditation_app/data/models/lesson_model.dart';
import 'package:meditation_app/data/models/meditationData.dart';
import 'package:meditation_app/data/models/mission_model.dart';
import 'package:meditation_app/data/models/stageData.dart';
import 'package:meditation_app/domain/entities/mission.dart';
import 'package:meditation_app/domain/entities/stage_entity.dart';
import 'package:observable/observable.dart';
import 'package:uuid/uuid.dart';
import 'lesson_entity.dart';
import 'level.dart';
import 'meditation_entity.dart';

class User {
  //Nombre es el nombre de pila y usuario es el nombre en la aplicación
  String coduser;
  String nombre, usuario, password;

  String mail;
  int stagenumber;
  Level level;

  int meditationstreak = 0;

  Stage stage; 

  //May be a string with 1 hour, 30 sec, 20 min ...
  String timeMeditated = "";

  //We only need minutes meditated for the total minutes;
  int minutesMeditated = 0;

  //Para ver si he pasado las suficientes misiones
  int missionspassed = 0;

  //A list with the meditations
  final ObservableList<MeditationModel> totalMeditations = new ObservableList();

  //List with the lessons that the user has learned
  final ObservableList<LessonModel> lessonslearned = new ObservableList();

  //Missions for the stage. When the user completes all the stage missions he
  final ObservableList<MissionModel> requiredmissions = new ObservableList();
  final ObservableList<MissionModel> optionalmissions = new ObservableList();

  //Map with "required" and "optional" missions. In the form {"required":[Mission,Mission]}
  final Map<String, Map<String, ObservableList<MissionModel>>> missions =
      new Map();

  User(
      {this.coduser,
      this.nombre,
      @required this.level,
      @required this.mail,
      @required this.usuario,
      @required this.password,
      @required this.stagenumber}) {
    if (this.coduser == null) {
      var uuid = Uuid();
      this.coduser = uuid.v1();
    }
    minutesMeditated = 15;
    timeMeditated = '15 minutes meditated';
  }

  /* @override
  List<Object> get props =>
      [coduser, nombre, mail, usuario, password, stagenumber];*/

  ObservableList<Lesson> getLessonsLearned() => lessonslearned;

  int getStageNumber() => this.stagenumber;
  void setLearnedLessons(List<LessonModel> l) => lessonslearned.addAll(l);
  void setMeditations(List<MeditationModel> m) => totalMeditations.addAll(m);
  void setRequiredMissions(List<MissionModel> m) {
    if (missions['required'] == null) {
      missions['required'] = {};
    }

    for (MissionModel mission in m) {
      if (missions['required'][mission.type] == null) {
        missions['required'][mission.type] = new ObservableList();
      }
      missions['required'][mission.type].add(mission);
    }
  }
  void setOptionalMissions(List<MissionModel> m) => optionalmissions.addAll(m);
  
  //este método recorrerá por todas las misiones de la stage para añadirselas al user
  void setStage(StageModel s) { 
    stage = s;
    missions['required']['lesson'].clear();
    missions['required']['meditation'].clear();
    missions['optional']['lesson'].clear();
    missions['optional']['meditation'].clear();

    for(MissionModel m in s.missions){
      missions[ m.requiredmission ? 'required' :'optional'][m.type].add(m);
    }

  }
  void setTimeMeditated() {
    if (minutesMeditated / 60 > 0) {
      this.timeMeditated = (minutesMeditated / 60).toString() + " h ";
    }
    if (minutesMeditated % 60 > 0) {
      this.timeMeditated += (minutesMeditated % 60).toString() + " m";
    }
  }

  List<Mission> takeLesson(Lesson l) {
    if (!this.lessonslearned.contains(l)) this.lessonslearned.add(l);
    List<Mission> result = new List<Mission>();

    if (l.xp != null) {
      this.level.addXP(l.xp);
    } else {
      this.level.addXP(250);
    }

    this.missions.forEach((key, value) {
      value.forEach((key, value) {
        if (key == "lesson") {
          for (MissionModel mission in value) {
            if (!mission.done) {
              if (mission.requirement == "list") {
                final auxlist = lessonslearned.where((element) =>
                    mission.requirements.contains(element.codlesson));
                if (auxlist.length >= mission.requirements.length) {
                  missionspassed++;
                  mission.passed();
                  result.add(mission);
                }
              } else {
                if (lessonslearned.contains(mission.requirements[0]) ||
                    mission.requirements[0] <= lessonslearned.length) {
                  missionspassed++;
                  mission.passed();
                  result.add(mission);
                }
              }
            }
          }
        }
      });
    });

    if (missionspassed >=
        (this.missions["required"]["lesson"].length +
            this.missions["required"]["meditation"].length)) {
      this.stagenumber++;
      missionspassed = 0;
    }
    return result;
  }

  //Este método se tendrá que refinar. Devuelve null o una misión cuando se pase una el usuario
  List<Mission> takeMeditation(Meditation m) {
    List<Mission> result = new List<Mission>();
    if (meditationstreak == 0) {
      meditationstreak++;
    } else {
      var lastMeditation = totalMeditations[totalMeditations.length - 1].day;
      if (lastMeditation != null) {
        if (lastMeditation.add(Duration(days: 1)).day == m.day.day) {
          meditationstreak++;
        } else if (lastMeditation.day != m.day.day ||
            lastMeditation.month != m.day.month) {
          meditationstreak = 1;
        }
      } else {
        meditationstreak = 1;
      }
    }

    this.totalMeditations.add(m);
    this.level.addXP(m.xp);
    //minutesMeditated += m.duration.inMinutes;
    //setTimeMeditated();

    this.missions.forEach((key, value) {
      value.forEach((key, value) {
        if (key == "meditation") {
          for (MissionModel mission in value) {
            if (!mission.done) {
              if (mission.requirement == "time") {
                if (mission.requirements[0] <= m.duration.inMinutes) {
                  //Añade la misión a la cuenta de misiones
                  missionspassed++;
                  mission.passed();
                  this.level.addXP(mission.xp);
                  result.add(mission);
                }
              }
              if (mission.requirement == "count") {
                if (mission.requirements[0] <= this.totalMeditations.length) {
                  mission.passed();
                  missionspassed++;
                  this.level.addXP(mission.xp);
                  result.add(mission);
                }
              } else {
                if (mission.requirements[0] <= this.meditationstreak) {
                  mission.passed();
                  missionspassed++;
                  this.level.addXP(mission.xp);
                  result.add(mission);
                }
              }
            }
          }
        }
      });
    });

    if (missionspassed >=
        this.missions["required"]["lesson"].length +
            this.missions["required"]["meditation"].length) {
      stagenumber++;
      missionspassed = 0;
    }

    minutesMeditated += m.duration.inMinutes;
    timeMeditated = minutesMeditated.toString() + ' minutes meditated';

    return result;
  }

  void passMission(Mission m, bool isstagemission) {
    if (isstagemission) {
      this.requiredmissions.remove(m);
    } else {
      this.optionalmissions.remove(m);
    }
  }
}
