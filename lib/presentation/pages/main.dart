import 'package:flutter/material.dart';
import 'package:meditation_app/presentation/mobx/actions/game_state.dart';
import 'package:meditation_app/presentation/mobx/actions/meditation_state.dart';
import 'package:meditation_app/presentation/mobx/actions/requests_state.dart';
import 'package:meditation_app/presentation/mobx/actions/user_state.dart';
import 'package:meditation_app/presentation/mobx/login_register/login_state.dart';
import 'package:meditation_app/presentation/pages/leaderboard.dart';
import 'package:meditation_app/login_injection_container.dart' as di;
import 'package:flutter/services.dart';
import 'package:meditation_app/presentation/pages/layout.dart';
import 'package:meditation_app/presentation/pages/meditation_screen.dart';
import 'package:meditation_app/presentation/pages/profile_widget.dart';
import 'package:meditation_app/presentation/pages/requests_screen.dart';
import 'package:meditation_app/presentation/pages/settings_widget.dart';
import 'package:meditation_app/presentation/pages/stage/path.dart';
import 'package:meditation_app/presentation/pages/teachers_screen.dart';
import 'package:meditation_app/presentation/pages/welcome/loading_widget.dart';
import 'package:meditation_app/presentation/pages/welcome/login_widget.dart';
import 'package:meditation_app/presentation/pages/welcome/register_widget.dart';
import 'package:meditation_app/presentation/pages/welcome/set_user_data.dart';
import 'package:meditation_app/presentation/pages/welcome/welcome_widget.dart';
import 'package:provider/provider.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../login_injection_container.dart';
import 'game_screen.dart';

//final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  /*
  var initializationSettingsAndroid = AndroidInitializationSettings('ic_launcher');

  var initializationSettingsIOS = IOSInitializationSettings(
    requestAlertPermission: true,
    requestBadgePermission: true,
    requestSoundPermission: true,
    onDidReceiveLocalNotification: (int id,String title, String body,String payload) async{}
  );

  var initializationSettings = InitializationSettings(
   android: initializationSettingsAndroid,iOS:initializationSettingsIOS);

  await flutterLocalNotificationsPlugin.initialize(initializationSettings,
    onSelectNotification: (String payload) async{
      if(payload != null){
        debugPrint(payload);
      }
    }
  );
 // FirebaseMessaging messaging = FirebaseMessaging.instance;
  //NotificationSettings settings = await messaging.requestPermission();
*/

  
  PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      String appName = packageInfo.appName;
      String packageName = packageInfo.packageName;
      String version = packageInfo.version;
      String buildNumber = packageInfo.buildNumber;

      print({appName,packageName,version,buildNumber});
  });

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
      overlays: [SystemUiOverlay.bottom]);
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

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
          //METER  GAME DENTRO DE GAME NO EN EL GLOBAL
          Provider<GameState>(create: (context) => sl<GameState>()),
          Provider<LoginState>(create: (context) => sl<LoginState>()),
          //METER REQUEST SOLO EN LA DE REQUESTS
          Provider<RequestState>(create: (context) => sl<RequestState>())
        ],
        child: MaterialApp(
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
              '/addcontent':(BuildContext context)=> AddContent()
            }));
  }
}
