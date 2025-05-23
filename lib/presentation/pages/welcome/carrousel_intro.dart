
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meditation_app/domain/entities/database_entity.dart';
import 'package:meditation_app/domain/entities/local_notifications.dart';
import 'package:meditation_app/presentation/pages/commonWidget/back_button.dart';
import 'package:meditation_app/presentation/pages/commonWidget/carousel_balls.dart';
import 'package:meditation_app/presentation/pages/commonWidget/html_towidget.dart';
import 'package:meditation_app/presentation/pages/commonWidget/remind_time.dart';
import 'package:meditation_app/presentation/pages/config/configuration.dart';
import 'package:meditation_app/presentation/pages/contentWidgets/meditation_screens.dart';
import 'package:meditation_app/presentation/pages/layout.dart';
import 'package:provider/provider.dart';


import '../../mobx/actions/user_state.dart';
import '../../mobx/login_register/login_state.dart';
import '../commonWidget/start_button.dart';

class CarrouselIntro extends StatefulWidget {
  const CarrouselIntro({ Key key }) : super(key: key);

  @override
  _CarrouselIntroState createState() => _CarrouselIntroState();
}

class _CarrouselIntroState extends State<CarrouselIntro> {
  
  int _index = 0;

  UserState _userState;
  LoginState _loginState;

  Image slide1, slide2,slide3, slide4, slide5;

  bool loadedImages = false;

  List<Map<String,dynamic>> slides = [];

  CarouselController controller = new CarouselController();
  TextEditingController _nameController = new TextEditingController();


  Future gettingImages;

  @override
  void initState() {
    super.initState();
  } 

  @override
  void didChangeDependencies(){
    super.didChangeDependencies();
    
    if(Configuration.width == null){
      Configuration c = new Configuration();
      c.init(context);
    }

    _loginState = Provider.of<LoginState>(context);
    _userState = Provider.of<UserState>(context);

    int index = 0;

    

    precacheImage(AssetImage('assets/logo.png'), context);

    if(_userState.user == null){
      _userState.setUser(_loginState.loggeduser);
    }
  }


  @override
  Widget build(BuildContext context) {
    List<IntroSlide> slides = _userState.data != null 
      ? _userState.data.settings.introSlides : [];
      
      
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: BackButton(color:Colors.white),
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent
        ),
      ),
      body: containerGradient(
        child: Stack(
        children: [
          CarouselSlider.builder(
            carouselController: controller,
            itemCount:  slides.length,
            itemBuilder: (context, index,o) {
              IntroSlide slide = slides[index];
        
              return Container(
                width: Configuration.width,
                height: Configuration.height,
                padding: EdgeInsets.all(Configuration.tinpadding),
                margin: EdgeInsets.only(top: AppBar().preferredSize.height + Configuration.verticalspacing),
                child: ListView(
                  physics: ClampingScrollPhysics(),
                  padding: EdgeInsets.all(0),
                  children: [
                    slide.image != null  ?
                    ClipRRect(
                      borderRadius: BorderRadius.circular(Configuration.borderRadius/2 ),
                      child: Image(
                        height: Configuration.height*0.3,
                        width: Configuration.width,
                        fit: BoxFit.contain,
                        image: slide.image != null 
                        ? slide.image 
                        : null,
                      ),
                    ) : Container(),
              
                    SizedBox(height: Configuration.verticalspacing*2),
                    
                    Material(
                      elevation: 2,
                      borderRadius: BorderRadius.circular(
                        Configuration.borderRadius/3
                      ),
                      child: Container(
                        margin: EdgeInsets.only(
                          top: slide.image != null
                          ? 0 : Configuration.height*0.2
                        ),
                        padding: EdgeInsets.all(
                          Configuration.smpadding
                        ),
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255,236,225,197),
                          borderRadius: BorderRadius.circular(
                            Configuration.borderRadius/3
                          )
                        ),
                        child: Column(
                          children: [
                            Text(slide.title,
                              textAlign: TextAlign.left,  
                              style: Configuration.text('subtitle',Colors.black)
                            ),
                            htmlToWidget(slide.description),
                          ],
                        ),
                      ),
                    ),
                  
                  
                  
                    SizedBox( height: Configuration.verticalspacing*8)
                  ],
                ) 
              );
            },
            options: CarouselOptions(
              scrollPhysics: ClampingScrollPhysics(),
              height: Configuration.height,
              viewportFraction: 1,
              initialPage: 0,
              enableInfiniteScroll: false,
              reverse: false,
              onPageChanged: (index, reason) {
                setState(() {
                  _index = index;
                });
              })
            ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CarouselBalls(
                  index: _index, 
                  inactivecolor: Colors.grey,
                  activecolor: Colors.white,
                  items: slides.length,
                  
                  onNext: (_){
                    if(_index < slides.length -1){
                      setState((){
                        controller.jumpToPage(++_index);
                      });
                    }
                  },
                ),
        
                
                Container(
                  margin: EdgeInsets.only(top: Configuration.verticalspacing*1),
                  padding: EdgeInsets.symmetric(
                    horizontal: Configuration.verticalspacing*2
                  ),
                  child: BaseButton(
                    color: Colors.white,
                    text:  "Continue",
                    onPressed: (){
                      if(_index < slides.length -1){
                        setState((){
                          controller.jumpToPage(++_index);
                        });
                      }else {
                        Navigator.pushNamed(context,'/register');
                      }
                    },
                  ),
                ),
        
                SizedBox(height: Configuration.verticalspacing*5),
              ],
            ),
          )
        ],
        ),
      ),
    );
  }
}