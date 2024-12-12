import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meditation_app/presentation/mobx/actions/user_state.dart';
import 'package:meditation_app/presentation/pages/config/configuration.dart';
import 'package:meditation_app/presentation/pages/offline_screen.dart';
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
  UserState _userstate;
  List<double> itemsize = [50, 150];
  double size = 50;
  int count = 0;
  double opacity = 1;
  Duration animationDuration = Duration(milliseconds: 200);
  Duration _duration = Duration(seconds: 6);
  bool started = false;
  VideoPlayerController _controller;
  bool isTablet = false;
  bool newversion = true;
  bool finishedloading = false;
  bool hasPushed = false;
  bool hasUpdate = true;
  PackageInfo packageInfo;
  Future finishedAnimation;
  bool animationFinish = false;

  @override
  void initState() {
    super.initState();
    // precache  path image
    
    _controller = VideoPlayerController.asset('assets/tenstages.mp4')..initialize().then((_) {
    _controller.play();
      setState(() { });
    });
  }

 
  //METER CAROUSEL AQUI ??????
  void pushPage(){
    hasPushed = true;

    if(_userstate.isOffline || _userstate.user != null &&  _userstate.user.offline ){
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => OfflinePage()),
        (Route<dynamic> route) => false,
      );
    } else if(_userstate.user != null) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => Layout()),
        (Route<dynamic> route) => false,
      );
    } else {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => WelcomeWidget()),
          (Route<dynamic> route) => false,
        );
    }
  }
  

  
  @override 
  void didChangeDependencies(){
    super.didChangeDependencies();


    // PARA SACAR UNA ANIMACION DE CARGA 
    finishedAnimation = Future.delayed(Duration(seconds: 6), ()=>{
      setState(() {
        animationFinish=  true;
      })
    });
    
    precacheImage(AssetImage('assets/logo.png'), context);

    _userstate = Provider.of<UserState>(context);

    precacheImage(AssetImage('assets/fondo.png'), context);
    precacheImage(new AssetImage("assets/update_app.jpg"), context);
    

    Configuration().init(context);

    //comprobamos si el usuario esta loggeado
    // SE PODRIA HACER MEJOR!!
    userisLogged(context);
    started = true;
  
  }

  @override 
  void dispose(){
    super.dispose();
    _controller.dispose();
  }

  void userisLogged(context) async {
    await _userstate.connect();
    finishedloading = true;

    if(!animationFinish && !hasPushed){
      finishedAnimation.whenComplete(() => pushPage());
    }else{
      pushPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
           // Status bar color
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.white, 
            statusBarIconBrightness: Brightness.dark, // For Android (dark icons)
            statusBarBrightness: Brightness.light, // For iOS (dark icons)
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          automaticallyImplyLeading: false,
        ),
        body: Center(
            child: Stack(
              children: [
                animationFinish ?
                Align(
                  alignment: Alignment.topLeft,
                  child: Container(
                    width: Configuration.verticalspacing*2.5,
                    margin: EdgeInsets.symmetric(horizontal:20,  vertical: 50),
                    height: Configuration.verticalspacing*2.5,
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
                ):Container(color: Colors.white),
              ],
            )
            ));
  }
}



class UpdatePage extends StatefulWidget {
  const UpdatePage({Key key}) : super(key: key);

  @override
  State<UpdatePage> createState() => _UpdatePageState();
}

class _UpdatePageState extends State<UpdatePage> {

  Image myImage;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    //precacheImage(myImage.image, context);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        padding: EdgeInsets.all(Configuration.smpadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // IMAGE FROM ASSETS
            Image.asset("assets/update_app.jpg", width: Configuration.width*0.8),
            
            SizedBox(height: Configuration.verticalspacing*3),

            Center(
              child: Text('There is a new update in the store. Please update the app to the latest version',
                style: Configuration.text('medium',Colors.black),
                textAlign: TextAlign.center,
              ),
            )
          ],
        ),
      ),
    );
  }
}
