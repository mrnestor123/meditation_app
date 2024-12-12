
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:meditation_app/domain/entities/content_entity.dart';
import 'package:meditation_app/domain/entities/milestone_entity.dart';
import 'package:meditation_app/presentation/mobx/actions/user_state.dart';
import 'package:meditation_app/presentation/pages/commonWidget/date_tostring.dart';
import 'package:meditation_app/presentation/pages/commonWidget/dialogs.dart';
import 'package:meditation_app/presentation/pages/commonWidget/html_towidget.dart';
import 'package:meditation_app/presentation/pages/commonWidget/profile_widget.dart';
import 'package:meditation_app/presentation/pages/config/configuration.dart';
import 'package:meditation_app/presentation/pages/contentWidgets/content_card.dart';
import 'package:meditation_app/presentation/pages/milestone_screen.dart';
import 'package:meditation_app/presentation/pages/profile_screen.dart';
import 'package:provider/provider.dart';

import '../../../domain/entities/action_entity.dart';
import '../../../domain/entities/database_entity.dart';
import '../../../domain/entities/request_entity.dart';
import '../../../domain/entities/user_entity.dart';
import '../../mobx/actions/requests_state.dart';
import '../commonWidget/beautiful_container.dart';
import '../commonWidget/carousel_balls.dart';
import '../commonWidget/stage_card.dart';
import '../commonWidget/start_button.dart';
import '../commonWidget/user_bottom_dialog.dart';
import 'explore_screen.dart';

class MainScreen extends StatefulWidget {
  MainScreen();

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  UserState _userstate;
  int learnPosition = 0;
  int meditatePosition = 0;

  bool introCarousel = false;

  @override 
  void didChangeDependencies(){
    super.didChangeDependencies();
    _userstate = Provider.of<UserState>(context);
    if(_userstate.user != null && _userstate.data != null){
      _userstate.user.checkStage(stage: _userstate.data.stages.firstWhere((element) => element.stagenumber == _userstate.user.stagenumber));
      _userstate.user.checkMileStone(milestone: _userstate.data.milestones[_userstate.user.milestonenumber-1]);

      WidgetsBinding.instance.addPostFrameCallback((_) {
        // HAY QUE VER QUE PASA CON GUARDAR LOS DATOS !!
        // COMPROBAR DE OTRA MANERA COMO SE INTRODUCEN LOS DATOS 
        if(_userstate.user.settings.seenIntroCarousel == null || _userstate.user.settings.seenIntroCarousel == false){
          //_userstate.user.settings.seenIntroCarousel = true;
        
          checkUpdates();
        }
      });
    }
  }

