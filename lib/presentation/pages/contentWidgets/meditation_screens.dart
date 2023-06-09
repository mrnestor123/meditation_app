

// SCREEN POST MEDITATION  !!!



import 'dart:async';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:audio_service/audio_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meditation_app/login_injection_container.dart';
import 'package:meditation_app/presentation/pages/commonWidget/alert_dialog.dart';
import 'package:meditation_app/presentation/pages/commonWidget/back_button.dart';
import 'package:meditation_app/presentation/pages/commonWidget/date_tostring.dart';
import 'package:meditation_app/presentation/pages/commonWidget/dialog.dart';
import 'package:meditation_app/presentation/pages/contentWidgets/meditation_widgets.dart';
import 'package:provider/provider.dart';
import 'package:wakelock/wakelock.dart';

import '../../../domain/entities/audio_handler.dart';
import '../../../domain/entities/content_entity.dart';
import '../../../domain/entities/local_notifications.dart';
import '../../../domain/entities/meditation_entity.dart';
import '../../mobx/actions/meditation_state.dart';
import '../../mobx/actions/user_state.dart';
import '../commonWidget/carousel_balls.dart';
import '../commonWidget/html_towidget.dart';
import '../commonWidget/start_button.dart';
import '../config/configuration.dart';
import '../meditation_screen.dart';

// HAY Q UE QUITAR LOS  SYSTEMCHROME DE AQUI

class MeditationEndedScreen extends StatefulWidget {
  Meditation meditation;

  MeditationEndedScreen({ Key key, this.meditation}) : super(key: key);

  @override
  State<MeditationEndedScreen> createState() => _MeditationEndedScreenState();
}

class _MeditationEndedScreenState extends State<MeditationEndedScreen> {
  bool addedNote;
  UserState _userstate;


  Widget stat(String title, String value){
    return Container(
      margin: EdgeInsets.only(bottom: Configuration.verticalspacing),
      child: Column(
        children: [
          Text(value, style: Configuration.text('subtitle', Colors.black)),
          SizedBox(height: Configuration.verticalspacing/2),
          Text(title.toUpperCase(), style: Configuration.text('tiny', Colors.black, font: 'Helvetica')),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _userstate = Provider.of<UserState>(context);

    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        ),
        elevation: 0,
        leading: ButtonClose(
          onPressed:(){
            SystemChrome.setEnabledSystemUIMode(
              SystemUiMode.manual, 
              overlays: [
                SystemUiOverlay.bottom,
                SystemUiOverlay.top
              ]
            );
            Navigator.pop(context);
          },
          color: Colors.white,
        ),
        backgroundColor: Colors.transparent
      ),
      extendBodyBehindAppBar: true,
      body: containerGradient(
        child: ListView(
          physics: ClampingScrollPhysics(),
          children: [
            Container(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height - 100
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: Configuration.smpadding),
                    padding: EdgeInsets.all(Configuration.smpadding),
                    decoration: BoxDecoration(
                      color: Configuration.boxBackground,
                      borderRadius: BorderRadius.circular(Configuration.borderRadius/3),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 10,
                          offset: Offset(0, 5), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                        WeekList(),
                        SizedBox(height: Configuration.verticalspacing*3),

                        Text('Congratulations!', style: Configuration.text('subtitle', Colors.black)),

                        _userstate.user.userStats.streak > 1 ? 
                        Container(
                          margin: EdgeInsets.only(
                            top: Configuration.verticalspacing
                          ),
                          child: Text(_userstate.user.userStats.streak.toString() + ' consecutive days', 
                            style: Configuration.text('subtitle', Colors.black)),
                        ) 
                          
                        : Container(),
                        SizedBox(height: Configuration.verticalspacing),

                        
                        // minutes text
                        Text('You completed a ' + widget.meditation.duration.inMinutes.toString() + ' min meditation', 
                          style: Configuration.text('small', Colors.black)
                        ),

                        SizedBox(height: Configuration.verticalspacing*1),
                        
                        


                        
                        SizedBox(height: Configuration.verticalspacing*2),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            
                            stat(
                              'Total meditations',
                              (_userstate.user.userStats.doneMeditations > _userstate.user.totalMeditations.length 
                                  ? _userstate.user.userStats.doneMeditations.toString() 
                                  : (_userstate.user.totalMeditations.length).toString())
                            ),
                            stat(
                              'Total time',
                              _userstate.user.timemeditated
                             
                            ),
                          ],
                        ),
                        
                    ],
                  ),
                ),

                SizedBox(height: Configuration.verticalspacing*1.5),
               
                
                widget.meditation.report == null ?
                BaseButton(
                  text: 'Write a meditation report',
                  color: Configuration.maincolor,
                  bordercolor: Colors.white,
                  textcolor: Colors.white,
                  onPressed: ()=>{
                    // set preferred layout
                    SystemChrome.setEnabledSystemUIMode(
                      SystemUiMode.manual, 
                      overlays: [
                        SystemUiOverlay.bottom,
                        SystemUiOverlay.top
                      ]
                    ),

                    Navigator.push(
                      context, 
                      PageRouteBuilder(
                      transitionDuration: Duration.zero,
                      reverseTransitionDuration: Duration.zero,
                      pageBuilder: (context,_,__) => AddReport(
                        guided: widget.meditation.title != null

                      ))
                      
                    ).then((value) => 
                      setState(() {  
                        
                      })
                    )
                  }
                ) : 
                Padding(
                  padding: EdgeInsets.all(Configuration.smpadding),
                  child: MeditationReportWidget(m: widget.meditation.report),
                )
              ]),
            ),
          ],
        )
      ),
    );
  }
}

