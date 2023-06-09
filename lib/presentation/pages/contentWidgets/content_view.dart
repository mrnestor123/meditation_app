
// WIDGET COMÚN DE VISTA DE CONTENIDO
// SE PODRÁN VER LECCIONES Y MEDITACIONES, Y EDITAR 
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meditation_app/domain/entities/content_entity.dart';
import 'package:meditation_app/domain/entities/meditation_entity.dart';
import 'package:meditation_app/presentation/mobx/actions/meditation_state.dart';
import 'package:meditation_app/presentation/mobx/actions/user_state.dart';
import 'package:meditation_app/presentation/pages/commonWidget/alert_dialog.dart';
import 'package:meditation_app/presentation/pages/commonWidget/circular_progress.dart';
import 'package:meditation_app/presentation/pages/commonWidget/meditation_modal.dart';
import 'package:meditation_app/presentation/pages/commonWidget/start_button.dart';
import 'package:meditation_app/presentation/pages/commonWidget/user_bottom_dialog.dart';
import 'package:meditation_app/presentation/pages/config/configuration.dart';
import 'package:meditation_app/presentation/pages/contentWidgets/meditation_screens.dart';
import 'package:meditation_app/presentation/pages/contentWidgets/meditation_widgets.dart';
import 'package:meditation_app/presentation/pages/learn_screen.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:wakelock/wakelock.dart';

import '../../../domain/entities/lesson_entity.dart';
import '../commonWidget/back_button.dart';
import '../commonWidget/profile_widget.dart';

/*
class ContentShow extends StatefulWidget {
  Content content;
  Meditation m;
  Lesson l;

  //NO ESTOY MUY SEGURO DE ESTO !!!
  ContentShow({this.content, this.m, this.l}) : super();

  @override
  _ContentShowState createState() => _ContentShowState();
}

/*
  SE PODRÁ VER MEDITACIONES,LECCIONES Y EDITARLAS
*/
class _ContentShowState extends State<ContentShow> {

  bool started = false;

  bool isMeditation;

  String type;
  AssetsAudioPlayer player = new AssetsAudioPlayer();
  VideoPlayerController controller;
  bool initialized = false;

  String text = '';

  MeditationState _meditationstate;


  @override
  void didChangeDependencies(){
    super.didChangeDependencies();

    if(widget.content.isMeditation()){
      isMeditation = true;
      text = 'This meditation will not count';
      type = 'Meditation';
    }else{
      text = "This lesson will not count as a read one";
      isMeditation = false;
      type = 'Lesson';
    }
  }

  Widget portada({Content c}) {
    return Column(children: [
      widget.content.image != null && widget.content.image.isNotEmpty ?
      Image.network(
          widget.content.image,
          width: Configuration.width,
          height: Configuration.height*0.6,
          fit: BoxFit.cover,
      ) : Container(color: Configuration.lightgrey, height: Configuration.height * 0.6),
      Expanded(
        child: Container(
          width: Configuration.width,
          child: Stack(
            children: [
              Align(
                alignment: Alignment.topLeft,
                  child: Padding(
                  padding: EdgeInsets.only(
                      left: Configuration.smpadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(height: Configuration.verticalspacing*2),
                      Text(widget.content.title,textAlign: TextAlign.left,
                        style: Configuration.text('smallmedium', Colors.black)),
                      SizedBox(height: Configuration.verticalspacing),
                      Text(widget.content.description,
                        style:Configuration.text('small',Colors.grey)
                      )
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    BaseButton(
                      margin:true,
                      text:'Start ' + type,
                      onPressed: () async{
                        print('QUE P ASA AQUI');
                        if(c.isMeditation()){
                          //_meditationstate.selectMeditation(c);
                        }

                        if(c.isLesson()){
                          print('CHANGING SYSTEMCHROME');

                          SystemChrome.setEnabledSystemUIMode(
                            SystemUiMode.immersive
                          );
                        }
                        setState(() => started = true);
                      } 
                    ),
                    SizedBox(height: Configuration.verticalspacing*1.5)
                  ],
                )
              )
            ],
          ),
        ),
      )
    ]);
  }