  Widget wrapperContainer({Widget child}){
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(Configuration.borderRadius/2),
        border: Border.all(
          color: Colors.grey,
          width: 0.5
        ),
      ),
      child: child
    );
  }

  Widget milestoneView(){
    Milestone m = _userstate.data.milestones[_userstate.user.milestonenumber-1];
   
    return Stack(
      children: [      
        OutlinedButton(
          onPressed:() {
            if(!m.blocked)  Navigator.pushNamed(context, '/milestone').then((value) => setState(() => null));
          },
          style: OutlinedButton.styleFrom(
            padding: EdgeInsets.all(Configuration.smpadding),
            side: BorderSide(color: Colors.grey, width: 0.5),
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Configuration.borderRadius/2))
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Milestone ${m.position}', 
                      style: Configuration.text('smallmedium',Colors.black),
                      textAlign: TextAlign.center
                    ),
              
                    SizedBox(height: Configuration.verticalspacing/2),
                    Text(m.title, style: Configuration.text('subtitle',Colors.black)),
                    
                    SizedBox(height: Configuration.verticalspacing/2),
                    stagesChip(m: m)
                  ],
                ),
              ),

              Container(
                child: Container(
                  padding: EdgeInsets.all(4),
                  width: Configuration.width  >500 ? Configuration.width*0.2 : Configuration.width*0.3,
                  height: Configuration.width  >500 ? Configuration.width*0.2 : Configuration.width*0.3,
                  child: milestonePercentage(m:m)
                ),
              )
            ],
          )
        ),

        m.blocked ? 
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Configuration.borderRadius / 3),
              color: Colors.grey.withOpacity(0.8)
            ),
            child: Center(
              child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(Icons.lock, size: Configuration.smicon, color: Colors.white),
                SizedBox(height: 10),
                Text('Locked', 
                  style: Configuration.text('small', Colors.white)
                )
              ],
            )),
          )
        ) : Container(),
        
      ],
    );
  }

  Widget quickStart(){

    Widget quickShow({String text, IconData icon, Content content, String topText}) {
      return content == null ?
        Container():
      
       OutlinedButton(
        onPressed: (){ 
          selectContent(
            content: content, 
            then: (d)=> setState(()=> null),
            stage: _userstate.data.stages.firstWhere((element) => element.stagenumber == content.stagenumber)
          ); 
        },
        style: OutlinedButton.styleFrom(
          padding: EdgeInsets.zero,
          minimumSize: Size(0,0),
          side: BorderSide(color: Colors.grey, width: 0.5),
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Configuration.borderRadius/2))
        ),
        child: Container(
          padding: EdgeInsets.all(Configuration.smpadding),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Icon(icon, color: Colors.black, size: Configuration.smicon),
                        SizedBox(width: Configuration.verticalspacing),
                        Text(topText, style: Configuration.text('tiny',Colors.grey), textAlign: TextAlign.center),
                      
                        SizedBox(width: Configuration.verticalspacing),

                        // stage chip
                        Container(
                          padding: EdgeInsets.symmetric(vertical:2, horizontal: 8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(Configuration.borderRadius/2),
                            border: Border.all(
                              color: Colors.grey,
                              width: 0.5
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.landscape, size: Configuration.tinicon, color: Colors.grey),
                              SizedBox(width: Configuration.verticalspacing/2),
                              Text(content.stagenumber.toString(), style: Configuration.text('tiny',Colors.black)),
                            ],
                          )
                        )
                      ],
                    ),
                    SizedBox(height: Configuration.verticalspacing/2),
                    Flexible(child: Text(content.title, style: Configuration.text('small',Colors.black), maxLines: 2, overflow: TextOverflow.ellipsis))
                   
                  ],
                ),
              ),

              // chevron 
              Icon(Icons.chevron_right, color: Colors.black, size: Configuration.smicon),
            ],
          ),
        )
      );
    }
    

    Content getQuickContent({int stagenumber, int position, bool meditation}){
      List<Content> path = meditation ? 
        _userstate.data.stages[stagenumber].meditpath : 
        _userstate.data.stages[stagenumber].path;

      
      if(path.length > position){
        Content c = path[position];
       // c.stagenumber = stagenumber;
        return c;
      }else {
        if(stagenumber == 10 || _userstate.data.stages[stagenumber+1].blocked){
          return null;
        } else {
          return getQuickContent(
            stagenumber: stagenumber+1, 
            position: _userstate.user.userProgression.lessonposition[stagenumber+1], 
            meditation: meditation
          );
        }
      }
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // learn and meditate 
        Container(
          margin: EdgeInsets.only(
            bottom: Configuration.verticalspacing
          ),
          child: quickShow(
            topText: 'Learn',
            icon: Icons.book,
            content: getQuickContent(
              stagenumber: _userstate.user.stagenumber, 
              position: _userstate.user.userProgression.lessonposition[_userstate.user.stagenumber], 
              meditation: false,
            )
          ),
        ),

        quickShow(
          topText: 'Practice',
          icon: Icons.self_improvement,
          content: getQuickContent(
            stagenumber: _userstate.user.stagenumber, 
            position: _userstate.user.userProgression.meditposition[_userstate.user.stagenumber], 
            meditation: true,
          )
        )
      ],
    );
  }


  Widget checkUpdates(){

    /*if(_userstate.data.lastUpdate){

    }*/

    showDialog(
      context: context, 
      builder: (context) { 
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(Configuration.borderRadius/2),
          ),
          child: Column(
            children: [
              Text('New content available', style: Configuration.text('smallmedium',Colors.black)),
            ],
          ),
        );
      }
    );

  }


  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: _userstate == null ? 0 : 1,
      duration: Duration(milliseconds: 1000),
      child: ListView(
        physics: ClampingScrollPhysics(),
        children: [
          SizedBox(height: Configuration.verticalspacing),
          Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children:[
            Container(
              padding: EdgeInsets.symmetric(horizontal: Configuration.smpadding),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  /*Container(
                    padding: EdgeInsets.all(Configuration.smpadding),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(Configuration.borderRadius/2),
                      border: Border.all(
                        color: Colors.grey,
                        width: 0.5
                      ),
                    ),
                    child: Container(
                      child: Text('Start meditating',
                        style: Configuration.text('medium',Colors.black),
                      )
                    ),
                  )*/

                  SizedBox(height: Configuration.verticalspacing),
                  /*
                  Container(
                    padding: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      color: Colors.white
                    ),
                    child: Container(
                      padding: EdgeInsets.all(
                        Configuration.smpadding
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey
                        )
                      ),
                      child: Column(
                        children: [
                          Text(
                            '''Beneath all our mental chatter, beneath all our worries and fears, there is silence. \n\n A silence that whispers when we quiet down, a silence that brings out a forgotten and lost feeling.\n\n An inner fire that shouts''',
                            style: Configuration.text('smallmedium', Colors.black, style: 'italic', font: 'HandWritten'),
                            textAlign: TextAlign.center
                          ),

                          Text('LIVE, LIVE AND LIVE',
                            style: Configuration.text('medium', Colors.black),
                          )
                        ],
                      ),
                    ),
                  ),
                  
                  SizedBox(height: Configuration.verticalspacing * 2),
                  
                  Container(
                    padding: EdgeInsets.all(
                      Configuration.smpadding
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: Colors.grey
                      ),
                    ),
                  ),*/
                  
                  /*Text(
                    'First phase',
                    style: Configuration.text('medium', Colors.black),
                  ), */

                    
                   Column(
                    children: [
                      StageCard(
                        stage: _userstate.data.stages.firstWhere((element) => element.stagenumber == _userstate.user.stagenumber),
                        user: _userstate.user
                      ),
                      /*
                      Container(
                        padding: EdgeInsets.all(Configuration.smpadding),
                        child: quickStart())
                      */
                    ],
                  ), 
                  

                  //weekly meditation
                  _userstate.data.weeklyMeditation != null ?
                  Container(
                    margin: EdgeInsets.only(
                      top: Configuration.verticalspacing * 2
                    ),
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.all(Configuration.smpadding),
                        minimumSize: Size(0,0),
                        side: BorderSide(color: Colors.grey, width: 0.5),
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Configuration.borderRadius/2))
                      ),
                      onPressed: (){
                        selectContent(content: _userstate.data.weeklyMeditation);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.self_improvement, color: Colors.black, size: Configuration.medicon),
                              SizedBox(width: Configuration.verticalspacing),
                              Text('Weekly Meditation', style: Configuration.text('small',Colors.black)),
                            ],
                          ),
                          Icon(Icons.chevron_right, color: Colors.black, size: Configuration.smicon),
                        ],
                      ),
                    ),
                  ) : Container(),

                  
                  Container(
                    margin: EdgeInsets.only(
                      top: Configuration.verticalspacing*2
                    ),
                    child: milestoneView()
                  ),

                  /*
                  _userstate.data.sections.length > 0 ?
                  Container(
                    margin: EdgeInsets.only(top: Configuration.verticalspacing*2),
                    child: containerLayout(
                      text: 'Explore other content',
                      icon: Icons.explore,
                      child:  Container(
                        height: Configuration.height*0.15,
                        width: Configuration.width,
                        child: ListView.separated(
                          physics: ClampingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          itemCount: _userstate.data.sections.length,
                          separatorBuilder: (context,index){
                            return SizedBox(width: Configuration.verticalspacing*2);
                          },
                          itemBuilder: (context,index){
                            Section e = _userstate.data.sections[index];

                            return Container(
                              width: Configuration.width * 0.8,
                              margin: EdgeInsets.only(
                                bottom: Configuration.verticalspacing,
                                left: index == 0 ? Configuration.verticalspacing : 0,
                                right: index == _userstate.data.sections.length - 1 
                                  ? Configuration.verticalspacing 
                                  : 0,
                              ),
                              child: BeautifulContainer(
                                minHeight: Configuration.height*0.15 - Configuration.verticalspacing*2,
                                createdBy: e.createdBy,
                                onPressed: (){
                                  Navigator.push(
                                    context, 
                                    MaterialPageRoute(builder: (context){
                                      return ViewSection(section:e);
                                    })
                                  );
                                },
                                title: e.title,
                                image: e.image,
                                color: e.gradientStart != null ? e.gradientStart : Configuration.maincolor,
                              ),
                            );
                          },
                        ),
                      )
                    ),
                  ) : Container(),

                  */
                      
                  /*
                  Container(
                    margin: EdgeInsets.only(
                      top: Configuration.verticalspacing * 2
                    ),
                    decoration: BoxDecoration(
                      
                    ),
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.all(Configuration.smpadding),
                        minimumSize: Size(0,0),
                        side: BorderSide(color: Colors.grey, width: 0.5),
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Configuration.borderRadius/2))
                      ),
                      onPressed: (){
                        Navigator.push(
                            context,
                          MaterialPageRoute(builder: (context)=> Scaffold(
                            appBar:AppBar(backgroundColor: Colors.white, leading: CloseButton(color:Colors.black), elevation:0),
                            body:WebView(initialUrl:'https://www.amazon.com/-/en/John-Yates-Phd/dp/1781808201/ref=sr_1_1?adgrpid=82460957179&gclid=CjwKCAiAv_KMBhAzEiwAs-rX1Bo6Q8WImFMLs5t4p67OFcglUBMhHJkNp_cCg2N-GjbcYsLJ2UlynxoCYmoQAvD_BwE&hvadid=394592758731&hvdev=c&hvlocphy=20297&hvnetw=g&hvqmt=b&hvrand=2610658949964129015&hvtargid=kwd-488309045472&hydadcr=24491_1812059&keywords=the+mind+illuminated&qid=1637694427&sr=8-1' ,javascriptMode: JavascriptMode.unrestricted),
                          ))
                        );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Image.asset(
                                'assets/book.png',
                                height: Configuration.medicon,
                                width: Configuration.medicon,
                              ),
                  
                              SizedBox(width: Configuration.verticalspacing),
                  
                              Text('Get The Mind Illuminated',
                                style: Configuration.text('small',Colors.black),
                              ),
                            ],
                          ),
                  
                          //chevron
                          Icon(
                            Icons.chevron_right,
                            color: Colors.black,
                            size: Configuration.smicon,
                          ),
                        ],
                      )
                    ),
                  ), */
                  
                  SizedBox(height: Configuration.verticalspacing*2),

                  containerLayout(
                    text: 'Feed',
                    icon: Icons.feed_outlined,
                    button: OutlinedButton(
                      onPressed:() {
                        Navigator.pushNamed(context, '/leaderboard').then((value) => setState(() => null));
                      },
                      child: Icon(Icons.leaderboard,
                        color: Colors.lightBlue,
                      ),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Colors.lightBlue, width: 2),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Configuration.borderRadius))
                      ),
                    ),
                    child: _Timeline()
                  ),
                ],
              ),
            ),
           
            SizedBox(height: Configuration.verticalspacing)          
          ]  
        )    
      ]),
    );
  }


}


