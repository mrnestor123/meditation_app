import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:meditation_app/data/models/lesson_model.dart';
import 'package:meditation_app/presentation/mobx/actions/lesson_state.dart';
import 'package:meditation_app/presentation/pages/commonWidget/bottomMenu.dart';
import 'package:meditation_app/presentation/pages/commonWidget/bottom_menu.dart';
import 'package:meditation_app/presentation/pages/commonWidget/horizontal_list.dart';
import 'package:meditation_app/presentation/pages/config/configuration.dart';
import 'package:meditation_app/presentation/pages/menu/animatedcontainer.dart';
import 'package:provider/provider.dart';

//List of guided meditationsx
List<Map> guidedmeditations = [];

class LearnScreen extends StatelessWidget {
  List<LessonModel> brainlessons;

  @override
  Widget build(BuildContext context) {
    final _learnstate = Provider.of<LessonState>(context);
    _learnstate.getBrainLessons(stage: 1);
    return ListView(
        children: <Widget>[
          Container(
            width: Configuration.blockSizeHorizontal * 6,
            height: Configuration.blockSizeVertical * 10,
            child: Text(
              'Learn everything about your mind',
              softWrap: true,
              style: Configuration.subtitle,
              textAlign: TextAlign.center,
            ),
          ),
          Observer(builder: ((BuildContext context) {
            if (_learnstate.brainlessons.length > 0) {
              return HorizontalList(lessons: _learnstate.brainlessons);
            }else {
              return Container();
            }
          })),
          // HorizontalList(description: 'Guided Meditations'),
          // HorizontalList(description: 'Lessons'),
          // HorizontalList(description: 'Mind exercises'),
          // HorizontalList(description: 'Mind improvement'),
        ],
      );
  }
}
