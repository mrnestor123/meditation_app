import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:meditation_app/presentation/mobx/actions/user_state.dart';
import 'package:meditation_app/presentation/pages/commonWidget/horizontal_list.dart';
import 'package:meditation_app/presentation/pages/config/configuration.dart';
import 'package:meditation_app/presentation/pages/learn/brain_widget.dart';
import 'package:provider/provider.dart';

//List of guided meditations
List<Map> guidedmeditations = [];

class LearnMeditation extends StatelessWidget {
  ScrollController controller;

  LearnMeditation({this.controller});

  @override
  Widget build(BuildContext context) {
    final _userstate = Provider.of<UserState>(context);
    return ListView(
      controller: controller,
      children: <Widget>[
        Container(
          width: Configuration.blockSizeHorizontal * 6,
          height: Configuration.blockSizeVertical * 10,
          child: Text(
            'Learn meditation techniques to apply right away',
            softWrap: true,
            style: Configuration.subtitle,
            textAlign: TextAlign.center,
          ),
        ),
        Observer(builder: ((context) {
          // return CardView(lessons: _learnstate.brainlessons);
          return HorizontalList(
              lessons: _userstate.lessondata[_userstate.menuindex]["meditation"]);
        })),

        // HorizontalList(description: 'Guided Meditations'),
        // HorizontalList(description: 'Lessons'),
        // HorizontalList(description: 'Mind exercises'),
        // HorizontalList(description: 'Mind improvement'),
      ],
    );
  }
}
