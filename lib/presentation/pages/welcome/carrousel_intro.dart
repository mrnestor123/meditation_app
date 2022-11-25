
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:meditation_app/presentation/pages/commonWidget/carousel_balls.dart';
import 'package:meditation_app/presentation/pages/config/configuration.dart';
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

  Image slide1, slide2,slide3, slide4;

  bool loadedImages = false;

  List<Map<String,dynamic>> slides = [
    {
      "title":"Welcome to TenStages", 
      "description":"This application is based on The Mind Illuminated, written by John Yates, a neuroscientist that got interested in meditation. It combines ancient buddhist wisdom with brain science.\n\nIt is recommended to use the book along with the application."
    },
    {
      "title":" Ten Stages of training", 
      "description":"The process of training the mind is divided into ten different stages.\n\nIn each stage you will master certain goals, learn new information about how your mind works or meditation. "
    },
    {
      "title": "Progress is not linear", 
      "description": "The stages form a broad map to help you figure out where you are and how best to continue. Although we present the stages as linear, the practice doesn't actually unfold that way. Expect to be moving between stages.\n\nThe goal is to give you tools for you to work, at the level you are in each moment "
    },
    {
      "title":"Commit to the practice", 
      "description":"In order to progress to the next stages you will have to accomplish certain objectives.This objectives should be used as general guidelines.\n\nDon't make the stages a goal itself, the target is to understand your mind and what really is meditation about.\n "
    }
  ];

  CarouselController controller = new CarouselController();
  TextEditingController _nameController = new TextEditingController();

  @override
  void initState() {
    super.initState();

    slide1 = Image.asset("assets/first_slide.png");
    slides[0]['image']= slide1;
    slide2 = Image.asset("assets/second_slide.png");
    slides[1]['image']= slide2;
    slide3 = Image.asset("assets/fourth_slide.png");
    slides[2]['image']= slide3;
    slide4 = Image.asset("assets/third_slide.png");
    slides[3]['image']= slide4;

  } 

  @override
  void didChangeDependencies(){
    super.didChangeDependencies();
    if(Configuration.width == null){
      Configuration c = new Configuration();
      c.init(context);
    }

    precacheImage(slide1.image, context).then((value) => setState((){ loadedImages = true;}));
    precacheImage(slide2.image, context);
    precacheImage(slide3.image, context);
    precacheImage(slide4.image, context);



    _loginState = Provider.of<LoginState>(context);
    _userState = Provider.of<UserState>(context);

    if(_userState.user == null){
      _userState.setUser(_loginState.loggeduser);
    }
  }


  Widget setUsername(){
    Container(
        height: Configuration.height,
        width: Configuration.width,
        color: Configuration.maincolor,
        padding: EdgeInsets.all(Configuration.medpadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Type your username', style: Configuration.text('medium', Colors.white)),
            SizedBox(height: Configuration.verticalspacing),
            TextField(
              controller: _nameController, 
              style: Configuration.text('small', Colors.white),
            ),
            SizedBox(height: Configuration.verticalspacing * 2),
        ],
      )
    );

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
                            Text(slide['title'],textAlign: TextAlign.left,  style: Configuration.text('medium',Colors.white)),
                            SizedBox(height: Configuration.verticalspacing*2),
                            Text(slide["description"],textAlign: TextAlign.left, 
                            style:Configuration.text('small',Colors.white, font: 'Helvetica')),
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
                    items: slides.length,
                    showNext: true,
                    onNext:(index){
                      if(index < slides.length -1){
                        setState((){
                          controller.jumpToPage(++index);
                        });
                      }else {
                        _userState.user.seenIntroCarousel = true;
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