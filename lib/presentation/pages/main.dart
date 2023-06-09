import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meditation_app/login_injection_container.dart' as di;
import 'package:meditation_app/presentation/mobx/actions/game_state.dart';
import 'package:meditation_app/presentation/mobx/actions/meditation_state.dart';
import 'package:meditation_app/presentation/mobx/actions/messages_state.dart';
import 'package:meditation_app/presentation/mobx/actions/profile_state.dart';
import 'package:meditation_app/presentation/mobx/actions/requests_state.dart';
import 'package:meditation_app/presentation/mobx/actions/user_state.dart';
import 'package:meditation_app/presentation/mobx/login_register/login_state.dart';
import 'package:meditation_app/presentation/pages/layout.dart';
import 'package:meditation_app/presentation/pages/leaderboard.dart';
import 'package:meditation_app/presentation/pages/meditation_screen.dart';
import 'package:meditation_app/presentation/pages/messages_screen.dart';
import 'package:meditation_app/presentation/pages/path.dart';
import 'package:meditation_app/presentation/pages/objectives_screen.dart';
import 'package:meditation_app/presentation/pages/practical_path.dart';
import 'package:meditation_app/presentation/pages/profile_widget.dart';
import 'package:meditation_app/presentation/pages/requests_screen.dart';
import 'package:meditation_app/presentation/pages/retreat_screen.dart';
import 'package:meditation_app/presentation/pages/settings_widget.dart';
import 'package:meditation_app/presentation/pages/teachers_screen.dart';
import 'package:meditation_app/presentation/pages/welcome/carrousel_intro.dart';
import 'package:meditation_app/presentation/pages/welcome/loading_widget.dart';
import 'package:meditation_app/presentation/pages/welcome/login_widget.dart';
import 'package:meditation_app/presentation/pages/welcome/register_widget.dart';
import 'package:meditation_app/presentation/pages/welcome/set_user_data.dart';
import 'package:meditation_app/presentation/pages/welcome/welcome_widget.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';

import '../../login_injection_container.dart';
import 'game_screen.dart';

//final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

final navigatorKey = new GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();

  //LocalNotifications.setReminder(date: DateTime.now());
  PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
    String appName = packageInfo.appName;
    String packageName = packageInfo.packageName;
    String version = packageInfo.version;
    String buildNumber = packageInfo.buildNumber;
    print({appName,packageName,version,buildNumber});
  });

  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.manual, 
    overlays: [
      SystemUiOverlay.bottom,
      SystemUiOverlay.top
    ]
  );
  
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
// This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);    
    
    //we pass the userstate class to all the classes
    return MultiProvider(
        //UTILIZAR SOLO MULTIPROVIDER PARA ALGUNAS COSAS !!! 
        providers: [
          Provider<UserState>(create: (context) => sl<UserState>()),
          Provider<MeditationState>(create: (context) => sl<MeditationState>()),
          //METER  GAME DENTRO DE GAME NO EN EL GLOBAL
          Provider<GameState>(create: (context) => sl<GameState>()),
          Provider<ProfileState>(create: (context) => sl<ProfileState>()),
          Provider<LoginState>(create: (context) => sl<LoginState>()),
          //METER REQUEST SOLO EN LA DE REQUESTS
          Provider<RequestState>(create: (context) => sl<RequestState>()),
          Provider<MessagesState>(create: (context) => sl<MessagesState>())
        ],
        child: MaterialApp(
          theme: ThemeData(
            pageTransitionsTheme: PageTransitionsTheme(
                builders: {
                  TargetPlatform.android: ZoomPageTransitionsBuilder(),
                  TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
                },
              ),
            ),
            navigatorKey: navigatorKey,
            debugShowCheckedModeBanner: false,
            initialRoute: '/loading',
            routes: <String, WidgetBuilder>{
              '/welcome': (BuildContext context) => WelcomeWidget(),
              '/loading': (BuildContext context) => Loading(),
              '/login': (BuildContext context) => LoginWidget(),
              '/register': (BuildContext context) => RegisterWidget(),
              '/profile': (BuildContext context) => ProfileScreen(),
              '/imagepath': (BuildContext context) => ImagePath(),
              '/countdown': (BuildContext context) => Countdown(),
              '/setdata': (BuildContext context) => SetUserData(),
              '/leaderboard': (BuildContext context) => LeaderBoard(),
              '/main': (BuildContext context) => Layout(),
              '/requests': (BuildContext context) => Requests(),
              '/selectusername': (BuildContext context) => SetUserData(),
              '/settings': (BuildContext context) => Settings(),
              '/gamestarted': (BuildContext context) => GameStarted(),
              '/teachers': (BuildContext context) => TeachersScreen(),
              '/carousel':(BuildContext context)=> CarrouselIntro(),
             // '/addcontent':(BuildContext context)=> AddContent(),
              '/messages':(BuildContext context) => MessagesScreen(),
              '/chat':(BuildContext context) => ChatScreen(),
              '/progress':(BuildContext context) => ProgressScreen(),
              '/requestview': (BuildContext context) => RequestView(),
              '/messageusers': (BuildContext context) => NewMessageScreen(),
              '/sendcomment':(BuildContext  context)=> SendComment(),
              '/retreats':(BuildContext context)=> RetreatScreen(),
              '/techniques': (BuildContext context)=> PracticalPath(),
              //'/discussion':(BuildContext context)=> DiscussionScreen(),
              '/mymeditations':(context)=> MyMeditations()
          })
        );
  }
}
