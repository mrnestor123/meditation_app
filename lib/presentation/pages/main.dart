import 'package:flutter/material.dart';
import 'package:meditation_app/domain/usecases/user/loginUser.dart';
import 'package:meditation_app/login_injection_container.dart';
import 'package:meditation_app/presentation/mobx/login_register/login_state.dart';
import 'package:meditation_app/presentation/mobx/login_register/register_state.dart';
import 'package:meditation_app/presentation/pages/meditation/meditationWidget.dart';
import 'package:meditation_app/presentation/pages/menu/mainscreen.dart';
import 'package:meditation_app/presentation/pages/welcome/login_widget.dart';
import 'package:meditation_app/presentation/pages/welcome/register_widget.dart';
import 'package:meditation_app/presentation/pages/welcome/welcome_widget.dart';
import 'package:provider/provider.dart';
import 'package:meditation_app/login_injection_container.dart' as di;

import 'menu/menu_widget.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          // Define el Brightness y Colores por defecto
          primaryColor: Colors.blue,
          accentColor: Colors.purpleAccent,

          // Define la Familia de fuente por defecto
          fontFamily: 'Montserrat',

          // Define el TextTheme por defecto. Usa esto para espicificar el estilo de texto por defecto
          // para cabeceras, títulos, cuerpos de texto, y más.
          textTheme: TextTheme(
            title: TextStyle(
                fontSize: 35.0,
                fontWeight: FontWeight.w800,
                color: Color.fromARGB(255, 230, 29, 210)),
            subtitle: TextStyle(
                fontSize: 20.0,
                fontStyle: FontStyle.italic,
                color: Colors.blueAccent),
            button: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.w800,
                color: Colors.white),

            display2: TextStyle(
              fontSize:20.0,
              fontFamily:'Montserrat',
              color:Colors.white
            ),
            //for error texts
            display1: TextStyle(fontSize: 10.0, color: Colors.red),
            body1: TextStyle(fontSize: 20.0, fontFamily: 'Hind'),
          ),
        ),
        initialRoute: '/main',
        routes: <String, WidgetBuilder>{
         // '/welcome': (BuildContext context) => WelcomeWidget(),
         // '/login': (BuildContext context) => Provider(
       //       create: (context) => sl<LoginState>(), child: LoginWidget()),
        //  '/register': (BuildContext context) => Provider(
         //     create: (context) => sl<RegisterState>(),
          //    child: RegisterWidget()),
          '/main': (BuildContext context) => MainWidget(),
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
