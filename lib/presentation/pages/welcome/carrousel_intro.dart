
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:meditation_app/presentation/pages/commonWidget/carousel_balls.dart';
import 'package:meditation_app/presentation/pages/config/configuration.dart';
import 'package:meditation_app/presentation/pages/layout.dart';
import 'package:provider/provider.dart';


import '../../mobx/actions/user_state.dart';
import '../../mobx/login_register/login_state.dart';

class CarrouselIntro extends StatefulWidget {
  const CarrouselIntro({ Key key }) : super(key: key);

  @override
  _CarrouselIntroState createState() => _CarrouselIntroState();
}

class _CarrouselIntroState extends State<CarrouselIntro> {
  
  int _index = 0;

  UserState _userState;
  LoginState _loginState;

  Image slide1, slide2,slide3;

  bool loadedImages = false;

  List<Map<String,dynamic>> slides = [
    {
      "title":"Welcome to TenStages", 
      "description":" This application is based on The Mind Illuminated, written by John Yates, a neuroscientist that got interested in meditation. It combines ancient buddhist wisdom with brain science. \n \n  It is recommended to use the book along with the application."
    },
    {
      
      "title":" Ten Stages of training", 
      "description":" The process of training the mind is divided into ten different stages. \n \n In each stage you will learn new information about how your mind works and how to progress in meditation. "
    },
    {
      "title":"Commit to the practice", 
      "description":" In order to progress to the next stages you will have to accomplish certain objectives. \n \n Don't make the objectives and the stages a goal itself, the main goal of this app is to understand your brain and what really is meditation. "
    }
  ];

  CarouselController controller = new CarouselController();

  @override
  void initState() {
    super.initState();

    slide1 = Image.asset("assets/first_slide.png");
    slides[0]['image']= slide1;
    slide2 = Image.asset("assets/second_slide.png");
    slides[1]['image']= slide2;

    slide3 = Image.asset("assets/third_slide.png");

    slides[2]['image']= slide3;

  } 

  void didChangeDependencies(){
    super.didChangeDependencies();
    if(Configuration.width == null){
      Configuration c = new Configuration();
      c.init(context);
    }

    precacheImage(slide1.image, context).then((value) => setState((){ loadedImages = true;}));
    precacheImage(slide2.image, context);
    precacheImage(slide3.image, context);


    _loginState = Provider.of<LoginState>(context);
    _userState = Provider.of<UserState>(context);

    if(_userState.user == null){
      _userState.setUser(_loginState.loggeduser);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Configuration.maincolor,
        height: Configuration.height,
        width: Configuration.width,
        padding: EdgeInsets.all(Configuration.smpadding),
        child: Stack(
          children: [
            !loadedImages ? Container():
            CarouselSlider.builder(
              carouselController: controller,
              itemCount: slides.length,
              itemBuilder: (context, index,o) {
                var slide = slides[index];

                return Container(
                  width: Configuration.width,
                  height: Configuration.height,
                  padding: EdgeInsets.all(Configuration.tinpadding),
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.topCenter,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(height: Configuration.verticalspacing*3),
                            Container(
                              width: Configuration.width/1.5,
                              child: slide['image']
                            ),
                            SizedBox(height: Configuration.verticalspacing*4),
                            Text(slide['title'],textAlign: TextAlign.center,  style: Configuration.text('medium',Colors.white)),
                            SizedBox(height: Configuration.verticalspacing*2),
                            Text(slide["description"],textAlign: TextAlign.center, style:Configuration.text('small',Colors.white)),
                          ],
                        ),
                      ),
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
                    items: slides,
                    showNext: true,
                    onNext:(index){
                      if(index < slides.length -1){
                        setState((){
                          controller.jumpToPage(++index);
                        });
                      }else {
                        _userState.user.seenIntroCarousel = true;
                        print({_userState.user.seenIntroCarousel,'SEENCAROUSEL'});
                        _userState.updateUser();
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => Layout()),
                            (Route<dynamic> route) => false,
                          );
                      }
                    }),
                  SizedBox(height: Configuration.verticalspacing*2)
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}