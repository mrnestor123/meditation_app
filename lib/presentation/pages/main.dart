import 'package:flutter/material.dart';
import 'package:meditation_app/presentation/mobx/actions/lesson_state.dart';
import 'package:meditation_app/presentation/mobx/actions/meditation_state.dart';
import 'package:meditation_app/presentation/mobx/actions/user_state.dart';
import 'package:meditation_app/presentation/mobx/login_register/login_state.dart';
import 'package:meditation_app/presentation/mobx/login_register/register_state.dart';
import 'package:meditation_app/presentation/pages/config/configuration.dart';
import 'package:meditation_app/presentation/pages/learn/brain_widget.dart';
import 'package:meditation_app/presentation/pages/meditation/main_screen.dart';

import 'package:meditation_app/login_injection_container.dart' as di;

import 'package:flutter/services.dart';
import 'package:meditation_app/presentation/pages/meditation/premeditation.dart';
import 'package:meditation_app/presentation/pages/menu/animatedcontainer.dart';
import 'package:meditation_app/presentation/pages/menu/layout.dart';
import 'package:meditation_app/presentation/pages/profile/profile_widget.dart';
import 'package:meditation_app/presentation/pages/stage/path.dart';
import 'package:meditation_app/presentation/pages/welcome/login_widget.dart';
import 'package:meditation_app/presentation/pages/welcome/register_widget.dart';
import 'package:provider/provider.dart';
import 'package:workmanager/workmanager.dart';

import '../../login_injection_container.dart';
import 'welcome/loading_widget.dart';
import 'welcome/welcome_widget.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIOverlays([]);

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  await di.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
// This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    //we pass the userstate class to all the classes
    return MultiProvider(
        providers: [
          Provider<UserState>(create: (context) => sl<UserState>()),
        ],
        child: MaterialApp(
            debugShowCheckedModeBanner: false,
            initialRoute: '/loading',
            routes: <String, WidgetBuilder>{
              '/welcome': (BuildContext context) => WelcomeWidget(),
              '/brain': (BuildContext context) => Provider(
                  create: (context) => sl<LessonState>(), child: BrainScreen()),
              '/loading': (BuildContext context) => Loading(),
              '/login': (BuildContext context) => Provider(
                  create: (context) => sl<LoginState>(), child: LoginWidget()),
              '/register': (BuildContext context) => Provider(
                  create: (context) => sl<RegisterState>(),
                  child: RegisterWidget()),
              '/profile': (BuildContext context) => ProfileScreen(),
              '/main': (BuildContext context) => ContainerAnimated(),
              //'/main': (BuildContext context) => MainLayout(),

              '/premeditation': (BuildContext context) => Provider(
                  create: (context) => sl<MeditationState>(),
                  child: SetMeditation()),
              '/path': (context) => PathWidget(),
              '/learn': (BuildContext context) => Provider(
                  create: (context) => sl<LessonState>(), child: BrainScreen()),

              //'/meditating':(BuildContext context) => MeditationinProgress()
              // '/meditate': (BuildContext context) => MeditationWidget(),
              // '/feed': (BuildContext context) => FeedWidget(0),
              // '/meditate': (BuildContext context) => BlocProvider<MeditationBloc>(
              // creator: (context, _bag) => MeditationBloc(),
              // child: MeditationWidget(3)),
              // '/learn': (BuildContext context) => LearnWidget(2),
              // '/stage': (BuildContext context) => StageWidget(1),
              // '/profile': (BuildContext context) => ProfileWidget(selectedIndex: 4),
            }));
  }
}