class MeditationReportWidget extends StatelessWidget {
  const MeditationReportWidget({
    Key key,
    @required this.m,
  }) : super(key: key);

  final MeditationReport m;

  @override
  Widget build(BuildContext context) {

    Widget textComponent(String title, String text){
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            flex: 2,
            child: Text(title, 
              style: Configuration.text('small', Colors.black),
            ),
          ),
          SizedBox(width: Configuration.verticalspacing),
          Flexible(
            flex: 3,
            child: Text(text, 
              style: Configuration.text('small', Colors.black, font: 'Helvetica'),
            ),
          ),
        ],
      );
    }


    return Container(
      padding: EdgeInsets.all(Configuration.smpadding),
      decoration: BoxDecoration(
        color:Configuration.lightgrey,
        borderRadius: BorderRadius.circular(Configuration.borderRadius/3),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.self_improvement,
                color:Colors.black,
                size: Configuration.smicon,
              ),
              SizedBox(width: Configuration.verticalspacing),
              Flexible(
                child: Text('Meditation Report', 
                  style: Configuration.text('subtitle', Colors.black),
                ),
              ),
            ],
          ),

          Divider(),
          
          SizedBox(height: Configuration.verticalspacing),
          m.overallSatisfaction !=  null?
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text('How were you feeling after ? ', 
                  style: Configuration.text('small', Colors.black),
                ),
              ),
              SizedBox(width: Configuration.verticalspacing),
              Column(
                children: [
                  Icon(faces[m.overallSatisfaction], color: Colors.black.withOpacity(0.6)),
                  Text(moods[m.overallSatisfaction],
                    style: Configuration.text('tiny', Colors.black,  font: 'Helvetica'),
                  )
                ],
              ),
            ],
          ) : m.feelings != null && m.feelings.isNotEmpty ?
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text('How were you feeling after ? ', 
                  style: Configuration.text('small', Colors.black),
                ),
              ),
              SizedBox(width: Configuration.verticalspacing),
              Expanded(
                child: Text(
                  m.feelings.join(' '),
                  textAlign: TextAlign.end,
                  style: Configuration.text('small', Colors.black,  font: 'Helvetica'),
                )
              ) 
            ],
          ): Container(),

          SizedBox(height: Configuration.verticalspacing),
          
          m.stage != null ?
          textComponent('Stage reached', m.stage.toString()) 
          : Container(),

          SizedBox(height: Configuration.verticalspacing),

          m.text != null && m.text.isNotEmpty ?
          textComponent('Meditation note', m.text)
          : Container(),
        ],
      ),
    );
  }
}

class AddReport extends StatefulWidget {

  final bool guided;

  const AddReport({Key key, this.guided}) : super(key: key);

  @override
  State<AddReport> createState() => _AddReportState();
}

class _AddReportState extends State<AddReport> {
  MeditationReport m = new  MeditationReport();

  @override 
  void initState(){
    super.initState();
    feelings.sort((a,b)=> a.compareTo(b));
  }

  List<String> feelings = [
    'Relaxed','Alert','Happy',
    'Sad', 'Sleepy', 'Angry', 'Tired',
    'Upset'
  ];

  List<String> distractions = [
    'Thoughts', 'Physical pain', '',
    'Emotions',  'Other'
  ];

