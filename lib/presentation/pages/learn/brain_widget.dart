import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:meditation_app/data/models/lesson_model.dart';
import 'package:meditation_app/presentation/mobx/actions/user_state.dart';
import 'package:meditation_app/presentation/pages/commonWidget/card_scroll.dart';
import 'package:meditation_app/presentation/pages/config/configuration.dart';
import 'package:meditation_app/presentation/pages/learn/lesson_view.dart';
import 'package:provider/provider.dart';

//List of guided meditationsx
List<Map> guidedmeditations = [];

/* NO DEBERÍA LLAMARSE ASÍ*/
//lista de lecciones
class BrainScreen extends StatelessWidget {
  var brainlessons;
  var controller;

  BrainScreen({this.controller});

  @override
  Widget build(BuildContext context) {
    final _userstate = Provider.of<UserState>(context);
    //  _learnstate.getBrainLessons(stage: 1);
    return ListView(
      controller: controller,
      children: <Widget>[
        SizedBox(height: Configuration.height * 0.05),
        Container(
          width: Configuration.blockSizeHorizontal * 4,
          height: Configuration.blockSizeVertical * 10,
          child: Text(
            'Learn everything you need to know',
            softWrap: true,
            style: Configuration.subtitle,
            textAlign: TextAlign.center,
          ),
        ),
        Observer(builder: ((context) {
          // return CardView(lessons: _learnstate.brainlessons);
          return HorizontalList(
              lessons: _userstate.user.lessons[_userstate.menuindex],
              key: Key(_userstate.menuindex.toString()));
        })),
      ],
    );
  }
}

class HorizontalList extends StatelessWidget {
  var lessons;
  //String description;

  HorizontalList({this.lessons, Key key}) : super(key: key);

  List<Widget> getWidgets(context) {
    List<Widget> list = new List<Widget>();
    lessons.forEach((key, value) {
      list.addAll([
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(key, style: Configuration.paragraph),
            GestureDetector(
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (_) => LessonsDialog(lessons: value),
                      barrierDismissible: true);
                },
                child: Text("View All", style: Configuration.paragraph3)),
          ],
        ),
        SizedBox(height: Configuration.safeBlockVertical * 2),
        CardView(lessons: value),
        SizedBox(height: Configuration.safeBlockVertical * 3),
      ]);
    });
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
          top: Configuration.safeBlockVertical * 2,
          bottom: Configuration.safeBlockVertical * 1),
      padding: EdgeInsets.symmetric(
          vertical: Configuration.safeBlockVertical * 5,
          horizontal: Configuration.safeBlockHorizontal * 3),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: getWidgets(context)),
    );
  }
}

class LessonCard extends StatelessWidget {
  LessonModel lesson;

  LessonCard({Key key, this.lesson}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(this.lesson);
    return Stack(
      children: <Widget>[
        GestureDetector(
          onLongPress: () => showModalBottomSheet(
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
              context: context,
              builder: (BuildContext builder) {
                return Wrap(children: <Widget>[
                  BottomModal(title: lesson.title, subtitle: lesson.description)
                ]);
              }),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => LessonView(lesson: lesson)),
          ),
          child: Container(
            height: Configuration.safeBlockHorizontal * 40,
            width: Configuration.safeBlockHorizontal * 40,
            decoration: BoxDecoration(
                // border: Border.all(color: Colors.black),
                image: DecorationImage(
                    image: AssetImage(lesson.slider != null
                          ? 'assets/stage ' + lesson.stagenumber.toString() + '/' + lesson.slider
                          : 'assets/sky.jpg'),
                    fit: BoxFit.cover),
                borderRadius: BorderRadius.circular(8)),
          ),
        ),
        Positioned(
          bottom: 0.0,
          left: 0.0,
          width: Configuration.safeBlockHorizontal * 40,
          height: Configuration.safeBlockHorizontal * 10,
          child: lesson.blocked
              ? Container(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [Colors.grey, Colors.grey.withOpacity(0.5)],
                  )),
                )
              : Container(),
        ),
        Positioned(
            left: 5.0,
            bottom: 0.0,
            child: Container(
                height: Configuration.safeBlockHorizontal * 10,
                width: Configuration.safeBlockHorizontal * 50,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(lesson.title, style: Configuration.lessontext),
                  ],
                ))),
      ],
    );
  }
}

class BottomModal extends StatelessWidget {
  String title;
  String subtitle;

  BottomModal({
    this.title,
    this.subtitle,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(Configuration.safeBlockVertical * 4),
      margin: EdgeInsets.all(Configuration.safeBlockVertical * 2),
      decoration: new BoxDecoration(
        color: Colors.white,
        borderRadius: new BorderRadius.all(Radius.circular(25.0)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(title, style: Configuration.modaltitle),
          SizedBox(height: Configuration.safeBlockVertical * 3),
          Text(subtitle, style: Configuration.modalsubtitle)
        ],
      ),
    );
  }
}

class LessonsDialog extends StatelessWidget {
  var lessons;

  LessonsDialog({Key key, this.lessons}) : super(key: key);

  List<Widget> grid() {
    List<Widget> result = new List<Widget>();

    for (var lesson in lessons) {
      result.add(LessonCard(lesson: lesson));
    }

    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: Container(
            width: Configuration.width,
            padding: EdgeInsets.all(Configuration.safeBlockVertical * 2),
            child: ListView(children: grid())));

    /*CustomScrollView(primary: false, slivers: <Widget>[
              SliverPadding(
                padding: const EdgeInsets.all(20),
                sliver: SliverGrid.count(
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    crossAxisCount: 2,
                    children: grid()),
              ),
            ])));**/

    /*return AlertDialog(
          title: Text("You can't come back"),
          shape: ContinuousRectangleBorder(),
          backgroundColor: Colors.grey,
          content: Text(
              "This session won't count if you abandon now. Do you want to exit?"),
          actions: <Widget>[
            FlatButton(
              child: Text('Yes'),
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
            ),
            FlatButton(
              child: Text('No'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );*/
  }
}
