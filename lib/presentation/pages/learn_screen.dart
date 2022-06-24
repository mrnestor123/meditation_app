import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:meditation_app/domain/entities/content_entity.dart';
import 'package:meditation_app/domain/entities/lesson_entity.dart';
import 'package:meditation_app/domain/entities/meditation_entity.dart';
import 'package:meditation_app/domain/entities/stage_entity.dart';
import 'package:meditation_app/presentation/mobx/actions/user_state.dart';
import 'package:meditation_app/presentation/pages/commonWidget/alert_dialog.dart';
import 'package:meditation_app/presentation/pages/commonWidget/dialog.dart';
import 'package:meditation_app/presentation/pages/commonWidget/html_towidget.dart';
import 'package:meditation_app/presentation/pages/commonWidget/stage_card.dart';
import 'package:meditation_app/presentation/pages/commonWidget/stage_dialog.dart';
import 'package:meditation_app/presentation/pages/commonWidget/start_button.dart';
import 'package:meditation_app/presentation/pages/config/configuration.dart';
import 'package:meditation_app/presentation/pages/meditation_screen.dart';
import 'package:meditation_app/presentation/pages/requests_screen.dart';
import 'package:provider/provider.dart';
import 'commonWidget/progress_dialog.dart';

class LearnScreen extends StatefulWidget {
  LearnScreen();

  @override
  _LearnScreenState createState() => _LearnScreenState();
}

class _LearnScreenState extends State<LearnScreen> {

  UserState _userstate;

  Widget oldLearnScreen(){
    return GridView.builder(
          padding: EdgeInsets.symmetric(vertical:10),
            physics:ClampingScrollPhysics(), 
            shrinkWrap: true,
            itemCount: _userstate.data.stages.length,
            gridDelegate: 
              SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisSpacing: Configuration.verticalspacing,
                mainAxisSpacing: Configuration.verticalspacing,
                crossAxisCount: Configuration.width > 500 ? 3 : 2,
            ),
            itemBuilder: (context, index) {
              
              var flex = _userstate.user.stage.stobjectives.lecciones == 0 ? 0 : ((_userstate.user.userStats.stage.lessons / _userstate.user.stage.stobjectives.lecciones)*6).round();
              var _blocked = _userstate.user.isStageBlocked(_userstate.data.stages[index]);
              return Container(
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(Configuration.borderRadius)),
                child: ElevatedButton(
                  onPressed:() {
                    if(_blocked){
                      showDialog(
                        context: context,
                        builder: (_) => AbstractDialog(
                          content: Container(
                            padding: EdgeInsets.all(Configuration.smpadding),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(Configuration.borderRadius/2)
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.info, size: Configuration.smicon, color: Colors.blue),
                                SizedBox(height: Configuration.verticalspacing),
                                Text("You need to read stage " + 
                              (_userstate.data.stages[index].stagenumber -1).toString() +
                              ' to unlock this stage', style: Configuration.text('small',Colors.black, font: 'Helvetica'))
                              ],
                            )
                          )
                        )              
                      );
                    }else{
                     Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => StageView(
                                stage:_userstate.data.stages[index],
                              )),
                        ).then((value) => setState(() {})
                      );
                    }
                  },
                  child: Stack(
                    children: [
                      Center(
                        child: Text('Stage ' +  _userstate.data.stages[index].stagenumber.toString(),
                          style: Configuration.text("smallmedium", !_blocked ? Colors.white : Colors.grey),
                        ),
                      ),
                      false && !_blocked && _userstate.user.stagenumber == index+1 &&  _userstate.user.isNormalProgression() ? 
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: AspectRatio(
                         aspectRatio: 9/1,
                         child: Container(  
                           decoration: flex < 6 && _userstate.user.stagenumber == (index +1) ? BoxDecoration(
                              borderRadius: BorderRadius.circular(16.0),
                              border: Border.all(color:Colors.grey), 
                              color: Colors.white
                            ) : BoxDecoration(color: Colors.transparent), 
                           child: Row(
                             mainAxisAlignment: MainAxisAlignment.center,
                             children: [
                             flex < 6 && _userstate.user.stagenumber == (index +1) ? 
                               Flexible(
                                 flex: flex,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.green, 
                                      borderRadius: BorderRadius.circular(16.0)
                                    ),
                                  ) ,
                               ) : Padding(
                                 padding: const EdgeInsets.only(bottom:16.0),
                                 child: Icon(Icons.check_circle,color: Colors.green),
                               ),
                              flex < 6 && _userstate.user.stagenumber == (index +1) ?
                               Flexible(
                                 child: Container(),
                                 flex:6-flex
                                ) : Container()
                           ])
                           ),
                         )
                        ) : Container()
                    ]
                  ) ,
                  style: ElevatedButton.styleFrom(
                      elevation:  _blocked ? 0 : 4,
                      shape: RoundedRectangleBorder(borderRadius:BorderRadius.circular(16.0)),
                      primary: _blocked ? Colors.grey.withOpacity(0.4) : Configuration.maincolor,
                      onPrimary: Colors.white,
                      padding: EdgeInsets.all(Configuration.smpadding),
                      minimumSize:Size(double.infinity, double.infinity),
                      animationDuration: Duration(milliseconds: 50)        
                    ),
                ),
              );
    });
  }

  Widget newLearnScreen(){

    Widget listbutton({Phase phase}){
      return Expanded(
        flex: 1,
        child: ElevatedButton(
          onPressed: (){
            Navigator.push(context,  
              MaterialPageRoute(builder: (context) => PhaseView(phase:phase))
            );
          }, 
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(phase.title,style: Configuration.text('smallmedium', Colors.white)),
              SizedBox(height: Configuration.verticalspacing),
              Row(  
                children: [
                  Icon(Icons.checklist, size: Configuration.smicon),
                  SizedBox(width: Configuration.verticalspacing),
                  Flexible(child: Text(phase.description,
                    style: Configuration.text('small',Colors.white,font: 'Helvetica'))
                  )
                ],
              ),
            ],
          ),
          style: ElevatedButton.styleFrom(
            minimumSize:Size(double.infinity, double.infinity),
            primary: Configuration.maincolor
          ),
          
        ),
      );
    }


    List<Widget> listOfPhases(){
      List<Widget> l = new List.empty(growable: true);

      for(Phase p in _userstate.data.phases){
        l.add(listbutton(phase: p));
        l.add(SizedBox(height: Configuration.verticalspacing));
      }
      
      return l;
    }

    return Column(
      children: [
        SizedBox(height: Configuration.verticalspacing),
        Container(
          padding: EdgeInsets.all(Configuration.smpadding),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(Configuration.borderRadius)),
          ),
          child: Column(
            children: [
              Container(
                height: Configuration.height*0.2,
                child: ClipRRect(
                 borderRadius: BorderRadius.circular(Configuration.borderRadius/3),
                 child:Image.asset('assets/tenstages-book.png')
                ),
              ),
              SizedBox(height: Configuration.verticalspacing),
              Text('The Mind illuminated',style: Configuration.text('medium',Colors.black))
            ],
          ),
        ),
        Expanded(
          child: Container(
            padding:EdgeInsets.all(Configuration.smpadding),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Configuration.borderRadius/3),
              color: Colors.white
            ),
            child: Column(
              children: listOfPhases(),
            ),
          ),
        ),
        SizedBox(height: Configuration.verticalspacing)
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    _userstate = Provider.of<UserState>(context);

    return newLearnScreen();
  }
}

