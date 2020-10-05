import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:meditation_app/presentation/mobx/actions/user_state.dart';
import 'package:meditation_app/presentation/pages/commonWidget/horizontal_list.dart';
import 'package:meditation_app/presentation/pages/config/configuration.dart';
import 'package:provider/provider.dart';

//List of guided meditationsx
List<Map> guidedmeditations = [];

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
        SizedBox(height: Configuration.height*0.05),
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
              lessons: _userstate.lessondata[_userstate.menuindex],key: Key(_userstate.menuindex.toString()));
        })),
      ],
    );
  }
}