class ListDropdownItem extends StatefulWidget {
  String text,description;
  IconData icon;

  ListDropdownItem({Key key, this.text, this.description, this.icon}) : super(key: key);

  @override
  State<ListDropdownItem> createState() => _ListDropdownItemState();
}

class _ListDropdownItemState extends State<ListDropdownItem> {

  bool showing = false;

  @override
  Widget build(BuildContext context) {

    return TextButton(
      onPressed: ()=> setState(()=>{showing = !showing}),
      style: TextButton.styleFrom(
        padding: EdgeInsets.zero,
        minimumSize: Size(0,0),
        alignment: Alignment.centerLeft
      ), 
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(widget.icon, color: Colors.black, size: Configuration.smicon),
                  SizedBox(width: Configuration.verticalspacing),
                  Text(widget.text, 
                    style: Configuration.text('small',Colors.black),
                  ),
                ],
              ),
    
              Icon(!showing ? Icons.arrow_downward : Icons.arrow_upward_rounded, color: Colors.black, size: Configuration.smicon),
            ]
          ),
    
          SizedBox(width: Configuration.verticalspacing),
          showing ? htmlToWidget(widget.description) : Container()
    
          
        ]
      ),
    );
  }
}

class TeachersList extends StatefulWidget {
  TeachersList({
    Key key,
    @required UserState userstate,
  }) : _userstate = userstate, super(key: key);