class StageView extends StatefulWidget {
  Stage stage;

  StageView({this.stage});

  @override
  _StageViewState createState() => _StageViewState();
}

class _StageViewState extends State<StageView> {
  UserState _userstate;

  var filter = ['all'];

  FutureOr onGoBack(dynamic value) {
    setState(() {
      if(_userstate.user.progress != null) 
        autocloseDialog( _userstate.user);
      });
  }

  @override
  void initState() {
    super.initState();
    print('init');
  }

  Widget getLessons(context) {
    List<Widget> lessons = new List.empty(growable: true);
    var count = 0;

    widget.stage.path.forEach((content) {
      count++;
      var image;
      var _blocked = _userstate.user.isLessonBlocked(content);

      if (filter.contains(content.type) || filter.contains('all')) {
        lessons.add(AspectRatio(
            aspectRatio: Configuration.lessonratio,
            child: Container(
            margin: EdgeInsets.all(Configuration.verticalspacing),
           
            child: ElevatedButton(
              onPressed: () {
                if (!_blocked) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ContentView(
                              lesson: content,
                              content: content,
                              slider: image
                              ))).then(onGoBack);
                }
              },
              style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.all(0),
                  primary: Colors.white,
                  onPrimary: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(Configuration.borderRadius/3)
                  ),
                  minimumSize: Size(double.infinity, double.infinity)),
              child: Stack(
                children: [
                  content.image != null && content.image.isNotEmpty ?
                  Align(
                    alignment: Alignment.centerRight,
                    child: Hero(tag: content.cod ,
                    child: AspectRatio(
                      aspectRatio: 0.9,
                      child: ClipRRect(
                        borderRadius: BorderRadius.horizontal(right: Radius.circular(Configuration.borderRadius/3)),
                        child: CachedNetworkImage(
                          imageUrl: content.image,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            color: Colors.white,
                          ),
                          errorWidget: (context, url, error) => Icon(Icons.error),
                        ),
                        ))
                    ),
                  ) : Container(),
                  Positioned(
                      top: 15,
                      left: 15,
                      child: Row(
                        children: [
                          Container(
                            margin: EdgeInsets.only(right: Configuration.blockSizeHorizontal *2),
                            width: Configuration.safeBlockHorizontal * 5,
                            height: Configuration.safeBlockHorizontal * 5,
                            child: Icon(
                                content.type == 'meditation'
                                    ? Icons.self_improvement
                                    : Icons.book,
                                color: Colors.grey),
                          ),
                          _userstate.user.readLesson(content)
                            ?  
                            Container(
                              width: Configuration.safeBlockHorizontal * 5,
                              height: Configuration.safeBlockHorizontal * 5,
                              child: Icon(Icons.visibility,color: Colors.lightBlue),
                            ): Container(),
                        ],
                      )),
                  Positioned(
                      left: 15,
                      bottom: 15,
                      child: Container(
                        width: Configuration.width * 0.5,
                        child: Text(
                          content.title,
                          style:Configuration.text("small", _blocked ? Colors.grey : Colors.black, 
                                ),
                        ),
                      )),
                  Positioned(
                    left: 0,
                    bottom: 0,
                    right: 0,
                    top: 0,
                    child: AnimatedContainer(
                      padding: EdgeInsets.all(0),
                      key: Key(content.cod),
                      duration: Duration(seconds: 2),
                      child: _blocked?
                        Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(Icons.lock, size: Configuration.smicon),
                              SizedBox(height: 10),
                              Text('Unlocked after reading ' + widget.stage.path[content.position == 0 ? content.position :content.position-1].title , style: Configuration.text('tiny', Colors.white),textAlign: TextAlign.center ),
                            ],
                          )
                        ) :Container(),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(Configuration.borderRadius/3),
                          color: _blocked
                              ? Colors.grey.withOpacity(0.8)
                              : Colors.transparent),
                      curve: Curves.fastOutSlowIn,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
      }
    });

    return Container(
      width: Configuration.width,
      color: Configuration.lightgrey,
      child: lessons.length > 0 ? SingleChildScrollView(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children:  lessons),
      ) : 
      Center(
          child: Text('There are no lessons' ,style: Configuration.text('small', Colors.black),)
        )
      ,
    );
  }

  @override
  Widget build(BuildContext context) {
    _userstate = Provider.of<UserState>(context);

    return Scaffold(
      appBar: AppBar(
        leading: ButtonBack(),
        actions: [
          IconButton(
            iconSize:Configuration.smicon,
            onPressed: ()=> {
               showGeneralDialog(
                  context: context,
                  barrierLabel: 'dismiss',
                  barrierDismissible: true,
                  pageBuilder:(context, anim1, anim2) {
                    return AbstractDialog(
                      content: Container(
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(12.0), color: Colors.white),
                        padding: EdgeInsets.all(12),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            htmlToWidget(widget.stage.longdescription, color: Colors.black, fontsize: 12.0)
                          ],
                        ),
                      ),
                      );
                })
            } , 
            icon: Icon(Icons.info, color:Colors.black)
            )
        ],
        backgroundColor: Configuration.white,
        elevation: 0,
      ),
      body: Container(
        color: Configuration.white,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: Configuration.smpadding),
              child: StageCard(stage: widget.stage),
            ),
            SizedBox(height: Configuration.verticalspacing),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text('Filter',
                  style: Configuration.text('small', Colors.black),
                ),
                OutlinedButton(
                  onPressed: () => setState(
                      () => filter.contains('all') ? '' : filter = ['all']),
                  child: Icon(Icons.more_vert,
                      color: filter.contains('all') ? Colors.white: Colors.black.withOpacity(0.5)),
                  style: ButtonStyle(
                    backgroundColor: filter.contains('all')? MaterialStateProperty.all<Color>(Configuration.maincolor): null,
                  ),
                ),
                OutlinedButton(
                  onPressed: () => setState(() {
                    filter.contains('lesson') ? '' : filter = ['lesson'];
                  }),
                  child: Icon(Icons.book,
                      color: filter.contains('lesson')
                          ? Colors.white
                          : Colors.black.withOpacity(0.5)),
                  style: ButtonStyle(
                    backgroundColor: filter.contains('lesson')
                        ? MaterialStateProperty.all<Color>(
                            Configuration.maincolor)
                        : null,
                  ),
                ),
                OutlinedButton(
                  onPressed: () => setState(() =>
                      filter.contains('meditation')
                          ? ''
                          : filter = ['meditation']),
                  child: Icon(Icons.self_improvement,
                      color: filter.contains('meditation')
                          ? Colors.white
                          : Colors.black.withOpacity(0.5)),
                  style: ButtonStyle(
                    backgroundColor: filter.contains('meditation')
                        ? MaterialStateProperty.all<Color>(
                            Configuration.maincolor)
                        : null,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Container(
              height: 2,
              width: Configuration.width,
              color: Colors.grey,
            ),
            Expanded(child: getLessons(context))
          ],
        ),
      ),
    );
  }
}

