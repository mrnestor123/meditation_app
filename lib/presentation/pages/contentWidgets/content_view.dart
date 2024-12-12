
// WIDGET COMÚN DE VISTA DE CONTENIDO
// SE PODRÁN VER LECCIONES Y MEDITACIONES, Y EDITAR 
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meditation_app/domain/entities/content_entity.dart';
import 'package:meditation_app/domain/entities/meditation_entity.dart';
import 'package:meditation_app/presentation/mobx/actions/meditation_state.dart';
import 'package:meditation_app/presentation/mobx/actions/user_state.dart';
import 'package:meditation_app/presentation/pages/commonWidget/category_chip.dart';
import 'package:meditation_app/presentation/pages/commonWidget/circular_progress.dart';
import 'package:meditation_app/presentation/pages/commonWidget/created_by.dart';
import 'package:meditation_app/presentation/pages/commonWidget/dialogs.dart';
import 'package:meditation_app/presentation/pages/commonWidget/start_button.dart';
import 'package:meditation_app/presentation/pages/commonWidget/user_bottom_dialog.dart';
import 'package:meditation_app/presentation/pages/config/configuration.dart';
import 'package:meditation_app/presentation/pages/contentWidgets/meditation_screens.dart';
import 'package:meditation_app/presentation/pages/contentWidgets/meditation_widgets.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:wakelock/wakelock.dart';

import '../../../domain/entities/stage_entity.dart';
import '../commonWidget/back_button.dart';
import '../commonWidget/carousel_balls.dart';
import '../commonWidget/html_towidget.dart';
import '../commonWidget/profile_widget.dart';
import '../commonWidget/time_chip.dart';


// IR SIEMPRE A CONTENTFRONTPAGE AUNQUE SEA RECORDING
class ContentFrontPage extends StatefulWidget {
  Content content;
  Stage stage;
  dynamic then;
  List<Content> path;

  ContentFrontPage({this.content,this.then, this.stage, this.path}) : super();

  @override
  State<ContentFrontPage> createState() => _ContentFrontPageState();
}

class _ContentFrontPageState extends State<ContentFrontPage> {  
  
  checkMedhasPreText(Meditation m){
    return m.content != null && m.content.length > 0;
  }

  bool hasBells(Meditation m){
    return m.meditationSettings.bells != null && m.meditationSettings.bells.length > 0;
  }

  Duration getTime(FileContent f){
    return f.total;
  }

  int getPages(Lesson l){
    return l.text.length;
  }


  void cacheImages(Lesson lesson){
    lesson.text.forEach((slide) {
      if (slide['image'] != '') {
        precacheImage(new CachedNetworkImageProvider(slide['image']), context);
      }
    });
  }
  
  // didChangedependencies
  void didChangeDependencies(){
    super.didChangeDependencies();
    if(widget.content.isLesson()){
      cacheImages(widget.content);
    }
  }

