/**
class Stage {
  //The stageNumber is used as a unique ID
  int stageNumber;
  String description;

  //this is for referencing the lessons. A list with their ids.
  ObservableList<String> lessons = new ObservableList();

  //this is for referencing the users. List with their ids
  ObservableList<String> users = new ObservableList();

  Stage({@required this.stageNumber, description});

  // If there are users in these stage they are added to that one.
  void addLesson(Lesson l) {
    for (User u in users) {
      u.addLesson(l);
    }
    this.lessons.add(l);
  }

  ObservableList<Lesson> getLessons() => lessons;

  void addPerson(User u) => users.add(u);
}**/
