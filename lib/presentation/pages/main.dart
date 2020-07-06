import 'package:flutter/material.dart';
import 'package:meditation_app/presentation/pages/meditation/main_screen.dart';

import 'package:meditation_app/login_injection_container.dart' as di;

import 'package:flutter/services.dart';
import 'package:meditation_app/presentation/pages/meditation/premeditation.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIOverlays([]);

  await di.init();
  runApp(MyApp());  
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: '/main',
        routes: <String, WidgetBuilder>{
         // '/welcome': (BuildContext context) => WelcomeWidget(),
         // '/login': (BuildContext context) => Provider(
        //       create: (context) => sl<LoginState>(), child: LoginWidget()),
        //  '/register': (BuildContext context) => Provider(
         //     create: (context) => sl<RegisterState>(),
          //    child: RegisterWidget()),
          '/main': (BuildContext context) => MainScreen(),
          '/premeditation':(BuildContext context) => SetMeditation()

         // '/meditate': (BuildContext context) => MeditationWidget(),
          // '/feed': (BuildContext context) => FeedWidget(0),
          // '/meditate': (BuildContext context) => BlocProvider<MeditationBloc>(
          // creator: (context, _bag) => MeditationBloc(),
          // child: MeditationWidget(3)),
          // '/learn': (BuildContext context) => LearnWidget(2),
          // '/stage': (BuildContext context) => StageWidget(1),
          // '/profile': (BuildContext context) => ProfileWidget(selectedIndex: 4),
        });
  }
}