  @override
  Widget build(BuildContext context) {
    final  _meditationstate = Provider.of<MeditationState>(context);
  
    return Scaffold(
      extendBodyBehindAppBar: false,
      // Status bar brightness (optional)
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.white, 
          statusBarIconBrightness: Brightness.dark, // For Android (dark icons)
          statusBarBrightness: Brightness.light, // For iOS (dark icons)
        ),
        backgroundColor: Colors.white,
        elevation:0,
        leading: ButtonClose(
          color: Colors.black,
        ),
      ),
      body: ListView(
        physics: ClampingScrollPhysics(),
        children: [
        widget.content.image != null && widget.content.image.isNotEmpty
        ?  Stack(
            children: [
              Container(
                color:Colors.white,
                height: Configuration.height*0.5 - AppBar().preferredSize.height,
                child: Center(
                  child: CachedNetworkImage(
                    imageUrl: widget.content.image,
                    placeholder: (context, url) => Container(
                      height: Configuration.height * 0.4,
                      width: Configuration.width,
                      color: Colors.grey.withOpacity(0.5),
                    ),
                    width: Configuration.width,
                    height: Configuration.height * 0.4,
                    fit: BoxFit.contain,
                  ),
                )
              )
            ],
          )
        : Container(
          color: Configuration.lightgrey,
          height: Configuration.height * 0.5 - AppBar().preferredSize.height
        ),

        Container(
          constraints: BoxConstraints(
            minHeight: Configuration.height*0.5 - AppBar().preferredSize.height
          ),
          width: Configuration.width,
          child: Column(
            children: [
              Container(
                constraints: BoxConstraints(
                  minHeight: Configuration.height*0.35
                ),
                padding: EdgeInsets.only(
                  left: Configuration.smpadding,
                  right: Configuration.smpadding,
                  top: Configuration.medpadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.content.title,
                      textAlign: TextAlign.left,
                      style: Configuration.text('subtitle', Colors.black)),
                    SizedBox(height: Configuration.verticalspacing),
                    Text(widget.content.description != null ? widget.content.description : '',
                      textAlign: TextAlign.left,
                      style: Configuration.text('small',Colors.black,font: 'Helvetica'),
                    ),
                    SizedBox(height: Configuration.verticalspacing),
                    
                    Row(
                      children: [
                          widget.content.isLesson() ? 
                          Chip(
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(Configuration.borderRadius),
                              side: BorderSide(
                                color: Colors.grey,
                                width: 1,
                              ),
                            ),
                            avatar: Icon(Icons.book, color: Colors.black),
                            label: Text(
                              getPages(widget.content).toString() + ' pages',
                              style: TextStyle(
                                color:  Colors.black,
                              ),
                            ),
                          ) : Container(),


                          widget.content.category!= null && widget.content.category.isNotEmpty ? 
                          Container(
                            margin: EdgeInsets.only(
                              left: Configuration.verticalspacing
                            ),
                            child: Chip(
                              
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(Configuration.borderRadius),
                                side: BorderSide(
                                  color: Colors.grey,
                                  width: 1,
                                ),
                              ),
                              avatar: Icon(
                                widget.content.getCategoryIcon(), 
                                color: Colors.black
                              ),
                              label: Text(
                                widget.content.category,
                                style: TextStyle(
                                  color:  Colors.black,
                                ),
                              ),
                            ),
                          ) : Container(), 
                      ],
                    ),
                   
                    

                    widget.content.isMeditation() || widget.content.createdBy != null ?
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                           widget.content.isMeditation() ? TimeChip(c:widget.content):  Container(),
                            SizedBox(width: Configuration.verticalspacing*2),
                            
                            widget.content.createdBy != null && widget.content.createdBy['nombre'] != null 
                            ? createdByChip(widget.content.createdBy)
                            : Container(),
                          ],
                        ),
                      ],
                    ) : Container(),

                    widget.content.isMeditation() ?
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            /*Text(
                                _meditationstate.bells != null && _meditationstate.bells.length > 0 ? 
                                getBellString(bells:_meditationstate.bells) :
                                'No interval bells added',
                                style: Configuration.text('small',Colors.black,font: 'Helvetica'),
                            )*/

                            Container(
                              child: ElevatedButton(
                                style: OutlinedButton.styleFrom(
                                  padding: EdgeInsets.all(Configuration.smpadding),
                                  backgroundColor: Colors.white,
                                  side: BorderSide(color: Colors.lightBlue),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                                onPressed: ()=>{
                                  showModalBottomSheet(
                                  barrierColor: Colors.black.withOpacity(0.5),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(top: Radius.circular(Configuration.borderRadius/2)),
                                  ),
                                  context: context, 
                                  builder: (context){
                                    return Container(
                                      padding: EdgeInsets.all(Configuration.smpadding),
                                      child: IntervalBells(time: getTime(widget.content))
                                    );
                                  }).then((value) => setState((){}))
                              }, child: Text('Add Interval Bells', style: Configuration.text('small',Colors.lightBlue))
                              ),
                            )
                          ],
                        ),
                      ],
                    )
                    : Container(),

                    SizedBox(height: Configuration.verticalspacing)
                  
                  ],
                ),
              ),
              Column(
                mainAxisSize:MainAxisSize.min,
                children: [
                  BaseButton(
                    filled: true,
                    margin: true,
                    textcolor: Colors.white,
                    text: 'Start ' + (
                      widget.content.isVideo() ? 'Video' :  
                      widget.content.isMeditation() ? 'Meditation' : 
                      'Lesson'
                    ),
                    onPressed: () async {
                      if(widget.content.isMeditation()){
                        _meditationstate.selmeditation = widget.content;

                        if(_meditationstate.selmeditation.report != null){
                          _meditationstate.selmeditation.report = null;
                        }
                        
                        _meditationstate.createIntervalBells();
                      }

                      Navigator.pushReplacement(
                        context, 
                        PageRouteBuilder(
                            pageBuilder: (context, animation1, animation2){
                              if(widget.content.isMeditation()){
                                if(checkMedhasPreText(widget.content)){
                                  return PreMeditationScreen(
                                    then:widget.then,
                                    meditation:widget.content
                                  );
                                }else{                 
                                  return CountDownScreen(
                                    then:widget.then,
                                    content: widget.content,
                                  );
                                }
                              }else if(widget.content.isVideo()) {
                                return VideoScreen(video:widget.content);
                              }else if(widget.content.isRecording()){
                                return CountDownScreen(
                                  then: widget.then,
                                  content: widget.content,
                                );
                              // FALTA HACER UNA PARA ARTICULOS
                              }else  {
                                return LessonView(
                                  lesson: widget.content, 
                                  stage: widget.stage,
                                  path: widget.path
                                );
                              }
                            },
                            transitionDuration: Duration.zero,
                            reverseTransitionDuration: Duration.zero,
                        ),
                      ).then((d){
                        if(widget.then != null){widget.then(d);}
                      });
                    }
                ),

                  
                ],
              )
            ],
          ),
        ),
      ])
    );
  }
}


