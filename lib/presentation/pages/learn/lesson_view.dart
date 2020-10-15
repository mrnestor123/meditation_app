import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:meditation_app/data/models/lesson_model.dart';
import 'package:meditation_app/domain/entities/mission.dart';
import 'package:meditation_app/presentation/mobx/actions/user_state.dart';
import 'package:meditation_app/presentation/pages/commonWidget/mission_popup.dart';
import 'package:meditation_app/presentation/pages/config/configuration.dart';
import 'package:meditation_app/presentation/pages/meditation/main_screen.dart';
import 'package:provider/provider.dart';

class LessonView extends StatefulWidget {
  LessonModel lesson;

  LessonView({this.lesson});

  @override
  _LessonViewState createState() => _LessonViewState();
}

class _LessonViewState extends State<LessonView> {
  int index = 0;
  UserState _userstate;

  void finishlesson(context) async {
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
        child: Container(
          color:
              index == 0 ? Configuration.maincolor : Configuration.whitecolor,
          width: Configuration.width,
          height: Configuration.height,
          child: Stack(
            children: <Widget>[
              index == 0
                  ? Center(
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
                    )
                  : Positioned(
                      bottom: 0.0,
                      child: Column(children: [
                        Image(
                            width: Configuration.width,
                            image: AssetImage("images/" +
                                widget.lesson.text[index.toString()]["image"])),
                        Container(
                            width: Configuration.width,
                            padding: EdgeInsets.all(
                                Configuration.safeBlockHorizontal * 4),
                            color: Configuration.grey,
                            child: Center(
                                child: Text(
                                    widget.lesson.text[index.toString()]
                                        ["text"],
                                    style: GoogleFonts.montserrat(
                                        textStyle:
                                            TextStyle(color: Colors.white),
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
      ),
    );
  }
}
