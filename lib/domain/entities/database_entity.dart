//Objeto para almacenar información de la base de datos

import 'dart:ui';

import 'package:meditation_app/data/models/game_model.dart';
import 'package:meditation_app/data/models/helpers.dart';
import 'package:meditation_app/data/models/stageData.dart';
import 'package:meditation_app/data/models/userData.dart';
import 'package:meditation_app/domain/entities/course_entity.dart';
import 'package:meditation_app/domain/entities/request_entity.dart';
import 'package:meditation_app/domain/entities/stage_entity.dart';
import 'package:meditation_app/domain/entities/technique_entity.dart';
import 'package:meditation_app/domain/entities/user_entity.dart';
import 'package:meditation_app/domain/entities/version_entity.dart';
import 'package:mobx/mobx.dart';

import 'category_entity.dart';
import 'content_entity.dart';
import 'game_entity.dart';
import 'lesson_entity.dart';
import 'meditation_entity.dart';

//habrá que ir añadiéndole datos
class DataBase {
  //PODRIAN SER LISTS?? NO CAMBIAN  CREO !!
  ObservableList<Stage> stages = new ObservableList();
  ObservableList<User> users = new ObservableList();
  ObservableList<Request> requests = new ObservableList();
  ObservableList<Meditation> nostagemeditations = new ObservableList();
  ObservableList<Lesson> nostagelessons = new ObservableList();

  List<Section> sections =  new List.empty(growable: true);

  // textos para los settings !!
  AppSettings settings  = new AppSettings();

  // DEBERÍA SER ASÍ !!!
  List<Technique> techniques = new List.empty(growable: true);

  List<Course> courses = new  List.empty(growable: true);

  List<Content> newContent = new List.empty(growable: true);

  List<Content> newLessons = new List.empty(growable: true);

  List<User> teachers = new List.empty(growable: true);

  List<Game> games  = new List.empty(growable: true);

  // PARA QUITAR !!!
  List<Phase> phases = new List.empty(growable: true);

  // HACER MERGE CON COURSES
  List<Course> paths = new List.empty(growable: true);

  List<Version> versions = new List.empty(growable: true);


  List<Week> weeks = new List.empty(growable: true);


  List<AppCategory> categories = new List.empty(growable: true);

  
  Version lastVersion;

  DataBase(){
    settings = new AppSettings();
  }

  void addVersion(Version v){
    versions.add(v);
  }

  void getLastVersion(){
    Version last = versions[0];

    for(Version v in versions){
      if(last.versionNumber < v.versionNumber){
        last = v;
      }
    }
    this.lastVersion = last;
  }


  void checkPercentage({User user}){
    this.stages.forEach((stage) {
      stage.checkPercentage(user);
    });
  }


  // fromjson method
  // tojson method
  factory DataBase.fromJson(Map<String, dynamic> json){

    DataBase d = new DataBase();

    if(json['stages'] !=  null && json['stages'].length > 0){
      for(var stage in json['stages']){
        d.stages.add(StageModel.fromJson(stage));
      }
    }

    if(json['versions'] != null && json['versions'].length > 0){
      for(var version in json['versions']){
        d.addVersion(Version.fromJson(version));
      }

      d.getLastVersion();
    }

    if(json['courses'] !=  null && json['courses'].length > 0){
      for(var course in json['courses']){
        d.courses.add(Course.fromJson(course));
      }
    }

    if(json['weeks'] != null && json['weeks'].length > 0){
      for(var week in json['weeks']){
        d.weeks.add(Week.fromJson(week));
      }
    }

    if(json['games'] != null && json['games'].length > 0){
      for(var game in json['games']){
        d.games.add(GameModel.fromJson(game));
      }

      d.games.sort((a, b) => a.position.compareTo(b.position));
    }

    if(json['teachers'] != null && json['teachers'].length > 0){
      for(var teacher in json['teachers']){
        d.teachers.add(UserModel.fromJson(teacher));
      }
      
      d.teachers.sort((a, b) => a.image == null || a.image.isEmpty ? 1 : -1);
    }


    if(json['newLessons'] != null){
      for(var lesson in json['newLessons']){
        d.newLessons.add(Content.fromJson(lesson));
      }


      d.newLessons.sort((a, b) => 
        a.position != null && b.position != null ? a.position.compareTo(b.position) : 0);
    }


    if(json['categories'] != null){
      for(var category in json['categories']){
        d.categories.add(AppCategory.fromJson(category));
      }
    }

    // same with settings
    if(json['settings'] != null){
      d.settings = AppSettings.fromJson(json['settings']);
    }

    if(json['sections'] != null && json['sections'].length > 0){
      for(var section in json['sections']){
        d.sections.add(Section.fromJson(section));
      }
    }
    
    if(json['techniques'] != null && json['techniques'].length > 0){
      for(var technique in  json['techniques']){
        d.techniques.add(Technique.fromJson(technique));
      }

      if(d.techniques.length >  0){
        d.techniques.sort((a, b) => a.position.compareTo(b.position));
      }
    }

    return d;
  }


  //habrá que implementar un método update, etc etc.
}

class Section {
  String cod, title, description,image;

  List<Content> content = new List.empty(growable: true);

  Color gradientStart,gradientEnd;

  bool isNew;
  int position;

  Map<String,dynamic>  createdBy;

