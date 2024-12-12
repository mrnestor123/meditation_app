// GUARDAR EN BASE DE DATOS EN EL FUTURO !!!
class Milestone {
  String title, description, objectivesHint, name; 
  int lastStage, firstStage, passedPercentage, position;
  bool blocked;
  
  List<Metrics> metrics = new List.empty(growable: true);
  List<Objective> objectives = new List.empty(growable: true);

  Milestone({
    this.title,
    this.name, 
    this.position,
    this.description, 
    this.passedPercentage,
    this.lastStage, 
    this.objectivesHint, 
    this.firstStage, 
    this.objectives, 
    this.blocked = false,
    this.metrics
  });
  
  // from json method
  Milestone.fromJson(Map<String, dynamic> json) {
    title = json['title'] ?? json['name'];
    name = json['name'];
    position = json['position'];
    description = json['description'];
    passedPercentage = json['passedPercentage'];
    lastStage = json['endingStage'] is String ? int.parse(json['endingStage']) : json['endingStage'];
    firstStage = json['startingStage'] is String ? int.parse(json['startingStage']) : json['startingStage'];
    blocked = json['blocked'] ?? false;
    objectivesHint = json['objectivesHint'];
    objectives = json['objectives'] != null ? 
      (json['objectives'] as List).map((i) => Objective.fromJson(i)).toList() : 
      new List.empty(growable: true);
    metrics = json['metrics'];
  }
}


class Metrics {
  String title;
  int percentage;
  
  Metrics({this.title, this.percentage});
}


var objectivetypes = [
  'streak',
  'totaltime',
  'meditationtime',
  'metric'
];


class Objective {
  String type, reportType, title, description, hint, name, metricName;

  bool passed;
  
  int percentage, toComplete, metricValue, completed;

  Objective({
    this.type, 
    this.title, 
    this.name, 
    this.reportType,
    this.description, 
    this.metricName, 
    this.hint, 
    this.completed = 0, 
    this.toComplete, 
    this.metricValue
  });

  //from json method
  Objective.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    title = json['title'];
    name = json['name'];
    reportType = json['reportType'];
    description = json['description'];
    hint = json['hint'];
    completed = json['completed'];
    toComplete = json['toComplete'] is String ? int.parse(json['toComplete']) : json['toComplete'];
    metricValue = json['metricValue'];
  }

}