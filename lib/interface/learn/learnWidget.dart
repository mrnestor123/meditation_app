import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:meditation_app/interface/commonWidget/bottomMenu.dart';
import 'package:meditation_app/interface/commonWidget/titleWidget.dart';

class LearnWidget extends StatelessWidget {
  final int selectedIndex;

  LearnWidget(this.selectedIndex);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            DescriptionWidget('Learn everything you need to know'),
            LessonView('Lessons remaining'),
            LessonView('Lessons learned')
          ],
        ),
      ),
      bottomNavigationBar: BottomNavyBar(selectedIndex),
    );
  }
}

class LessonView extends StatelessWidget {
  final String text;

  LessonView(this.text);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: MediaQuery.of(context).size.height * 0.30,
        color: Colors.blueGrey,
        padding: EdgeInsets.all(16),
        margin: EdgeInsets.all(8),
        child: Column(mainAxisSize: MainAxisSize.max, children: <Widget>[
          Text(text),
          Expanded(
            child: ListView.builder(
                shrinkWrap: true,
                padding: const EdgeInsets.all(8),
                scrollDirection: Axis.horizontal,
                itemCount: 6,
                itemBuilder: (context, index) {
                  return LessonIcon('Prueba', 'images/sky.jpg');
                }),
          )
        ]));
  }
}

class LessonIcon extends StatelessWidget {
  final String title;
  final String lessonImage;

  LessonIcon(this.title, this.lessonImage);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
          padding: EdgeInsets.all(16),
          margin: EdgeInsets.all(8),
          height: MediaQuery.of(context).size.height * 0.15,
          width: MediaQuery.of(context).size.height * 0.15,
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(lessonImage), fit: BoxFit.cover)),
          child: SizedBox(child: Center(child: Text(this.title)))),
    );
  }
}
