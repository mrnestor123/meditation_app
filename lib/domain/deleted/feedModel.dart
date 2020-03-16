/** 
class Feed {
  //Stores the users ids that are connected
  ObservableList<int> usersonline = new ObservableList();
  //Stores the meditations that are currently being made.
  List<String> meditationsinProgress = new ObservableList();

  //stores the user that are online and their status.
  ObservableMap<int, String> usersMeditating = new ObservableMap();

  int numberofpeopleMeditating;

  Feed() {
    this.numberofpeopleMeditating = meditationsinProgress.length;
  }

  ObservableList<int> getUsers() => usersonline;

  void userLoggedin(int id) => usersonline.add(id);

  void userLoggedout(int id) => usersonline.remove(id);

  void incrMeditations(String m) {
    meditationsinProgress.add(m);
    numberofpeopleMeditating++;
  }

  void decrMeditations(String m) {
    meditationsinProgress.remove(m);
    numberofpeopleMeditating--;
  }
}**/