  @override
  Widget build(BuildContext context) {
    final _userstate =  Provider.of<UserState>(context);
    final _meditationstate = Provider.of<MeditationState>(context);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        elevation: 0,
        leading: CloseButton(
          color: Colors.black,
        ),
        backgroundColor: Colors.transparent,
        title: Text('Add a report', style: Configuration.text('subtitle', Colors.black)),
      ),
      body: Container(
        color: Configuration.lightgrey,
        child: ListView(
           physics: ClampingScrollPhysics(),           
              children: [
                Container(
                  padding: EdgeInsets.all(Configuration.smpadding),
                  decoration: BoxDecoration(
                    color: Colors.grey,
                    border: Border.all(color: Colors.black.withOpacity(0.1)),
                  ),
                  child: Text('Write a report about your meditation. This will help you track your progress, reflect on your meditations and improve your practice.',
                    textAlign: TextAlign.justify,
                    style: Configuration.text('small', Colors.black, font: 'Helvetica'),
                  ),
                ),
                SizedBox(height: Configuration.verticalspacing),
                Container(
                  padding: EdgeInsets.all(Configuration.smpadding),
                  child: Center(
                    child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                      children: [
                      Text('How are you feeling?',
                        style: Configuration.text('small', Colors.black),
                      ),
                      SizedBox(height: Configuration.verticalspacing),
                      GridView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 100,
                          childAspectRatio: 2,
                          crossAxisSpacing: Configuration.verticalspacing,
                          mainAxisSpacing: Configuration.verticalspacing
                        ),
                        itemCount: feelings.length, 
                        itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: (){
                                setState(() {
                                  if(m.feelings == null){
                                    m.feelings = [];
                                  }
                                    if(m.feelings.contains(feelings[index])){
                                      m.feelings.remove(feelings[index]);
                                    }else if(m.feelings.length < 2){
                                      m.feelings.add(feelings[index]);
                                    }else{
                                      showAlertDialog(
                                        context: context,
                                        title: 'You can only select 2 feelings',
                                        yesText: 'Close',
                                        noPop: true,
                                        hideNoButton:true,
                                      );
                                    }
                                });
                              },
                            child: Container(
                              decoration: BoxDecoration(
                                color: m.feelings != null && m.feelings.contains(feelings[index]) ? Colors.lightBlue : Colors.white,
                                borderRadius: BorderRadius.circular(Configuration.borderRadius/3),
                                border: Border.all(color: Colors.grey)
                              ),
                              child: Center(
                                child: Text(feelings[index],
                                  style: Configuration.text('small', m.feelings != null && m.feelings.contains(feelings[index]) ? Colors.white : Colors.black, font: 'Helvetica'),
                                ),
                              ),
                            ),
                        );
                      }),



                      SizedBox(height: Configuration.verticalspacing*2),
/*
                      Text('What were your distractions ?',
                        style: Configuration.text('small', Colors.black),
                      ),

                      SizedBox(height: Configuration.verticalspacing),

                      GridView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 100,
                          childAspectRatio: 2,
                          crossAxisSpacing: Configuration.verticalspacing,
                          mainAxisSpacing: Configuration.verticalspacing
                        ),
                        itemCount: distractions.length, 
                        itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: (){
                                setState(() {
                                  if(m.distractions == null){
                                    m.distractions = [];
                                  }
                                    if(m.distractions.contains(distractions[index])){
                                      m.distractions.remove(distractions[index]);
                                    }else if(m.distractions.length < 3){
                                      m.distractions.add(distractions[index]);
                                    }else{
                                      showAlertDialog(
                                        context: context,
                                        title: 'You can only select 3 distractions',
                                        noText: true,
                                        buttonText: 'Close',

                                        hideYesButton: true
                                      );
                                    }
                                });
                              },
                            child: Container(
                              decoration: BoxDecoration(
                                color: m.distractions != null && m.distractions.contains(distractions[index]) ? Configuration.maincolor : Colors.white,
                                borderRadius: BorderRadius.circular(Configuration.borderRadius/3),
                                border: Border.all(color: Configuration.maincolor)
                              ),
                              child: Center(
                                child: Text(distractions[index],
                                  style: Configuration.text('small', m.distractions != null && m.distractions.contains(distractions[index]) ? Colors.white : Colors.black, font: 'Helvetica'),
                                ),
                              ),
                            ),
                        );
                      }),
  */





                      _userstate.user.userProgression.stageshown > 1 
                      && widget.guided != null && !widget.guided
                      ?
                      Container(
                        margin: EdgeInsets.only(top: Configuration.verticalspacing*2),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('What stage have you reached ?',
                              style: Configuration.text('small', Colors.black),
                            ),
                            // dropdown button with integers from one to ten
                            Container(
                              constraints: BoxConstraints(
                                minWidth: 100,
                                maxWidth: 100
                              ),
                              margin: EdgeInsets.only(right: Configuration.verticalspacing),
                              child: DropdownButton<int>(
                                isExpanded: true,
                                value: m.stage,
                                icon:  Icon(Icons.expand_more, color: Colors.black),
                                iconSize: Configuration.smicon,
                                elevation: 16,
                                style: Configuration.text('small',Colors.black),
                                underline: Container(
                                  height: 2,
                                  color: Colors.lightBlue,
                                ),
                                onChanged: (int newValue) {
                                  m.stage = newValue;
                                  setState((){});
                                },
                                items: <int>[1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
                                  .map<DropdownMenuItem<int>>((int value) {
                                    return DropdownMenuItem<int>(
                                      value: value,
                                      child: Text(value.toString()),
                                    );
                                  })
                                  .toList(),
                              ),
                            ),
                          ],
                        ),
                      ) : Container(),
                    
                      SizedBox(height: Configuration.verticalspacing*2),

                      Text('Add a note',
                        style: Configuration.text('small', Colors.black),
                      ),
                      SizedBox(height: Configuration.verticalspacing/2),
                      // a textfield and two buttons, one for sending and other for cancelling
                      TextField(
                        maxLines: 6,
                        minLines: 3,
                        
                        textCapitalization: TextCapitalization.sentences,
                        onChanged: (value) {
                          m.text = value;
                          setState((){});
                        },
                        style: Configuration.text('small', Colors.black, font:'Helvetica'),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          alignLabelWithHint: true,

                          hintMaxLines: 3,
                          errorMaxLines: 3,
                          
                          hintText:'What went well, what went wrong, what you worked on this meditation, thoughts...' ,
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                           //labelText: '',
                        ),
                      ),

