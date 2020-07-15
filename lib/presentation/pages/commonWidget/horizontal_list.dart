import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:meditation_app/data/models/lesson_model.dart';
import 'package:meditation_app/presentation/pages/config/configuration.dart';
import 'package:meditation_app/presentation/pages/learn/lesson_view.dart';

class HorizontalList extends StatelessWidget {
  List<LessonModel> lessons;
  //String description;

  HorizontalList({this.lessons});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 32),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
                padding: EdgeInsets.only(
                    left: Configuration.safeBlockHorizontal * 5),
                child: Text("Attention", style: Configuration.paragraph)),
            Row(
              children: <Widget>[
                Expanded(
                    child: Container(
                        height: Configuration.safeBlockVertical * 35,
                        child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.all(16),
                            itemCount: lessons.length,
                            itemBuilder: (context, index) {
                              return LessonCard(lesson: lessons[index]);
                            }))),
              ],
            )
          ]),
    );
  }
}

class LessonCard extends StatelessWidget {
  LessonModel lesson;

  LessonCard({Key key, this.lesson}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
            margin:
                EdgeInsets.only(right: Configuration.safeBlockHorizontal * 5),
            width: Configuration.safeBlockHorizontal * 45,
            decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7, // changes position of shadow
                  )
                ],
                // border: Border.all(color: Colors.black),
                image: DecorationImage(
                    image: AssetImage('images/drawing.jpg'), fit: BoxFit.cover),
                borderRadius: BorderRadius.circular(8)),
          ),
        ),
        Positioned(
          bottom: 0.0,
          left: 0.0,
          width: Configuration.safeBlockHorizontal * 45,
          height: Configuration.safeBlockVertical * 7,
          child: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [Colors.grey, Colors.grey.withOpacity(0.5)],
            )),
          ),
        ),
        Positioned(
            left: Configuration.safeBlockHorizontal * 2,
            bottom: Configuration.safeBlockVertical * 1,
            child: Container(
                height: Configuration.safeBlockVertical * 6,
                width: Configuration.safeBlockHorizontal * 45,
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
