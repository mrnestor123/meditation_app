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
  Duration _duration = Duration(seconds: 5);
  bool started = false;
  VideoPlayerController _controller;
  bool isTablet = false;
  bool finishedloading = false;


  @override
  void initState() {
    super.initState();
     _controller = VideoPlayerController.asset('assets/tenstages.mp4')..initialize().then((_) {
        _controller.play();
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() { });
      });

      _timer = new Timer.periodic(Duration(seconds: 1), 
        (Timer timer) => setState(() {
             if (_duration.inSeconds == 0) {
                if(finishedloading) {
                  _user.user != null ? Navigator.pushNamed(context, '/main') : Navigator.pushNamed(context, '/welcome');
                }
                timer.cancel();
              } else {
                _duration = _duration - Duration(seconds: 1);
              }
            })
      );
  }

  @override 
  void dispose(){
    super.dispose();
    _timer.cancel();
  }

  void userisLogged(context) async {
    //SACAMOS LA INFORMACIÓN DE LA BASE DE DATOS Y COMPROBAMOS SI EL USUARIO ESTÁ LOGUEADO
    await _user.getData();
    await _user.userisLogged();
    setState(() {
      finishedloading = true;
    });

    if(_duration.inSeconds <= 0){
      _user.user != null ? 
        _user.user.nombre == null || _user.user.nombre == '' ?
        Navigator.pushReplacementNamed(context, '/selectusername'):
        Navigator.pushReplacementNamed(context, '/main') 
      : 
      Navigator.pushReplacementNamed(context, '/welcome');
    }
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
        backgroundColor: Colors.white,
        body: Center(
            child: Stack(
              children: [
                _duration.inSeconds == 0 ?
                Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                    width: 25,
                    margin: EdgeInsets.all(12.0),
                    height: 25,
                    child: CircularProgressIndicator(
                      color: Configuration.maincolor,
                      strokeWidth: 3.0,
                    ),
                  ),
                ) : Container(),
                Align(
                  alignment: Alignment.center,
                  child: AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: VideoPlayer(_controller),
                  ),
                ),
              ],
            )
            ));
  }
}
