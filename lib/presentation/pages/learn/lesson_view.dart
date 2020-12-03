import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:meditation_app/data/models/lesson_model.dart';
import 'package:meditation_app/domain/entities/mission.dart';
import 'package:meditation_app/presentation/mobx/actions/user_state.dart';
import 'package:meditation_app/presentation/pages/commonWidget/card_scroll.dart';
import 'package:meditation_app/presentation/pages/commonWidget/mission_popup.dart';
import 'package:meditation_app/presentation/pages/config/configuration.dart';
import 'package:meditation_app/presentation/pages/learn/brain_widget.dart';
import 'package:meditation_app/presentation/pages/meditation/main_screen.dart';
import 'package:meditation_app/presentation/pages/menu/animatedcontainer.dart';
import 'package:provider/provider.dart';

class StartLesson extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class LessonView extends StatefulWidget {
  LessonModel lesson;

  LessonView({this.lesson});

  @override
  _LessonViewState createState() => _LessonViewState();
}

class _LessonViewState extends State<LessonView> {
  int startindex = 0;
  UserState _userstate;

  CarouselController buttonCarouselController = CarouselController();

  var state = '';

  void finishlesson(context) async {
    //Esto no hace falta. Simplemente esperar a que la lista de misiones del usuario cambie
    List<Mission> l = await _userstate.takeLesson(widget.lesson);

    if (l != null && l.length > 0) {
      showGeneralDialog(
          barrierColor: Colors.black.withOpacity(0.5),
          transitionBuilder: (context, a1, a2, widget) {
            return Transform.scale(
              scale: a1.value,
              child: Opacity(
                opacity: a1.value,
                child: MissionPopup(missions: l),
              ),
            );
          },
          transitionDuration: Duration(milliseconds: 200),
          barrierDismissible: true,
          barrierLabel: '',
          context: context,
          pageBuilder: (context, animation1, animation2) {});

      await Future.delayed(Duration(seconds: 2));
      Navigator.pop(context);
      Navigator.pop(context);
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    _userstate = Provider.of<UserState>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          CarouselSlider.builder(
              itemCount: widget.lesson.text.entries.length + 1,
              itemBuilder: (BuildContext context, int index) {
                if (index == 0) {
                  return Stack(children: [
                    Image.asset(
                        'assets/stage ' +
                            widget.lesson.stagenumber.toString() +
                            '/' +
                            widget.lesson.slider,
                        width: double.maxFinite,
                        height: double.maxFinite,
                        fit: BoxFit.fill),
                    Container(
                        height: Configuration.height,
                        color: Configuration.maincolor.withOpacity(0.8),
                        child: Center(
                          child: Container(
                              width: Configuration.width * 0.8,
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(widget.lesson.title,
                                        style: Configuration.title2),
                                    SizedBox(
                                        height: Configuration.height * 0.1),
                                    Text(widget.lesson.description,
                                        style: Configuration.paragraph4)
                                  ])),
                        )),
                  ]);
                } else {
                  return Column(
                    children: [
                      Expanded(
                        child: Center(
                            child: Image(
                                width: Configuration.width,
                                image: AssetImage("assets/stage " +
                                    widget.lesson.stagenumber.toString() +
                                    "/" +
                                    widget.lesson.text[index.toString()]
                                        ["image"]))),
                      ),
                      Container(
                          width: Configuration.width,
                          padding: EdgeInsets.all(
                              Configuration.safeBlockHorizontal * 4),
                          color: Configuration.grey,
                          child: Center(
                              child: Text(
                                  widget.lesson.text[index.toString()]["text"],
                                  style: GoogleFonts.montserrat(
                                      textStyle: TextStyle(color: Colors.white),
                                      fontSize:
                                          Configuration.safeBlockHorizontal *
                                              5)))),
                    ],
                  );
                }
              },
              options: CarouselOptions(
                height: Configuration.height,
                viewportFraction: 1,
                initialPage: 0,
                enableInfiniteScroll: false,
                reverse: false,
                onPageChanged: (index, reason) {
                  print(index);
                  print(widget.lesson.text.entries.length);
                  /* if (index == 1) {
                    setState(() {});
                  }*/

                  if (index == widget.lesson.text.entries.length) {
                    setState(() {
                      state = 'finished';
                      print("algo pasa aquí");
                    });
                  } else {
                    setState(() {
                      startindex = index;
                      state = '';
                      print("algo pasa aquí");
                    });
                  }
                },

                /*autoPlay: true,
                    autoPlayInterval: Duration(seconds: 3),
                    autoPlayAnimationDuration: Duration(milliseconds: 800),
                    autoPlayCurve: Curves.fastOutSlowIn,
                    */
                enlargeCenterPage: true,
                scrollDirection: Axis.horizontal,
              )),
          startindex != 0
              ? Positioned(
                  top: 0,
                  child: Container(
                      height: Configuration.height * 0.12,
                      color: Configuration.grey,
                      width: Configuration.width,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: Icon(Icons.close,
                                size: Configuration.iconSize,
                                color: Colors.white),
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ContainerAnimated(route: '/brain')));
                            },
                          ),
                          Flexible(
                              child: Text(
                            widget.lesson.title,
                            style: Configuration.title3,
                            textAlign: TextAlign.center,
                          )),
                          state == 'finished'
                              ? Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: IconButton(
                                    icon: Icon(
                                      Icons.check_circle_outline_sharp,
                                      size: Configuration.iconSize,
                                      color: Colors.white,
                                    ),
                                    onPressed: () {
                                      // do something
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                FinishedLesson(
                                                    lesson: widget.lesson)),
                                      );
                                    },
                                  ),
                                )
                              : Container()
                        ],
                      )))
              : Container()
        ],
      ),
    );
  }
}