class VideoScreen extends StatefulWidget {
  FileContent video;

  VideoScreen({this.video}) : super();

  @override
  State<VideoScreen> createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  VideoPlayerController controller;
  UserState _userstate;

  int start = 0;
  int endSeconds = 0;

  bool started = false;

  bool loaded = false;

  bool isPlaying = false;

  Duration position,totalDuration;

  bool isFullScreen = true;

  double _aspectRatio = 16/9;
  ChewieController chewiController;
  bool hasFinished = false;

  bool disposed = false;

  void loadController()  async{
    controller = new VideoPlayerController.network(widget.video.file);
    await controller.initialize();

    loaded = true;
    totalDuration = controller.value.duration;
    _aspectRatio = controller.value.aspectRatio;
    position = Duration(seconds: 0);
    endSeconds = controller.value.duration.inSeconds;

    chewiController = ChewieController(
      allowedScreenSleep: false,
      allowFullScreen: true,
      showOptions: false,
      showControlsOnInitialize: true,
      deviceOrientationsAfterFullScreen: [
        DeviceOrientation.landscapeRight,
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ],
      videoPlayerController: controller,
      aspectRatio: _aspectRatio,
      autoInitialize: true,
      autoPlay: false,
    );

     if(_userstate.user.contentDone.length > 0){ 
      DoneContent content = _userstate.user.contentDone.firstWhere((element) => element.cod == widget.video.cod,
        orElse: (){}
      );

      if(content != null && content.done != null && content.done.inSeconds < widget.video.total.inSeconds-30){
        controller.seekTo(content.done);
        chewiController.seekTo(content.done);
      }
    }  

    chewiController.addListener(() {
      if (chewiController.isFullScreen) {
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp, 
          DeviceOrientation.landscapeLeft,
          DeviceOrientation.landscapeRight,
          DeviceOrientation.portraitDown  
        ]);    
       } else {
         SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp,
          DeviceOrientation.portraitDown,
        ]);
      }
    });


    controller.addListener(() {
      if(!disposed && controller.value.position.inSeconds >= widget.video.total.inSeconds - 30){
        setState(() {
          hasFinished = true;
        });
      }
    });

    setState(() {});

  }

  @override 
  void initState(){
    super.initState();
   // SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.landscapeLeft,DeviceOrientation.landscapeRight]);    
  }

  void finish(){
    _userstate.finishContent(widget.video,controller.value.position,totalDuration);

    if(hasFinished && widget.video.stagenumber != null) _userstate.takeLesson(widget.video);
  }

  @override
  void didChangeDependencies(){
    super.didChangeDependencies();
    _userstate = Provider.of<UserState>(context);
    Wakelock.enable();
    loadController();
  }

  Widget video(){
    return GestureDetector(
      onTap: ()=> {          
        if(controller.value.isPlaying && false){
          setState((){ controller.pause();})
        }else{
          setState((){started = true; controller.play();})
        }
      },
      child: Container(
        height: Configuration.width,
        child: AspectRatio(
          aspectRatio: _aspectRatio,
          child: Stack(children:[
            Chewie(controller: chewiController) 
          ]),
        ),
      )
    );
  }

  @override
  void dispose(){
    super.dispose();
    disposed = true;
    Wakelock.disable();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);    
    controller.dispose();
    chewiController.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    _userstate = Provider.of<UserState>(context);

    return Scaffold(
      backgroundColor: Configuration.maincolor,
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light, // For Android (dark icons)
          statusBarBrightness: Brightness.dark, // For iO
        ),
        backgroundColor: Configuration.maincolor,
        leading: ButtonClose(
          color:Colors.white,
          onPressed: (){
            if(hasFinished){
              finish();    
              Navigator.pop(context);
            }else{
              showAlertDialog(
                context:context,
                title: 'Are you sure you want to exit ?',
                text: '',
                onYes: (){
                  finish();
                  //Navigator.pop(context);
                }
              );
            }
          },
        ),
        elevation: 0,
      ),
      body: containerGradient(
        child: ListView(
          physics: ClampingScrollPhysics(),
          children: [
            SizedBox(height: Configuration.verticalspacing*2),
            
            loaded ?
            Column(
              children: [
                video(),
                Padding(
                  padding: EdgeInsets.all(Configuration.smpadding),
                  child: Column(
                    crossAxisAlignment:CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      SizedBox(height: Configuration.verticalspacing*1.5),
                      Text(widget.video.title,style: Configuration.text('medium',Colors.white),textAlign: TextAlign.left),
                      SizedBox(height: Configuration.verticalspacing),
                      widget.video.description.isNotEmpty ?
                      Text(widget.video.description,style: Configuration.text('small',Colors.white,font:'Helvetica'))
                      : Container(),
                    ],
                  ),
                ),

                SizedBox(height: Configuration.verticalspacing*1.5),

                AnimatedOpacity(
                  opacity: hasFinished ? 1.0 : 0.0,
                  duration: Duration(milliseconds: 500),
                  child: BaseButton(
                    text: 'Finish',
                    color: Colors.white,
                    textcolor: Colors.white,
                    onPressed: (){
                      finish();
                      Navigator.pop(context);
                    },
                  ),
                ),

                SizedBox(height: Configuration.verticalspacing*2),
              ],
            )
            : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: CircularProgress(color: Colors.white),
                ),
              ],
            )
        ])
      ),
    );
  }
}



