import 'package:flutter/material.dart';
import 'package:meditation_app/presentation/mobx/actions/game_state.dart';
import 'package:meditation_app/presentation/mobx/actions/lesson_state.dart';
import 'package:meditation_app/presentation/mobx/actions/meditation_state.dart';
import 'package:meditation_app/presentation/mobx/actions/user_state.dart';
import 'package:meditation_app/presentation/mobx/login_register/login_state.dart';
import 'package:meditation_app/presentation/mobx/login_register/register_state.dart';
import 'package:meditation_app/presentation/pages/leaderboard.dart';
import 'package:meditation_app/presentation/pages/learn_screen.dart';
import 'package:meditation_app/login_injection_container.dart' as di;
import 'package:flutter/services.dart';
import 'package:meditation_app/presentation/pages/main_screen.dart';
import 'package:meditation_app/presentation/pages/layout.dart';
import 'package:meditation_app/presentation/pages/meditation_screen.dart';
import 'package:meditation_app/presentation/pages/path_screen.dart';
import 'package:meditation_app/presentation/pages/profile_widget.dart';
import 'package:meditation_app/presentation/pages/settings_widget.dart';
import 'package:meditation_app/presentation/pages/stage/path.dart';
import 'package:meditation_app/presentation/pages/welcome/loading_widget.dart';
import 'package:meditation_app/presentation/pages/welcome/login_widget.dart';
import 'package:meditation_app/presentation/pages/welcome/register_widget.dart';
import 'package:meditation_app/presentation/pages/welcome/set_user_data.dart';
import 'package:meditation_app/presentation/pages/welcome/welcome_widget.dart';
import 'package:provider/provider.dart';

import '../../login_injection_container.dart';
import 'game_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIOverlays([]);

//  SystemChrome.setPreferredOrientations(
  //    [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft,DeviceOrientation.landscapeRight]);

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
          Provider<MeditationState>(create: (context) => sl<MeditationState>()),
          Provider<GameState>(create: (context) => sl<GameState>())
        ],
        child: MaterialApp(
            debugShowCheckedModeBanner: false,
            initialRoute: '/loading',
            routes: <String, WidgetBuilder> {
              '/welcome': (BuildContext context) => WelcomeWidget(),
              //      '/brain': (BuildContext context) => Provider(
              //        create: (context) => sl<LessonState>(), child: BrainScreen()),
              '/loading': (BuildContext context) => Loading(),
              '/login': (BuildContext context) => Provider(
                  create: (context) => sl<LoginState>(), child: LoginWidget()),
              '/register': (BuildContext context) => Provider(
                  create: (context) => sl<RegisterState>(),
                  child: RegisterWidget()),
              '/profile': (BuildContext context) => ProfileScreen(),
              '/imagepath': (BuildContext context) => ImagePath(),
               '/tabletimagepath': (BuildContext context) => TabletImagePath(),
              '/main': (BuildContext context) => Layout(),
              '/selectusername': (BuildContext context) => SetUserData(),
              '/settings': (BuildContext context) => Settings(),
              '/gamestarted': (BuildContext context) => GameStarted()
            }));
  }
}