  final UserState _userstate;

  @override
  State<TeachersList> createState() => _TeachersListState();
}

class _TeachersListState extends State<TeachersList> {
  ScrollController _scrollController = new ScrollController();


  void moveTeachers(){
    if(_scrollController.hasClients){
      _scrollController.animateTo(_scrollController.offset != 0 ? 0 : _scrollController.position.maxScrollExtent, 
        duration: Duration(seconds: 10), 
        curve: Curves.linear
      ).then((value) => moveTeachers());
    }
  }

  @override
  void initState() {
    super.initState();


     WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
       //moveTeachers();
     });
    /*
    Future.delayed(Duration(seconds: 1),() {
      _scrollController.animateTo(0, duration: Duration(seconds: 10), curve: Curves.linear).then((value) => 
      
      _scrollController.animateTo(_scrollController.initialScrollOffset, duration: Duration(seconds: 10), curve: Curves.linear)
      );
    });*/
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.textScaleFactorOf(context) > 1 ? Configuration.height * 0.2 : Configuration.height*0.16,
      width: Configuration.width,
      child: ListView.builder(
        controller: _scrollController,
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemCount: widget._userstate.data.teachers.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () => {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfileScreen(
                    user: widget._userstate.data.teachers[index],
                  )
                ),
              )
            },
            child: Container(
              height: Configuration.height*0.2,
              margin: EdgeInsets.all(Configuration.verticalspacing),
              child: Column(
                children: [
                  ProfileCircle(
                    userImage: widget._userstate.data.teachers[index].image,
                    width: Configuration.height*0.1,
                  ),
                  SizedBox(height: Configuration.verticalspacing/2),
                  Flexible(child: Text(
                    widget._userstate.data.teachers[index].nombre, 
                    style: Configuration.text('small',Colors.black)))
                ],
              ),
            ),
          );
        }
      ),
    );
  }
}

