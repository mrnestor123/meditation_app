/**void main() {
  test('Model testing and functions', () {
    Stage one = new Stage(stageNumber: 1);
    Stage two = new Stage(stageNumber: 2);
    Feed f = new Feed();
    Lesson l1 = new Lesson(quickdescription: "example lesson", stage: one);
    Lesson l2 = new Lesson(quickdescription: "example lesson 2", stage: one);
    Lesson l3 = new Lesson(quickdescription: "example lesson 2", stage: two);

    User u = new User(
        nombrepila: "jose",
        mail: "jose@gmail.com",
        userName: "josemari",
        assignedStage: one,
        feed: f);

    User u2 = new User(
        nombrepila: "jose",
        mail: "jose@hotmail.com",
        userName: "josemi",
        assignedStage: two,
        feed: f);

    expect(u.remainingLessons.length, 2);
    expect(u2.remainingLessons.length, 1);
    expect(u.lessonslearned.length, 0);

    u.startLesson(l1);
    Meditation meditation = new Meditation(duration: new Duration(minutes: 60));
    u.startMeditation(meditation);
    expect(f.totalMeditations.length, 1);
    u.finishedMeditation(meditation);
    expect(f.totalMeditations.length, 0);

    u.finishedLesson(l1);

    expect(u.lessonslearned.length, 1);
    expect(u.remainingLessons.length, 1);
  
**/
