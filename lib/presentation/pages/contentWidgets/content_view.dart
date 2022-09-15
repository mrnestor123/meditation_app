
// WIDGET COMÚN DE VISTA DE CONTENIDO
// SE PODRÁN VER LECCIONES Y MEDITACIONES, Y EDITAR 
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:meditation_app/domain/entities/content_entity.dart';
import 'package:meditation_app/domain/entities/lesson_entity.dart';
import 'package:meditation_app/domain/entities/meditation_entity.dart';
import 'package:meditation_app/presentation/mobx/actions/meditation_state.dart';
import 'package:meditation_app/presentation/mobx/actions/user_state.dart';
import 'package:meditation_app/presentation/pages/commonWidget/alert_dialog.dart';
import 'package:meditation_app/presentation/pages/commonWidget/circular_progress.dart';
import 'package:meditation_app/presentation/pages/commonWidget/date_tostring.dart';
import 'package:meditation_app/presentation/pages/commonWidget/meditation_modal.dart';
import 'package:meditation_app/presentation/pages/commonWidget/start_button.dart';
import 'package:meditation_app/presentation/pages/commonWidget/user_bottom_dialog.dart';
import 'package:meditation_app/presentation/pages/config/configuration.dart';
import 'package:meditation_app/presentation/pages/contentWidgets/meditation_screens.dart';
import 'package:meditation_app/presentation/pages/contentWidgets/meditation_widgets.dart';
import 'package:meditation_app/presentation/pages/learn_screen.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

import '../commonWidget/profile_widget.dart';


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
                        if(c.isMeditation()){
                          //_meditationstate.selectMeditation(c);
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


class ContentFrontPage extends StatelessWidget {
  Content content;
  dynamic then;

  ContentFrontPage({this.content,this.then}) : super();

  checkMedhasPreText(Meditation m){
    return m.content.entries != null && m.content.entries.length > 0;
  }

  @override
  Widget build(BuildContext context) {
    final  _meditationstate = Provider.of<MeditationState>(context);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar:AppBar(
        backgroundColor: Colors.transparent,
        elevation:0,
        leading: CloseButton(
          color: Colors.black,
        ),
      ),
      body: Column(children: [
        content.image != null && content.image.isNotEmpty
        ? Hero(
            tag: content.cod,
            child: Container(
              color:Colors.white,
              height: Configuration.height*0.6,
              child: Center(
                child: CachedNetworkImage(
                  imageUrl: content.image,
                  placeholder: (context, url) => Container(
                    height: Configuration.height * 0.4,
                    width: Configuration.width,
                    color: Colors.grey.withOpacity(0.5),
                  ),
                  width: Configuration.width,
                  height: content.type == 'meditation-practice' ? Configuration.height*0.3: Configuration.height * 0.6,
                  fit: BoxFit.contain,
                ),
              ),
            )
          )
        : Container(
          color: Configuration.lightgrey,
          height: Configuration.height * 0.6
        ),

        Expanded(
          child: Container(
            width: Configuration.width,
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.topLeft,
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: Configuration.smpadding,
                      right: Configuration.smpadding,
                      top: Configuration.medpadding),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(content.title,
                          textAlign: TextAlign.left,
                          style: Configuration.text('big', Colors.black)),
                        SizedBox(height: Configuration.verticalspacing),
                        Text(content.description != null ? content.description : '',
                          textAlign: TextAlign.left,
                          style: Configuration.text('small',Colors.grey,font: 'Helvetica'),
                        ),
                        SizedBox(height: Configuration.verticalspacing),
                        content.isMeditation() || content.createdBy != null ?
                        Row(
                          children: [
                            TimeChip(c:content),
                            SizedBox(width: Configuration.verticalspacing*2),
                            content.createdBy != null ? 
                              GestureDetector(
                                onTap: ()=>{
                                  showUserProfile(usercod: content.createdBy['coduser'], isTeacher: true)
                                },
                                child: Chip(
                                  backgroundColor: Colors.lightBlue,
                                  avatar: ProfileCircle(userImage: content.createdBy['image'], width: Configuration.smicon, bordercolor: Colors.white),
                                  label: Text('Created by ' + content.createdBy['nombre'], style: Configuration.text('small', Colors.white),),
                                )
                              ) : Container(),
                          ],
                        )
                        : Container()
                      ],
                    ),
                  ),
                ),
                Align(
                  alignment:Alignment.bottomCenter,
                  child: Column(
                    mainAxisSize:MainAxisSize.min,
                    children: [
                      BaseButton(
                        margin: true,
                        text: 'Start ' + (content.type== 'meditation-practice' ? 'Meditation' : 'Lesson'),
                        onPressed: () async {
                          Navigator.pushReplacement(
                            context, 
                            PageRouteBuilder(
                                pageBuilder: (context, animation1, animation2){
                                  if(content.isMeditation()){
                                    if(checkMedhasPreText(content)){
                                      return PreMeditationScreen(
                                        then:then,
                                        meditation:content
                                      );
                                    }else{                 
                                      return CountDownScreen(
                                        then:then,
                                        content: content,
                                      );
                                    }
                                  }else if(content.isVideo()) {
                                    //return VideoScreen(video:content);
                                    // HAY QUE CREAR LA VISTA DE VIDEO AÚN !!
                                    return LessonView(lesson: content);
                                  }else{
                                    return LessonView(lesson: content);
                                  }
                                },
                                transitionDuration: Duration.zero,
                                reverseTransitionDuration: Duration.zero,
                            ),
                          ).then((d){
                            if(then != null){then(d);}
                          });
                        }
                      ),
                      SizedBox(height: Configuration.verticalspacing*2)
                    ],
                  )
                )
              ],
            ),
          ),
        )
      ])
    );
  }
}