class WelcomeMessage extends StatefulWidget {
  const WelcomeMessage({Key key}) : super(key: key);

  @override
  State<WelcomeMessage> createState() => _WelcomeMessageState();
}



class UserActions extends StatelessWidget {

  var _userstate;
  List<UserAction> sortedlist = new List.empty(growable: true);
  String mode = 'today';

  DateTime today =  new DateTime( DateTime.now().year,  DateTime.now().month,  DateTime.now().day, 00);

  DateTime sunday; 

  List<Widget> getActions() { 

    // FILTER THIS WEEK OR TODAY
    sortedlist = _userstate.user.actions ?? _userstate.user.actions.toList();
    sortedlist.sort((a,b) => b.time.compareTo(a.time));

    List<Widget> widgets = new List.empty(growable: true);

    if (sortedlist.length > 0) {
      for (var action in sortedlist) {
        widgets.add(
          GestureDetector(
            onTap: ()=> {
              if(action.user != null){
                showUserProfile(user:action.user)
              }
            },
            child: Container(
              margin:EdgeInsets.only(top: Configuration.verticalspacing,left:Configuration.verticalspacing/2),
              width: Configuration.width,
              color: Colors.transparent,
              child: Row(mainAxisAlignment: MainAxisAlignment.start, 
              children: [
                Stack(
                    children: [
                      ProfileCircle(
                        userImage: action.userimage,
                        width: 40,
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          clipBehavior: Clip.hardEdge,
                          width: Configuration.verticalspacing*2,
                          height: Configuration.verticalspacing*2,
                          decoration: BoxDecoration(shape: BoxShape.circle, color: Colors.lightBlue),
                          child: Icon(action.icono, color: Colors.white, size: Configuration.tinicon)),
                      ) 
                    ],
                  ),
                SizedBox(width: Configuration.verticalspacing),
                Expanded(
                    child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start, 
                    mainAxisAlignment:MainAxisAlignment.spaceEvenly,
                    children: [
                      //QUITAR LOS IFS DEL CÓDIGO !!!!
                      Text((action.username == _userstate.user.nombre ? 'You': action.username) + ' ' + action.message,
                          style: Configuration.text('tiny', Colors.black, font: 'Helvetica'),
                          overflow: TextOverflow.fade,
                          ),
                      SizedBox(height: Configuration.verticalspacing/2),
                      Text((mode == 'Today' ? '' : action.day + ' ') +   action.hour,
                          style: Configuration.text('tiny', Configuration.grey, font: 'Helvetica'))
                  ]),
                )
              ]),
            ),
          ),
        );
        widgets.add(SizedBox(height: 10));
      }
    } else {
      widgets.add(SizedBox(height: Configuration.verticalspacing*2));
      widgets.add(Center(child: Text('No actions done ' + (mode == 'today' ? 'today' : 'this week'), style: Configuration.text('small', Colors.grey, font: 'Helvetica'))));
    }

    // Timer(Duration(milliseconds: 1), () => _scrollController.jumpTo(_scrollController.position.maxScrollExtent));

    return widgets;
  }
     
  @override
  Widget build(BuildContext context) {
    _userstate =  Provider.of<UserState>(context);
    sunday = DateTime(today.year, today.month, today.day - today.weekday % 7);

    return Column(
      children: getActions()
    );
  }
}

class _WelcomeMessageState extends State<WelcomeMessage> with SingleTickerProviderStateMixin {

  AnimationController controller;
  Animation<double> scaleAnimation;

  String whoAmI  = "My name is Ernest and I'm the creator of TenStages. I'd like to explain a bit of how this app works. \n\n"
  "Our content is based in the book The Mind Illuminated and my experience, it is a meditation manual that divided the meditative path into ten different stages and four milestones. \n \n"+
  "";

  var _userstate;


  int _index = 0;
  
  // CAROUSEL AQUÍ
  @override
  void initState() {
    super.initState();
    controller = AnimationController(vsync: this, duration: Duration(milliseconds: 900));
    scaleAnimation = CurvedAnimation(parent: controller, curve: Curves.elasticInOut);
    controller.addListener(() {
      setState(() {});
    });    
    controller.forward();
  }

  bool loadedImages = false;

