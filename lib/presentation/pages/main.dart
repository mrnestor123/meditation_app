import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meditation_app/login_injection_container.dart' as di;
import 'package:meditation_app/presentation/mobx/actions/game_state.dart';
import 'package:meditation_app/presentation/mobx/actions/meditation_state.dart';
import 'package:meditation_app/presentation/mobx/actions/profile_state.dart';
import 'package:meditation_app/presentation/mobx/actions/requests_state.dart';
import 'package:meditation_app/presentation/mobx/actions/user_state.dart';
import 'package:meditation_app/presentation/mobx/login_register/login_state.dart';
import 'package:meditation_app/presentation/pages/layout.dart';
import 'package:meditation_app/presentation/pages/leaderboard_screen.dart';
import 'package:meditation_app/presentation/pages/mainpages/meditation_screen.dart';
import 'package:meditation_app/presentation/pages/mainpages/stage_screen.dart';
import 'package:meditation_app/presentation/pages/milestone_screen.dart';
import 'package:meditation_app/presentation/pages/path_screen.dart';
import 'package:meditation_app/presentation/pages/profile_screen.dart';
import 'package:meditation_app/presentation/pages/requests_screen.dart';
import 'package:meditation_app/presentation/pages/settings_widget.dart';
import 'package:meditation_app/presentation/pages/teachers_screen.dart';
import 'package:meditation_app/presentation/pages/welcome/loading_widget.dart';
import 'package:meditation_app/presentation/pages/welcome/login_widget.dart';
import 'package:meditation_app/presentation/pages/welcome/welcome_widget.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';

import '../../login_injection_container.dart';
import 'mainpages/game_screen.dart';
import 'welcome/carrousel_intro.dart';

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
          // METER GAME DENTRO DE GAME NO EN EL GLOBAL
          Provider<GameState>(create: (context) => sl<GameState>()),
          Provider<ProfileState>(create: (context) => sl<ProfileState>()),
          Provider<LoginState>(create: (context) => sl<LoginState>()),
          //METER REQUEST SOLO EN LA DE REQUESTS
          Provider<RequestState>(create: (context) => sl<RequestState>())
        ],
        child: MaterialApp(
          builder: (context, child) {
            // Retrieve the MediaQueryData from the current context.
            final mediaQueryData = MediaQuery.of(context);

            // Calculate the scaled text factor using the clamp function to ensure it stays within a specified range.
            final scale = mediaQueryData.textScaleFactor.clamp(
              1.0, // Minimum scale factor allowed.
              1.2, // Maximum scale factor allowed.
            );
            
            // Create a new MediaQueryData with the updated text scaling factor.
            // This will override the existing text scaling factor in the MediaQuery.
            // This ensures that text within this subtree is scaled according to the calculated scale factor.
            return MediaQuery(
              // Copy the original MediaQueryData and replace the textScaler with the calculated scale.
              data: mediaQueryData.copyWith(
                textScaleFactor: scale,
              ),
              // Pass the original child widget to maintain the widget hierarchy.
              child: child,
            );
          },
          theme: ThemeData(
            pageTransitionsTheme: PageTransitionsTheme(
              builders: {
                TargetPlatform.android: ZoomPageTransitionsBuilder(),
                TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
              },
            )),
            navigatorKey: navigatorKey,
            debugShowCheckedModeBanner: false,
            initialRoute: '/loading',
            routes: <String, WidgetBuilder>{
              '/loading': (BuildContext context) => Loading(),
              '/welcome':(context) => WelcomeWidget(),
              '/login': (BuildContext context) => LoginWidget(),
              '/profile': (BuildContext context) => ProfileScreen(),
              '/stage': (BuildContext context) => StageScreen(),
              '/meditation': (BuildContext context) => MeditationWrapperScreen(),
              '/path': (BuildContext context)  => ImagePath(),
              '/countdown': (BuildContext context) => Countdown(),
              '/milestone': (BuildContext context) => MilestoneScreen(),
              '/main': (BuildContext context) => Layout(),
              '/requests': (BuildContext context) => Requests(),
              '/carousel': (BuildContext context) => CarrouselIntro(),
              '/settings': (BuildContext context) => Settings(),
              '/register': (BuildContext context) => RegisterScreen(),
              '/gamestarted': (BuildContext context) => GameStarted(),
              '/requestview': (BuildContext context) => RequestView(),
              '/sendcomment':(BuildContext  context)=> SendComment(),
              '/leaderboard': (BuildContext context) => LeaderBoard(),
              '/teachers':(BuildContext  context)=> TeachersScreen(),
              '/mymeditations':(context)=> MyMeditations()
          })
        );
  }
}