  Widget meditation(Content c){
    
    Widget finishedScreen(){
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(child: Text('The meditation has ended', style: Configuration.text('small',Colors.black))),
          SizedBox(height: Configuration.verticalspacing),
          Text('Thank you for helping make this app better',style: Configuration.text('small',Colors.black))
        ],
      );
    }

    List<Widget> mapToWidget(map){  
     List<Widget> l = new List.empty(growable: true);
     l.add(SizedBox(height: 30));
      
      if (map['title'] != null) {
        l.add(Center(child: Text(map['title'],style: Configuration.text('medium', Colors.white))));
        
        l.add(SizedBox(height:15));
      }

      if (map['image'] != null) {
        l.add(ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Image(image: CachedNetworkImageProvider( map['image']), width: Configuration.width*0.6)));
      }

      if (map['text'] != null) {
        l.add(SizedBox(height:15));
        l.add(Text(map['text'],
            style: Configuration.text('small', Colors.white,font:'Helvetica')));
      }

      if(map['html'] != null){
        l.add(SizedBox(height: 15));
        l.add(Center(child: Html(data: map['html'],
        style: {
          "body": Style(color: Colors.white,fontSize: FontSize(18)),
          "li": Style(margin: EdgeInsets.symmetric(vertical: 10.0)),
          "h2":Style(textAlign: TextAlign.center)
        })));
      }

    return l;
    
  }

    Widget slider(){
      return Slider(
        activeColor: Configuration.maincolor,
        inactiveColor: Colors.white,
        min: 0.0,
        max: _meditationstate.totalduration.inSeconds.toDouble(),
        onChanged: (a)=> null, 
        value: _meditationstate.totalduration.inSeconds - _meditationstate.duration.inSeconds.toDouble() ,
        label:  _meditationstate.duration.inHours > 0
              ? _meditationstate.duration.toString().substring(0, 7)
              : _meditationstate.duration.toString().substring(2, 7)
      );
    }

    Widget pauseButton(){
      return  FloatingActionButton(
      backgroundColor: Colors.white,
      onPressed: () => setState(()=> _meditationstate.state == 'started' ? _meditationstate.pause() :  _meditationstate.startTimer()),
      child: Icon(_meditationstate.state == 'started' ?  Icons.pause  : Icons.play_arrow, color: Colors.black)
      );           
    }

    Widget freeMeditation(){
      return Center(
        child: Container(
          height: Configuration.blockSizeHorizontal * 60,
          width: Configuration.blockSizeHorizontal * 60,
          decoration: BoxDecoration(color: Configuration.grey, borderRadius: BorderRadius.circular(12.0)),
          child: Center(
            child:GestureDetector(
              onDoubleTap: (){ _meditationstate.finishMeditation();}, 
              child:Text('free meditation', style:Configuration.text('smallmedium', Colors.white))
            )
          ),
        ),
      );
    }

    Widget guidedMeditation(){
      return Align(
        alignment:Alignment.center,
        child: Padding(
          padding: EdgeInsets.all(Configuration.smpadding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: 
               _meditationstate.currentsentence != null ?  
                mapToWidget(_meditationstate.currentsentence)
                : 
               [
                 ClipRRect(
                    borderRadius: BorderRadius.circular(12.0),
                    child: Image(image: CachedNetworkImageProvider(_meditationstate.selmeditation.image),
                    height: Configuration.height*0.35,
                    width: Configuration.height*0.35
                    ),
                  ),
                SizedBox(height: Configuration.blockSizeVertical*3),
                GestureDetector(
                  onDoubleTap: (){
                    _meditationstate.finishMeditation();
                  }, 
                  child: Text(_meditationstate.selmeditation.title,style: Configuration.text('smallmedium',Colors.white))
                )
              ],
          ),
        ),
      );
    }

    Widget video(){
      return Container(
          //height: showfullscreen ? Configuration.height : Configuration.width / controller.value.aspectRatio,
         // width:!showfullscreen ? Configuration.width : Configuration.height * controller.value.aspectRatio,
         // ESTO ESTA BIEN ???
          height: (Configuration.width *0.9) / _meditationstate.videocontroller.value.aspectRatio,
          width: (Configuration.height * 0.9) *  _meditationstate.videocontroller.value.aspectRatio,
          child: VideoPlayer(_meditationstate.videocontroller)
      );
    }

    Widget meditating(){
      return Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: _meditationstate.hasVideo && _meditationstate.videocontroller.value.duration.inSeconds > 0 ? 
              video() :
              AspectRatio(
                aspectRatio:1,
                child: Container(
                  margin:EdgeInsets.all(Configuration.smpadding),
                  width: Configuration.width*0.6,
                  decoration: BoxDecoration(
                    borderRadius:BorderRadius.circular(Configuration.borderRadius),
                    color:Colors.grey
                  ),
                ),
            )
          ),

          Positioned(
            bottom: 20,
            right:10,
            left:10,
            child: Column(
            children: [
              pauseButton(),
              SizedBox(height:Configuration.verticalspacing),
              slider()
            ]),
          ),
        /*
        _meditationstate.shadow ? 
        Positioned.fill(
          child: GestureDetector(
            onTap: () {
              _meditationstate.light();
            },
            child: Container(
              decoration: BoxDecoration(color:Colors.black.withOpacity(0.9))
            ),
          ),
        ): Container(), 

        _meditationstate.selmeditation != null ? guidedMeditation(): freeMeditation()
        */

      ]);


    }

    return Observer(builder: (context) { 
      return _meditationstate.state == 'finished' ? finishedScreen() : meditating();
    });
  }

  @override
  Widget build(BuildContext context) {
    _meditationstate = Provider.of<MeditationState>(context);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar:AppBar(
        // ESTO HABRÁ QUE HACERLO PARA LOS DOS
        leading: Container(
          padding: EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: Configuration.lightgrey,
          ),
          child: CloseButton(
              color: Colors.black,
              onPressed: () { 
                if(_meditationstate.state != 'finished') {
                  showAlertDialog(
                    title: 'Are you sure you want to exit ?',
                    context: context,
                    text: text
                  );
              }else{ 
                Navigator.pop(context);
              }}
            ),
        ),
          backgroundColor: Colors.transparent,
          elevation: 0,
      ),
      body:!started ? portada(c:widget.content): 
        widget.content.isMeditation() ? meditation(widget.content):
        Container()
    );
  }
}
*/


