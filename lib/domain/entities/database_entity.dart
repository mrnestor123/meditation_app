//Objeto para almacenar información de la base de datos

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:meditation_app/data/models/game_model.dart';
import 'package:meditation_app/data/models/stage_model.dart';
import 'package:meditation_app/data/models/user_model.dart';
import 'package:meditation_app/domain/entities/course_entity.dart';
import 'package:meditation_app/domain/entities/milestone_entity.dart';
import 'package:meditation_app/domain/entities/request_entity.dart';
import 'package:meditation_app/domain/entities/stage_entity.dart';
import 'package:meditation_app/domain/entities/user_entity.dart';
import 'package:meditation_app/domain/entities/version_entity.dart';
import 'package:mobx/mobx.dart';


import '../../data/models/content_model.dart';
import '../../data/models/meditation_model.dart';
import 'content_entity.dart';
import 'meditation_entity.dart';


List<Milestone> allMilestones = [
  Milestone(
    title: 'Continuous attention to the breath',
    name:'continuousattention',
    description: 'The first milestone is to be able to sustain attention on the breath for a continuous period of time. This is the first step towards developing a stable attention.',
    passedPercentage: 0,
    objectives: [
      Objective(
        title: 'Establish a practice',
        description: 'Complete 21 consecutive meditations.',
        toComplete: 21,
        type: 'streak'
      ),

      Objective(
        title: 'Long meditations',
        description: 'Complete 4 meditations of 30 minutes or more.',
        toComplete: 4,
        metricValue: 30,
        type:'timeMetric',
        name:'longmeditations'
      ),

      Objective(
        type:'reportMetric',
        name:'mindwandering',
        reportType: 'percentage',
        title:'Overcome mind-wandering',
        metricValue: 70,
        description: 'Complete ten sessions with 70% of focused attention.',
        hint: 'What percentage were you focused on what you intended to?',
        metricName:'Focused attention',
        toComplete: 10
      ),

      Objective(
        type:'reportMetric',
        reportType: 'units',
        name:'forgetting',
        title:'Overcome forgetting',
        metricName:'Aha moments',
        hint:'How much times did you come back to the intended focus?',
        description: 'Complete ten sessions without forgetting our focus of attention more than 10 times.',
        metricValue: 10,
        toComplete: 10
      ),
    ],
    firstStage: 1,
    lastStage: 3,
    position: 1
  ),

  Milestone(
    title: 'Sustained Exclusive Focus of attention',
    name:'sustainedfocus',
    description: 'xx',
    firstStage: 4,
    lastStage: 6,
    position: 2
  ),

  Milestone(
    title: 'Effortless stability of attention',
    name:'effortless',
    description: 'xxxy',
    firstStage: 7,
    lastStage: 7,
    position: 3
  ),

  Milestone(
    title: 'Combining effort and effortlessness.  ',
    name:'persistence',
    description: 'xyxy',
    firstStage: 8,
    lastStage: 10,
    position: 4,
    objectives: [
      Objective(
        title: 'Master the skill of meditation',
        description: 'Complete 10000 hours of total practice',
        toComplete: 100000,
        type: 'totaltime'
      )
    ],
  )
];

Map<String,String> metricNames = {};



//habrá que ir añadiéndole datos
class DataBase {
  ObservableList<Stage> stages = new ObservableList();
  ObservableList<User> users = new ObservableList();
  ObservableList<Request> requests = new ObservableList();
  ObservableList<Meditation> nostagemeditations = new ObservableList();
  ObservableList<Content> introductoryContent = new ObservableList();

  List<Section> sections =  new List.empty(growable: true);
  // textos para los settings !!
  AppSettings settings  = new AppSettings();

 // List<Course> courses = new  List.empty(growable: true);

  List<Content> newContent = new List.empty(growable: true);

  List<User> teachers = new List.empty(growable: true);

  List<Game> games  = new List.empty(growable: true);

  List<Milestone> milestones = new List.empty(growable: true);


  List<Version> versions = new List.empty(growable: true);

  UpdatePatch lastUpdate;



  Meditation weeklyMeditation;


  
  Version lastVersion;

  DataBase(){
    settings = new AppSettings();
  //  milestones = allMilestones;
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

    if(json['games'] != null && json['games'].length > 0){
      for(var game in json['games']){
        d.games.add(GameModel.fromJson(game));
      }

      d.games.sort((a, b) => a.position.compareTo(b.position));
    }

    
    if(json['milestones'] != null){
      for(var milestone in json['milestones']){
        d.milestones.add(Milestone.fromJson(milestone));
      }

      d.milestones.sort((a,b) => a.position.compareTo(b.position));

      d.milestones.forEach((element) {
        metricNames[element.name] = element.title;
      });
    } else {
      d.milestones = allMilestones;
    }

    if(json['weeklyMeditation'] != null){
      d.weeklyMeditation = MeditationModel.fromJson(json['weeklyMeditation']);
    }

    if(json['teachers'] != null && json['teachers'].length > 0){
      for(var teacher in json['teachers']){
        d.teachers.add(UserModel.fromJson(teacher));
      }
      
      d.teachers.sort((a, b) => a.image == null || a.image.isEmpty ? 1 : -1);
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

    if(json['introductoryContent'] != null && json['introductoryContent'].length > 0){
      for(var content in json['introductoryContent']){
        d.introductoryContent.add(Content.fromJson(content));
      }
    }
    
  
    return d;
 
  }


  //habrá que implementar un método update, etc etc.
}


class Section {
  String cod, title, description,image;

