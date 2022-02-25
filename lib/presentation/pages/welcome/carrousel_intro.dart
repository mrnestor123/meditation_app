
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

  List<Map<String,dynamic>> slides = [
    {
      "image": AssetImage("assets/tenstages-book.png"), 
      "title":"Welcome to TenStages", 
      "description":" This application based on The Mind Illuminated, written by John Yates, a neuroscientist that got interested in meditation\n \n. It combines buddhist wisdom with brain science."
    },
    {
      
      "image": AssetImage("assets/the_stages.jpg"), 
      "title":" Ten Stages of training", 
      "description":" The process of training the mind is divided into ten different stages. \n \n In each stage you have certain skills and objectives to attain. Expect to navigate between several stages at a time"
    },
    {
      "image": AssetImage("assets/meditator.png"), 
      "title":"Commit to the practice", 
      "description":" This is not your regular meditation app. This is for those who want to take meditation seriously and seek the truth that underlies within."
    }
  ];

  CarouselController controller = new CarouselController();

  void didChangeDependencies(){
    super.didChangeDependencies();
    if(Configuration.width == null){
      Configuration c = new Configuration();
      c.init(context);
    }

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
                      
                      Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(height: Configuration.verticalspacing*2),
                            ClipRRect(
                              child:Container(
                                width: Configuration.width/2,
                                child: Image(image:slide['image'])
                              ), 
                              borderRadius: BorderRadius.circular(Configuration.borderRadius/4)
                            ),
                            SizedBox(height: Configuration.verticalspacing*2),
                            Text(slide['title'],textAlign: TextAlign.center,  style: Configuration.text('medium',Colors.white)),
                            SizedBox(height: Configuration.verticalspacing*2),
                            Text(slide["description"],textAlign: TextAlign.center, style:Configuration.text('small',Colors.white)),
                            SizedBox(height: Configuration.verticalspacing*6)
                          ],
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