import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter/material.dart';
import 'package:meditation_app/blocs/meditationBloc.dart';
import 'package:meditation_app/domain/services/database_Service.dart';
import 'package:meditation_app/interface/feed/feedWidget.dart';
import 'package:meditation_app/interface/learn/learnWidget.dart';
import 'package:meditation_app/interface/meditation/meditationWidget.dart';
import 'package:meditation_app/interface/profile/profileWidget.dart';
import 'package:meditation_app/interface/stage/stageWidget.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    DB.init();
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: '/feed',
        routes: <String, WidgetBuilder>{
          '/feed': (BuildContext context) => FeedWidget(0),
          '/meditate': (BuildContext context) => BlocProvider<MeditationBloc>(
              creator: (context, _bag) => MeditationBloc(),
              child: MeditationWidget(3)),
          '/learn': (BuildContext context) => LearnWidget(2),
          '/stage': (BuildContext context) => StageWidget(1),
          '/profile': (BuildContext context) => ProfileWidget(selectedIndex: 4),
        });
  }
}