                      /* 
                      _userstate.user.stagenumber  > 1 || true ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(height: Configuration.verticalspacing*2),
                              Text('How much mind wandering you had?',
                                style: Configuration.text('small', Colors.black),
                              ),

                              SizedBox(height: Configuration.verticalspacing),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  for(int i = 0; i < faces.length; i++)
                                  IconButton(
                                    iconSize: Configuration.medicon,
                                    icon: Icon(faces[i], color: m.mindWandering != null && i == m.mindWandering ? Configuration.maincolor : Colors.grey,),
                                    onPressed: () {
                                      m.mindWandering = i;
                                      //_userstate.addMood(i);
                                      setState((){});
                                    },
                                  )
                                ],
                              ),

                              // the  same  with  forgetting
                              Text('How much you forgot the breath?',
                                style: Configuration.text('small', Colors.black),
                              ),

                              SizedBox(height: Configuration.verticalspacing),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  for(int i = 0; i < faces.length; i++)
                                  IconButton(
                                    iconSize: Configuration.medicon,
                                    icon: Icon(faces[i], color: m.forgetting != null && i == m.forgetting ? Configuration.maincolor : Colors.grey,),
                                    onPressed: () {
                                      m.forgetting = i;
                                      //_userstate.addMood(i);
                                      setState((){});
                                    },
                                  )
                                ],
                              ),
                            
                          ],
                        ):Container(),*/

                      ],
                    ),
                  ),
                ),

               
                
                SizedBox(height: Configuration.verticalspacing),
                


                Padding(
                  padding: EdgeInsets.symmetric(horizontal:Configuration.smpadding),
                  child: BaseButton(
                    border: true,
                    textcolor: Colors.red,
                    color: Colors.white,
                    bordercolor: Colors.red,
                    text: 'Cancel',
                    onPressed: ()=>{
                      Navigator.pop(context)
                    },
                  ),
                ),
                SizedBox(height: Configuration.verticalspacing),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal:Configuration.smpadding),
                  child: BaseButton(
                    text: 'Add',
                    onPressed: m.feelings == null || m.feelings.isEmpty 
                    ? null 
                    : (){
                      _userstate.addReport(report: m);
                      Navigator.pop(context);
                    },
                  ),
                ),
                SizedBox(height: Configuration.verticalspacing * 4)
              ],
            ),
      ),
    );
  }
}



Widget containerGradient({child}){
  return Container(
    width: Configuration.width,
    decoration: BoxDecoration(
       gradient: LinearGradient(
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
        colors: [
          Color.fromRGBO(23,23,23,100),
          Configuration.maincolor,
        ],
      )
    ),
    child: Container(
      decoration: BoxDecoration(
       gradient: LinearGradient(
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
        colors: [
          Color.fromRGBO(23,23,23,100),
          Configuration.maincolor,
        ],
      )
      ),child:child
    )
  );
}


class PreMeditationScreen extends StatefulWidget {
  Meditation meditation;

  dynamic then;

  PreMeditationScreen({this.meditation, this.then}) : super();

  @override
  State<PreMeditationScreen> createState() => _PreMeditationScreenState();
}


class _PreMeditationScreenState extends State<PreMeditationScreen> {
  bool finished = false;

  int _index = 0;

  List<Widget> mapToWidget(map){  
      List<Widget> l = new List.empty(growable: true);
      l.add(SizedBox(height: 30));
      
    if (map['title'] != null) {
      l.add(Center(
        child: Text(map['title'],style: Configuration.text('big', Colors.white)),
      ));
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
        style: Configuration.text('smallmedium', Colors.white,font:'Helvetica')));
    }

    if(map['html'] != null){
      l.add(SizedBox(height: 15));
      l.add(Center(child: htmlToWidget(map['html'], color: Colors.white)));
    }

    return l;
  }

  List<Widget> getContent(index) {
    List<Widget> l = mapToWidget(widget.meditation.content[index.toString()]);

    return l;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light
        ),
        elevation:0,
        backgroundColor: Colors.transparent,
        leading: CloseButton(
          color: Colors.white,
        ),
      ),
      extendBodyBehindAppBar: true,
      body: containerGradient(
        child: Stack(
          children: [
            CarouselSlider.builder(
              itemCount: widget.meditation.content.entries.length,
              itemBuilder: (context, index,o) {
                return Container(
                  width: Configuration.width,
                  height: Configuration.height,
                  padding: EdgeInsets.all(Configuration.medpadding),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: getContent(index))
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
                      })),
          Align(
          alignment: Alignment.bottomCenter,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              _index == widget.meditation.content.length -1 ? 
              BaseButton(
              margin:true,
              text:'Start Timer',
              onPressed: () {
                // SE PODRÍA HACER EL START CUANDO SE ABRE LA VENTANA DE COUNTDOWN
                //_meditationstate.startMeditation(_userstate.user, _userstate.data);
                Navigator.pushReplacement(
                  context, 
                  PageRouteBuilder(
                      pageBuilder: (context, animation1, animation2){
                        // HAY QUE VER SI 
                        return CountDownScreen(
                          content: widget.meditation,
                          then: widget.then,
                        );
                      },
                      transitionDuration: Duration.zero,
                      reverseTransitionDuration: Duration.zero,
                  ),
                );
              }): Container(),

              CarouselBalls(
                activecolor: Colors.white,
                items: widget.meditation.content.entries.length,
                index: _index,
                key:Key(_index.toString())),
              SizedBox(height: Configuration.verticalspacing*2)
            ],
          ),
        )
        ])
      )
    );
  }
}


