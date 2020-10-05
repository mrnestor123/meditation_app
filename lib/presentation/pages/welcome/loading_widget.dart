import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:meditation_app/domain/entities/user_entity.dart';
import 'package:meditation_app/presentation/mobx/actions/user_state.dart';
import 'package:meditation_app/presentation/pages/config/configuration.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';

class Loading extends StatefulWidget {
  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  final List<ReactionDisposer> _disposers = [];
  UserState _user;
  List<double> itemsize = [50, 150];
  double size = 50;
  int count = 0;
  double opacity = 1;
  Duration animationDuration = Duration(milliseconds: 200);
  Timer _timer;
  Duration _duration = Duration(seconds: 15);
  bool started = false;

  void startTimer() {
    const oneSec = const Duration(milliseconds: 200);
    _timer = new Timer.periodic(
        oneSec,
        (Timer timer) => setState(() {
          started = true;
              if (_duration.inMilliseconds == 0) {
                if (count < itemsize.length - 1) {
                  size = itemsize[++count];
                }
                else{
                  count = 0;
                  size = itemsize[count];
                }
                timer.cancel();
              } else {
                _duration = _duration - oneSec;
                if (count < itemsize.length - 1) {
                  size = itemsize[++count];
                }else{
                  count = 0;
                  size = itemsize[count];
                }
              }
            }));
  }

  @override
  void initState() {
    super.initState();
  }

  void userisLogged(context) async {
    await new Future.delayed(Duration(seconds: 5));
    await _user.getData();
    await _user.userisLogged();
    _user.loggedin
        ? Navigator.pushNamed(context, '/main')
        : Navigator.pushNamed(context, '/welcome');

    /*reaction(
        (_) => _user.loggedin,
        (loggedin) => loggedin
            ? Navigator.pushNamed(context, '/main')
            : Navigator.pushNamed(context, '/welcome'));*/
  }

  @override
  Widget build(BuildContext context) {
    _user = Provider.of<UserState>(context);
    //comprobamos si el usuario esta loggeado

    if(!started) {userisLogged(context); started = true;}

    //startTimer();

    return Scaffold(
        body: Center(
      child: Container(
        width: 200,
        height: 200,
        child: CircularProgressIndicator())
      
      /*AnimatedContainer(
          duration: animatio nDuration,
          width: size,
          height: size,
          decoration: BoxDecoration(
            image: DecorationImage(image: AssetImage('images/logo.jpg')),
          )),*/
    ));
  }
}