// HAY QUE CREAR UN  SLIDER DEFAULT ???







// esto porque esta aqui???
class LessonView extends StatefulWidget {
  Lesson lesson;
  NetworkImage slider;
  Stage stage;
  List<Content> path;

  LessonView({ this.lesson, this.stage, this.slider, this.path });

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
  CarouselController controller = new CarouselController();
  ScrollController scrollController = new ScrollController();


  // AQUÍ HABRÍA QUE PONER VISTA LECCIÓN ???
  Widget vistaLeccion() {
    return CarouselSlider.builder(
      carouselController: controller,
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
            controller: scrollController,
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
              
              SizedBox(height: Configuration.verticalspacing*6),
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
                Duration(seconds: 3),
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

  Widget nextLessonWidget(){
    Content nextLesson = widget.path != null && widget.path.length > widget.lesson.position + 1 ? widget.path[widget.lesson.position+1]: 
    widget.stage != null &&  widget.stage.path.length > widget.lesson.position + 1 ? widget.stage.path[widget.lesson.position+1] : 
    null;

    Widget closeLessonButton(){
      return OutlinedButton(
        onPressed: (){
          _userstate.takeLesson(widget.lesson);
          Navigator.pop(context);
        },
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Configuration.borderRadius),
          ),
          side: BorderSide(
            color: Colors.red,
            width: 2
          )
        ),
        child: Text('End',
          style: Configuration.text('tiny',Colors.red)
        )
      );
    }
    
