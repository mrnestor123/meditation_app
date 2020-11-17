import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:meditation_app/data/models/mission_model.dart';
import 'package:meditation_app/presentation/mobx/actions/user_state.dart';
import 'package:meditation_app/presentation/pages/commonWidget/horizontal_list.dart';
import 'package:meditation_app/presentation/pages/commonWidget/mission_popup.dart';
import 'package:meditation_app/presentation/pages/config/configuration.dart';
import 'package:meditation_app/presentation/pages/menu/animatedcontainer.dart';
import 'package:meditation_app/presentation/pages/profile/profile_widget.dart';
import 'package:mobx/mobx.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';

//List of guided meditationsx
List<Map> guidedmeditations = [];

int stagenumber;

class MainScreen extends StatefulWidget {
  var controller;

  MainScreen({this.controller});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  UserState _userstate;
  int stagenumber;

  List<Widget> getMissions(Map missions) {
    List<Widget> result = new List<Widget>();

    missions.forEach((key, value) {
      result.add(Text(key + " missions", style: GoogleFonts.roboto()));
      result.add(Divider(color: Configuration.maincolor));
      result.add(SizedBox(height: Configuration.height * 0.02));
      value.forEach((key, value) {
        for (MissionModel mission in value) {
          result.add(Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Image(
                    image: AssetImage(mission.type == 'lesson'
                        ? 'assets/books.png'
                        : 'assets/meditation.png'),
                    height: Configuration.blockSizeHorizontal * 9,
                    width: Configuration.blockSizeHorizontal * 9),
                Container(
                  width: Configuration.width * 0.45,
                  child: Text(
                    mission.description,
                    style: GoogleFonts.openSans(
                        fontSize: 18, textStyle: TextStyle()),
                  ),
                ),
                mission.done
                    ? Icon(Icons.check)
                    : Icon(Icons.check_box_outline_blank)
              ]));
          result.add(SizedBox(height: Configuration.height * 0.001));
        }
      });
      result.add(SizedBox(height: Configuration.height * 0.02));
    });

    return result;
  }

  @override
  Widget build(BuildContext context) {
    Configuration().init(context);
    _userstate = Provider.of<UserState>(context);
    stagenumber = _userstate.user.stagenumber;
    return ListView(
      controller: widget.controller,
      shrinkWrap: true,
      children: <Widget>[
        SizedBox(height: Configuration.safeBlockVertical * 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            SquareContainer(
                icon: Icon(Icons.star, color: Colors.white),
                modal: AbstractDialog(
                    height: Configuration.height * 0.40,
                    content: SingleChildScrollView(
                        child: Column(
                      children: getMissions(_userstate.user.missions),
                    )))),
            SquareContainer(
              icon: Icon(FontAwesomeIcons.chartBar, color: Colors.white),
              modal: AbstractDialog(
                height: Configuration.height * 0.4,
                width: Configuration.width * 0.9,
                content: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Row(children: <Widget>[
                        LevelBar(width: Configuration.width * 0.9),
                        Observer(
                          builder: (context) => Text(
                              (_userstate.user.level.xpgoal -
                                          _userstate.user.level.levelxp)
                                      .toString() +
                                  " xp left till next level"),
                        ),
                      ]),
                      Text(_userstate.user.timeMeditated,
                          style: GoogleFonts.roboto(
                              fontSize: Configuration.blockSizeHorizontal * 5)),
                      _userstate.user.meditationstreak > 0
                          ? Text(_userstate.user.meditationstreak.toString() +
                              ' day meditation streak')
                          : Container(),
                    ],
                  ),
                ),
              ),
            ),
            SquareContainer(
              icon: Icon(FontAwesomeIcons.moon, color: Colors.white),
            )
          ],
        ),
        SizedBox(height: Configuration.safeBlockVertical * 8),
        GestureDetector(
            onTap: () => Navigator.pushNamed(context, '/path'),
            child: Center(
                child: Image(
                    width: Configuration.width,
                    image: AssetImage(_userstate.user.stagenumber == 1
                        ? 'assets/stage 1/stage 1.png'
                        : 'assets/stage 2/stage 2.png')))),
        FloatingActionButton(
          onPressed: () => Navigator.pushNamed(context, '/premeditation')
              .then((value) => setState(() {
                    print(stagenumber);
                    print(_userstate.user.stagenumber);
                    if (stagenumber != _userstate.user.stagenumber) {
                      Future.delayed(Duration(seconds: 1));
                      showGeneralDialog(
                          barrierColor: Colors.black.withOpacity(0.5),
                          transitionBuilder: (context, a1, a2, widget) {
                            return Transform.scale(
                              scale: a1.value,
                              child: Opacity(
                                opacity: a1.value,
                                child: Stack(children: [
                                  Align(
                                      alignment: Alignment.center,
                                      child: CustomPaint(
                                          foregroundPainter: CircleBlurPainter(
                                              color: Colors.yellow,
                                              circleWidth:
                                                  Configuration.width * 0.9,
                                              blurSigma: 3000.0,
                                              height:
                                                  Configuration.height * 0.3))),
                                  AbstractDialog(
                                    content: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Text("CONGRATS!",style:GoogleFonts.roboto(
                                              fontSize: Configuration.blockSizeHorizontal * 7)),
                                        Text("You have improved to stage 2",style: GoogleFonts.roboto(fontSize:Configuration.blockSizeHorizontal*4),)
                                      ],
                                    ),
                                  ),
                                ]),
                              ),
                            );
                          },
                          transitionDuration: Duration(milliseconds: 200),
                          barrierDismissible: true,
                          barrierLabel: '',
                          context: context,
                          pageBuilder: (context, animation1, animation2) {});
                    }
                  })),
          child: Icon(Icons.timer),
          backgroundColor: Configuration.maincolor,
        ),
        SizedBox(height: 500)
        // HorizontalList(description: "Learn from our guided meditations")
      ],
    );
  }
}