class ContentView extends StatefulWidget {
  Content content;
  Meditation meditation;
  Lesson lesson;
  NetworkImage slider;

  ContentView({this.content, this.lesson, this.meditation, this.slider});

  @override
  _ContentViewState createState() => _ContentViewState();
}

// PODRIAMOS HACER CONTENTVIEW PARA TODO ???
class _ContentViewState extends State<ContentView> {
  int _index = -1;
  var _userstate;
  Map<int, NetworkImage> textimages = new Map();
  var reachedend = false;

  Widget portada() {
    return Column(children: [
      widget.content.image.isNotEmpty ?
      Hero(
        tag: widget.content.cod, 
        child: CachedNetworkImage(
          imageUrl: widget.content.image,
          placeholder: (context, url) => Container(
            height: Configuration.height * 0.4,
            width: Configuration.width,
            color: Colors.grey.withOpacity(0.5),
          ),
          width: Configuration.width,
          height: Configuration.height*0.6,
          fit: BoxFit.cover,
        )
      ) : Container(color: Configuration.lightgrey, height: Configuration.height * 0.6),
      Expanded(
        child: Container(
          width: Configuration.width,
          child: Stack(
            children: [
              Align(
                alignment: Alignment.topCenter,
                  child: Padding(
                  padding: EdgeInsets.only(
                      left: Configuration.smpadding,
                      right: Configuration.smpadding,
                      top: Configuration.medpadding),
                  child: Text(widget.content.title,
                      textAlign: TextAlign.center,
                      style: Configuration.text('big', Colors.black)),
                ),
              ),
              Center(
                child: BaseButton(
                  margin:true,
                  text:'Start Lesson',
                  onPressed: () async{
                      setState(() => _index = 0);
                  } 
                )
              )
            ],
          ),
        ),
      )
    ]);
  }

