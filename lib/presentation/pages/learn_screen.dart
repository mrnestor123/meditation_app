import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meditation_app/domain/entities/content_entity.dart';
import 'package:meditation_app/domain/entities/database_entity.dart';
import 'package:meditation_app/domain/entities/lesson_entity.dart';
import 'package:meditation_app/domain/entities/stage_entity.dart';
import 'package:meditation_app/presentation/mobx/actions/user_state.dart';
import 'package:meditation_app/presentation/pages/commonWidget/alert_dialog.dart';
import 'package:meditation_app/presentation/pages/commonWidget/carousel_balls.dart';
import 'package:meditation_app/presentation/pages/commonWidget/dialog.dart';
import 'package:meditation_app/presentation/pages/commonWidget/error_dialog.dart';
import 'package:meditation_app/presentation/pages/commonWidget/html_towidget.dart';
import 'package:meditation_app/presentation/pages/commonWidget/page_title.dart';
import 'package:meditation_app/presentation/pages/commonWidget/stage_card.dart';
import 'package:meditation_app/presentation/pages/commonWidget/start_button.dart';
import 'package:meditation_app/presentation/pages/config/configuration.dart';
import 'package:meditation_app/presentation/pages/contentWidgets/content_card.dart';
import 'package:meditation_app/presentation/pages/explore_screen.dart';
import 'package:provider/provider.dart';

import '../../domain/entities/technique_entity.dart';
import 'commonWidget/back_button.dart';
import 'commonWidget/created_by.dart';

class LearnScreen extends StatefulWidget {
  LearnScreen();

  @override
  _LearnScreenState createState() => _LearnScreenState();
}

class _LearnScreenState extends State<LearnScreen> {
  UserState _userstate;
  Image  image;

  double imageWidth, imageHeight;

  ScrollController _controller = new ScrollController();