class FinishedLesson extends StatefulWidget {
  LessonModel lesson;
  List<LessonModel> passedlessons;

  FinishedLesson({this.lesson});

  @override
  _FinishedLessonState createState() => _FinishedLessonState();
}

class _FinishedLessonState extends State<FinishedLesson> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Configuration.maincolor,
        child: Stack(children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: Configuration.height * 0.15),
              Center(
                  child: Text('Congrats.You read the lesson',
                      style: Configuration.title, textAlign: TextAlign.center)),
              SizedBox(height: Configuration.height * 0.05),
              LessonCard(lesson: widget.lesson),
              SizedBox(height: Configuration.height * 0.05),
              Expanded(
                  child: Container(
                width: Configuration.width,
                color: Colors.white,
                child: Column(children: [
                  SizedBox(height: Configuration.height * 0.1),
                  Center(child: Text('You have unlocked ',style: Configuration.titleblackmedium)),
                  
                ]),
              ))
            ],
          ),
          Positioned(
              top: 0,
              child: Container(
                  height: Configuration.height * 0.12,
                  width: Configuration.width,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: Icon(Icons.close,
                            size: Configuration.iconSize, color: Colors.white),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      ContainerAnimated(route: '/brain')));
                        },
                      ),
                    ],
                  )))
        ]),
      ),
    );
  }
}

/*
class _LessonViewState extends State<LessonView> {
  int index = 0;
  UserState _userstate;

  void finishlesson(context) async {
    //Esto no hace falta. Simplemente esperar a que la lista de misiones del usuario cambie
    List<Mission> l = await _userstate.takeLesson(widget.lesson);

    if (l != null && l.length > 0) {
      showGeneralDialog(
          barrierColor: Colors.black.withOpacity(0.5),
          transitionBuilder: (context, a1, a2, widget) {
            return Transform.scale(
              scale: a1.value,
              child: Opacity(
                opacity: a1.value,
                child: MissionPopup(missions: l),
              ),
            );
          },
          transitionDuration: Duration(milliseconds: 200),
          barrierDismissible: true,
          barrierLabel: '',
          context: context,
          pageBuilder: (context, animation1, animation2) {});

      await Future.delayed(Duration(seconds: 2));
      Navigator.pop(context);
      Navigator.pop(context);
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    _userstate = Provider.of<UserState>(context);
    return Scaffold(
      body: Dismissible(
        onDismissed: (DismissDirection direction) {
          setState(() {
            index += direction == DismissDirection.endToStart ? 1 : -1;
          });
        },
        key: new ValueKey(index),
        child: Stack(
          children: <Widget>[
            index == 0
                ? Image.asset('assets/' + widget.lesson.slider,
                    width: double.maxFinite,
                    height: double.maxFinite,
                    fit: BoxFit.fill)
                : Container(),
            index == 0
                ? Container(
                  color: Configuration.maincolor.withOpacity(0.8),
                  child: Center(
                      child: Container(
                          width: Configuration.width * 0.8,
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(widget.lesson.title,
                                    style: Configuration.title2),
                                SizedBox(height: Configuration.height * 0.1),
                                Text(widget.lesson.description,
                                    style: Configuration.paragraph4)
                              ])),
                    ),
                )
                : Positioned(
                    bottom: 0.0,
                    child: Column(children: [
                      Image(
                          width: Configuration.width,
                          image: AssetImage("assets/" +
                              widget.lesson.text[index.toString()]["image"])),
                      Container(
                          width: Configuration.width,
                          padding: EdgeInsets.all(
                              Configuration.safeBlockHorizontal * 4),
                          color: Configuration.grey,
                          child: Center(
                              child: Text(
                                  widget.lesson.text[index.toString()]["text"],
                                  style: GoogleFonts.montserrat(
                                      textStyle: TextStyle(color: Colors.white),
                                      fontSize:
                                          Configuration.safeBlockHorizontal *
                                              5))))
                    ])),
            new Positioned(
              //Place it at the top, and not use the entire screen
              top: Configuration.safeBlockVertical * 6,
              left: 10.0,
              child: IconButton(
                icon: Icon(index == 0 ? Icons.close : Icons.arrow_left,
                    size: Configuration.iconSize),
                color: index == 0 ? Colors.white : Colors.black,
                onPressed: () => setState(
                    () => index == 0 ? Navigator.pop(context) : index--),
              ),
            ),
            new Positioned(
              //Place it at the top, and not use the entire screen
              top: Configuration.safeBlockVertical * 6,
              right: 10.0,
              child: IconButton(
                icon: Icon(
                    index == widget.lesson.text.length
                        ? Icons.check
                        : Icons.arrow_right,
                    size: Configuration.iconSize),
                color: index == 0 ? Colors.white : Colors.black,
                onPressed: () => setState(() =>
                    index < widget.lesson.text.length
                        ? index++
                        : finishlesson(context)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
*/
