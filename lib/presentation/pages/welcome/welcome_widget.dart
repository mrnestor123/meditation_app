import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meditation_app/presentation/mobx/actions/user_state.dart';
import 'package:meditation_app/presentation/pages/commonWidget/start_button.dart';
import 'package:meditation_app/presentation/pages/config/configuration.dart';
import 'package:meditation_app/presentation/pages/contentWidgets/meditation_screens.dart';
import 'package:provider/provider.dart';

import '../../../domain/entities/database_entity.dart';


class WelcomeWidget extends StatefulWidget {
  @override
  State<WelcomeWidget> createState() => _WelcomeWidgetState();
}

class _WelcomeWidgetState extends State<WelcomeWidget> {

  @override
  void didChangeDependencies(){
    super.didChangeDependencies();  

    // WE PRECACHE IMAGES
    final _userState = Provider.of<UserState>(context);

    if(_userState.data != null && _userState.data.settings != null && _userState.data.settings.introSlides != null){
      /// SLIDES FROM APP  SETTINGS
      int index = 0;

      // TAMBIÉN CACHEAR  LA  IMAGEN DE 
      _userState.data.settings.introSlides.forEach((IntroSlide element) {
        if(element.image != null){
          precacheImage(element.image,context);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          systemStatusBarContrastEnforced: false
        ),
        automaticallyImplyLeading: false,
      ),
      body: containerGradient(
        child: Container(
          height: Configuration.height,  
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/fondo.png'),
              fit: BoxFit.cover,
            )
          ),
          padding: EdgeInsets.symmetric(vertical: Configuration.smpadding, horizontal: Configuration.smpadding),
          child: Stack(
            children: <Widget>[
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                  margin: EdgeInsets.only(top: AppBar().preferredSize.height-5),
                  padding: EdgeInsets.symmetric(horizontal:Configuration.smpadding/2),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(Configuration.borderRadius),
                    border: Border.all(
                      color: Colors.grey,
                    )
                  ),
                  child:Image.asset('assets/logo-horizontal.png', 
                    width: Configuration.width*0.66
                  ),
                )
              ),
              
              Align(
                alignment: Alignment.center,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(Configuration.borderRadius),
                  ),
                  padding: EdgeInsets.all(Configuration.medpadding),
                  child: Text('A journey inside yourself',
                    textAlign: TextAlign.center,
                    style: Configuration.text('title', Color.fromRGBO(102,102,102,1))
                  )
                ),
              ),

              Align(
                alignment: Alignment.bottomCenter,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: Configuration.width*0.9,                    
                      child: BaseButton(
                        filled: true,
                        textcolor: Colors.white,
                        text: 'Start my journey',
                        onPressed: (){
                          Navigator.pushNamed(context, '/carousel');
                        },
                      ),
                    ),

                    SizedBox(height: Configuration.verticalspacing*2),
                    
                    Container(
                      width: Configuration.width*0.9,                    
                      child: BaseButton(
                        filled: true,
                        color: Colors.blueGrey,
                        textcolor: Colors.white,
                        bordercolor: Colors.black,
                        border: true,
                        text: 'I already have an account',
                        onPressed: (){
                          Navigator.pushNamed(context, '/login');
                        },
                      ),
                    ),
                    
                    SizedBox(height: Configuration.verticalspacing)
                  ],
                ),
              ),
            
            ],
          ),
        ),
      )
    );
  }
}