  List<Widget> positionButtons(){ 
    
    Widget stageButton(Stage s){
      //container  with a number inside

      return Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(50)
        ),
        child: Center(
          child: Text(
            s.stagenumber.toString(),
            style: TextStyle(
              color: Colors.black,
              fontSize: 15,
              fontWeight: FontWeight.bold
            ),
          ),
        ),
      );
    }


    imageWidth = image.width;
    imageHeight = image.height;

    // create a grid array separating into five columns from width and height
    List<dynamic> grid = new List.empty(growable: true);
    List<Widget> widgets = [];

    for(int i = 0; i < 1 ;  i++){
      grid.add({
        'left':10.0,
        'bottom':20.0
      });
    }

    // create a list of widgets with the position of the buttons
    for(int i = 0; i < 1 ;  i++){
      if(grid[i] != null){
        widgets.add(Positioned(
          left: grid[i]['left'],
          bottom: grid[i]['bottom'],
          child: stageButton(_userstate.data.stages[i])
        ));
      }
    }


    return widgets;
  }


  @override
  void initState() {
    super.initState();
    _userstate = Provider.of<UserState>(context, listen: false);
    image = Image.asset("assets/path.png", width: Configuration.width);
  }


  Widget oldLearnScreen() {
    return ListView(
      reverse: true,
      physics: ClampingScrollPhysics(),
      children: [
        SizedBox(height: Configuration.verticalspacing*2),
        
        pageTitle('', 'Progress is not linear, work on your own pace', Icons.terrain),

        SizedBox(height: Configuration.verticalspacing*2),
  
        Container(
          width: Configuration.width,
          /*decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/camino.png"),
              fit: BoxFit.cover
            )
          ),*/
          child: ListView.separated(
            reverse: true,
            shrinkWrap: true,
            itemCount: _userstate.data.stages.length,
            physics: NeverScrollableScrollPhysics(),
            separatorBuilder: (context, index) {
              return SizedBox(height: Configuration.verticalspacing*2);
            },
            itemBuilder: ((context, index) {
             var _blocked = _userstate.user.isStageBlocked(_userstate.data.stages[index]);
              Stage s  = _userstate.data.stages[index];
              var flex;

              return Container(
                margin: EdgeInsets.symmetric(horizontal: Configuration.smpadding),
                child: GestureDetector(
                  onTap: ()=>{
                        if (_blocked) {
                          showDialog(
                            context: context,
                            builder: (_) => AbstractDialog(
                                content: Container(
                                  padding: EdgeInsets.all(Configuration.smpadding),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(
                                          Configuration.borderRadius / 2)),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.info, size: Configuration.smicon,color: Colors.blue),
                                      SizedBox(height: Configuration.verticalspacing),
                                      Text("You need to finish stage " + (_userstate.data.stages[index].stagenumber - 3).toString() +   ' to unlock this stage',
                                        style: Configuration.text('small', Colors.black,font: 'Helvetica')
                                      )
                                    ],
                                  )
                                )
                              )
                            )
                        } else {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => StageView(
                                stage: _userstate.data.stages[index],
                              )
                            ),
                          ).then((value) =>
                            // HAY QUE QUITAR LOS THEN !!!
                            setState(() {
                              print('SETTING STATE');
                            })
                          )
                        }
                  },
                  child: Stack(
                    children: [
                      StageCard(
                        learnscreen: true,
                        stage: s,
                        user: _userstate.user,
                      ),
                
                      Positioned.fill(
                        child: AnimatedContainer(
                          padding: EdgeInsets.all(0),
                          key: Key(s.stagenumber.toString()),
                          duration: Duration(seconds: 2),
                          child: _blocked
                              ? Center(
                                  child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Icon(Icons.lock, size: Configuration.smicon, color: Colors.white),
                                    SizedBox(height: 10),
                                    Text('Unlocked after doing stage ' + (s.stagenumber - 3).toString(), 
                                      style: Configuration.text('small', Colors.white)
                                    )
                                  ],
                                ))
                              : Container(),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                  Configuration.borderRadius / 3),
                              color: _blocked
                                  ? Colors.grey.withOpacity(0.8)
                                  : Colors.transparent),
                          curve: Curves.fastOutSlowIn,
                        )
                      )
                
                    ],
                  ),
                ),
              );
            }),
          )
        ),
        
        
        SizedBox(height: Configuration.verticalspacing*1.5)

         /* child: GridView.builder(
            padding: EdgeInsets.symmetric(vertical: 10),
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: _userstate.data.stages.length,
            itemBuilder: (context, index) {
              var _blocked = _userstate.user.isStageBlocked(_userstate.data.stages[index]);
              Stage s  = _userstate.data.stages[index];
              var flex;
              
              if(!_blocked){
                if(s.percentage == null){
                  s.checkPercentage(_userstate.user);
                }
                flex = (s.percentage *6 /100).round();
              }


              return Container(
                decoration: BoxDecoration(
                  borderRadius:  BorderRadius.circular(Configuration.borderRadius)),
                child: ElevatedButton(
                  onPressed: () {
                    if (_blocked) {
                      showDialog(
                          context: context,
                          builder: (_) => AbstractDialog(
                              content: Container(
                                  padding: EdgeInsets.all(Configuration.smpadding),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(
                                          Configuration.borderRadius / 2)),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.info,
                                          size: Configuration.smicon,
                                          color: Colors.blue),
                                      SizedBox(
                                          height: Configuration.verticalspacing),
                                      Text("You need to finish stage " +
                                        (_userstate.data.stages[index]
                                          .stagenumber - 3
                                        ).toString() +
                                        ' to unlock this stage',
                                        style: Configuration.text(
                                        'small', Colors.black,
                                        font: 'Helvetica')
                                      )
                                    ],
                                  )
                                )
                            )
                          );
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => StageView(
                            stage: _userstate.data.stages[index],
                          )
                        ),
                      ).then((value) =>
                        // HAY QUE QUITAR LOS THEN !!!
                        setState(() {
                          print('SETTING STATE');
                        })
                      );
                    }
                  },
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                    /*
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child:// THE IMAGE  OF THE  STAGE
                        ClipRRect(
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(Configuration.borderRadius),
                            bottomRight: Radius.circular(Configuration.borderRadius)
                          ),
                          child:  CachedNetworkImage(
                            imageUrl: _userstate.data.stages[index].shortimage,
                            fit: BoxFit.fitWidth,
                            height: 100,
                            errorWidget: (context, url, error) => Icon(Icons.error),
                        ),
                      )
                    ),*/
                    
                    Center(
                      child: Text(
                        'Stage ' + _userstate.data.stages[index].stagenumber.toString(),
                        style: Configuration.text(
                          "medium", !_blocked ? Colors.white : Colors.grey
                        ),
                      ),
                    ),
      

                    
                    !_blocked ?
                      Positioned(
                        bottom: Configuration.verticalspacing*2,
                        left:0,
                        right:0,
                        child: flex == 6 ? 
                        Icon(
                          Icons.check_circle, 
                          color: Colors.white,
                          size: Configuration.smicon,  
                        ):
                        Container(
                          height: Configuration.smicon/2,
                          decoration:  BoxDecoration(
                            borderRadius: BorderRadius.circular(16.0),
                            border: Border.all(color: Colors.grey),
                            color: Colors.white
                          ),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Flexible(
                                  flex: flex,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.lightBlue,
                                      borderRadius:BorderRadius.circular(16.0)
                                    ),
                                  ),
                                ),
                                
                                Flexible(
                                  child: Container(), flex: 6 - flex
                                )
                          ])
                        ),
                      )
                      : Container()
                  ]),
                  style: ElevatedButton.styleFrom(
                      elevation: _blocked ? 0 : 4,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16.0)),
                      backgroundColor: _blocked
                          ? Colors.grey.withOpacity(0.4)
                          : Configuration.maincolor,
                      foregroundColor: Colors.white,
                      minimumSize: Size(double.infinity, double.infinity),
                      animationDuration: Duration(milliseconds: 50)),
                ),
              );
            }),
        */
        
      
        
      
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    _userstate = Provider.of<UserState>(context);

    return Container(
      child: ListView(
        children: [

          
          SizedBox(height: Configuration.verticalspacing*1.5),
          
          pageTitle(

            '',
            'Find guided meditations, videos and techniques to practice',
            Icons.explore
          ),
          
          SizedBox(height: Configuration.verticalspacing),


          Container(
            padding: EdgeInsets.all(Configuration.smpadding),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: _userstate.data.sections.length,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context,index){
                Section e = _userstate.data.sections[index];
          
                return Container(
                  
                  margin: EdgeInsets.only(bottom: Configuration.verticalspacing),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      padding: EdgeInsets.all(0),
                      shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(Configuration.borderRadius/2))
                    ),
                    onPressed: (){
                      Navigator.push(
                        context, 
                        MaterialPageRoute(builder: (context){
                          return ViewSection(section:e);
                        })
                      );
                    },
                    child: Stack(
          
                      children: [
                        Positioned(
                          right: 0,
                          bottom: 0,
                          top: 0,
                          child: Container(
          
                            width: Configuration.width*0.3,
                            decoration: BoxDecoration(
                              color: Configuration.maincolor,
                              borderRadius: BorderRadius.circular(Configuration.borderRadius/2)
                            ),
                            child: e.image != null 
                              ? ClipRRect(
                                borderRadius: BorderRadius.horizontal(
                                  right: Radius.circular(Configuration.borderRadius/2)
                                ),
                                child: CachedNetworkImage(
                                  fit: BoxFit.cover,
                                  imageUrl: e.image != null ? e.image : '')
                              )
                              : Container(),
                          ),
                        ),
                        
                        Container(
                          constraints: BoxConstraints(
                            minHeight: Configuration.height*0.15
                          ),
                          padding: EdgeInsets.all(Configuration.smpadding),
                          child: Row(
                            children: [
                              Container(
                                width: Configuration.width * 0.7,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(e.title, style: Configuration.text('subtitle',Colors.black)),
                                    //SizedBox(height: Configuration.verticalspacing),
                                    //Text(e.description, style: Configuration.text('small',Colors.black)),
                                  
                                   
                                  
                                    SizedBox(height: Configuration.verticalspacing),
                                    Text(e.content.length.toString() + ' sessions', 
                                      style: Configuration.text('small',Colors.grey,font:'Helvetica')
                                    ),
          
          
                                    e.createdBy != null ? 
                                    createdByChip(e.createdBy): Container(),
                                  ],
                                ),
                              ),
                              
                        
                              SizedBox(width: Configuration.verticalspacing),
                            
                            ],
                          ),
                        ),
          
                        
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    ); 
  }
}