/*
class VideoScreen extends StatefulWidget {
  Content video;

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


  void  loadController()  async{
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
      dynamic content = _userstate.user.contentDone.firstWhere((element) => element.cod == widget.video.cod,
        orElse: (){}
      );

      if(content != null && content.done != null && content.done.inMinutes < widget.video.total.inMinutes){
        //controller.seekTo(content.done);
       // chewiController.seekTo(content.done);
      }
    }  

    chewiController.addListener(() {
      if (chewiController.isFullScreen) {
        SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.landscapeLeft,DeviceOrientation.landscapeRight]);    
       } else {
         SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp,
          DeviceOrientation.portraitDown,
        ]);
      }
    });


    controller.addListener(() {
      //QUITAR ESTOS SET STATE !!!!!!!!!!!!!!!!!!!!!
      if(start != controller.value.position.inSeconds){
        setState(() {});
      }

      if(controller.value.duration.inSeconds > 0 && controller.value.position == controller.value.duration) {
        setState(() {      
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

  @override
  void didChangeDependencies(){
    super.didChangeDependencies();
    _userstate = Provider.of<UserState>(context);

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
              
              /*!started && !controller.value.isPlaying ? 
              Positioned.fill(
                  child: Container(
                    color: Colors.black.withOpacity(0.9),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.play_arrow, color:Colors.white, size: Configuration.bigicon)
                      ],
                    ),
                  )
                ) : Container(),
              */
            ] ),
          ),
        )
      );
    }

  @override
  void dispose(){
    super.dispose();

    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);    

    if(controller.value.position.inSeconds > 0){
      _userstate.finishRecording(widget.video,controller.value.position,totalDuration);
    }
    controller.dispose();
    chewiController.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    _userstate = Provider.of<UserState>(context);
    print(MediaQuery.of(context).orientation);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Configuration.maincolor,
        leading: CloseButton(
          color:Colors.white,
          onPressed: (){
            showAlertDialog(
                context:context,
                title: 'Are you sure you want to exit ?',
                text: ''
              );
          },
        ),
        elevation: 0,
      ),
      body: containerGradient(
        child:Column(
          mainAxisAlignment:MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: Configuration.verticalspacing*2),
            loaded  ?
            Column(
              children: [
                video(),

                Padding(
                  padding: EdgeInsets.all(Configuration.smpadding),
                  child: Column(
                    crossAxisAlignment:CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(height: Configuration.verticalspacing*1.5),
                      Text(widget.video.title,style: Configuration.text('medium',Colors.white)),
                      SizedBox(height: Configuration.verticalspacing),
                      widget.video.description.isNotEmpty ?
                      Text(widget.video.description,style: Configuration.text('small',Colors.white,font:'Helvetica'),)
                      : Container(),
                    ],
                  ),
                ),
                SizedBox(height: Configuration.verticalspacing*1.5),


                
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
            
            /*
            SizedBox(height: Configuration.verticalspacing),

            Spacer(),

            totalDuration != null ?
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('0:00',style: Configuration.text('small',Colors.white)),
                  GestureDetector(
                    onDoubleTap: (){
                    },
                    child: Text(totalDuration.inHours.toString() + ':' + getMinutes(totalDuration),
                      style: Configuration.text('small',Colors.white)),
                  )
                ],  
              ),
            ): Container(),
            
            
            SizedBox(height: Configuration.verticalspacing/2),
            Slider.adaptive(
              activeColor: Colors.lightBlue,
              thumbColor: Colors.white,
              inactiveColor: Colors.white,
              min: 0.0,
              max: loaded ? totalDuration.inSeconds.toDouble() : 100,
              onChangeStart: (a)=>{
                //isDragging = true
              },
              onChanged: (a){
                null;
                //assetsAudioPlayer.seek(Duration(seconds: a.toInt()));
                //setState(() {});
              }, 
              value: loaded ? controller.value.position.inSeconds.toDouble() : 0,
            ),
            SizedBox(height:Configuration.verticalspacing*2),
            
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                secondaryButton(
                  Icons.replay_30, 
                  (){
                    if(controller.value.position.inSeconds > 30){
                      controller.seekTo(Duration(seconds: controller.value.position.inSeconds-30));
                    }
                    setState(() {});
                  },
                  'heroTag1'
                ),
                FloatingActionButton(
                  backgroundColor: Colors.white,
                  onPressed: () {
                    if(isPlaying){
                      controller.pause(); 
                    }else{
                      controller.play();
                    }
                    isPlaying =  !isPlaying;
                  },
                  child: Icon(
                    isPlaying ? Icons.pause  : Icons.play_arrow, 
                    color: Colors.black,
                    size: Configuration.smicon,
                  )
                ),


                  secondaryButton(
                  Icons.forward_30, 
                  (){
                    if(controller.value.position.inSeconds > 30){
                      controller.seekTo(Duration(seconds: controller.value.position.inSeconds+30));
                    }
                    setState(() {});
                  },
                  'heroTag2'
                  ),

              ]
            ),     
            
            */

          ],
        
          )
      ),
    );
  }
}
*/


// HAY QUE CREAR UN  SLIDER DEFAULT ???