// clase en la que se envía un contenido y este contenido se reproduce
// PARA RECOORDINGS, MEDITATIONS FREE Y GUIDED
class CountDownScreen extends StatefulWidget {
  dynamic onShare, onClose, onEnd,then;
  FileContent content;

  CountDownScreen({
    this.content,
    this.onShare, this.onClose,
    this.onEnd,
    this.then
  }) : super();

  @override
  State<CountDownScreen> createState() => _CountDownScreenState();
}

class _CountDownScreenState extends State<CountDownScreen> {
  bool pausedCount = false;
  bool loaded = false;
  
  AssetsAudioPlayer ambientPlayer = new AssetsAudioPlayer();

  AssetsAudioPlayer bellPlayer = new AssetsAudioPlayer();

  AssetsAudioPlayer sixStepPreparationPlayer = new AssetsAudioPlayer();

  Duration totalDuration = new Duration();

  Duration position;

  UserState _userstate;
  MeditationState _meditationstate;

  MyAudioHandler audioPlayer = sl<AudioHandler>();

  List<double> playSpeeds = [0.75,1.0,1.25,1.5];
  int selectedPlaySpeed = 0;

  int secondsAfter,secondsBefore;

  bool isDragging, finished = false;
  Timer t;
  int  bellPosition = 0;

  bool shadow = false;
  bool disposed = false;
  Timer _timer;
  bool delaying = false;
  bool entered = false;

  bool hasFinishedEarly = false;

  bool loadedFile = true;

  void changeDuration(Meditation m,  Duration toChange){
    m.duration = toChange;
  }

  // IT GOES TO THE FINISH SCREEN
  void finishMeditation(){
    // GUARDAMOS TAMBIEN LA MEDITACIÓN !!
    Duration getDuration(Meditation m){

      return m.duration;
    }

    if(isUnlimited(widget.content) || hasFinishedEarly){
      changeDuration(widget.content, position);  
    }else{
      changeDuration(widget.content, totalDuration);
    }

    _userstate.finishMeditation(m: widget.content, earlyFinish: hasFinishedEarly);

    _meditationstate.selmeditation= new Meditation(
      duration: getDuration(widget.content),
      meditationSettings: _userstate.user.settings.meditation,
      report: null
    );
  
    Navigator.pushReplacement(
      context, 
      PageRouteBuilder(
        pageBuilder: (context, animation1, animation2){
          return MeditationEndedScreen(meditation:widget.content);
        },
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
      )
    ).then((value) => 
      widget.then != null ? widget.then(value) : null
    );
  }

  void startMeditation(Meditation m){
    try{
      if(totalDuration  == null || totalDuration.inMinutes == 0) totalDuration = m.duration;

      position = new Duration(seconds: 0);

      //showNotification();
      loaded = true;

      if(m.meditationSettings.ambientsound != null){
        ambientPlayer.setVolume(m.meditationSettings.ambientvolume / 100);
        ambientPlayer.open(
          Audio(m.meditationSettings.ambientsound.sound),
          loopMode: LoopMode.single,
          volume: m.meditationSettings.addSixStepPreparation ? 0.05 : m.meditationSettings.ambientvolume
        ).then((e)=>{});
      }
     

      if(bellPlayer != null ){
        // el bellPlayer tiene que tener también la campana de final y principio
        bellPlayer.setVolume(m.meditationSettings.bellsvolume / 100 );
      }

      if(m.meditationSettings.addSixStepPreparation){
        sixStepPreparationPlayer.open(
          Audio('assets/six_step_preparation.mp3'),
          volume: 1
        ).then(((value) {
          if(!isUnlimited(m)){
            totalDuration += sixStepPreparationPlayer.current.value.audio.duration;
          }

          sixStepPreparationPlayer.playlistAudioFinished.listen((Playing playing){
            if(m.meditationSettings.startingBell != 'None' && !disposed){
              bellPlayer.open(
                Audio(bells.firstWhere((element) => element.name == m.meditationSettings.startingBell).sound),
                volume: m.meditationSettings.bellsvolume / 100
              );
            }
          });
        }));
      }else {
         if(m.meditationSettings.startingBell != 'None'){
          bellPlayer.open(
            Audio(bells.firstWhere((element) => element.name == m.meditationSettings.startingBell).sound),
            volume: m.meditationSettings.bellsvolume / 100
          );
        }
      
      }

      new Timer.periodic(Duration(seconds: 1), (timer){
        t = timer;

        if(!pausedCount){
          position += new Duration(seconds: 1);

          if(!isUnlimited(m) && position.inSeconds == totalDuration.inSeconds){
            t.cancel();
            finishMeditation();
          }else {
            if(m.meditationSettings  != null 
              && m.meditationSettings.bells != null  
              && m.meditationSettings.bells.length > 0 
              && bellPosition < m.meditationSettings.bells.length
              && position.inSeconds == m.meditationSettings.bells[bellPosition].playAt *60
            ){
              bellPlayer.open(
                Audio(m.meditationSettings.bells[bellPosition].sound),
                volume: m.meditationSettings.bellsvolume / 100 
              );
              
              bellPosition++;
            }
            setState(() {});
        }}
      });
    } catch(e){
      print(e);
    }
  }