class StageView extends StatefulWidget {
  Stage stage;

  StageView({this.stage});

  @override
  _StageViewState createState() => _StageViewState();
}

// PORQUE NO PASAMOS LA STAGE AQUI ????
class _StageViewState extends State<StageView> {
  UserState _userstate;

  var filter = ['lesson','meditation'];

  bool pushedDialog = false;

  List<Technique> stageTechniques = new  List.empty(growable: true);

  List<Content> path ;

  FutureOr onGoBack(dynamic value) {
    setState(() {
      //if (_userstate.user.progress != null) autocloseDialog(_userstate.user);
    });
  }

  Widget techniques(){
    return Container(
      padding: EdgeInsets.all(Configuration.smpadding),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          Configuration.borderRadius/2
        ),
        border: Border.all(
          color: Configuration.maincolor
        )
      ),
      child: Column(
        children: [
          SizedBox(height: Configuration.verticalspacing),
          Text('Techniques', style: Configuration.text('smallmedium', Colors.black, font:'Helvetica')),
          SizedBox(height: Configuration.verticalspacing),
          Container(
            height: 100,
            child: ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              itemCount: stageTechniques.length,
              itemBuilder: (context, index) {
                Technique t = stageTechniques[index];

                return ListTile(
                  leading: CachedNetworkImage(imageUrl: t.image,
                    width: 50,
                    height: 50,
                  ),
                  title: Text(t.title, style: Configuration.text('small', Colors.black)),
                  trailing: Icon(Icons.info, size: Configuration.smicon),
                );
              },
            ),
          ),
          SizedBox(height: Configuration.verticalspacing),
        ],
      ),
    );
  }

  Widget techniqueCard(Technique t){
    return AspectRatio(
      aspectRatio: Configuration.lessonratio,
      child: Container(
        margin: EdgeInsets.all(Configuration.verticalspacing),
        child: ElevatedButton(
          onPressed: (){
            Navigator.pushNamed(context, '/techniques', arguments:  
            {
              'technique': t,
              'stagenumber':t.startingStage,
              'position':t.position
            });
          },
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.all(0),
            primary: Colors.white,
            onPrimary: Colors.white,
            shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Configuration.borderRadius / 3)),
            minimumSize: Size(double.infinity, double.infinity)),
          child: Stack(
            children: [
              t.image != null && t.image.isNotEmpty
                ? Align(
                    alignment: Alignment.centerRight,
                    child: AspectRatio(
                      aspectRatio: 0.9,
                      child: ClipRRect(
                        borderRadius: BorderRadius.horizontal(
                            right: Radius.circular(
                              Configuration.borderRadius / 3)
                          ),
                        child: CachedNetworkImage(
                          imageUrl: t.image,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            color: Colors.white,
                          ),
                          errorWidget: (context, url, error) =>
                            Icon(Icons.error),
                        ),
                      )),
                  )
                : Container(),

              Positioned(
                  top: 15,
                  left: 15,
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(Configuration.verticalspacing),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey
                          ),
                        child: Center(
                          child: Text((t.position+1).toString(),
                            style: Configuration.text('small',Colors.white),
                          ),
                        )
                      ),
                    ],
                  )),
              Positioned(
                left: 15,
                bottom: 15,
                child: Container(
                  width: Configuration.width * 0.5,
                  child: Text(
                    t.title,
                    style: Configuration.text(
                      "small", Colors.black,
                    ),
                  ),
                )
              ),
              
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies(){
    super.didChangeDependencies();
    setState(() {});
  }

  List<Widget> contentList(List<Content> c){
    List<Widget> widgets = new List.empty(growable: true);

    c.forEach((content) {
      bool blocked = _userstate.user.isContentBlocked(content);
        
      widgets.add(ContentCard(
        then:onGoBack,
        unlocksContent: c[content.position == 0
          ? content.position
          : content.position - 1],
        content: content,
        blocked: blocked,
      )); 
    });

    return widgets;
  }

  Widget getLessons(context) {
    List<Widget> lessons = new List.empty(growable: true);
    var count = 0;

    path = filter.contains('meditation-practice') ? widget.stage.meditpath :
    filter.contains('video') ?  widget.stage.videos :
    widget.stage.path;

    lessons.add(
      Container(
        width: Configuration.width,
        color: Colors.grey,
        padding: EdgeInsets.all(Configuration.smpadding),
        child: Text(
          filter.contains('meditation-practice') ?
          'Guided meditations for practicing the techniques' :
          filter.contains('video') ?
          'Videos done by TMI teachers' :
          filter.contains('techniques') ?
          'Techniques you will learn on this stage':
          'Summary of lessons from The Mind Illuminated',
          style: Configuration.text('small',Colors.white,font: 'Helvetica'),
        ),
      )
    );

    if(filter.contains('techniques')){
      stageTechniques.forEach((t) { 
        lessons.add(techniqueCard(t));
      });
    }else{
      path.forEach((content) {      
        bool blocked = _userstate.user.isContentBlocked(content);
        
        lessons.add(ContentCard(
          then:onGoBack,
          unlocksContent: path[content.position == 0
            ? content.position
            : content.position - 1],
          content: content,
          blocked: blocked,
        )); 
      });
    }

    lessons.add(SizedBox(height: Configuration.verticalspacing*2));

    return Container(
      width: Configuration.width,
      color: Configuration.lightgrey,
      child: lessons.length > 1
        ? Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: lessons
          )
        : Center(
            child: Text(
            'There are no ' + (filter.contains('meditation-practice') ? 'meditations' : 'lessons'),
            style: Configuration.text('small', Colors.black),
          )
        )
    );
  }

  Widget filterButton({IconData icon, onPressed, condition}){
    return OutlinedButton(
      onPressed: onPressed,
      child: Icon(icon,
          color: condition
              ? Colors.white
              : Colors.black.withOpacity(0.5)),
      style: ButtonStyle(
      backgroundColor: condition
        ? MaterialStateProperty.all<Color>(Configuration.maincolor)
        : null,
      )
    );
  }

  // LE PODEMOS PASAR UN ICONO ??
  Widget containerHeader(String text, {IconData icon, Widget child}){
    return Container(
      width: Configuration.width,
      decoration: BoxDecoration(
        color: Configuration.maincolor,
        border: Border.symmetric(
          horizontal: BorderSide(
            color: Configuration.maincolor,
            width: 1
          ),
        )
      ),
      padding: EdgeInsets.all(Configuration.smpadding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: Colors.white,
                size: Configuration.smicon
              ),
              SizedBox(width: Configuration.verticalspacing*2),
              Text(
                text,
                style: Configuration.text('subtitle',Colors.white),
              ),
            ],
          ),
          child  != null ? 
          child : Container()
        ],
      ),
    );
  }

  Widget stageButton({String text, IconData icon, Widget child, onPressed, dialogText}){
    return Container(
      margin: EdgeInsets.only(bottom: Configuration.verticalspacing),
      padding: EdgeInsets.symmetric(horizontal:Configuration.smpadding),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Configuration.borderRadius/2)
          ),
          backgroundColor: Colors.white,
          foregroundColor: Colors.white,
          side: BorderSide(
            color: Colors.grey,
            width: 1,
          ),
          padding: EdgeInsets.all(Configuration.smpadding),
        ),
        onPressed: (){
          setState(() {
            pushedDialog = true;
          });
          if(onPressed != null){
            onPressed();
          }else{
            showDialog(
              context: context, 
              builder: (context){
                return AbstractDialog(
                  content: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(
                        Configuration.borderRadius/2
                      )
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          constraints: BoxConstraints(
                            maxHeight: Configuration.height*0.3,
                            minWidth: Configuration.width
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(Configuration.borderRadius/2),
                              topRight: Radius.circular(Configuration.borderRadius/2),
                            ),
                            child: CachedNetworkImage(
                              fit: BoxFit.cover,
                              imageUrl: widget.stage.shortimage,
                            ),
                          ),
                        ),
                        
                        Container(
                          child: ListView(                            
                            padding: EdgeInsets.all(Configuration.smpadding),
                            shrinkWrap: true,
                            physics: ClampingScrollPhysics(),
                            children: [
                              Text(
                                text,
                                style: Configuration.text('subtitle',Colors.black),
                              ),
                              htmlToWidget(
                                dialogText,
                                align: TextAlign.justify
                              ),
                            ],
                          ),
                        ),
                        
                      ],
                    ),
                  ),
                );
              }
            ).then((value) => setState(()=> pushedDialog = false));
          }
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(child: Text(text,  style: Configuration.text('small',Colors.black))),
            child != null ? child :
            Icon(icon, size: Configuration.smicon, color: Colors.black)
          ],
        )
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _userstate = Provider.of<UserState>(context);
    stageTechniques = _userstate.data.techniques.where(((element) => element.startingStage == widget.stage.stagenumber)).toList();

    return Scaffold(
      backgroundColor: Configuration.lightgrey,
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle(
          // Status bar color
          statusBarColor: pushedDialog ?  Colors.black.withOpacity(0.01) :  Configuration.lightgrey, 
          // Status bar brightness (optional)
          statusBarIconBrightness: Brightness.dark, // For Android (dark icons)
          statusBarBrightness: Brightness.light, // For iOS (dark icons)
        ),
        leading: ButtonBack(color: Colors.black),
        /*
        actions: [
          IconButton(
            iconSize: Configuration.smicon,
            onPressed: () {
              setState(()=> pushedDialog = true);
              showGeneralDialog(
                context: context,
                barrierLabel: 'dismiss',
                barrierDismissible: true,
                pageBuilder: (context, anim1, anim2) {
                  return AbstractDialog(
                    content: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.0),
                          color: Colors.white),
                      padding: EdgeInsets.all(12),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          htmlToWidget(widget.stage.longdescription,
                            color: Colors.black
                          )
                        ],
                      ),
                    ),
                  );
                }).then((value) => setState(()=>{
                  pushedDialog = false
                }));
              },
            icon: Icon(Icons.info, color: Colors.lightBlue,  size: Configuration.smicon)
          )
        ],*/
        backgroundColor: Configuration.lightgrey,
        elevation: 0
      ),
      body: Container(
        constraints: BoxConstraints(
          minHeight: Configuration.height
        ),
        child: SingleChildScrollView(
          physics: ClampingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                child: Padding(
                  padding:EdgeInsets.symmetric(horizontal: Configuration.smpadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      StageCard(
                        
                        stage: widget.stage, user: _userstate.user),
                     /*
                      Center(
                        child: Container(
                          width: Configuration.width*0.5,
                          height: Configuration.width*0.5,
                          decoration: BoxDecoration(
                            color: Configuration.maincolor,
                            borderRadius: BorderRadius.circular(Configuration.borderRadius),
                          ),
                        ),
                      ),

                      SizedBox(height: Configuration.verticalspacing*2),

                      Text('Stage ' + widget.stage.stagenumber.toString(),
                      
                        style: Configuration.text('smallmedium', Colors.black),
                      ),
                      SizedBox(height: Configuration.verticalspacing*0.5),
                      Text(widget.stage.description,
                        style: Configuration.text('small', Colors.black, font: 'Helvetica'),
                      ),


                      SizedBox(height: Configuration.verticalspacing),*/
                     //SizedBox(height: Configuration.verticalspacing*2),
                      


                      //StageCard(stage: widget.stage),
                      
                      
                      //SizedBox(height: Configuration.verticalspacing*2),
                      
                      //Divider(),

                      
                      //discussionButton(context, widget.stage),
                      //SizedBox(height: Configuration.verticalspacing*2),
                     
                      /*
                      BaseButton(
                        onPressed: ()=>{
                          Navigator.pushNamed(context, '/practicalpath')
                        },
                        text: 'Practical Path',
                      ),*/
                      /*
                      Text('Showing', style: Configuration.text('small',Colors.black)),
                      SizedBox(height: Configuration.verticalspacing*0.5),
                      
                      GridView(
                        padding: EdgeInsets.all(0),
                        shrinkWrap: true,

                        physics: NeverScrollableScrollPhysics(),
                        children: [
                          filterButton(
                            icon:Icons.book,
                            condition:filter.contains('lesson') || filter.contains('meditation'),
                            onPressed:(){
                              setState(() {
                                filter = ['lesson','meditation'];
                              });
                            }
                          ),
        
                          widget.stage.meditpath.length > 0  ?
                          filterButton(
                            icon:Icons.self_improvement,
                            condition:filter.contains('meditation-practice'),
                            onPressed:(){
                              setState(() {
                                filter = ['meditation-practice'];
                              });
                            }
                          ):Container(),


                          widget.stage.videos.length > 0  ?
                          filterButton(
                            icon:Icons.ondemand_video,
                            condition:filter.contains('video') ,
                            onPressed:(){
                              setState(() {
                                filter = ['video'];
                              });
                            }
                          ): Container(),


                          stageTechniques !=null && stageTechniques.length > 0 ?
                          filterButton(
                            icon: Icons.checklist,
                            condition:filter.contains('techniques'),
                            onPressed:(){
                              setState(() {
                                filter = ['techniques'];
                              });
                            }
                          ):Container(),
                          
        
                         
        
                          
                        ],
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisSpacing: Configuration.verticalspacing,
                          childAspectRatio: 1.8,
                          mainAxisSpacing: Configuration.verticalspacing,
                          crossAxisCount: 4)
                      ),
                    
                    
                      SizedBox(height: Configuration.verticalspacing*2),*/
                    ],
                  ),
                ),
              ),

              SizedBox(height: Configuration.verticalspacing*1.5),

              stageButton(
                text: 'Stage summary',
                icon: Icons.info,
                dialogText: widget.stage.longdescription
              ),

              /*
              stageButton(
                text: 'How to practice ',
                icon: Icons.self_improvement,
                onPressed: ()=>{
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: ((context) => PracticeSummary()))
                  )
                }
              ),*/

              /*
              _userstate.user.stagenumber == widget.stage.stagenumber ?
              stageButton(
                onPressed: ()=>{
                  Navigator.pushNamed(context, '/progress')
                },
                text: 'Objectives',
                icon: Icons.checklist
              ): Container(),
              */
              
              widget.stage.stagenumber != 10 ?
              stageButton(
                text: 'When to advance this stage',
                icon: Icons.check_box,
                dialogText: widget.stage.whenToAdvance
              ): Container(),

              SizedBox(height: Configuration.verticalspacing*1.5),

              containerHeader('Theory', icon: Icons.book),

              Column(
                mainAxisSize: MainAxisSize.min,
                children: contentList(widget.stage.path),
              ),
              
              widget.stage.meditpath != null && widget.stage.meditpath.length > 0 ?
              Column(
                children: [
                  containerHeader(
                    'Practice', 
                    icon: Icons.self_improvement,
                    child:widget.stage.stagenumber == 1 ?
                      //HELP BUTTON !!
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle
                        ),
                        child:GestureDetector(
                          onTap: (){
                            showInfoDialog(
                              type: 'help',
                              header: '',

                              description: 'Each technique is shown separately but they are meant to be used together. In each stage there will be a long meditation integrating all the techniques.'
                            );
                          },
                          child: Icon(Icons.help, color: Colors.lightBlue, size: Configuration.smicon,)),
                          
                      ): Container()
                    ),
                  SizedBox(height: Configuration.verticalspacing*1.5),


                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: contentList(widget.stage.meditpath),
                  )
                ],
              ): Container(),

              /*
              Container(
                height: 1,
                width: Configuration.width,
                color: Colors.grey
              ),
              Container(
                child: getLessons(context))

              */


              SizedBox(height: Configuration.verticalspacing*2,),
              
            ],
          ),
        ),
      ),
    );
  }
}