    return Container(
      width: Configuration.width,
      child: Material(
          elevation: 2,
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: Colors.grey.withOpacity(0.5),
                  width: 2
                )
              ),
            ),
            margin: EdgeInsets.only(bottom: Configuration.verticalspacing*2),
            padding: EdgeInsets.all(Configuration.smpadding),
            child: nextLesson == null ? 
            Row(
              children: [
                Icon(Icons.check, color: Colors.green),
                SizedBox(width: Configuration.verticalspacing),
                Flexible(
                  flex: 2,
                  child: Text('You have finished the lessons in this stage',
                    style: Configuration.text('small',Colors.black)
                  ),
                ),
                
                closeLessonButton()
              ],
            ) :
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: Configuration.width*0.2,
                  child: Image.network(
                    nextLesson.image,
                    fit: BoxFit.contain,
                  )
                ),
                
                Container(
                  width: Configuration.width*0.5,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Next lesson',
                        style: Configuration.text('small',Colors.black, font: 'Helvetica')
                      ),

                      SizedBox(height: Configuration.verticalspacing),
                
                      Text(nextLesson.title,
                        style: Configuration.text('small',Colors.black)
                      )
                    ],
                  ),
                ),
    
                Column(
                  children: [
                    
                    OutlinedButton(
                      onPressed: (){
                        int count = 0;
                        _userstate.takeLesson(widget.lesson);

                        if(nextLesson.isLesson()){
                         Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context){
                              return LessonView(
                                lesson: nextLesson,
                                path: widget.path,
                                stage: widget.stage,
                                slider: widget.slider
                              );
                            }),
                            (route) => route.isFirst
                          );
                        } else {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context){
                              return VideoScreen(
                                video: nextLesson,
                              );
                            }),
                            (route) => route.isFirst
                          );
                        }
                      },
                      style: OutlinedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(Configuration.borderRadius),
                        ),
                        side: BorderSide(
                          color: Colors.green,
                          width: 2
                        )
                      ),
                      child: Text('Next',
                        style: Configuration.text('tiny',Colors.green)
                      )
                    ),

                    // CLOSE 
                    closeLessonButton()

                  ],
                )
                
              ],
            ),
          ), 
      ),
    );
}
  
  
  @override
  void didChangeDependencies() {
    if(widget.lesson.text.length == 1){
      scrollController.addListener(() {
        if (scrollController.position.atEdge) {
          if(!reachedend){
            Future.delayed(
              Duration(seconds: 3),
              () => setState(() => reachedend = true)
            );
          }
        }
      });
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
            text: "This lesson will not be saved"
        )),
        backgroundColor: Configuration.lightgrey,
        elevation: 0,
      ),
      extendBodyBehindAppBar: false,
      body: WillPopScope(
        onWillPop: () {
          bool pop= true;


          showAlertDialog(
            title: 'Are you sure you want to exit ?',
            context: context,
            text: "This lesson will not be saved",

            onNo: ()=> pop = false,
          );
          
          
          return Future.value(pop);
        },
        child: Stack(children: [
          vistaLeccion(),
          
          widget.lesson.text.length > 1 ? 
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              decoration: BoxDecoration(
                color: Configuration.lightgrey,
                border: Border(
                  top: BorderSide(
                    color: Colors.grey.withOpacity(0.5),
                    width: 1
                  )
                ),
              ),
              child: Container(
                margin: EdgeInsets.only(left:15, right:15, bottom: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // ARROWS FOR LEFT RIGHT AND SKIP
                    Row(
                      children: [
                        IconButton(
                          icon: Icon(Icons.arrow_back_ios),
                          iconSize: Configuration.smicon,
                          color: _index == 0 ? Colors.grey : Colors.black,
                          onPressed: () {
                            if(_index > 0){
                              setState(() {
                                controller.jumpToPage(--_index);
                              });
                            }
                          },
                        ),
              
              
                        IconButton(
                          icon: Icon(Icons.arrow_forward_ios),
                          iconSize: Configuration.smicon,
                          color: _index < widget.lesson.text.length - 1 ? Colors.black : Colors.grey,
                          onPressed: () {
                            if( _index < widget.lesson.text.length - 1){
                              setState(() {
                                controller.jumpToPage(++_index);
                              });
                            }
                          },
                        ),
                      ],
                    ),
                      
                    IconButton(
                      icon: Icon(Icons.skip_next),
                      iconSize: Configuration.smicon,
                      color: Colors.black,
                      onPressed: () {
                        setState(() {
                          controller.jumpToPage(widget.lesson.text.length - 1);
                        });
                      },
                    ),
                  ],
                ),
              ),
            )
          ): Container(),

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
        
        
          Positioned(
            bottom: 0,
            right: 0,
            left: 0,
            child: AnimatedSlide(
              offset: reachedend ? Offset(0, 0): Offset(0,1),
              duration: Duration(milliseconds: 500),
              child: nextLessonWidget())
          )
        ]),
      )
    );
  }
}