  Widget vistaLeccion() {
    return CarouselSlider.builder(
        itemCount: widget.lesson.text.length,
        itemBuilder: (context, index, page) {
          var slide = widget.lesson.text[index];
          return Container(
            width: Configuration.width,
            color: Configuration.lightgrey,
            child: Center(
              child: ListView(
                physics: ScrollPhysics(),
                shrinkWrap: true,
                padding: EdgeInsets.only(top: 0.0),
                children: [
                  Align(
                    alignment: Alignment.topCenter,
                    child: slide["image"] != '' && slide["image"] != null ? 
                     Image.network(
                      slide["image"],
                      width: Configuration.width,
                    ) : Container(),
                  ),
                  Center(
                    child: Container(
                        width: Configuration.width,
                        padding: EdgeInsets.all(Configuration.smpadding),
                        child: htmlToWidget(
                          slide["text"],
                        )
                      ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                        AnimatedOpacity(
                          opacity: reachedend ? 1.0 : 0.0, 
                          duration: Duration(seconds: 1),
                          child: BaseButton(
                            text:'Finish',
                            onPressed: () async{
                              //NOSE SI HABRA QUE ESPERAR
                              await _userstate.takeLesson(widget.lesson);
                              Navigator.pop(context, true);
                            },
                          ),
                        )
                      ])
                ],
              ),
            ),
          );
        },
        options: CarouselOptions(
          height: Configuration.height,
          viewportFraction: 1,
          initialPage: 0,
          enableInfiniteScroll: false,
          reverse: false,
          onPageChanged: (index, reason) {
            setState(() {
              _index = index;
              if (_index == widget.lesson.text.length - 1) {
                Future.delayed(Duration(seconds: 2),() => setState(()=> reachedend = true));
              }
            });
          }));
  }

  @override
  void initState() {
    super.initState();
    _index = -1;
  }

