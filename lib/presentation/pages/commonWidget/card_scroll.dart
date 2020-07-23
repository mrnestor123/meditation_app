import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:meditation_app/data/models/lesson_model.dart';
import 'package:meditation_app/presentation/pages/config/configuration.dart';
import 'package:meditation_app/presentation/pages/learn/lesson_view.dart';

import 'horizontal_list.dart';


class CardView extends StatefulWidget {
  var lessons;
  //String description;

  CardView({this.lessons});
  @override
  _CardViewState createState() => new _CardViewState();
}

var cardAspectRatio = 1.0;
var widgetAspectRatio = cardAspectRatio * 1.2;

class _CardViewState extends State<CardView> {
  var currentPage;
  List<LessonModel> lessons;

  @override
  void initState() {
    super.initState();
    // currentPage = widget.lessons.length - 1.0;
    lessons = widget.lessons;
    currentPage = lessons.length - 1.0;
  }

  @override
  Widget build(BuildContext context) {
    PageController controller = PageController(initialPage: lessons.length - 1);
    controller.addListener(() {
      setState(() {
        currentPage =controller.page;
      });
    });

    return Stack(
      children: <Widget>[
        CardScrollWidget(currentPage, lessons),
        Positioned.fill(
          child: PageView.builder(
            itemCount: lessons.length,
            controller: controller,
            reverse: true,
            itemBuilder: (context, index) {
              return GestureDetector(
                behavior: HitTestBehavior.translucent,
                  onLongPress: () => showModalBottomSheet(
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      context: context,
                      builder: (BuildContext builder) {
                        return Wrap(children: <Widget>[
                          BottomModal(
                              title: lessons[currentPage.round()].title,
                              subtitle: lessons[currentPage.round()].description)
                        ]);
                      }),
                  onTap: () {
                    print("tapped");
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              LessonView(lesson: lessons[currentPage.round()])),
                    );
                  },
                  child: Container());
            },
          ),
        )
      ],
    );
  }
}

class CardScrollWidget extends StatelessWidget {
  var currentPage;
  var verticalInset = 20.0;
  var lessons;

  CardScrollWidget(this.currentPage, this.lessons);

  @override
  Widget build(BuildContext context) {
    return new AspectRatio(
      aspectRatio: widgetAspectRatio,
      child: LayoutBuilder(builder: (context, contraints) {
        var width = contraints.maxWidth;
        var height = contraints.maxHeight;

        var safeWidth = width;
        var safeHeight = height;

        var heightOfPrimaryCard = safeHeight;
        var widthOfPrimaryCard = heightOfPrimaryCard * cardAspectRatio;

        var primaryCardLeft = safeWidth - widthOfPrimaryCard;
        var horizontalInset = primaryCardLeft / 2;

        List<Widget> cardList = new List();

        for (var i = 0; i < lessons.length; i++) {
          var delta = i - currentPage;
          bool isOnRight = delta > 0;

          var start = 
              max(
                  primaryCardLeft -
                      horizontalInset * -delta * (isOnRight ? 15 : 1),
                  0.0);

          var cardItem = Positioned.directional(
            top: verticalInset * max(-delta, 0.0),
            bottom:  verticalInset * max(-delta, 0.0),
            start: start,
            textDirection: TextDirection.rtl,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16.0),
              child: AspectRatio(
                aspectRatio: cardAspectRatio,
                child: Stack(
                  fit: StackFit.expand,
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 5,
                              blurRadius: 7,
                            )
                          ],
                          border: Border.all(color: Colors.black12),
                          borderRadius: BorderRadius.circular(16.0),
                          color: Colors.white,
                          image: DecorationImage(
                              image: AssetImage(
                                  lessons[i].slider.startsWith('images')
                                      ? lessons[i].slider
                                      : 'images/sky.jpg'),
                              fit: BoxFit.cover)),
                    ),
                    Positioned(
                      bottom: 0.0,
                      left: 0.0,
                      width: widthOfPrimaryCard,
                      height: heightOfPrimaryCard * 0.2,
                      child: Container(
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [
                                Colors.grey.withOpacity(0.7),
                                Colors.grey.withOpacity(0.1)
                              ],
                            )),
                      ),
                    ),
                    Positioned(
                        left: 0.0,
                        bottom: 0.0,
                        child: Container(
                            height: heightOfPrimaryCard*0.2,
                            width: widthOfPrimaryCard,
                            child: Center(
                              child: Text(lessons[i].title,
                                  style: Configuration.lessontext),
                            ))),
                  ],
                ),
              ),
            ),
          );
          cardList.add(cardItem);
        }
        return Stack(
          children: cardList,
        );
      }),
    );
  }
}
