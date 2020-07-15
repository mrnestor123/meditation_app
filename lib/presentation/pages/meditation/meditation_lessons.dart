import 'package:flutter/material.dart';
import 'package:meditation_app/presentation/pages/commonWidget/bottomMenu.dart';
import 'package:meditation_app/presentation/pages/commonWidget/bottom_menu.dart';
import 'package:meditation_app/presentation/pages/commonWidget/horizontal_list.dart';
import 'package:meditation_app/presentation/pages/config/configuration.dart';

//List of guided meditations
List<Map> guidedmeditations = [];

class LearnMeditation extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Configuration().init(context);
    return ListView(
        children: <Widget>[
          Container(
            width: Configuration.blockSizeHorizontal*6,
            height: Configuration.blockSizeVertical*10,
            child: Text('Learn meditation techniques to apply right away',softWrap: true,style: Configuration.subtitle,textAlign: TextAlign.center,),
          ),
          // HorizontalList(description: 'Guided Meditations'),
          // HorizontalList(description: 'Lessons'),
          // HorizontalList(description: 'Mind exercises'),
          // HorizontalList(description: 'Mind improvement'), 
        ],
      );
  }
}