  @override
  void didChangeDependencies() {
    var configuration = createLocalImageConfiguration(context);

    if (widget.content.type == 'lesson') {
      widget.lesson.text.forEach((slide) {
        print(slide['image']);
        if (slide['image'] != '') {
          new NetworkImage(slide['image'])..resolve(configuration);
        }
      });
    }

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    _userstate = Provider.of<UserState>(context);
  
    return Scaffold(
        extendBody: true,
        appBar: AppBar(
          leading: CloseButton(
              color: Colors.black,
              onPressed: () => showAlertDialog(
                title: 'Are you sure you want to exit ?',
                context: context,
                text: "This lesson will not count as read one"
          )),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        extendBodyBehindAppBar: true,
        body: _index == -1
            ? portada()
            : WillPopScope(
              onWillPop: () {  
                print('CANT Go back');
                return Future.value(true);
              },
              child: Stack(children: [
                  vistaLeccion(),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      margin: EdgeInsets.all(15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: widget.lesson.text.map((url) {
                          int index = widget.lesson.text.indexOf(url);
                          return Container(
                            width: Configuration.safeBlockHorizontal * 3,
                            height: Configuration.safeBlockHorizontal * 3,
                            margin: EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 2.0),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _index == index
                                  ? Color.fromRGBO(0, 0, 0, 0.9)
                                  : Color.fromRGBO(0, 0, 0, 0.4),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ]),
            ));
  }
}


class Portada extends StatelessWidget {
  const Portada() : super();

  @override
  Widget build(BuildContext context) {
    return Container(
      
    );
  }
}

class PhaseView extends StatefulWidget {
  Phase phase;
  
  PhaseView({ Key key, this.phase }) : super(key: key);

  @override
  _PhaseViewState createState() => _PhaseViewState();
}

class _PhaseViewState extends State<PhaseView> with TickerProviderStateMixin {
  UserState _userstate;

  TabController tabController;
  int selectedIndex = 0;
  var image;

  List<Content> mindContent = new List.empty(growable: true);
  List<Content> lessons = new List.empty(growable: true);
  List<Content> meditations = new List.empty(growable: true);

  FutureOr onGoBack(dynamic value) {
    setState(() {
      if(_userstate.user.progress != null) 
        autocloseDialog( _userstate.user);
      });
  }

  @override
  void initState() {
    tabController = TabController(length: 3, vsync: this);

    tabController.addListener(() {
      setState(() {});
    });

    mindContent = widget.phase.content.where((element) => element.type == 'mind').toList();
    lessons = widget.phase.content.where((element) => element.type == 'lesson').toList();
    meditations = widget.phase.content.where((element) => element.type == 'meditation').toList();

    super.initState();
  }
  /*
  List<Widget> lessons(){
    List<Widget> lessons = new List.empty(growable: true);

    widget.phase.content.forEach((content) {
      var image;
      var _blocked = _userstate.user.isLessonBlocked(content);

      if (true) {
        lessons.add(AspectRatio(
            aspectRatio: Configuration.lessonratio,
            child: Container(
            margin: EdgeInsets.all(Configuration.verticalspacing),
           
            child: ElevatedButton(
              onPressed: () {
                if (!_blocked) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ContentView(
                      lesson: content,
                      content: content,
                      slider: image
                      )
                    )
                  ).then(onGoBack);
                }
              },
              style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.all(0),
                  primary: Colors.white,
                  onPrimary: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(Configuration.borderRadius/3)
                  ),
                  minimumSize: Size(double.infinity, double.infinity)),
              child: Stack(
                children: [
                  content.image != null && content.image.isNotEmpty ?
                  Align(
                    alignment: Alignment.centerRight,
                    child: Hero(tag: content.cod ,
                    child: AspectRatio(
                      aspectRatio: 0.9,
                      child: ClipRRect(
                        borderRadius: BorderRadius.horizontal(right: Radius.circular(Configuration.borderRadius/3)),
                        child: CachedNetworkImage(
                          imageUrl: content.image,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            color: Colors.white,
                          ),
                          errorWidget: (context, url, error) => Icon(Icons.error),
                        ),
                        ))
                    ),
                  ) : Container(),
                  Positioned(
                      top: 15,
                      left: 15,
                      child: Row(
                        children: [
                          Container(
                            margin: EdgeInsets.only(right: Configuration.blockSizeHorizontal *2),
                            width: Configuration.safeBlockHorizontal * 5,
                            height: Configuration.safeBlockHorizontal * 5,
                            child: Icon(
                                content.type == 'meditation'
                                    ? Icons.self_improvement
                                    : Icons.book,
                                color: Colors.grey),
                          ),
                          _userstate.user.readLesson(content)
                            ?  
                            Container(
                              width: Configuration.safeBlockHorizontal * 5,
                              height: Configuration.safeBlockHorizontal * 5,
                              child: Icon(Icons.visibility,color: Colors.lightBlue),
                            ): Container(),
                        ],
                      )),
                  Positioned(
                      left: 15,
                      bottom: 15,
                      child: Container(
                        width: Configuration.width * 0.5,
                        child: Text(
                          content.title,
                          style:Configuration.text("small", _blocked ? Colors.grey : Colors.black, 
                                ),
                        ),
                      )),
                  Positioned(
                    left: 0,
                    bottom: 0,
                    right: 0,
                    top: 0,
                    child: AnimatedContainer(
                      padding: EdgeInsets.all(0),
                      key: Key(content.cod),
                      duration: Duration(seconds: 2),
                      child: _blocked?
                        Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(Icons.lock, size: Configuration.smicon),
                              SizedBox(height: 10),
                             // Text('Unlocked after reading ' + widget.stage.path[content.position == 0 ? content.position :content.position-1].title , style: Configuration.text('tiny', Colors.white),textAlign: TextAlign.center ),
                            ],
                          )
                        ) :Container(),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(Configuration.borderRadius/3),
                          color: _blocked
                              ? Colors.grey.withOpacity(0.8)
                              : Colors.transparent),
                      curve: Curves.fastOutSlowIn,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
      }
    });

    return lessons;
  }
  */

  Widget contentView({Content content, blocked = false}){
    return AspectRatio(
            aspectRatio: Configuration.lessonratio,
            child: Container(
            margin: EdgeInsets.all(Configuration.verticalspacing),
            child: ElevatedButton(
              onPressed: () {
                if (!blocked) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ContentView(
                      lesson: content,
                      content: content,
                      slider: image
                      )
                    )
                  ).then(onGoBack);
                }
              },
              style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.all(0),
                  primary: Colors.white,
                  onPrimary: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(Configuration.borderRadius/3)
                  ),
                  minimumSize: Size(double.infinity, double.infinity)),
              child: Stack(
                children: [
                  content.image != null && content.image.isNotEmpty ?
                  Align(
                    alignment: Alignment.centerRight,
                    child: Hero(tag: content.cod ,
                    child: AspectRatio(
                      aspectRatio: 0.9,
                      child: ClipRRect(
                        borderRadius: BorderRadius.horizontal(right: Radius.circular(Configuration.borderRadius/3)),
                        child: CachedNetworkImage(
                          imageUrl: content.image,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            color: Colors.white,
                          ),
                          errorWidget: (context, url, error) => Icon(Icons.error),
                        ),
                        ))
                    ),
                  ) : Container(),
                  
                  Align(
                  alignment: Alignment.centerLeft,
                      child: Container(
                        width: Configuration.width * 0.5,
                        child: Text(
                          content.title,
                          style:Configuration.text("small", blocked ? Colors.grey : Colors.black),
                          textAlign:TextAlign.center
                        ),
                      )),
                  Positioned(
                    left: 0,
                    bottom: 0,
                    right: 0,
                    top: 0,
                    child: AnimatedContainer(
                      padding: EdgeInsets.all(0),
                      key: Key(content.cod),
                      duration: Duration(seconds: 2),
                      child: blocked ?
                        Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(Icons.lock, size: Configuration.smicon),
                              SizedBox(height: 10),
                             // Text('Unlocked after reading ' + widget.stage.path[content.position == 0 ? content.position :content.position-1].title , style: Configuration.text('tiny', Colors.white),textAlign: TextAlign.center ),
                            ],
                          )
                        ) :Container(),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(Configuration.borderRadius/3),
                          color: blocked
                              ? Colors.grey.withOpacity(0.8)
                              : Colors.transparent),
                      curve: Curves.fastOutSlowIn,
                    ),
                  ),
                ],
              ),
            ),
          ),
      );
  }
  // contenedor
  Widget containerIcon({IconData icon, Color color, child}){

    return  Stack(
      children: [
        Container(
          padding: EdgeInsets.all(Configuration.smpadding),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(Configuration.borderRadius/2)
          ),
          child:child
        ),
        Align(
          alignment: Alignment.topLeft,
          child: Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(Configuration.borderRadius/2),
                bottomRight: Radius.circular(Configuration.borderRadius/2)
              )
            ),
            child: Icon(icon,size: Configuration.tinicon),
          ),
        ), 
      ]
    );
  }

  @override
  Widget build(BuildContext context) {
    _userstate = Provider.of<UserState>(context);

    return Scaffold(
      appBar: AppBar(
        elevation:0,
        bottom: PreferredSize(child:  
          Container(
            color: Colors.grey,
            height: 1.0,
          ),preferredSize: Size.fromHeight(2)
        ),
        backgroundColor: Colors.transparent,
        leading: ButtonBack(),
        title: Text(
          widget.phase.title, 
          style: Configuration.text('small',Colors.black)
        ),
      ),
      body:Container(
            padding: EdgeInsets.all(Configuration.smpadding),
            child: ListView(
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              children: [
                containerIcon(
                  icon: Icons.check,
                  color:Configuration.maincolor,
                  child:Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('The objective of this phase is to achieve', style: Configuration.text('small', Colors.white,font:'Helvetica')),
                      SizedBox(height: Configuration.verticalspacing),
                      Text(widget.phase.description,style: Configuration.text('small',Colors.white),textAlign:TextAlign.center)
                    ]
                  ) 
                ),
                
                SizedBox(height: Configuration.verticalspacing),

                containerIcon(
                  color: Configuration.lightgrey,
                  icon: FontAwesomeIcons.brain,
                  child: Column(
                    children: [
                      Text('The map of the mind',style: Configuration.text('small',Colors.black),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: Configuration.verticalspacing),
                      ListView.builder(
                        padding: EdgeInsets.all(0),
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap:true,
                        itemCount: mindContent.length,
                        itemBuilder: (BuildContext context, int index) {  
                          Content c = mindContent[index];
                          return contentView(content: c);
                        },
                      )
                    ],
                  )
                ),

                SizedBox(height: Configuration.verticalspacing),

                containerIcon(
                  icon: Icons.self_improvement,
                  color:Colors.lightBlue,
                  child:Column(
                    children: [
                      Text('You will encounter this problems meditating',style: Configuration.text('small',Colors.black),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: Configuration.verticalspacing),
                      ListView.builder(
                        padding: EdgeInsets.all(0),
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap:true,
                        itemCount: meditations.length,
                        itemBuilder: (BuildContext context, int index) {  
                          Content c = meditations[index];
                          return contentView(content: c);
                        },
                      ),
                    ],
                  )
                ),

                SizedBox(height: Configuration.verticalspacing),

                containerIcon(
                  icon: Icons.book,
                  color:Colors.lightBlue,
                  child:Column(
                    children: [
                      Text('Meditation information you should know',style: Configuration.text('small',Colors.black),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: Configuration.verticalspacing),
                      ListView.builder(
                        padding: EdgeInsets.all(0),
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap:true,
                        itemCount: lessons.length,
                        itemBuilder: (BuildContext context, int index) {  
                          Content c = lessons[index];
                          return contentView(content: c);
                        },
                      ),
                    ],
                  )
                ),

                SizedBox(height: Configuration.verticalspacing),





              ],
            ),
          ),


    );
  }
}









