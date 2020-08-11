import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:meditation_app/presentation/mobx/actions/user_state.dart';
import 'package:meditation_app/presentation/pages/commonWidget/horizontal_list.dart';
import 'package:meditation_app/presentation/pages/config/configuration.dart';
import 'package:meditation_app/presentation/pages/menu/animatedcontainer.dart';
import 'package:meditation_app/presentation/pages/profile/profile_widget.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';

//List of guided meditationsx
List<Map> guidedmeditations = [];

class MainScreen extends StatelessWidget {
  var controller;
  UserState _userstate;

  MainScreen({this.controller});

  List<Widget> stageMissions() {
    List<Widget> result = new List<Widget>();

    for (var mission in _userstate.user.requiredmissions) {
      result.add(Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            SquareContainer(),
            Text(mission.description, style: Configuration.paragraph4),
          ]));
    }
    result.add(SizedBox(height: Configuration.height * 0.05));

    return result;
  }

  @override
  Widget build(BuildContext context) {
    Configuration().init(context);
    _userstate = Provider.of<UserState>(context);
    return ListView(
      controller: controller,
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
                        children: <Widget>[
                          Text('Stage missions'),
                          Divider(color: Configuration.maincolor),
                          Column(children: stageMissions()),
                          Text('Optional missions'),
                          Divider(color: Configuration.maincolor),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                SquareContainer(),
                                Text('Meditate 5 times',
                                    style: Configuration.paragraph4),
                                Icon(Icons.check_box_outline_blank)
                              ]),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                SquareContainer(),
                                Text('Meditate 5 times',
                                    style: Configuration.paragraph4),
                                Icon(Icons.check_box_outline_blank)
                              ]),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                SquareContainer(),
                                Text('Meditate 5 times',
                                    style: Configuration.paragraph4),
                                Icon(Icons.check_box_outline_blank)
                              ]),
                        ],
                      ),
                    ))),
            SquareContainer(
              icon: Icon(FontAwesomeIcons.chartBar, color: Colors.white),
              modal: AbstractDialog(
                height: Configuration.height * 0.4,
                width: Configuration.width * 0.9,
                content: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Row(children: <Widget>[
                        LevelBar(width: Configuration.width * 0.9),
                        Observer(
                            builder: (context) => Text(
                                (_userstate.user.level.xpgoal -
                                            _userstate.user.level.levelxp)
                                        .toString() +
                                    " xp left till next level"))
                      ]),
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
            child:
                Center(child: Image(image: AssetImage('images/stage 1.png')))),
        FloatingActionButton(
          onPressed: () => Navigator.pushNamed(context, '/premeditation'),
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
                  : showDialog(context: context, builder: (_) => modal),
              child: icon),
        ));
  }
}

//Dialog for everyone
class AbstractDialog extends StatelessWidget {
  Widget content;
  double width, height;

  AbstractDialog({this.content, this.width, this.height});

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
          goalCompleted: _userstate.user.level.percentage,
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