// IR SIEMPRE A CONTENTFRONTPAGE AUNQUE SEA RECORDING
class ContentFrontPage extends StatefulWidget {
  Content content;
  dynamic then;

  ContentFrontPage({this.content,this.then}) : super();

  @override
  State<ContentFrontPage> createState() => _ContentFrontPageState();
}

class _ContentFrontPageState extends State<ContentFrontPage> {
  
  checkMedhasPreText(Meditation m){
    return m.content.entries != null && m.content.entries.length > 0;
  }

  bool hasBells(Meditation m){
    return m.meditationSettings.bells != null && m.meditationSettings.bells.length > 0;
  }

  Duration getTime(FileContent f){
    return f.total;
  }

  void cacheImages(Lesson lesson){
    print('CACHING LESSON IMAGES');
    lesson.text.forEach((slide) {
      if (slide['image'] != '') {
        print({'CACHING',slide['image']});
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
      appBar:AppBar(
        systemOverlayStyle: SystemUiOverlayStyle(
          // Status bar color
          statusBarColor: Colors.white, 
          // Status bar brightness (optional)
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
                ),
              ),
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

                    widget.content.isMeditation() || widget.content.createdBy != null ?
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TimeChip(c:widget.content),
                            SizedBox(width: Configuration.verticalspacing*2),
                            widget.content.createdBy != null ? 
                              Container(
                                constraints: BoxConstraints(
                                  maxWidth: Configuration.width*0.6
                                ),
                                child: GestureDetector(
                                  onTap: ()=>{
                                    showUserProfile(usercod: widget.content.createdBy['coduser'], isTeacher: true)
                                  },
                                  child: Chip(
                                    padding: EdgeInsets.all(Configuration.tinpadding),
                                    backgroundColor: Colors.lightBlue,
                                    avatar: ProfileCircle(
                                      userImage: widget.content.createdBy['image'], 
                                      width: Configuration.verticalspacing*4, 
                                      bordercolor: Colors.white),
                                    label: Text('Created by ' + widget.content.createdBy['nombre'], style: Configuration.text('small', Colors.white),),
                                  )
                                ),
                              ) : Container(),
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
                            ),


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
                    margin: true,
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
                              }else{
                                return LessonView(lesson: widget.content);
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
                    textcolor: Colors.black,
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