class LessonView extends StatefulWidget {
  Lesson lesson;
  NetworkImage slider;

  LessonView({this.lesson, this.slider});

  @override
  _LessonViewState createState() => _LessonViewState();
}

class _LessonViewState extends State<LessonView> {
  int _index = -1;
  var _userstate;
  Map<int, NetworkImage> textimages = new Map();
  var reachedend = false;
  Map<dynamic, dynamic> slide = new Map();
  bool pushedDialog = false;

  bool hideBalls = false;

  // AQUÍ HABRÍA QUE PONER VISTA LECCIÓN ???
  Widget vistaLeccion() {
    return CarouselSlider.builder(
        itemCount: widget.lesson.text.length,
        itemBuilder: (context, index, page) {
          var slide = widget.lesson.text[index];
          
          return Container(
            width: Configuration.width,
            constraints: BoxConstraints(
              minHeight: Configuration.height
            ),
            color: Configuration.lightgrey,
            child: ListView(
              physics: ClampingScrollPhysics(),
              shrinkWrap: true,
              padding: EdgeInsets.only(top: 0.0),
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: slide["image"] != '' && slide["image"] != null
                    ? Container(
                      decoration: BoxDecoration(
                        color: slide['imagecolor'] != null ?
                        Color(int.parse(('0xff${slide['imagecolor'].substring(1,7)}'))) : 
                        Colors.white
                      ),
                      width: Configuration.width,
                      child: Center(
                        child: Container(
                          constraints: BoxConstraints(
                            maxWidth: Configuration.width  >  500 ?  
                            Configuration.width * 0.5 : 
                            Configuration.width * 0.9
                          ),
                          child: CachedNetworkImage(
                            imageUrl: slide["image"],
                            fit: BoxFit.contain
                          ),
                        ),
                      ),
                    )
                    : Container(),
                ),

                Center(
                  child: Container(
                    width: Configuration.width,
                    padding: EdgeInsets.all(Configuration.smpadding),
                    child: htmlToWidget(
                      slide["text"],
                      align: TextAlign.justify
                    )),
                ),
                Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  AnimatedOpacity(
                    opacity: reachedend  ? 1.0 : 0.0,
                    duration: Duration(seconds: 1),
                    child: page == widget.lesson.text.length - 1 ?  BaseButton(
                      text: 'Finish',
                      onPressed: () async {
                        //NOSE SI HABRA QUE ESPERAR
                        await _userstate.takeLesson(widget.lesson);
                        Navigator.pop(context, true);
                      },
                    ) :  Container(),
                  )
                ]),

                SizedBox(height: Configuration.verticalspacing*4),
              ],
            ),
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
              slide = widget.lesson.text[index];
              _index = index;
              