  List<Content> content = new List.empty(growable: true);

  List<ContentGroup> contentGroups = new List.empty(growable: true);

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
      
      if(json['content'][0] is String){
      }else{
        for(var c in json['content']){
          content.add(medorLessfromJson(c));
        }

        if(json['groups'] != null && json['groups'].length > 0){
          
          for(var group in json['groups']){
            group['content'] = content.where((element) => element.group == group['name']);


            contentGroups.add(ContentGroup.fromJson(group));
          }
        }else{
          ContentGroup generalGroup = new ContentGroup(
            title:'General',
            name:'general'
          );
          generalGroup.content = content;

          contentGroups.add(generalGroup);
          
        }
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


class ContentGroup {


  String title, name;
  int position;

  List<Content> content = new List.empty(growable: true);

  ContentGroup({this.title, this.name, this.position});

  // from json  and to json methods


  ContentGroup.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    
    name = json['name'];
    position = json['position'];

    if(json['content'] != null){
      for(var c in json['content']){
        content.add(c);
      }

      content.sort((a,b)=>  a.position- b.position);
    }  
  }




}



class UpdatePatch {
  int lastUpdate, lastVersion;
  List<Slide> slides = new List.empty(growable: true);

  UpdatePatch({this.lastUpdate, this.lastVersion});


  UpdatePatch.fromJson(Map<String, dynamic> json) {
    lastUpdate = json['lastUpdate'];
    lastVersion = json['lastVersion'];

    if(json['slides'] != null){
      for(var slide in json['slides']){
        slides.add(Slide.fromJson(slide));
      }
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['lastUpdate'] = this.lastUpdate;
    data['lastVersion'] = this.lastVersion;
    data['slides'] = this.slides.map((v) => v.toJson()).toList();
    return data;
  }

}


class Slide {
  String title, description, image;

  Slide({this.title, this.description, this.image});

  Slide.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    description = json['description'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title != null ? this.title : "";
    data['description'] = this.description != null ? this.description : "";
    data['image'] = this.image != null ? this.image : "";
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
      description: 
      """<p>We'd like to warn you before you enter: this is not your regular meditation app. This is not a quick fix, nor is it just another stress-relief app. </p> 
      <p>It is for those who are curious enough to look within and be honest with themselves. For those that want to go deep, for those who truly want to do the work.</p>""",
      image: AssetImage("assets/carousel1.png")
    ),

    IntroSlide(
      image: AssetImage("assets/carousel2.png"),
      description: """
      <p> Our content has been deeply inspired by the work of John Yates, particularly the book <i>The Mind Illuminated</i>. </p>
      <p> It presents a meditative path that combines psychology and neuroscience with Buddhism and Eastern wisdom.  </p>
      <p> Filling the gaps between science and spirituality. </p>
      """,
      title: 'Backed by science'
    ),
    
    IntroSlide(
      description: """
      <p>On this path, we divide our content into ten distinct stages, with each one introducing new meditation techniques and offering more insights about the mind. </p>
      <p> Be aware that this path is not about going anywhere or reaching any particular destination, it is a journey inward.</p>\n
      """,
      image: AssetImage("assets/carousel3.png"),
      title: 'Progressive guidance'
    ),

    IntroSlide(
      image: NetworkImage('https://firebasestorage.googleapis.com/v0/b/the-mind-illuminated-32dee.appspot.com/o/stage%201%2FD0E50587-688B-4F94-8051-D180A388FE47.png?alt=media&token=17cab94e-2971-4f2e-9baf-08beb1db6043'),
      title: 'Find a community',
      description: """
        <p>If you feel lost or in doubt, feel free to share and clarify your concerns with the community. </p>
        <p>Check in, talk with a teacher, or share your thoughts with like-minded individuals.</p>
        <p> We are here to support you. </p>
      """
    ),
  ];

  AppSettings({
    this.aboutMe, 
    this.aboutApp, 
    this.requiredUpdate,
    this.androidVersion,
    this.teachersText,
    this.iosVersion,
    this.version
  });

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
    

    /*
    if(json['introSlides'] != null){
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


class IntroSlide {
  String title, description;

  ImageProvider image;

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