  void showNotification(){
    /*LocalNotifications.showMessage(
      playSound: true,
      id:010,
      duration:totalDuration - position,
      title: "Congratulations!",
      body: 'You finished your meditation',
      onFinished: finishMeditation
    );*/
  }

  Widget secondaryButton(IconData icon, onPressed, tag){
    return FloatingActionButton(
      
      mini: true,
      heroTag: tag,
      backgroundColor: Colors.black.withOpacity(0.7),
      onPressed: ()=>{
        if(loaded){
          onPressed()
        }
      },
      child: Icon(icon,color: Colors.white,size: Configuration.smicon)
    );
  }

  void tap(){
    setState(() {shadow = false;});

    if(_timer != null  && _timer.isActive){
      _timer.cancel();
    }

    _timer = Timer(Duration(seconds: 10), () { 
      setState(() {
        shadow = true;
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [
          SystemUiOverlay.top
        ]);
      });
    });
  }
  
  @override 
  void dispose(){
    super.dispose();
    disposed = true;

    if(audioPlayer != null && audioPlayer.player != null){
      audioPlayer.stop();
    }
    
    if(t != null) t.cancel();

    Wakelock.disable();

    if(_timer != null){
      _timer.cancel();
    }

    if(_userstate != null && position != null && position.inMinutes > 1 && widget.content.cod.isNotEmpty){
      _userstate.finishContent(widget.content, position, totalDuration);
    }

    if(widget.content.isMeditation()){
      //LocalNotifications.cancelAll();
    }

    if(bellPlayer != null){
      bellPlayer.dispose();
    }
    if(ambientPlayer != null){
      ambientPlayer.dispose();
    }

    if(sixStepPreparationPlayer != null){
      sixStepPreparationPlayer.dispose();
    }
  }

  @override
  void didChangeDependencies(){
    super.didChangeDependencies();
    _userstate = Provider.of<UserState>(context);
    _meditationstate = Provider.of<MeditationState>(context);
    
    // SE PODRÍA HACER CADA 10 SEGUNDOS ??
    // only override  on bottom
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [
      SystemUiOverlay.top
    ]);
    
    // quitar wakelock en el futuro !!
    Wakelock.enable();
    
    try{
      tap();
      
      // SINO HAREMOS UN COUNTDOWN NORMAL CON EL TIPO
      if(widget.content.file != null && widget.content.file.isNotEmpty){  
        loadedFile = false;
        // HAY QUE HACER ESTO CON LAS FREE MEDITATIONS !!!
        audioPlayer.openAudio(MediaItem(
          id: widget.content.file, 
          title: widget.content.title,
          artUri: widget.content.image  != null &&  widget.content.image.isNotEmpty 
          ? Uri.parse(widget.content.image): 
            Uri.parse('https://firebasestorage.googleapis.com/v0/b/the-mind-illuminated-32dee.appspot.com/o/stage%201%2Flogo-no-text.png?alt=media&token=73d60235-c6db-473d-aa3d-f20fa28adf63'),
          displayTitle: widget.content.title,
          displayDescription: widget.content.description
        )).then((value) {
            if(disposed) return;
            totalDuration = audioPlayer.player.current.value.audio.duration;
            position = Duration(seconds: 0);
            pausedCount = false;
            loadedFile =true;

            if(widget.content.isMeditation()){
              //showNotification();
            }

            // EL FINISHED TAMBIEN SE LLAMA CUANDO SE SALE !!!!
            // se ejecuta más de una vez. comprobamos  que solo salga una
            audioPlayer.player.playlistFinished.listen((finished) {
              if(!disposed && !entered && finished ) {
                entered  = true;
                if(widget.content.isMeditation()){ 

                }else {
                  Navigator.pop(context);
                }
                audioPlayer.stop();
              }
            });

            if(_userstate.user.contentDone.length > 0){ 
              DoneContent content = _userstate.user.contentDone.firstWhere((element) => element.cod == widget.content.cod,
              orElse: (){});

              if(content !=null && content.done.inMinutes < totalDuration.inMinutes){
                audioPlayer.player.seek(content.done);
              }
            }

            // PILLAR CUANDO ACABA MEJOR !!!!!       
            // SOLO SI ES RECORDING CAMBIAMOS LA POSICIÓN 
            if(widget.content.isRecording()){
              audioPlayer.player.currentPosition.listen((positionValue){
                if(audioPlayer.player.isPlaying.value && !disposed && !finished){
                  if(positionValue <= totalDuration ){
                    position = positionValue;
                    setState(() {});
                  } 
                }
              });
            }

            if(widget.content.isMeditation()){
              changeDuration(widget.content, totalDuration);
              startMeditation(widget.content);
              setState(() {});
            }

            loaded = true;
            setState(() {});

          });
      }else{
        
        if(widget.content.isMeditation()){
          startMeditation(widget.content);
          setState(() {});
        }
      }
    }catch(e){
      showAlertDialog(
        context: context,
        title: 'Error',
        text: 'There was an error loading the content. Please try again later'
      );
      print(e);
    }
  }

  bool isFreeMeditation(Meditation m){
    return m.file == null || m.file.isEmpty;
  }

  bool isUnlimited(Meditation m){
    return m.meditationSettings.isUnlimited;
  }

  dynamic exit(context,{nopop = false}){
    bool pop = true;
    bool meditationCounts = widget.content.isMeditation() && (isUnlimited(widget.content) || this.position.inMinutes >= 5);

    /*
    PARA EL FUTURO !! HAY QUE PAUSAR LA MEDITACIÓN
    if(!pausedCount){
      pausedCount = true;
    }*/

    showAlertDialog(
      noPop: true,
      context:context,
      title: 'Are you sure you want to exit?',
      text: meditationCounts
      ? 'The current meditation will end': 'This meditation will not count until you meditate for at least 5 min',
      onYes:(){
        if(meditationCounts){
          hasFinishedEarly = true;
          finishMeditation();
          pop = false;
        }else{
          SystemChrome.setEnabledSystemUIMode(
            SystemUiMode.manual, 
            overlays: [
              SystemUiOverlay.bottom,
              SystemUiOverlay.top
            ]
          );
          pop = true;
          Navigator.pop(context);
        }
      },
      onNo:(){
        pop = false;
      }
    );
    

    return pop;
  }

  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: () {  
        return Future.value(exit(context,nopop: true));
      },
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          // transparent appbar status
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.dark,
            systemStatusBarContrastEnforced: false,
            systemNavigationBarColor: Colors.transparent,
            systemNavigationBarIconBrightness: Brightness.light
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          leading: ButtonClose(
            color: shadow ? Colors.black : Colors.white,
            onPressed: (){
              if(widget.content.isMeditation()){
                exit(context);
              }else{
                 SystemChrome.setEnabledSystemUIMode(
                  SystemUiMode.manual, 
                  overlays: [
                    SystemUiOverlay.bottom,
                    SystemUiOverlay.top
                  ]
                );
                Navigator.pop(context);
              }
            },
          ),
        ),
        body: Stack(
          children: [
            containerGradient(
              child: Container(
                padding: EdgeInsets.all(Configuration.smpadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children:[
                    Container(
                      height: Configuration.height*0.35,
                      width: Configuration.height*0.35,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(Configuration.borderRadius)
                      ),
                      child: widget.content.image != null && widget.content.image.isNotEmpty  ? 
                      Center(child: Image(
                        height: Configuration.height*0.3,
                        fit: BoxFit.contain, 
                        image: CachedNetworkImageProvider(widget.content.image))
                      ) : 
                      Container(
                        height: Configuration.height*0.35,
                        width: Configuration.height*0.35,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(Configuration.borderRadius)
                        ),
                        child: Icon(Icons.self_improvement, size: Configuration.bigicon*2),
                      ),
                    ),
                    
                    SizedBox(height: Configuration.verticalspacing*2),
                    
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: Configuration.smpadding),
                      child: Text(
                        widget.content.title != null ? 
                        widget.content.title : "Enjoy meditating",
                        textAlign:TextAlign.left,
                        style: Configuration.text('subtitle',Colors.white)
                      ),
                    ),
    
                    SizedBox(height: Configuration.verticalspacing*2),


                    widget.content.isMeditation() && isUnlimited(widget.content) ?
                    Column(
                      children: [
                        Text(getMinutes(position) +  ':' +  getSeconds(position),
                          style: Configuration.text('small', Colors.white,spacing: 2)),

                        SizedBox(height: Configuration.verticalspacing),
                      ],
                    ):
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children:[
                      widget.content.description != null ?
                      Text(
                        widget.content.description, 
                        style: Configuration.text('small', Configuration.lightgrey, font:'Helvetica'),
                        textAlign:TextAlign.left
                      )
                      : Container(),

                      SizedBox(height: Configuration.verticalspacing*2),
      
                      totalDuration != null  ?
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('0:00',style: Configuration.text('small',Colors.white)),
                          
                          GestureDetector(
                            onDoubleTap: (){
                              if(widget.content.isMeditation()){
                                finishMeditation();
                              }
                            },
                            child: Text(totalDuration.inHours.toString() + ':' + getMinutes(totalDuration),
                              style: Configuration.text('small',Colors.white)),
                          )
                        ],  
                      ): Container(),
      
                      SliderTheme(
                          data:SliderThemeData(
                          trackShape: CustomTrackShape(),
                          thumbShape: RoundSliderThumbShape(enabledThumbRadius: 0),
                          minThumbSeparation: 5,
                          ),
                          child: Slider(
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
                            }, 
                            value: loaded ? position.inSeconds > totalDuration.inSeconds ? totalDuration.inSeconds.toDouble() : (position.inSeconds).toDouble() : 0,
                          ),
                      ),
                      SizedBox(height:Configuration.verticalspacing*2),
                      
                    ]),

                    Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [ 
                          widget.content.isMeditation() && isFreeMeditation(widget.content) ? Container(): 
                          secondaryButton(
                            Icons.replay_30, 
                            (){
                              if(position != null && position.inSeconds > 30){
                                position -= Duration(seconds: 30);
                                audioPlayer.player.seek(position);
                                setState(() {});
                              }
                            },
                            'heroTag1'
                          ),

                          FloatingActionButton(
                            
                            backgroundColor: Colors.white,
                            onPressed: () {
                              if(audioPlayer.player != null){
                                if(audioPlayer.player.isPlaying.value){
                                  audioPlayer.pause();
                                }else{
                                  audioPlayer.play();
                                }
                              }
      
                              if(ambientPlayer != null){
                                ambientPlayer.playOrPause();
                              }
      
                              if(sixStepPreparationPlayer != null){
                                sixStepPreparationPlayer.playOrPause();
                              }
      
                              setState(()=> pausedCount = !pausedCount);
      
                              if(pausedCount && widget.content.isMeditation()){
                                //LocalNotifications.cancelAll();
                              } else {
                                //showNotification();
                              }
                            },
                            child: Icon(
                              !pausedCount ? Icons.pause : Icons.play_arrow, 
                              color: Colors.black,
                              size: Configuration.smicon,
                            )
                          ),
      
      
                          widget.content.isMeditation() && isFreeMeditation(widget.content) ? Container(): 
                          secondaryButton(
                            Icons.forward_30, 
                            (){
                              if(position != null && (totalDuration.inSeconds - position.inSeconds) > 40){
                                
                                position +=  Duration(seconds: 30);

                                audioPlayer.player.seek(position);

                                //
                                setState(() {});
                              }
                            },
                            'heroTag2'
                            ),
                        ]
                      ),     

                    SizedBox(height: Configuration.verticalspacing*3),

                    (widget.content.isMeditation() && isFreeMeditation(widget.content)) || totalDuration != null ? Container(): 
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(width: Configuration.verticalspacing),
                        PopupMenuButton<double>(
                          initialValue: audioPlayer.player.playSpeed.value,
                          padding: EdgeInsets.all(0.0),
                          itemBuilder: (BuildContext context) {  
                            return playSpeeds.map((e) => PopupMenuItem(
                              onTap:(){
                                setState(() {
                                  audioPlayer.player.setPlaySpeed(e);
                                });
                              },
                              value: e,
                              child: Text(e.toString(),style: Configuration.text('small',Colors.black, font: 'Helvetica')),
                            )).toList();
                          },
                          child: Container(
                            padding: EdgeInsets.all(Configuration.smpadding),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(Configuration.smpadding),
                              color: Colors.black.withOpacity(0.7)
                            ),
                            child: Text(audioPlayer.player.playSpeed.value.toString() +  ' x',
                              style: Configuration.text('tiny',Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),


                    widget.content.isMeditation() && isUnlimited(widget.content) ?
                    Container(
                      margin: EdgeInsets.only(top:Configuration.verticalspacing*2),
                      child: BaseButton(
                        text: 'End meditation',
                        color: Colors.transparent,
                        onPressed: position.inMinutes >= 1
                        ? (){
                          finishMeditation();
                        } : null,
                        border: true,
                        bordercolor: Colors.red,
                        textcolor: Colors.red,
                      ),
                    ) : Container(),

                  ]
                ),
              )
            ),
    
            shadow ?
            Positioned.fill(
              child: GestureDetector(
                onTap: () {
                  print('TAPPED');
                  tap();
                },
                child: Container(
                  decoration: BoxDecoration(color:Colors.black.withOpacity(0.99))
                ),
              ),
            ) : Container(),
          ],
        )),
    );
  }
}