class SquareContainer extends StatelessWidget {
  Icon icon;
  Widget modal;
  SquareContainer({this.icon, this.modal});

  @override
  Widget build(BuildContext context) {
    final _userstate = Provider.of<UserState>(context);
    return Container(
        decoration: BoxDecoration(),
        child: ButtonTheme(
          minWidth: 40,
          height: 40,
          child: RaisedButton(
              color: Colors.grey,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(32)),
              onPressed: () => modal == null
                  ? null
                  : showGeneralDialog(
                      barrierColor: Colors.black.withOpacity(0.5),
                      transitionBuilder: (context, a1, a2, widget) {
                        return Transform.scale(
                          scale: a1.value,
                          child: Opacity(opacity: a1.value, child: modal),
                        );
                      },
                      transitionDuration: Duration(milliseconds: 200),
                      barrierDismissible: true,
                      barrierLabel: '',
                      context: context,
                      pageBuilder: (context, animation1, animation2) {}),
              child: icon),
        ));
  }
}

//Dialog for everyone
class AbstractDialog extends StatelessWidget {
  Widget content;
  double width, height;

  AbstractDialog({this.content, this.width, this.height}) {
    if (this.width == null) {
      this.width = Configuration.width * 0.9;
    }
    if (this.height == null) {
      this.height = Configuration.height * 0.3;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: Container(
            padding: EdgeInsets.all(Configuration.blockSizeHorizontal * 4),
            margin: EdgeInsets.all(Configuration.blockSizeHorizontal * 2),
            height: height,
            width: width,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12), color: Colors.white),
            child: content));
  }
}

class UserModal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class LevelBar extends StatelessWidget {
  double width;
  LevelBar({this.width});

  @override
  Widget build(BuildContext context) {
    final _userstate = Provider.of<UserState>(context);
    return Container(
      margin: EdgeInsets.all(Configuration.safeBlockVertical * 3),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
      child: RadialProgress(
          width: Configuration.safeBlockHorizontal * 2,
          progressColor: Configuration.maincolor,
          progressBackgroundColor: Configuration.grey,
          goalCompleted:
              _userstate.user.level.levelxp / _userstate.user.level.xpgoal,
          child: Container(
            height: Configuration.height * 0.1,
            width: Configuration.width * 0.1,
            child: Center(
              child: Text(
                _userstate.user.level.level.toString(),
                style: GoogleFonts.montserrat(
                    textStyle: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Configuration.maincolor,
                        fontSize: Configuration.blockSizeHorizontal * 5)),
              ),
            ),
          )),
    );
  }
}