// HAY QUE PENSAR OTRA FORMA MAS EFICIENTE DE HACER LAS COSAS !!!
/*
class TabletStageView extends StatefulWidget {
   Stage stage;

   TabletStageView({this.stage});

  @override
  _TabletStageViewState createState() => _TabletStageViewState();
}

class _TabletStageViewState extends State<TabletStageView> {

  UserState _userstate;

  var filter = ['all'];

  FutureOr onGoBack(dynamic value) {
    setState(() {
      if(_userstate.user.progress != null) autocloseDialog(context, _userstate.user, isTablet: true);});
  }

  @override
  void initState() {
    super.initState();
    print('init');
  }

  Widget getLessons(context) {
    List<Widget> lessons = new List.empty(growable: true);

    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3), 
      padding: EdgeInsets.all(0.0),
      itemCount: widget.stage.path.length,
      itemBuilder: (context,index) {
        var content = widget.stage.path[index];
        var image;
        if (content.image != null) {
          var configuration = createLocalImageConfiguration(context);
          image = new NetworkImage(content.image)..resolve(configuration);
        }

        return Container(
        margin: EdgeInsets.only(left:16.0,right:16.0,bottom: 32.0),
        decoration: BoxDecoration(
          color: Configuration.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: ElevatedButton(
          onPressed: () {
            if (_userstate.user.position >= content.position || _userstate.user.stagenumber > content.stagenumber) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => TabletContentView(
                          lesson: content,
                          content: content,
                          slider: image
                          ))).then(onGoBack);
            }
          },
          style: ElevatedButton.styleFrom(
              padding: EdgeInsets.all(0),
              primary: Colors.white,
              onPrimary: Colors.white,
              minimumSize: Size(double.infinity, double.infinity)),
          child: Stack(
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: Hero(tag: content.cod ,child: Image.network(content.image)),
              ),
              Positioned(
                  top: 15,
                  left: 15,
                  child: Container(
                    child: Icon(
                        content.type == 'meditation'
                            ? Icons.self_improvement
                            : Icons.book,
                        color: Colors.grey,
                        size: Configuration.tabletsmicon,
                        ),
                  )
              ),
              content.position < _userstate.user.position || 
              content.stagenumber < _userstate.user.stagenumber || 
              _userstate.user.userStats.lastread.where((c) => c['cod'] == content.cod).length > 0
              ? 
              Positioned(
                  top: 15,
                  right: 15,
                  child: Container(
                    child: Icon(Icons.visibility,
                        color: Colors.lightBlue,
                        size: Configuration.tabletsmicon,
                        ),
                )
              ) : Container(),
              Positioned(
                  left: 15,
                  bottom: 15,
                  child: Container(
                    width: Configuration.width*0.23,
                    child: Text(
                      content.title,
                      style:
                          Configuration.tabletText("verytiny", _userstate.user.position < content.position &&
                              _userstate.user.stagenumber <= content.stagenumber ? Colors.grey : Colors.black, 
                               ),
                    ),
                  )),
              /*Positioned(
                  bottom: 0.0,
                  left: 0.0,
                  width: Configuration.safeBlockHorizontal * 40,
                  height: Configuration.safeBlockHorizontal * 5,
                  child:  Container(
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [Colors.grey.withOpacity(0.9), Colors.grey.withOpacity(0.1)],
                          )),
                        )
              ),*/
              Positioned(
                left: 0,
                bottom: 0,
                right: 0,
                top: 0,
                child: AnimatedContainer(
                  padding: EdgeInsets.all(0),
                  key: Key(content.cod),
                  duration: Duration(seconds: 2),
                  decoration: BoxDecoration(
                      color: _userstate.user.position < content.position &&
                              _userstate.user.stagenumber <= content.stagenumber
                          ? Colors.grey.withOpacity(0.6)
                          : Colors.transparent),
                  curve: Curves.fastOutSlowIn,
                ),
              ),
            ],
          ),
        )
        );
      });
    
    
    
    //lessons.length > 0 ? Container(child: Text('hello'), height: Configuration.height*0.1, width: Configuration.width*0.5) : Text('There are no lessons');
          
  }

  @override
  Widget build(BuildContext context) {
    _userstate = Provider.of<UserState>(context);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back,
              size: Configuration.tabletsmicon, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        height: Configuration.height,
        width: Configuration.width,
        color: Configuration.lightgrey,
        padding: EdgeInsets.only(top:Configuration.height*0.07,left:16.0,right:16.0,bottom: 16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: Configuration.width*0.3,
              child: Column(
                children: [
                  Container(
                  height: Configuration.height* 0.4,
                  width: Configuration.width,
                  padding: EdgeInsets.all(16.0),
                  child: Text('Stage ' + widget.stage.stagenumber.toString(), style: Configuration.tabletText('small', Colors.white),),
                  decoration: BoxDecoration(
                      color: Configuration.maincolor,
                      borderRadius: BorderRadius.circular(12.0)),
                  ),
                  Text('Filter',
                      style: Configuration.tabletText('tiny', Colors.black),
                    ),
                    OutlinedButton(
                      onPressed: () => setState(
                          () => filter.contains('all') ? '' : filter = ['all']),
                      child: Icon(Icons.more_vert,
                          color: filter.contains('all')
                              ? Colors.white
                              : Colors.black.withOpacity(0.5)),
                      style: ButtonStyle(
                        backgroundColor: filter.contains('all')
                            ? MaterialStateProperty.all<Color>(
                                Configuration.maincolor)
                            : null,
                      ),
                    ),
                    OutlinedButton(
                      onPressed: () => setState(() {
                        filter.contains('lesson') ? '' : filter = ['lesson'];
                      }),
                      child: Icon(Icons.book,
                          color: filter.contains('lesson')
                              ? Colors.white
                              : Colors.black.withOpacity(0.5)),
                      style: ButtonStyle(
                        backgroundColor: filter.contains('lesson')
                            ? MaterialStateProperty.all<Color>(
                                Configuration.maincolor)
                            : null,
                      ),
                    ),
                    OutlinedButton(
                      onPressed: () => setState(() =>
                          filter.contains('meditation')
                              ? ''
                              : filter = ['meditation']),
                      child: Icon(Icons.self_improvement,
                          color: filter.contains('meditation')
                              ? Colors.white
                              : Colors.black.withOpacity(0.5)),
                      style: ButtonStyle(
                        backgroundColor: filter.contains('meditation')
                            ? MaterialStateProperty.all<Color>(
                                Configuration.maincolor)
                            : null,
                      ),
                    ),


                ],
              ),
            ),
            Expanded(child: getLessons(context))
          ],
        ),
      ),
    );
  }
}

