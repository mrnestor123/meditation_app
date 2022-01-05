import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:meditation_app/domain/entities/user_entity.dart';
import 'package:meditation_app/presentation/mobx/actions/user_state.dart';
import 'package:meditation_app/presentation/pages/config/configuration.dart';
import 'package:meditation_app/presentation/pages/welcome/set_user_data.dart';
import 'package:meditation_app/presentation/pages/welcome/welcome_widget.dart';
import 'package:mobx/mobx.dart';
import 'package:provider/provider.dart';
import 'package:upgrader/upgrader.dart';
import 'package:video_player/video_player.dart';

import '../layout.dart';

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
  bool newversion = true;
  bool finishedloading = false;

  String appcastURL ='https://raw.githubusercontent.com/mrnestor123/meditation_app/master/appcast.xml';
  AppcastConfiguration cfg;


  @override
  void initState() {
    super.initState();
    cfg = AppcastConfiguration(url: appcastURL, supportedOS: ['android']);
    _controller = VideoPlayerController.asset('assets/tenstages.mp4')..initialize().then((_) {
    _controller.play();
      // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
      setState(() { });
    });
  }

  @override 
  void didChangeDependencies(){
    super.didChangeDependencies();
    _timer = new Timer.periodic(Duration(seconds: 1), 
        (Timer timer) { 
          if (_duration.inSeconds == 0) {
            if(finishedloading){
              pushPage();
            }else{
              setState(() {});
            }
            _timer.cancel();
          } else {
            _duration = _duration - Duration(seconds: 1);
          }
        }   
      );
  }

  @override 
  void dispose(){
    super.dispose();
    _timer.cancel();
    _controller.dispose();
  }

  void pushPage(){
    _user.user != null ?
          _user.user.nombre == null|| _user.user.nombre.isEmpty ? 
            Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => SetUserData()),
            (Route<dynamic> route) => false,
          ) :
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => Layout()),
            (Route<dynamic> route) => false,
          ) 
        : 
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => WelcomeWidget()),
        (Route<dynamic> route) => false,
      );
  }

  void userisLogged(context) async {
    //SACAMOS LA INFORMACIÓN DE LA BASE DE DATOS Y COMPROBAMOS SI EL USUARIO ESTÁ LOGUEADO
    await _user.getData();
    await _user.userisLogged();
    await _user.getTeachers();
    _user.getUsers();

    finishedloading = true;

    if(_duration.inSeconds <= 0){
       pushPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    _user = Provider.of<UserState>(context);
    Configuration().init(context);

    //comprobamos si el usuario esta loggeado
    // SE PODRIA HACER MEJOR!!
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
                    margin: EdgeInsets.all(20),
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
