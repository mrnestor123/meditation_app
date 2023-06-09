
import 'content_entity.dart';


// LA TECNICA CREO QUE NO S E UTILIZAN TODOS LOS ATRIBUTOS!!!
class Technique extends Content  {
  String why,  distraction, moveOn, returnTo, shortDescription;
  int startingStage, endingStage;

  bool isDistraction  = false;


  Technique({
    this.why,
    this.distraction,
    this.moveOn,
    this.returnTo,
    this.startingStage,
    this.endingStage,
    this.shortDescription,
    this.isDistraction,
    cod,
    type = 'technique',
    stagenumber,
    description,
    image,
    title,
    file = '',
    position,
    createdBy,
    notes,
    isNew,
    total,
    report,
    
  })
  : super(
    cod: cod,
    isNew: isNew,
    description: description,
    image: image,
    title: title,
    createdBy: createdBy,
    stagenumber: stagenumber,
    position: position,
    type: type
  );


  
  //from  json and tojson methods
  factory Technique.fromJson(Map<String, dynamic> json) => Technique(
    cod: json["cod"] == null ? null : json["cod"],
    image: json["image"] == null ? null : json["image"],
    shortDescription: json["shortDescription"] == null ? null : json["shortDescription"],
    title: json["title"] == null ? null : json["title"],
    description: json["description"] == null ? null : json["description"],
    why: json["why"] == null ? null : json["why"],
    distraction: json["distraction"] == null ? null : json["distraction"],
    isDistraction: json['isDistraction'] == null ? false : json['isDistraction'],
    moveOn: json["moveon"] == null ? null : json["moveon"],
    returnTo: json["return"] == null ? null : json["return"],
    position: json["position"] == null ? 10 : json["position"],
    startingStage: json["startingStage"] == null ? 10 : json["startingStage"],
    endingStage: json["endingStage"] == null ? 10 : json["endingStage"],
  );

  // ESTO NO HACE FALTA JEJEJE
  Map<String, dynamic> toJson() => {
    "cod": cod == null ? null : cod,
    "title": title == null ? null : title,
    "image": image == null ? null : image,
    "description": description == null ? null : description,
    "why": why == null ? null : why,
    "distraction": distraction == null ? null : distraction,
    "moveOn": moveOn == null ? null : moveOn,
    "returnTo": returnTo == null ? null : returnTo,
    "position": position == null ? null : position,
    "startingStage": startingStage == null ? null : startingStage,
    "endingStage": endingStage == null ? null : endingStage,
  };

}