              if (_index == widget.lesson.text.length - 1  &&  !reachedend) {
                Future.delayed(
                  Duration(seconds: 2),
                  () => setState(() => reachedend = true)
                );
              }
            });
          })
        );
  }

  @override
  void initState() {
    super.initState();
    _index = 0;

    slide = widget.lesson.text[0];
  }

  @override
  void didChangeDependencies() {
    if(widget.lesson.text.length == 1){
      reachedend = true;
    }

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    _userstate = Provider.of<UserState>(context);
    
    return Scaffold(
      extendBody: false,
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle(
          // Status bar color
          statusBarColor: pushedDialog ?  Colors.black.withOpacity(0.01) : Configuration.lightgrey, 
          // Status bar brightness (optional)
          statusBarIconBrightness: Brightness.dark, // For Android (dark icons)
          statusBarBrightness: Brightness.light, // For iOS (dark icons)
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Flexible(
              child: Text(
                widget.lesson.title,
                maxLines:2,
                style: Configuration.text('subtitle', Colors.black),
              ),
            ),
          ],
        ),
        actions: [
          slide['help'] != null ?
          IconButton(
            icon: Icon(Icons.info),
            iconSize: Configuration.smicon,
            color: Colors.lightBlue,
            onPressed: () {
              setState(() {
                pushedDialog =true;
              });
              showInfoDialog(
                key: Key(_index.toString()),
                type: 'info',
                html: slide['help'],
              ).then((d)=>{
                setState(() {
                  pushedDialog =false;
                })
              });
            },
          ) : Container()
        ],
        leading: ButtonClose(
          color: Colors.black,
          onPressed: () => showAlertDialog(
            title: 'Are you sure you want to exit ?',
            context: context,
            text: "This lesson will not count as a read one"
        )),
        backgroundColor: Configuration.lightgrey,
        elevation: 0,
      ),
      extendBodyBehindAppBar: false,
      body: WillPopScope(
        onWillPop: () {
          print('CANT Go back');
          return Future.value(true);
        },
        child: Stack(children: [
          vistaLeccion(),
          
          widget.lesson.text.length  >  1 ? 
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: EdgeInsets.all(15),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CarouselBalls(
                    activecolor: Colors.black,
                    index:_index,
                    items:widget.lesson.text.length,
                  ),
                  SizedBox(height: Configuration.verticalspacing)
                ],
              ),
            ),
          ) :  Container(),
        ]),
      )
    );
  }
}