  @override
  void didChangeDependencies(){
    super.didChangeDependencies();
    if(Configuration.width == null){
      Configuration c = new Configuration();
      c.init(context);
    }

    _userstate = Provider.of<UserState>(context);

    precacheImage(
      _userstate.data.settings.introSlides[0].image,
      context
    ).then((value){
      loadedImages = true;
      setState(()=>{});
    });

    int index = 0;

    _userstate.data.settings.introSlides.forEach((IntroSlide element) {
      if(index++ != 0 && element.image != null){
        precacheImage(element.image,context);
      }
    });
    
  }

  @override
  Widget build(BuildContext context) {
    List<IntroSlide> slides = _userstate.data != null ? _userstate.data.settings.introSlides : [];

    return AnimatedOpacity(
      opacity: !loadedImages ? 0 : 1,
      duration: Duration(seconds: 1),
      child: Wrap(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CarouselSlider.builder(
                itemCount:  slides.length,
                itemBuilder: (context, index,o) {
                  IntroSlide slide = slides[index];
      
                  return Container(
                    width: Configuration.width,
                    padding: EdgeInsets.all(Configuration.tinpadding),
                    child: ListView(
                    physics: ClampingScrollPhysics(),
                    padding: EdgeInsets.all(0),
                    children: [
                      
                      slide.image != null  ?
                      Container(
                        height: Configuration.width *0.8,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(Configuration.borderRadius/2)
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(Configuration.borderRadius/2 ),
                          child: Image(
                            fit: BoxFit.contain,
                            image: slide.image != null 
                            ? slide.image 
                            : null,
                          ),
                        )
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
                              
                              SizedBox(height: Configuration.verticalspacing*2),
                              
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
            ]),

            CarouselBalls(
              index: _index, 
              items: slides.length,
              showNext: false
            ),
            /*
                Center(child: Image.asset('assets/myself.jpeg', height: Configuration.width*0.2)),
                SizedBox(height: Configuration.verticalspacing*2),
    
                Text("Welcome to TenStages",style: Configuration.text('subtitle',Colors.black)),
                SizedBox(height: Configuration.verticalspacing,),
                Text(whoAmI,style: Configuration.text('small',Colors.black,font:'Helvetica')),
                SizedBox(height: Configuration.verticalspacing),
                Center(
                  child: Text('There is no one to be but yourself\n',
                    textAlign: TextAlign.center,
                    style: Configuration.text('smallmedium',Colors.black),
                  ),
                ),
                SizedBox(height: Configuration.verticalspacing),
                
                */
            
            BaseButton(
                color: Configuration.maincolor,
                filled: true,
                textcolor: Colors.white,
                text: 'Start',
                onPressed:() {
                  _userstate.user.settings.askedProgressionQuestions = true;
                  //_userstate.user.settings.progression = 'unlockall';        
                  _userstate.updateUser();                           
                  Navigator.pop(context);
                }, 
              ),
    
          
            SizedBox(height: Configuration.verticalspacing*2),
        ],
      ),
    );
  }
}


Widget containerLayout({String text, IconData icon, Widget button, Widget child}){
  return Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(Configuration.borderRadius/2),
      border: Border.all(
        color: Colors.grey,
        width: 0.5
      ),
    ),
    child: Column(
      children: [

        text != null || button != null 
        ? Container(
          padding: EdgeInsets.only(
            right: Configuration.smpadding,
            top:  Configuration.smpadding,
            left: Configuration.smpadding
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              text == null 
              ? Container() 
              : Expanded(
                child: Row(
                  children: [
                    Icon(icon, color: Colors.black, size: Configuration.smicon),
                    SizedBox(width: Configuration.verticalspacing),
                    Flexible(
                      child: Text(text, 
                      textScaleFactor: 1,
                        style: Configuration.text('subtitle',Colors.black),
                      ),
                    ),
                  ],
                ),
              ),

              button != null? button : Container()

            ],
          ),
        )
        : Container(),

        SizedBox(height: Configuration.verticalspacing),

        child != null ? child : Container()
      ],
    ),
  );

}

// LAS VERSIONES ??
      


class _Timeline extends StatefulWidget {
  bool isTablet;

  _Timeline({this.isTablet = false});

  @override
  __TimelineState createState() => __TimelineState();
}

class __TimelineState extends State<_Timeline> {
  UserState _userstate;
  String mode = 'Today'; 
  List<User> users = new List.empty(growable: true);
  var states = ['Today','This week'];
  ScrollController _scrollController = new ScrollController();
  RequestState  _requestState;
  String text = '';
  final _formKey = GlobalKey<FormState>();
  bool justPressed = false;
  
  @override
  void initState() { super.initState(); }

