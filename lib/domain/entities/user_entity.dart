import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  //Nombre es el nombre de pila y usuario es el nombre en la aplicación. ESTO HAY QUE QUITARLO
  String coduser;
  String nombre, usuario, password;
  String mail;
  // !!!!


  FirebaseUser user;
  int stagenumber;
  int meditationstreak = 0;
  Stage stage;

  String role;

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

  final Map<int, Map<String, ObservableList<LessonModel>>> lessons = new Map();

  //contains a list with all lessons
  //final ObservableMap<int,List<LessonModel>> lessons = new ObservableMap();

  //Missions for the stage. When the user completes all the stage missions he
  final ObservableList<MissionModel> requiredmissions = new ObservableList();
  final ObservableList<MissionModel> optionalmissions = new ObservableList();

  //Map with "required" and "optional" missions. In the form {"required":[Mission,Mission]}
  final Map<String, Map<String, ObservableList<MissionModel>>> missions = new Map();

  User(
      {this.coduser,
      this.nombre,
      this.user,
      @required this.stagenumber,
      this.stage,
      this.role,
      this.meditationstreak,
      this.minutesMeditated}) {
    if (coduser == null) {
      var uuid = Uuid();
      this.coduser = uuid.v1();
    } else {
      this.coduser = coduser;
    }


    //inicializamos el map
    for (int i = 1; i < 11; i++) {
      lessons[i] = {};
      // de momento hay dos categorías. Cuando haya mas las añadiremos
    }
  }

  /* @override List<Object> get props => [coduser, nombre, mail, usuario, password, stagenumber];
  */

  ObservableList<Lesson> getLessonsLearned() => lessonslearned;

  int getStageNumber() => this.stagenumber;

  //añadimos la lección a la lista de lecciones
  void addLesson(LessonModel l) {
    if (lessons[l.stagenumber][l.group] == null) {
      lessons[l.stagenumber][l.group] = new ObservableList<LessonModel>();
    }
    lessons[l.stagenumber][l.group].add(l);
  }

  void addMission(MissionModel m) =>
      m.requiredmission ? requiredmissions.add(m) : optionalmissions.add(m);

  void addMeditation(MeditationModel m) => totalMeditations.add(m);

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
  void setLessons(Map<int, Map<String, List<LessonModel>>> l) =>
      lessons.addAll(l);

  void setStage(StageModel s) => this.stage = s;

  //este método recorrerá por todas las misiones de la stage para añadirselas al user
  void setMissions(StageModel s) {
    stage = s;
    missions['required']['lesson'].clear();
    missions['required']['meditation'].clear();
    missions['optional']['lesson'].clear();
    missions['optional']['meditation'].clear();

    for (MissionModel m in s.missions) {
      missions[m.requiredmission ? 'required' : 'optional'][m.type].add(m);
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

  //returns the list of the next unlockable lessons
  List<Lesson> takeLesson(Lesson l) {
    List<Mission> result = new List<Mission>();

    List<Lesson> lessons = new List<Lesson>();

    if (!l.seen) l.seen = true;

    //Habrá que desbloquear la lección siguiente.
    this.lessons[l.stagenumber].forEach((key, value) {
      for (Lesson lesson in value) {
        if (lesson.precedinglesson == l.codlesson) {
          lesson.blocked = false;
          lessons.add(lesson);
        }
      }
    });

    return lessons;

    /*
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
    }*/
  }

  //Este método se tendrá que refinar. Devuelve null o una misión cuando se pase una el usuario
  List<Mission> takeMeditation(Meditation m) {
    List<Mission> result = new List<Mission>();
    this.totalMeditations.add(m);

    if (meditationstreak == 0) {
      meditationstreak++;
    } else {
      var lastMeditation = totalMeditations[totalMeditations.length - 1].day;
      if (lastMeditation != null) {
        //comprobamos la streak
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

    minutesMeditated += m.duration.inMinutes;
    timeMeditated = minutesMeditated.toString() + ' minutes meditated';

    return result;

    //minutesMeditated += m.duration.inMinutes;
    //setTimeMeditated();
/*
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
    */
  }

  void passMission(Mission m, bool isstagemission) {
    if (isstagemission) {
      this.requiredmissions.remove(m);
    } else {
      this.optionalmissions.remove(m);
    }
  }
}