  Section({this.cod, this.title, this.description, this.image, this.isNew, this.position, this.gradientStart, this.gradientEnd});


  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  Section.fromJson(Map<String, dynamic> json) {
    cod = json['cod'];
    title = json['title'];
    description = json['description'];
    image = json['image'];
    isNew = json['isNew'];
    position = json['position'] == null ? 0 : json['position'];
    createdBy = json['createdBy'] != null && json['createdBy'] is Map && json['createdBy'].entries.length > 0  ? json['createdBy'] : null;
    
    gradientEnd = json['gradientEnd'] != null ? Color(_getColorFromHex(json['gradientEnd'])) : null;
    gradientStart = json['gradientStart'] != null ? Color(_getColorFromHex(json['gradientStart'])) : null;

    if(json['content'] != null && json['content'].length > 0){
      for(var c in json['content']){
        content.add(medorLessfromJson(c));
      }
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cod'] = this.cod;
    data['title'] = this.title;
    data['description'] = this.description;
    data['content'] = this.content.map((v) => v.toJson()).toList();
    return data;
  }

}



class AppSettings {
  List<String> settingsItems;
  String aboutMe, aboutApp, teachersText;
  int androidVersion, iosVersion, version;
  bool requiredUpdate;
  String updateText, updateImage;
  List<MenuItem> menu = new List.empty(growable: true);

  List<IntroSlide> introSlides = [
      IntroSlide(
        title: "Welcome to TenStages",
        description: "This is not your regular meditation app, we want you to understand what meditation really is about and how you can apply it in your daily life.<br><br>"
        "Our content is inspired by the book The Mind Illuminated, written by John Yates. It is a meditation manual that integrates neuroscience with buddhist wisdom.<br><br>"
        "<i> We recommend reading the book along with the application</i>",
        image: "https://firebasestorage.googleapis.com/v0/b/the-mind-illuminated-32dee.appspot.com/o/teacherFiles%2Ffirst_slide.png?alt=media&token=c12e7c3c-cd72-4f1a-8a89-9c992f915129"
      ),

      IntroSlide(
        image: "https://firebasestorage.googleapis.com/v0/b/the-mind-illuminated-32dee.appspot.com/o/teacherFiles%2Fsecond_slide.png?alt=media&token=912b294e-c8a7-4ad4-8e39-ef2dd8efdd4b",

        description: "The process of training the mind is divided into ten different stages. All building up into the next one. <br><br>"
        "In each stage, you will master certain goals, learn new information about how your mind works and practice meditation techniques." 
        
        "<br><br><b>Keep in mind that progress is not linear </b>",
        title: "Learn to train the mind"
      ),


      IntroSlide(
        description: "The meditations have been created by certified TMI Teachers. The teacher's course consists of 4 years of training in the methodology.<br><br>"
        "You can also contact them if you'd like to clarify any doubts<br><br>", 
        image:  "https://firebasestorage.googleapis.com/v0/b/the-mind-illuminated-32dee.appspot.com/o/teacherFiles%2Ffourth_slide.png?alt=media&token=cc59c239-4471-4a87-a03f-390321e7a43e",
        title: 'Practice with a teacher'
      ),

      IntroSlide(
        image: "https://firebasestorage.googleapis.com/v0/b/the-mind-illuminated-32dee.appspot.com/o/teacherFiles%2Ffifth_slide.png?alt=media&token=a119f61c-11ab-4f7a-bc0e-71fc2f4db16e",
        title: "Test for yourself",
        description: "It's important to know that we don't preach any absolute truth. Keep an open mind and accept only what is skillful for you. <br><br>As the buddha said:  <br> <br><div style='text-align:center;font-style:italic'> Don't blindly believe me <br>Find out for yourself <br>what is true and virtuous </div><br><br><b font-size='1.2em'>Good luck!</b>",

      )
    ];

  AppSettings({
    this.aboutMe, 
    this.aboutApp, 
    this.requiredUpdate,
    this.androidVersion,
    this.teachersText,
    this.iosVersion,
    this.version
  }){

   


  }

  AppSettings.fromJson(Map<String, dynamic> json) {
    aboutMe = json['aboutMe'];
    aboutApp = json['aboutApp'];
    teachersText = json['teachersText'];
    requiredUpdate = json['requiredUpdate'] != null ? json['requiredUpdate']: false;
  
  
    if(json['androidVersion'] != null){
      androidVersion = json['androidVersion'];
    }

    if(json['iosVersion'] != null){
      iosVersion = json['iosVersion'];
    }

    /*if(json['introSlides'] != null){
      json['introSlides'].forEach((v) {
        introSlides.add(new IntroSlide.fromJson(v));
      });
    }*/

    if(json['version'] != null){
      version = json['version'];
    }


    if(json['menu'] != null) {
      json['menu'].forEach((v) {
        menu.add(new MenuItem.fromJson(v));
      });
    }
    
  }
}


class MenuItem {

  String title, text;

  MenuItem({this.title, this.text});

  MenuItem.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    text = json['text'];
  }


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title != null ? this.title : "";
    data['text'] = this.text != null ? this.text : "";
    return data;
  }
}


class Week {
  String cod, title, description, image;
  int position;
  List<Content> content = new List.empty(growable: true);

  Week({this.cod, this.title, this.description, this.image, this.position});

  Week.fromJson(Map<String, dynamic> json) {
    cod = json['cod'];
    title = json['title'];
    description = json['description'];
    position = json['position'];
    image = json['image'];
    if(json['content'] != null && json['content'].length > 0){
      for(var c in json['content']){
        content.add(medorLessfromJson(c));
      }
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['cod'] = this.cod;
    data['title'] = this.title;
    data['description'] = this.description;
    data['image'] = this.image;
    data['content'] = this.content.map((v) => v.toJson()).toList();
    return data;
  }

}


class IntroSlide {
  String title, description, image;

  IntroSlide({this.title, this.description, this.image});

  IntroSlide.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    description = json['description'] != null  ? json['description'] : json['text'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['description'] = this.description;
    data['image'] = this.image;
    return data;
  }
}