class TabletContentView extends StatefulWidget {
  Content content;
  Meditation meditation;
  Lesson lesson;
  NetworkImage slider;

  TabletContentView({this.content, this.lesson, this.meditation, this.slider});
  
  @override
  _TabletContentViewState createState() => _TabletContentViewState();
}

class _TabletContentViewState extends State<TabletContentView> {
  int _index = -1;
  var _userstate;
  Map<int, NetworkImage> textimages = new Map();
  var reachedend = false;
  List balls = new List.empty(growable: true);

  Widget portada() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
      Hero(tag: widget.content.cod, 
        child: Container(
          width: Configuration.width*0.4, 
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(16.0)), 
          child: Image(image: widget.slider)
          )
      ),
      Expanded(
        child: Container(
          height: Configuration.height,
          color: Configuration.lightgrey,
          padding: EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
                  Text(widget.content.title,
                      style: Configuration.tabletText('small', Colors.black)),
                  SizedBox(height: Configuration.height*0.01),
                  Text(widget.lesson.description,
                      style: Configuration.tabletText('tiny', Colors.grey)),
                  SizedBox(height: Configuration.height*0.05),
                  TabletStartButton(
                    onPressed: () async{
                        setState(() => _index = 0);
                    } 
                  )
            ],
          ),
        ),
      )
    ]);
  }

  Widget vistaLeccion() {

    Widget vistaSlide(slide) {
      return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                slide['image'] != null && slide['image'] != '' ? Image.network(slide["image"], width: Configuration.width*0.4) : Container(),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(16.0),
                    child: Text(slide["text"], style: Configuration.tabletText('tiny', Colors.black, font: 'Helvetica')),
                    ),
                )
            ]),
            SizedBox(height: 30),
            AnimatedOpacity(
              opacity: reachedend ? 1.0 : 0.0, 
              duration: Duration(seconds: 4),
              child: Container(
                width: Configuration.width*0.3,
                child: AspectRatio(
                  aspectRatio: 9/2,
                  child: ElevatedButton(
                      onPressed: () async {
                      await _userstate.takeLesson(widget.lesson);
                      Navigator.pop(context, true);
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Configuration.maincolor,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32.0)),
                    ), 
                    child: Text(
                      'Finish',
                      style: Configuration.tabletText('tiny', Colors.white),
                    )
                  ),
                ),
              ),
            )
          ],
        );

    }
    
    return CarouselSlider.builder(
        itemCount: widget.lesson.text.length,
        itemBuilder: (context, index) {
          return Container(
            width: Configuration.width,
            height: Configuration.height,
            color: Configuration.lightgrey,
            padding: EdgeInsets.all(32),
            child: vistaSlide(widget.lesson.text[index]),
          );
        },
        options: CarouselOptions(
            height: Configuration.height,
            viewportFraction: 1,
            initialPage: 0,
            enableInfiniteScroll: false,
            reverse: false,
            onPageChanged: (index, reason) {
              setState(() {
                _index = index ;
                if (_index == widget.lesson.text.length - 1) {
                  setState(()=> reachedend = true);
                }
              });
            }));
  }

  @override
  void initState() {
    super.initState();
    _index = -1;
  }

  @override
  void didChangeDependencies() {
    var configuration = createLocalImageConfiguration(context);

    widget.lesson.text.forEach((slide) {
      if (slide['image'] != null) {
        new NetworkImage(slide['image'])..resolve(configuration);
      }
    });
  
    var count = 0;

    for(var lesson in widget.lesson.text){
      balls.add(count++);
    }

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    _userstate = Provider.of<UserState>(context);

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: IconButton(
              icon: Icon(Icons.close, size: Configuration.tabletsmicon, color: Colors.black),
              onPressed: () => Navigator.pop(context)
              ),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        extendBodyBehindAppBar: true,
        body: _index == -1
            ? portada()
            : Stack(children: [
                vistaLeccion(),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    margin: EdgeInsets.all(Configuration.smmargin),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: balls.map((index) {
                        return Container(
                          width: Configuration.safeBlockHorizontal * 2,
                          height: Configuration.safeBlockHorizontal * 2,
                          margin: EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 2.0),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _index == index
                                ? Color.fromRGBO(0, 0, 0, 0.9)
                                : Color.fromRGBO(0, 0, 0, 0.4),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ])
    );
  }
}
*/