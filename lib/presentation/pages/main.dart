import 'package:bloc_provider/bloc_provider.dart';
import 'package:flutter/material.dart';
import 'package:meditation_app/presentation/blocs/meditationBloc.dart';
import 'package:meditation_app/presentation/pages/feed/feedWidget.dart';
import 'package:meditation_app/presentation/pages/learn/learnWidget.dart';
import 'package:meditation_app/presentation/pages/meditation/meditationWidget.dart';
import 'package:meditation_app/presentation/pages/profile/profileWidget.dart';
import 'package:meditation_app/presentation/pages/stage/stageWidget.dart';
import 'package:meditation_app/presentation/pages/welcome/login_widget.dart';
import 'package:meditation_app/presentation/pages/welcome/signup_widget.dart';
import 'package:meditation_app/presentation/pages/welcome/welcome_widget.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          // Define el Brightness y Colores por defecto
          brightness: Brightness.dark,
          primaryColor: Colors.lightBlue[800],
          accentColor: Colors.cyan[600],

          // Define la Familia de fuente por defecto
          fontFamily: 'Lato',

          // Define el TextTheme por defecto. Usa esto para espicificar el estilo de texto por defecto
          // para cabeceras, títulos, cuerpos de texto, y más.
          textTheme: TextTheme(
            headline: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
            title: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
            body1: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
          ),
        ),
        initialRoute: '/welcome',
        routes: <String, WidgetBuilder>{
          '/welcome': (BuildContext context) => WelcomeWidget(),
          '/login': (BuildContext context) => LoginWidget(),
          '/signup': (BuildContext context) => SignupWidget(),
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