  void avatarChange(){
    final TextEditingController _nameController = new TextEditingController();

    Widget sendMessage(){
      return Container(
        margin: EdgeInsets.only(
          bottom: Configuration.verticalspacing * 2
        ),
        child: TextField( 
          textCapitalization: TextCapitalization.sentences,
          maxLines:3,
          maxLength: 50,
          decoration: InputDecoration(
            hintText: 'Maximum 50 characters',
            hintStyle: Configuration.text('small', Colors.grey, font: 'Helvetica'),
            fillColor: Colors.white,
            filled:true,
            border: OutlineInputBorder()
          ),
          onChanged: (value) => {
            text = value
          },
        ),
      );
    }

    Widget changeUserName(){
      return Form(
        key: _formKey,
        child: Container(
          margin: EdgeInsets.only(
            bottom: Configuration.verticalspacing
          ),
          child: TextFormField(
            autofocus: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a valid username';
              }else if(value.length < 3){
                return 'Please enter a username longer than three characters';
              }else if(value.length > 15){
                return 'Please enter a username shorter than fifteen characters';
              } else if(value.contains(' ')){
                return 'Please enter a username without white spaces';
              }
              return null;
            },
      
            decoration: InputDecoration(
              errorStyle: Configuration.text('small', Colors.redAccent, font: 'Helvetica'),
              errorBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.redAccent),
              ),
              hintText: 'superBuddha',
              hintStyle: Configuration.text('small', Colors.grey, font: 'Helvetica'),
              fillColor: Colors.white,
              filled:true,
              border: OutlineInputBorder()
            ),
            controller: _nameController, 
            style: Configuration.text('small', Colors.black, font: 'Helvetica')
          ),
        ),
      );
    }

    return showAlertDialog(
      title:  _userstate.user.nombre == null ?  "Write your username" : "Share a message",
      text: _userstate.user.nombre == null ? 
      "This will be your username in the feed, you won't be able to change it later" :
      "Share how you are feeling, how your practice is going or anything else you'd like to share with everyone",
      context: context,
      customWidget:  _userstate.user.nombre == null || _userstate.user.nombre.isEmpty ? 
        changeUserName() :
        sendMessage(),
      noText: 'Cancel',
      yesText: _userstate.user.nombre == null ? 'Set':'Share',
      noPop: true,
      onYes: ()async {
        if(_userstate.user.nombre == null || _userstate.user.nombre.isEmpty) {
          if(_formKey.currentState.validate()){
            bool success = await _userstate.changeName(_nameController.text);
            /*
            if(success){
              _userstate.user.nombre = _nameController.text;
            }*/
          }

        } else {
          message = new Request(
            coduser: _userstate.user.coduser,
            content: text,
            type: 'feed',
            date: DateTime.now(),
            username: _userstate.user.nombre,
            userimage: _userstate.user.image
          );

          messages.add(message);

          _requestState.uploadToFeed(r: message);

        }
      }
    );
  }


  void sendToFeed(){
    final TextEditingController _nameController = new TextEditingController();

    Widget sendMessage(){
      return TextField( 
        textCapitalization: TextCapitalization.sentences,
        maxLines:3,
        maxLength: 50,
        decoration: InputDecoration(
          hintText: 'Maximum 50 characters',
          hintStyle: Configuration.text('small', Colors.grey, font: 'Helvetica'),
          fillColor: Colors.white,
          filled:true,
          border: OutlineInputBorder()
        ),
        onChanged: (value) => {
          text = value
        },
      );
    }

    // EL USERNAME 
    Widget changeUserName(){
      return Form(
        key: _formKey,
        child: Container(
          margin: EdgeInsets.only(
            bottom: Configuration.verticalspacing
          ),
          child: TextFormField(
            autofocus: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a valid username';
              }else if(value.length < 3){
                return 'Please enter a username longer than three characters';
              }else if(value.length > 15){
                return 'Please enter a username shorter than fifteen characters';
              } else if(value.contains(' ')){
                return 'Please enter a username without white spaces';
              }
              return null;
            },
      
            decoration: InputDecoration(
              errorStyle: Configuration.text('small', Colors.redAccent, font: 'Helvetica'),
              errorBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.redAccent),
              ),
              hintText: 'superBuddha',
              hintStyle: Configuration.text('small', Colors.grey, font: 'Helvetica'),
              fillColor: Colors.white,
              filled:true,
              border: OutlineInputBorder()
            ),
            controller: _nameController, 
            style: Configuration.text('small', Colors.black, font: 'Helvetica')
          ),
        ),
      );
    }


    // cambiar esto a un modal bottom sheet
    showModalBottomSheet(
      context: context, 
      isScrollControlled: true,
      barrierColor: Colors.black.withOpacity(0.5),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(Configuration.borderRadius/2)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom + 10),
          child: Container(
            padding: EdgeInsets.all(Configuration.smpadding),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('You can only send one message a day, so make it count!', 
                  style: Configuration.text('small', Colors.grey, font: 'Helvetica'),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: Configuration.verticalspacing),
                sendMessage(),
                SizedBox(height: Configuration.verticalspacing),
                BaseButton(
                  text: 'Send Message',
                  color: Colors.lightBlue,
                  onPressed: (){
                    if(!justPressed){

                      justPressed = true;
                      message = new Request(
                        coduser: _userstate.user.coduser,
                        content: text,
                        type: 'feed',
                        date: DateTime.now(),
                        username: _userstate.user.nombre,
                        userimage: _userstate.user.image
                      );
          
                    
                      _requestState.uploadToFeed(r: message);
          
                      messages.add(message); 
                      messages.sort((a,b) => b.date.compareTo(a.date));
                      _userstate.user.settings.lastMessageSent = DateTime.now();
                      _userstate.updateUser();
                      
                      setState(() {});
                      
                      Navigator.pop(context);
                    }
                  },
                ),
                SizedBox(height: Configuration.verticalspacing)
              ],
            )),
        );
      });
      
  }


  Widget feed(){
    return Container(
      child: Stack(
        children: [
          RefreshIndicator(
            onRefresh: ()=> _requestState.getFeed().then((value) => setState(()=>{})),
            child: ListView.separated(
              physics: ClampingScrollPhysics(),
              padding: EdgeInsets.all(Configuration.smpadding),
              itemCount: messages.length,
              separatorBuilder: (context, index) => SizedBox(height: Configuration.verticalspacing),
              itemBuilder: (context,index){                
                Request r = messages[index];

                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(Configuration.borderRadius/2),
                    color: Configuration.lightgrey,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 0.5,
                        blurRadius: 2,
                        offset: Offset(0, 1) // changes position of shadow
                      ),
                    ]
                  ),
                  padding: EdgeInsets.symmetric(vertical: Configuration.verticalspacing),
                  child: ListTile(
                    onTap: () => { showUserProfile(usercod: r.coduser) },
                    leading: ProfileCircle(
                      width: Configuration.width*0.1,
                      userImage: r.userimage
                    ),
                    title: Text(r.username != null ? r.username : 'Guest', style: Configuration.text('small',Colors.black)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(r.content, style: Configuration.text('small',Colors.black, font: 'Helvetica')),
                        SizedBox(height: Configuration.verticalspacing/2),
                        Text(dayAndMonth(r.date) + ' ' + getHour(r.date)  , style: Configuration.text('tiny',Colors.grey, font: 'Helvetica'))
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        
           
          _userstate.user != null && (_userstate.user.isTeacher() ||  _userstate.user.isAdmin())  ?
          Positioned(
            right: Configuration.width > 500 ? Configuration.verticalspacing : -20 ,
            bottom: 10,
            child: RawMaterialButton(
              elevation: 3.0,
              fillColor: Colors.lightBlue,
              child: Row(
                children: [
                  Icon(Icons.add, color: Colors.white, size: Configuration.smicon),
                ],
              ),
              padding: EdgeInsets.all(Configuration.tinpadding),
              shape: CircleBorder(),
              onPressed: () {
                sendToFeed();
              },
            )
          ): Container()
        ],
      ));
  }


  Request message;
  List<Request> messages = new List.empty(growable: true);

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    _userstate = Provider.of<UserState>(context);
    _requestState = Provider.of<RequestState>(context);

    
    // ESTO SOLO DEBERÍA DE HACERSE UNA VEZ
    
    if(_requestState.feed.length == 0){
      _requestState.getFeed().then((r){ 
        if(r != null){
          messages = _requestState.feed.where((Request element) => element.type == 'feed'  && element.content.isNotEmpty).toList();
        }
      });
    } else {
      messages = _requestState.feed.where((Request element) => element.type == 'feed'  && element.content.isNotEmpty).toList();
    }
   }
  

  @override
  Widget build(BuildContext context) {

    return Column(children: [
      Container(
        width:Configuration.width,
        height: 0.15,
        color: Colors.grey,
      ),


      //UserActions(),
      
      SizedBox(height: Configuration.verticalspacing),
      
      Container(
        padding: EdgeInsets.symmetric(horizontal: 5),
        height:Configuration.height*0.4,
        child: Observer(
          builder: (context) {
            if(_requestState.gettingrequests){
              return Center(child: CircularProgressIndicator());
            }
            
            return feed();
          }
        )
      )
    ]);

  }
}