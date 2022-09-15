import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:meditation_app/presentation/mobx/actions/user_state.dart';
import 'package:meditation_app/presentation/pages/config/configuration.dart';
import 'package:meditation_app/presentation/pages/main.dart';
import 'package:meditation_app/presentation/pages/welcome/carrousel_intro.dart';
import 'package:meditation_app/presentation/pages/welcome/set_user_data.dart';
import 'package:meditation_app/presentation/pages/welcome/welcome_widget.dart';
import 'package:mobx/mobx.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
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
  Duration _duration = Duration(seconds: 6);
  bool started = false;
  VideoPlayerController _controller;
  bool isTablet = false;
  bool newversion = true;
  bool finishedloading = false;

  bool hasPushed = false;

  bool hasUpdate = true;



  @override
  void initState() {
    super.initState();

    if(Platform.isAndroid){
  //    androidCheckUpdate();
    }else if(Platform.isIOS){
  //    iosCheckUpdate();
    }


    _controller = VideoPlayerController.asset('assets/tenstages.mp4')..initialize().then((_) {
    
    _controller.play();
      // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
      setState(() { });
    });
  }


  //METER CAROUSEL AQUI ??????
  void pushPage(){
    hasPushed = true;
   
    if(_user.user != null ){
        _user.user.nombre == null || _user.user.nombre.isEmpty ? 
          Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => SetUserData()),
          (Route<dynamic> route) => false,
        ) : 
        _user.user.seenIntroCarousel == null || _user.user.seenIntroCarousel == false ? 
          Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => CarrouselIntro()),
          (Route<dynamic> route) => false,
        ) :
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => Layout()),
          (Route<dynamic> route) => false,
        );
    }else {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => WelcomeWidget()),
        (Route<dynamic> route) => false,
      );
    }
  }

  void showSnack(String text) {
    if (navigatorKey.currentContext != null) {
      ScaffoldMessenger.of(navigatorKey.currentContext).showSnackBar(SnackBar(content: Text(text)));
    }
  }

  void androidCheckUpdate(){
    // ONLY WORKS FOR PRODUCTION !!!
    
    Future<void> checkForUpdate() async {
      InAppUpdate.checkForUpdate().then((info) {
        print({'UPDAtEINFO', info});

        if(info?.updateAvailability == UpdateAvailability.updateAvailable){

          InAppUpdate.performImmediateUpdate().then((_) {
            print('Update performed');
          }).catchError((e) {
            showSnack(e.toString());
          });
        }
      }).catchError((e){
        showSnack(e.toString());
      });
    } 
  }



  @override 
  void didChangeDependencies(){
    super.didChangeDependencies();
    _timer = new Timer.periodic(Duration(seconds: 1), 
        (Timer timer) { 
          if (_duration.inSeconds == 0 ) {
            _timer.cancel();
            if(finishedloading && !hasPushed){
              pushPage();
            }else if(!hasPushed){
              setState(() {});
            }
            _timer.cancel();
          } else {
            _duration = _duration - Duration(seconds: 1);
          }
        }   
      );


    _user = Provider.of<UserState>(context);
    Configuration().init(context);

    //comprobamos si el usuario esta loggeado
    // SE PODRIA HACER MEJOR!!
    userisLogged(context);
    started = true;
  }

  @override 
  void dispose(){
    super.dispose();
    _timer.cancel();
    _controller.dispose();
  }



  void userisLogged(context) async {
    //SACAMOS LA INFORMACIÓN DE LA BASE DE DATOS Y COMPROBAMOS SI EL USUARIO ESTÁ LOGUEADO
    // PARA CONECTAR A LA  BASE DE DATOS
    await _user.connect();
   
    finishedloading = true;

    if(_duration.inSeconds <= 0 && !hasPushed){
      pushPage();
    }
  }

  @override
  Widget build(BuildContext context) {
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
                 _controller.value.isInitialized ?  
                Align(
                  alignment: Alignment.center,
                  child: AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: VideoPlayer(_controller),
                  ),
                ):Container(),
              ],
            )
            ));
  }
}