class WarmUpScreen extends StatefulWidget {
  Meditation m;
  
  WarmUpScreen({this.m}) : super();

  @override
  State<WarmUpScreen> createState() => _WarmUpScreenState();
}

class _WarmUpScreenState extends State<WarmUpScreen> {
  Duration d;
  Timer t;

  @override 
  void initState(){
    super.initState();

    d = new Duration(seconds: widget.m.meditationSettings.warmuptime.toInt());

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);


    new Timer.periodic(Duration(seconds: 1), (timer) { 
      t = timer;
      
      if(d.inSeconds <=1){
        AssetsAudioPlayer bellPlayer = new AssetsAudioPlayer();

        bellPlayer.open(Audio("assets/audios/bowl-new.wav"));

        t.cancel();

        Navigator.pushReplacement(
          context, 
          PageRouteBuilder(
              pageBuilder: (context, animation1, animation2){
                // HAY QUE VER SI 
                return CountDownScreen(
                  content: widget.m,
                );
              },
              transitionDuration: Duration.zero,
              reverseTransitionDuration: Duration.zero,
          ),
        );
      }
      
      setState(() {
        d -= Duration(seconds: 1); 
      });
    });
  }

  @override 
  void dispose(){
    super.dispose();

    t.cancel();
  }  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: CloseButton(
          onPressed: (){
             showAlertDialog(
              context:context,
              title: 'Are you sure you want to exit?',
              text: 'This meditation will not count',
              onYes:(){
                //t.cancel();
              },
              onNo:(){
              }
            );
          },
          color: Colors.white)
      ),
      body: containerGradient(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children:[
              Text('Get ready for the meditation', style: Configuration.text('small',Colors.white)),
              SizedBox(height: Configuration.verticalspacing),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width:Configuration.width*0.5,
                    child:Center(child: Text(d.inSeconds.toString() + ' s', style:Configuration.text('huge',Colors.white)))
                  )
                ],
              ),
          ]
        )
      )
    );
  }
}