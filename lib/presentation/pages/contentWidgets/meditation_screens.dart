

// SCREEN POST MEDITATION  !!!



import 'dart:async';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:audio_service/audio_service.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meditation_app/login_injection_container.dart';
import 'package:meditation_app/presentation/pages/commonWidget/back_button.dart';
import 'package:meditation_app/presentation/pages/commonWidget/date_tostring.dart';
import 'package:meditation_app/presentation/pages/contentWidgets/meditation_widgets.dart';
import 'package:provider/provider.dart';
import 'package:wakelock/wakelock.dart';


import '../../../domain/entities/audio_handler.dart';
import '../../../domain/entities/content_entity.dart';
import '../../../domain/entities/database_entity.dart';
import '../../../domain/entities/meditation_entity.dart';
import '../../../domain/entities/milestone_entity.dart';
import '../../mobx/actions/meditation_state.dart';
import '../../mobx/actions/user_state.dart';
import '../commonWidget/carousel_balls.dart';
import '../commonWidget/dialogs.dart';
import '../commonWidget/html_towidget.dart';
import '../commonWidget/start_button.dart';
import '../config/configuration.dart';
import '../mainpages/meditation_screen.dart';

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
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: Configuration.smpadding
                  ),
                  child: BaseButton(
                    text: 'Write a meditation report',
                    color: Colors.white,
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
                  ),
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
            flex:1,
            child: Text(title, 
              style: Configuration.text('small', Colors.black),
            ),
          ),
          SizedBox(width: Configuration.verticalspacing),
          Flexible(
            flex: 4,
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
          m.stage != null ?
          textComponent('Stage reached', m.stage.toString()) 
          : Container(),

          m.metrics!= null && m.metrics.length > 0 ?
          Column(
            children: m.metrics.map((e) => 
              textComponent(e.name, e.value.toString())
            ).toList()
          ) : Container(),

          SizedBox(height: Configuration.verticalspacing),
          
          m.text != null && m.text.isNotEmpty ?
          textComponent('Note', m.text)
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

List<Metric> expertMetrics = [
 /* NumericMetric(
    name: 'Stage reached',
    type: 'numeric',
    icon: Icons.terrain,
    min:1,
    max:10
  ),*/

  OptionsMetric(
    name:'Effort put in',
    icon: Icons.fitness_center,
    options: [
      'Effortless',
      'Low',
      'Medium',
      'High',
      'Very High'
    ]
  ),

  NumericMetric(
    name: 'Stage reached',
    type: 'numeric',
    icon: Icons.terrain,
    min:1,
    max:10
  ),
  
  OptionsMetric(
    name:'Energy',
    icon:Icons.flash_on,
    options: [
      'Low',
      'Medium',
      'High',
      'Very High'
    ]
  ),
  
  TextMetric(
    name: 'Insights or valuable thoughts',
    hint: 'Any insights, feelings or helpful thoughts',
    type: 'text',  
    icon: Icons.lightbulb,
  ),

  TextMetric(
    name: 'Distractions',
    hint: 'What distracted you, how did you deal with it?',
    type: 'text',
    icon: Icons.psychology,
  ),

  TextMetric(
    name: 'Practice Notes',
    type:'text',
    hint: 'What to improve, what to keep, what to change',
    icon: Icons.note,
  ),
];

List<Metric> basicMetrics = [
  OptionsMetric(
    name:'Focus',
    icon:Icons.adjust,
    options: [
      'Distracted',
      'Low',
      'Medium',
      'High',
      'Very High'
    ]
  ),

  

  //MOOD 
  OptionsMetric(
    name:'Feeling',
    icon: Icons.mood,
    options: [
      //ADD MOODS
      'Sad',
      'Sluggish',
      'Spaced out',
      'Neutral',
      'Calm',
      'Focused',
      'Happy'
    ]
  ),

  //  A metric for text and one for stage
  TextMetric(
    name: 'Note',
    hint: 'How was your meditation?. Distraction, thoughts, what to improve...',
    type: 'text',
    icon: Icons.note,
  )
];


class _AddReportState extends State<AddReport> {
  MeditationReport m = new  MeditationReport();

  UserState _userstate;

  @override 
  void initState(){
    super.initState();
    
  }

  @override
  void didChangeDependencies(){
    super.didChangeDependencies();
    _userstate = Provider.of<UserState>(context);
    
   
    if(_userstate.user.settings.meditation.metricsType == 'basic'){
      m.metrics = basicMetrics;
    } else if(_userstate.user.settings.meditation.metricsType == 'expert') {
      m.metrics = expertMetrics;
    } else if(_userstate.user.settings.meditation.metricsType == 'custom'){
      m.metrics = _userstate.user.settings.meditation.metrics;
    }
  }

  Widget metric({Metric m}){
    // if metric is type text we show notes
    // else  we  show a numeric dropdown from min  to max using step
    
    Widget textMetric(TextMetric m){
      return TextField(
        maxLines: 9,
        minLines: 3,
        textCapitalization: TextCapitalization.sentences,
        onChanged: (value) {
          m.value = value;
          setState((){});
        },
        style: Configuration.text('small', Colors.black, font:'Helvetica'),
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderSide: BorderSide( color: Colors.grey, width: 2),
            borderRadius: BorderRadius.circular(Configuration.borderRadius/3),
          ),
          alignLabelWithHint: true,
          hintMaxLines: 3,
          errorMaxLines: 3,
          hintText:m.hint,
          floatingLabelBehavior: FloatingLabelBehavior.never,
          //labelText: '',
        ),
      );

    }

    Widget numericMetric(NumericMetric m){

      //numeric dropdown from m.min to m.max using step
      return DropdownButton<int>(
        value: m.value,
        items: List.generate(m.max, (index) => m.min +index*m.step).map((e) => 
          DropdownMenuItem(
            child: Text(e.toString(), style: Configuration.text('small', Colors.black)),
            value: e
          )
        ).toList(),
        onChanged: (value){
          m.value = value;
          setState(() {});
        },
      );
    }

    Widget optionsMetric(OptionsMetric m){
      return DropdownButton<String>(
        value: m.value,
        items: m.options.map((e) => 
          DropdownMenuItem(
            child: Text(e, style: Configuration.text('small', Colors.black)),
            value: e
          )
        ).toList(),
        onChanged: (value){
          m.value = value;
          setState(() {});
        },
      );
    }

    Widget headerText(){
      return Row(
        children: [
          m.icon != null ?
          Icon(m.icon, color: Colors.black, size: Configuration.smicon) : Container(),

          SizedBox(width: Configuration.verticalspacing/2),

          Text(m.name,
            style: Configuration.text('small', Colors.black),
          ),
        ],
      );
    }

    return Container(
      margin: EdgeInsets.only(top: Configuration.verticalspacing),
      child:  m.type == 'text'? 
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            headerText(),
            SizedBox(height: Configuration.verticalspacing),
            textMetric(m)
          ],
        ) :
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            headerText(),

            m.type == 'options' ?
            optionsMetric(m) : numericMetric(m)
          ],
        )
    );
  }


  Future<dynamic> openMetricsDialog(){

    Metric editingMetric;

    Widget numericEditing(NumericMetric m){

      return Row(
        children: [
          TextField(
            onChanged: (value){
              m.min = int.parse(value);
              setState((){});
            },
            decoration: InputDecoration(
              hintText: 'Min',
              border: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.grey,
                  width: 2
                ),
                borderRadius: BorderRadius.circular(Configuration.borderRadius/3)
              )
            ),
          ),

          TextField(
            onChanged: (value){
              m.max = int.parse(value);
              setState((){});
            },
            decoration: InputDecoration(
              hintText: 'Max',
              border: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.grey,
                  width: 2
                ),
                borderRadius: BorderRadius.circular(Configuration.borderRadius/3)
              )
            ),
          ),

          
        ],
      );
    }

    Widget optionsEditing(OptionsMetric o){
      return Column(
        children: [
          TextField(
            onChanged: (value){
              o.options = value.split(',');
              setState((){});
            },
            decoration: InputDecoration(
              hintText: 'Options',
              border: OutlineInputBorder(
                borderSide: BorderSide(
                  color: Colors.grey,
                  width: 2
                ),
                borderRadius: BorderRadius.circular(Configuration.borderRadius/3)
              )
            ),
          ),
        ],
      );
    }

    return showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, setState) {
              return AbstractDialog(
                    content: Container(
                      padding: EdgeInsets.all( Configuration.smpadding ),
                      decoration: BoxDecoration( 
                        borderRadius: BorderRadius.circular(
                          Configuration.borderRadius
                        ),
                        color: Colors.white 
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            child: Text('Personalize your metrics',
                              style: Configuration.text('subtitle', Colors.black),
                            )
                          ),
                          
                          SizedBox(height: Configuration.verticalspacing),
                          //THREE ITEM SELECTOR FOR METRICS
                          SegmentedButton(
                            segments:<ButtonSegment<String>>[
                              ButtonSegment(
                                label: Text(
                                  'Basic',
                                  style: Configuration.text('small', Colors.black)
                                ),
                                value: 'basic'
                              ),
                              ButtonSegment(
                                label: Text(
                                  'Advanced',
                                  style: Configuration.text('small', Colors.black)
                                ),
                                value: 'expert'
                              ),
                              ButtonSegment(
                                label: Text(
                                  'Custom',
                                  style: Configuration.text('small', Colors.black)
                                ),
                                value: 'custom'
                              )
                            ], 
                            selected:  <String>{_userstate.user.settings.meditation.metricsType},
                            onSelectionChanged: (value){
                              _userstate.user.settings.meditation.metricsType = value.first;

                              if(value.first == 'basic'){
                                m.metrics = basicMetrics;
                              } else if(value.first == 'expert'){
                                m.metrics = expertMetrics;
                              } else if(value.first == 'custom'){
                                m.metrics = _userstate.user.settings.meditation.metrics;
                              }

                              setState(() {});
                            }
                          ),

                          SizedBox(height: Configuration.verticalspacing*1.5),

                          m.metrics != null && m.metrics.length > 0 ?
                          GridView.builder(
                            itemCount: m.metrics.length,
                            shrinkWrap: true,
                            physics: ClampingScrollPhysics(),
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: Configuration.crossAxisCount +1,
                              childAspectRatio: 3,
                              crossAxisSpacing: Configuration.verticalspacing,
                              mainAxisSpacing: Configuration.verticalspacing
                            ),
                            itemBuilder: (context, index){
                              return Chip(
                                avatar: Icon(
                                  m.metrics[index].type == 'text'  ? 
                                  Icons.text_fields :
                                  m.metrics[index].type == 'numeric' ?
                                  Icons.format_list_numbered :
                                  Icons.list,
                                  color: Colors.black,
                                  size: Configuration.smicon
                                ),
                                label: Text(m.metrics[index].name, 
                                  style: Configuration.text('small', Colors.black)
                                )
                              );
                            },
                          )
                          : Container(),


                          // Textfield with inputs for  adding data  in editing metric
                          editingMetric != null ? 
                          Container(
                            margin: EdgeInsets.only(top: Configuration.verticalspacing),
                            padding: EdgeInsets.all(Configuration.tinpadding),
                            decoration: BoxDecoration(
                              color: Configuration.lightgrey,
                              
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Row(
                                  children: [
                                    TextField(
                                      onChanged: (value){
                                        editingMetric.name = value;
                                        setState((){});
                                      },
                                      decoration: InputDecoration(
                                        hintText: 'Metric name',
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            color: Colors.grey,
                                            width: 2
                                          ),
                                          borderRadius: BorderRadius.circular(Configuration.borderRadius/3)
                                        )
                                      ),
                                    ),
                                  ],
                                ),
                          
                                //dropdown to  select  metric type
                                Column(
                                  children: [
                                    Text('Type', style: Configuration.text('small', Colors.black)),
                                    SizedBox(height: Configuration.verticalspacing/2),
                                    DropdownButton<String>(
                                      value: editingMetric.type,
                                      items: [
                                        DropdownMenuItem(
                                          child: Text('Text', style: Configuration.text('small', Colors.black)),
                                          value: 'text'
                                        ),
                                        DropdownMenuItem(
                                          child: Text('Numeric', style: Configuration.text('small', Colors.black)),
                                          value: 'numeric'
                                        ),
                                        DropdownMenuItem(
                                          child: Text('Options', style: Configuration.text('small', Colors.black)),
                                          value: 'options'
                                        )
                                      ],
                                      onChanged: (value){
                                        editingMetric.type = value;
                                        
                                        if(editingMetric.type =='options'){
                                          editingMetric = OptionsMetric(
                                            name: editingMetric.name,
                                            options: [],
                                            type: 'options'
                                          );
                                        } else if(editingMetric.type == 'numeric'){
                                          editingMetric = NumericMetric(
                                            name: editingMetric.name,
                                            type: 'numeric',
                                            min: 0,
                                            max: 10,
                                            step: 1
                                          );
                                        } else {
                                          editingMetric = TextMetric(
                                            name: editingMetric.name,
                                            type: 'text',
                                            hint: 'New metric hint'
                                          );
                                        }
                                        setState(() {});
                                      },
                                    ),
                                  ],
                                ),
                          
                                //numeric dropdown for min and max
                                editingMetric.type == 'numeric' ?
                                numericEditing(editingMetric): Container(),
                                
                                //dropdown for options
                                editingMetric.type == 'options' ?
                                optionsEditing(editingMetric): Container(),
                          
                          
                              ],
                            ),
                          ) : Container(),



                          _userstate.user.settings.meditation.metricsType == 'custom' ?
                          IconButton(
                            icon: Icon(Icons.add, color: Colors.black),
                            onPressed: (){
                              if(_userstate.user.settings.meditation.metrics == null){
                                _userstate.user.settings.meditation.metrics = [];
                              }

                              editingMetric = TextMetric(
                                name: 'New metric',
                                hint: 'New metric hint',
                                type: 'text',
                                icon: Icons.text_fields
                              );


                              _userstate.user.settings.meditation.metrics.add(
                                editingMetric
                              );

                              setState((){});

                              //openAddMetricDialog();
                            },
                          ) : Container(),

                          SizedBox(height: Configuration.verticalspacing*1.5),
                        

                          BaseButton(
                            color: Colors.red,
                            text: 'Close',
                            onPressed: (){
                              Navigator.pop(context);
                            },
                          ),

                        ],
                      ),
                    )
                  );
            }
          );
        }
      );
  }


 
  @override
  Widget build(BuildContext context) {
    _userstate =  Provider.of<UserState>(context);
    final _meditationstate = Provider.of<MeditationState>(context);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        elevation: 0,
        leading: CloseButton(color: Colors.white),
        backgroundColor: Configuration.maincolor,
        title: Text('Add a report', style: Configuration.text('subtitle', Colors.white)),
        actions: [
          IconButton(
            icon: Icon(Icons.settings, color: Colors.white),
            onPressed: (){
              openMetricsDialog().then((value) => {
                setState((){})
              });
            },
          )
        ],
      ),
      body: Container(
        child: ListView(
          physics: ClampingScrollPhysics(),
          children: [
            
            SizedBox(height: Configuration.verticalspacing),
            Container(
              padding: EdgeInsets.all(Configuration.smpadding),
              child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
                children: [
                  
                  m.metrics != null && m.metrics.length > 0 ?
                  Column(
                    children: m.metrics.map((e) => metric(m:e)).toList()
                  ) : Container(),


                ],
              ),
            ),

            
            Container(
              height: Configuration.verticalspacing*3,
            ),
            SizedBox(height: Configuration.verticalspacing),
            Padding(
              padding: EdgeInsets.symmetric(horizontal:Configuration.smpadding),
              child: BaseButton(
                border: true,
                textcolor: Colors.red,
                color: Colors.red,
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
                onPressed: (){

                  m.metrics = m.metrics.where((element) => element.value != null).toList();
                  
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
    List<Widget> l = mapToWidget(
      widget.meditation.content is List ?
      widget.meditation.content[index] :
      widget.meditation.content[index.toString()]
    );

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
              itemCount:widget.meditation.content.length,
              itemBuilder: (context, index,o) {
                return Container(
                  width: Configuration.width,
                  height: Configuration.height,
                  padding: EdgeInsets.all(Configuration.smpadding),
                  child: ListView(
                    
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
                })
            ),

            Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  _index == widget.meditation.content.length -1 ? 
                  BaseButton(
                  margin:true,
                  text:'Start Timer',
                  textcolor: Colors.white,
                  filled: true,
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
                    items: widget.meditation.content.length,
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

// ESTO ES PARA RECORDINGS Y MEDITATIONS!!
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

  Duration timeMeditated = new Duration(seconds: 0);

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

    // time meditated ??
    if(isUnlimited(widget.content) || hasFinishedEarly){
      changeDuration(widget.content, timeMeditated);  
    }else {
      changeDuration(widget.content, totalDuration);
    }

    _userstate.finishMeditation(m: widget.content, earlyFinish: hasFinishedEarly);

    _meditationstate.selmeditation = new Meditation(
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
    try {
      if(totalDuration  == null || totalDuration.inMinutes == 0) totalDuration = m.duration;

      position = new Duration(seconds: 0);
      loaded = true;

      if(m.meditationSettings.ambientsound != null){
        ambientPlayer.setVolume(m.meditationSettings.ambientvolume / 100);
        ambientPlayer.open(
          Audio(m.meditationSettings.ambientsound.sound),
          loopMode: LoopMode.single,
          volume: m.meditationSettings.addSixStepPreparation ? 0.05 : m.meditationSettings.ambientvolume
        ).then((e)=>{});
      }
     
      // el bellPlayer tiene que tener también la campana de final y principio
      if(bellPlayer != null ){
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
      } else {
         if(m.meditationSettings.startingBell != 'None'){
          bellPlayer.open(
            Audio(bells.firstWhere((element) => element.name == m.meditationSettings.startingBell).sound),
            volume: m.meditationSettings.bellsvolume / 100
          );
        }
      
      }

      new Timer.periodic(Duration(seconds: 1), (timer){
        t = timer;

        timeMeditated += new Duration(seconds: 1);

        if(!pausedCount){
          position += new Duration(seconds: 1);

          if(!isUnlimited(m) && position.inSeconds == totalDuration.inSeconds){
            t.cancel();
            finishMeditation();
          }else {
            if(m.meditationSettings != null 
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

    print('DISPOSING HIJODEPUTA');

    if(audioPlayer != null){
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

    /* WidgetsBinding.instance.addObserver(LifecycleEventHandler(
      detachedCallBack: () async {
        print('DETACHED HEHEHEHE');
        if(audioPlayer != null){
          audioPlayer.stop();   
        }
      },
      resumeCallBack: () async {
      })); */
      
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
                if(!widget.content.isMeditation()){ 
                  Navigator.pop(context);
                }
                audioPlayer.stop();
              }
            });

            
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

            if(_userstate.user.contentDone.length > 0){ 
              DoneContent content = _userstate.user.contentDone.firstWhere((element) => element.cod == widget.content.cod,
              orElse: (){});

              if(content != null && content.done.inMinutes < totalDuration.inMinutes){
                audioPlayer.player.seek(content.done, force: true);
                position =  content.done;
                setState(() {});
              }
            }


            loaded = true;
            setState(() {});

          });
      }else {
        
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
    bool meditationCounts = this.timeMeditated.inMinutes >= 5;

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
                          style: Configuration.text('small', Colors.white,spacing: 2)
                        ),

                        SizedBox(height: Configuration.verticalspacing),
                      ],
                    ) :
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
                          widget.content.isMeditation() ? Container(): 
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
      
      
                          widget.content.isMeditation() ? 
                          Container(): 
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


                    widget.content.isMeditation() && isUnlimited(widget.content) && position.inMinutes >= 1 ?
                    Container(
                      margin: EdgeInsets.only(top:Configuration.verticalspacing*2),
                      child: BaseButton(
                        text: 'End meditation',
                        color: Colors.red,
                        onPressed: (){
                          finishMeditation();
                        },
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
                  decoration: BoxDecoration(color:Colors.black)
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