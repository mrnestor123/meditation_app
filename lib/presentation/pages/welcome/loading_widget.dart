import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:meditation_app/domain/entities/user_entity.dart';
import 'package:meditation_app/presentation/mobx/actions/user_state.dart';
import 'package:meditation_app/presentation/pages/config/configuration.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

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
  VideoPlayerController _controller;

  // UN TIMER PARA QUEEE
  void startTimer() {
    const oneSec = const Duration(milliseconds: 200);
    _timer = new Timer.periodic(
        oneSec,
        (Timer timer) => setState(() {
              started = true;
              if (_duration.inMilliseconds == 0) {
                if (count < itemsize.length - 1) {
                  size = itemsize[++count];
                } else {
                  count = 0;
                  size = itemsize[count];
                }
                timer.cancel();
              } else {
                _duration = _duration - oneSec;
                if (count < itemsize.length - 1) {
                  size = itemsize[++count];
                } else {
                  count = 0;
                  size = itemsize[count];
                }
              }
            }));
  }

  @override
  void initState() {
    super.initState();
     _controller = VideoPlayerController.asset('assets/animacion.webm')
      ..initialize().then((_) {
        _controller.play();
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() { });
      });
  }

  void userisLogged(context) async {
    //SACAMOS LA INFORMACIÓN DE LA BASE DE DATOS Y COMPROBAMOS SI EL USUARIO ESTÁ LOGUEADO
    await _user.getData();
    await _user.userisLogged();
    _user.user != null ? 
        Navigator.pushNamed(context, '/main')
        : Navigator.pushNamed(context, '/welcome');
  }

  @override
  Widget build(BuildContext context) {
    _user = Provider.of<UserState>(context);

    //comprobamos si el usuario esta loggeado
    if (!started) {
      userisLogged(context);
      started = true;
    }

    return Scaffold(
        body: Center(
            child: Container(
                width: 200, height: 200, child: AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller),
                )
              )
            /*AnimatedContainer(
          duration: animatio nDuration,
          width: size,
          height: size,
          decoration: BoxDecoration(
            image: DecorationImage(image: AssetImage('assets/logo.jpg')),
          )),*/
            ));
  }
}
