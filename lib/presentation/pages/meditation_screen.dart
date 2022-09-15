import 'dart:async';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_circular_slider/flutter_circular_slider.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:meditation_app/domain/entities/meditation_entity.dart';
import 'package:meditation_app/domain/entities/stage_entity.dart';
import 'package:meditation_app/presentation/mobx/actions/game_state.dart';
import 'package:meditation_app/presentation/mobx/actions/meditation_state.dart';
import 'package:meditation_app/presentation/mobx/actions/user_state.dart';
import 'package:meditation_app/presentation/pages/commonWidget/alert_dialog.dart';
import 'package:meditation_app/presentation/pages/commonWidget/carousel_balls.dart';
import 'package:meditation_app/presentation/pages/commonWidget/dialog.dart';
import 'package:meditation_app/presentation/pages/commonWidget/html_towidget.dart';
import 'package:meditation_app/presentation/pages/commonWidget/meditation_modal.dart';
import 'package:meditation_app/presentation/pages/commonWidget/start_button.dart';
import 'package:meditation_app/presentation/pages/contentWidgets/meditation_screens.dart';
import 'package:meditation_app/presentation/pages/more_screen.dart';
import 'package:provider/provider.dart';

import '../../domain/entities/local_notifications.dart';
import 'commonWidget/horizontal_picker.dart';
import 'commonWidget/progress_dialog.dart';
import 'config/configuration.dart';
import 'contentWidgets/meditation_widgets.dart';


class MeditationScreen extends StatefulWidget {
  @override
  _MeditationScreenState createState() => _MeditationScreenState();
}

class _MeditationScreenState extends State<MeditationScreen> {
  UserState _userstate;
  MeditationState _meditationstate;
  GameState _gamestate;
  int seltime = 5;  
  String presetName = '';

  //podriamos utilizar meditationstate de arriba
  var meditationtype = 'free';
  var selectedstage = 1;
  var selectedtype = 'Meditation';
  var finished = false;
  bool canStart = false;



  AssetsAudioPlayer assetsAudioPlayer = new AssetsAudioPlayer();

  // LISTA DE BELLS
  List<IntervalBell> bells = [
    IntervalBell(sound: 'assets/audios/bowl-sound.mp3',name:'Bowl sound',image:'assets/audios/bowl.png'),
    IntervalBell(sound: 'assets/audios/high-gong.wav',name:'High gong',image:'assets/audios/high-gong.png'),
    IntervalBell(sound: 'assets/audios/church-bell.mp3',name: 'Church bell', image:'assets/audios/church-bell.jpg'),
    IntervalBell(sound: 'assets/audios/bronze-bell.wav',name: 'Bronze bell', image:'assets/audios/bronze-bell.png'),
  ];


  Widget buttonModal(child, text, selected,[scroll = false]){
    return AspectRatio(
      aspectRatio: 11/2,
      child: ElevatedButton(
        style: OutlinedButton.styleFrom(
          primary: Configuration.maincolor,
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
          elevation: 1.5,
          side: BorderSide.none
        ),
        onPressed: ()=>{
          showModalBottomSheet(
            isScrollControlled: scroll,
            barrierColor: Colors.black.withOpacity(0.5),
             shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(Configuration.borderRadius/2)),
            ),
            context: context, 
            builder: (context){
              return Container(
                padding: EdgeInsets.all(Configuration.smpadding),
                child: child
              );
            }).then((value) => 
              setState((){})            
            )
        }, 
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(text, style:Configuration.text('small', Colors.black)),
            selected
          ],
        )
      ),
    );

  }

  String getBellString({List<IntervalBell> bells}){
    String bellsString= '';

      for(IntervalBell b in  bells != null ? bells : _meditationstate.bells){
        bellsString += b.name != null  && b.name.isNotEmpty ? b.name + ' ' : '';
      };

      return bellsString;
  }

  Widget freeMeditation() {

    Widget presets(){
      bool isEditingPresets = false;
      List<MeditationPreset> toRemove = new List.empty(growable: true);

      Widget myPresets(setState){
        return ListView.separated(
          shrinkWrap:true,
          physics: ClampingScrollPhysics(),
          itemBuilder: (BuildContext context, int index) {  
            MeditationPreset p = _userstate.user.presets[index]; 
            
            return Container(
              decoration: BoxDecoration(
                color: Configuration.lightgrey,
                borderRadius: BorderRadius.circular(Configuration.borderRadius)
              ),
              child:Stack(
                children: [
                  ListTile(
                  onTap:(){
                    if(!isEditingPresets){
                      _meditationstate.selectPreset(p);
                      Navigator.pop(context);
                      setState(() {});
                    }
                  },
                  trailing: Container(
                        constraints:BoxConstraints(
                          maxWidth:Configuration.width*0.6
                        ),
                        child: Stack(
                          children: [
                            Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.timer,size: Configuration.tinicon),
                                  Text('${p.duration} min', style: Configuration.text('tiny', Colors.black, font:'Helvetica')),
                                  
                                  SizedBox(width: Configuration.verticalspacing),
                                  
                                  p.intervalBell != null && p.intervalBell.isNotEmpty ?
                                  Expanded(
                                     child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(Icons.notifications,size: Configuration.tinicon),
                                        Flexible(
                                          child: Text('${p.intervalBell}',
                                          overflow: TextOverflow.ellipsis,
                                          style: Configuration.text('tiny', Colors.black, font:'Helvetica')),
                                        ),
                                      ],
                                    ),
                                  ): Container(),

                                p.bells != null && p.bells.length > 0 ?
                                  Container(
                                    constraints: BoxConstraints(
                                      maxWidth: Configuration.width*0.2
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(Icons.notifications,size: Configuration.tinicon),
                                        Flexible(
                                          child: Text(getBellString(bells:p.bells), 
                                          overflow: TextOverflow.ellipsis,
                                          style: Configuration.text('tiny', Colors.black, font:'Helvetica'))
                                        ),
                                      ],
                                    ),
                                  ): Container(),
                                
                                 SizedBox(width: Configuration.verticalspacing),
                                  p.warmuptime > 0 ?  
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.local_fire_department, size:  Configuration.tinicon),
                                      Text('${p.warmuptime.floor().toString()} s', style: Configuration.text('tiny', Colors.black, font:'Helvetica')),
                                    ],
                                  )
                                  :Container()
                                ],
                              ),
                           
                          
                          ],
                        ),
                      ), 
                  title: Text(p.name, style: Configuration.text('small', Colors.black)),
            ),
                
                  isEditingPresets ? 
                    Positioned.fill(
                      child: GestureDetector(
                        onTap: (){
                          showAlertDialog(
                            context:context,
                            title: 'Are you sure you want to remove this preset?',
                            text: "You won't be able to recover it",
                            noPop: true,
                            onYes:(){
                              _userstate.user.presets.remove(p);
                              _userstate.updateUser();
                              setState((){});
                            },
                            onNo:(){
                            }
                          );
                          
                        },
                        child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(Configuration.borderRadius)
                        ),
                        child: Row(
                          mainAxisAlignment:MainAxisAlignment.spaceEvenly,
                          children: [
                            Icon(Icons.remove_circle,color: Colors.red),
                            Text('Tap to remove this preset',style: Configuration.text('small',Colors.white))
                          ],
                        ),
                        ),
                      )
                    ):Container()
                ],
              ));
          },
          separatorBuilder: (BuildContext context, int index) {  
            return SizedBox(height: Configuration.verticalspacing);
          },
          itemCount: _userstate.user.presets.length
        );
      }

      return StatefulBuilder(
        builder: (context,setState) {
          return Container(
              constraints: BoxConstraints(
                minHeight: Configuration.height*0.3
              ),
              padding:EdgeInsets.all(Configuration.smpadding),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(Configuration.borderRadius/2),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('My sessions', style: Configuration.text('medium',Colors.black)),
                  _userstate.user.presets.length > 0 ?
                  Container(
                    margin: EdgeInsets.symmetric(vertical: Configuration.verticalspacing),
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        primary: Colors.white,
                        side:BorderSide(color:  isEditingPresets ? Colors.green : Colors.blue),
                        padding:EdgeInsets.all(8),
                        shape: CircleBorder()
                      ),
                      onPressed: (){
                        setState((){
                          isEditingPresets = !isEditingPresets;
                        });
                      }, child: Icon(!isEditingPresets ? Icons.edit : Icons.check, size: Configuration.smicon, color:isEditingPresets ? Colors.green : Colors.blue,)),
                  ): Container(),
                  SizedBox(height: Configuration.verticalspacing*1),
                  _userstate.user.presets.length > 0 ?
                  myPresets(setState): 
                  Text('You have not created any preset', style: Configuration.text('small', Colors.grey,font: 'Helvetica'),),
                  SizedBox(height: Configuration.verticalspacing)
                ],
              ),
          );
        }
      );
    }

    Widget savePreset(){
      Widget item(left, right){
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(left, style: Configuration.text('small', Colors.black)),
            Text(right, style: Configuration.text('small', Colors.black, font: 'Helvetica')),
          ],
        );

      }
  
      return StatefulBuilder(
        builder: (context,setState) {
          return Container(
            padding: EdgeInsets.all(Configuration.smpadding),              
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(Configuration.borderRadius/2),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: Configuration.verticalspacing),
                Container(
                  height: Configuration.verticalspacing*5,
                  child: TextField(
                  onChanged:(e){ setState((){presetName = e;});},
                  minLines: null,
                  maxLines: null,
                  expands: true,
                    scrollPadding: EdgeInsets.all(Configuration.smpadding),
                    style: Configuration.text('small', Colors.black),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: Configuration.smpadding),
                      hintText: 'Session name',
                      labelStyle:Configuration.text('small', Colors.black),
                      hintStyle: Configuration.text('small', Colors.grey),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(Configuration.borderRadius/2),
                        borderSide: BorderSide(color: Colors.grey)
                      )
                    ),
                  ),
                ),
                SizedBox(height: Configuration.verticalspacing),
                item('Duration', _meditationstate.selmeditation.duration.inMinutes.toString() + ' min'),
                SizedBox(height: Configuration.verticalspacing),
                item('Warm up time', _meditationstate.selmeditation.meditationSettings.warmuptime.floor().toString() + ' s'),
                SizedBox(height: Configuration.verticalspacing),
                item('Interval', _meditationstate.bells.length > 0 ? getBellString() : 'No interval'),
                SizedBox(height: Configuration.verticalspacing*2),
                BaseButton(
                  onPressed: presetName.isNotEmpty ? (){
                    MeditationPreset p = new MeditationPreset(
                      name: presetName,
                      duration: _meditationstate.selmeditation.duration.inMinutes,
                      warmuptime: _meditationstate.selmeditation.meditationSettings.warmuptime,
                    );

                    p.bells = _meditationstate.bells;

                    _userstate.user.presets.add(p);
                    _userstate.updateUser();
                    
                    Navigator.pop(context);
                  } : null,
                  color: Colors.lightBlue,
                  text: 'Save session',
                ),
                SizedBox(height: Configuration.verticalspacing*2)
              ],
            )
          );
        }
      );
    }

    dynamic addModifyBell({IntervalBell b, int i}){
      int selectedIndex = b != null ? bells.indexWhere((element) => element.image == b.image) : 0;
      String selectedMode =  b == null || b.repeat ? 'Repeat': 'Once';

      int selectedTime = b != null ? b.playAt : 1;

      CarouselController c;

      return showModalBottomSheet(
        isScrollControlled: true,
        barrierColor: Colors.black.withOpacity(0.5),
          shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(Configuration.borderRadius/2)),
        ),
        context: context, 
        builder: (context){
          return StatefulBuilder(
            builder: (context,setState) {
              return Container(
                constraints: BoxConstraints(maxHeight: Configuration.height*0.7),
                padding: EdgeInsets.symmetric(vertical:Configuration.smpadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('Interval bell',  style: Configuration.text('smallmedium',Colors.black)),
                    SizedBox(height: Configuration.verticalspacing),
                    CarouselSlider.builder(
                      itemCount: bells.length,
                      
                      itemBuilder: (context,i,selected){
                        IntervalBell b = bells[i];
                        
                        return GestureDetector(
                          onTap: (){
                            assetsAudioPlayer.stop().then((s){
                              assetsAudioPlayer.open(Audio(bells[i].sound));
                            });
                          },
                          child: Container(
                            decoration:BoxDecoration(
                              color: selectedIndex == i ? Configuration.lightgrey : Colors.white,
                              borderRadius: BorderRadius.circular(Configuration.borderRadius)
                            ),
                            padding: EdgeInsets.all(Configuration.smpadding),
                            margin:EdgeInsets.symmetric(horizontal:Configuration.smpadding),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(b.image,fit: BoxFit.cover),
                                SizedBox(height: Configuration.verticalspacing),
                                Text(b.name, style: Configuration.text('small',Colors.black))
                            ])
                          ),
                        );
                      },
                      options: CarouselOptions(
                        scrollPhysics: ClampingScrollPhysics(),
                        viewportFraction:0.5,
                        aspectRatio: 4/2,
                        initialPage: selectedIndex,
                        enableInfiniteScroll: false,
                        onPageChanged: (int i, d){
                          
                            assetsAudioPlayer.stop().then((s){
                              assetsAudioPlayer.open(Audio(bells[i].sound));
                            
                            });

                            setState(() {
                              selectedIndex =  i;
                            });
                          
                        }
                      )
                    ),
                    SizedBox(height: Configuration.verticalspacing),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal:20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          DropdownButton<String>(
                            underline: Container(),
                            style: Configuration.text('small',Colors.black,font:'Helvetica'),
                            items: ["Repeat","Once"].map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value.toString()),
                              );
                            }).toList(),
                            value:selectedMode,
                            onChanged: (newValue){
                              setState((){selectedMode = newValue;});
                          }),
                        ],
                      ),
                    ),
                    
                    SliderTheme(
                      data:SliderThemeData(
                        activeTickMarkColor: Colors.transparent,
                        trackShape: RectangularSliderTrackShape(),
                      ),
                      child:Slider(
                        label: selectedTime.toString() + ' min',
                        activeColor: Colors.lightBlue,
                        thumbColor: Colors.white,
                        inactiveColor: Colors.white,
                        min: 1,
                        max: _meditationstate.selmeditation.duration.inMinutes.toDouble() - 1,
                        divisions: _meditationstate.selmeditation.duration.inMinutes -2,
                        onChanged: (a){
                          setState((){selectedTime = a.toInt();});
                        }, 
                        value: selectedTime.toDouble(),
                      ),
                    ),
                    
                    Text(selectedMode =='Repeat' ? 
                    'The bell will ring every $selectedTime minute' + (selectedTime!=1 ? 's':''):
                    'The bell will ring at minute $selectedTime  ', 
                    style: Configuration.text('small',Colors.grey,font:'Helvetica')),
                   
                    Spacer(),
                    BaseButton(
                      aspectRatio: Configuration.buttonRatio*1.5,
                      text: 'Confirm',
                      onPressed:(){
                        IntervalBell bell = new IntervalBell(
                          playAt: selectedTime,
                          repeat: selectedMode == 'Repeat',
                          name: bells[selectedIndex].name,
                          image: bells[selectedIndex].image,
                          sound:bells[selectedIndex].sound
                        ); 
                        
                        if(b != null){
                          _meditationstate.bells[i] = bell;
                        }else{
                          _meditationstate.bells.add(bell);
                        }
                        Navigator.pop(context);
                      },
                      color: Configuration.maincolor
                    ),
                    SizedBox(height: Configuration.verticalspacing),
                    BaseButton(
                      text:'Cancel',
                      aspectRatio: Configuration.buttonRatio * 1.5,
                      border: true,
                      bordercolor:Colors.red,
                      color:Colors.white,
                      onPressed:(){
                        Navigator.pop(context);
                      },
                      textcolor: Colors.red,
                    ),
                    SizedBox(height: Configuration.verticalspacing*1.5),
                  ],
                )
              );
            }
          );
        });
    }
    
    Widget bell(IntervalBell b, setState, int i){
      return ListTile(
        key: Key(i.toString()),
        title: Text(b.name, style: Configuration.text('small',Colors.black)),
        subtitle: Text((b.repeat ? 'Every ': 'At ') + b.playAt.toString() + ' min',  style:Configuration.text('small',Colors.grey,font: 'Helvetica')),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            OutlinedButton(
              onPressed: (){
                addModifyBell(b:b, i:i).then((d){setState((){});});
              },
              child: Icon(Icons.edit, color: Colors.blue, size: Configuration.smicon-5),
              style: OutlinedButton.styleFrom(
                primary: Colors.white,
                side:BorderSide(color: Colors.blue),
                padding:EdgeInsets.all(8),
                shape: CircleBorder()
              ),
            ),
            OutlinedButton(
              onPressed: (){
                _meditationstate.bells.remove(b);
                setState((){});
              },
              child: Icon(Icons.remove,color:Colors.red, size:Configuration.smicon-5),
              style: OutlinedButton.styleFrom(
                primary: Colors.white,
                side:BorderSide(color: Colors.red),
                padding:EdgeInsets.all(8),
                shape: CircleBorder()
              ),
            ),
          ],
        ),
      );
    }

    return layout(
      Column(
      children: [
        SizedBox(height: Configuration.verticalspacing*2),
        buttonModal(
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              CirclePicker(),
              SizedBox(height: Configuration.verticalspacing*1.5),
              Text('Warm up', style: Configuration.text('small',Colors.black)),
              SizedBox(height: Configuration.verticalspacing),
              HorizontalPicker(
                minValue: 0,
                maxValue: 90,
                divisions: 18,
                selectedValue: _meditationstate.selmeditation.meditationSettings.warmuptime ,
                onChanged:(value){
                  _meditationstate.selmeditation.meditationSettings.warmuptime = value;
                },
                suffix: " s",
                initialPosition: InitialPosition.start,
                showCursor: false,
                backgroundColor: Colors.grey.withOpacity(0.6),
                activeItemTextColor: Colors.lightBlue,
                passiveItemsTextColor: Colors.black.withOpacity(0.8),
                height: Configuration.verticalspacing*6,
              ),
              SizedBox(height: Configuration.verticalspacing*2),
            ],
          ),
          'Duration', 
          Observer(
              builder: (context) {
                return Text(_meditationstate.selmeditation.duration.inMinutes.toString() + ' min ', style: Configuration.text('small', Colors.black, font:'Helvetica'));
              }
            ),
            true
        ),
        SizedBox(height: Configuration.verticalspacing*2),
        buttonModal(
          Container(
            height: Configuration.height*0.4,
            padding: EdgeInsets.all(Configuration.smpadding),
            child: Center(
              child: Text(
                'We are working on recording some great ambient sounds for the app. Any help is appreciated!!', 
                style: Configuration.text('small', Colors.black),
              ),
            ),
          ), 
          "Ambient Sound", 
          Text('Coming soon',style: Configuration.text('small', Colors.black, font:'Helvetica')),
          true
        ),
        SizedBox(height: Configuration.verticalspacing*2),
        buttonModal(
          StatefulBuilder(
            builder: (context,setState) {
              int i = 0;

              return Column(
                mainAxisSize:MainAxisSize.min,
                children: [
                  SizedBox(height: Configuration.verticalspacing*2),

                  _meditationstate.bells.length == 0 ? 
                  Text('Press add to set up a new bell for the meditation',  style:Configuration.text('small',Colors.black,font: 'Helvetica')):
                  Column(children:_meditationstate.bells.map((IntervalBell b){
                    return bell(b,setState,i++);
                  }).toList()),
                  SizedBox(height: Configuration.verticalspacing*2),
                  OutlinedButton(
                    onPressed: (){
                      addModifyBell().then((d){setState((){});});
                    },
                    child: Row(
                      mainAxisSize:MainAxisSize.min,
                      children: [
                        Text('Add new interval bell',style: Configuration.text('tiny', Colors.green),),

                        Icon(Icons.add, color: Colors.green,size: Configuration.smicon-5),
                      ],
                    ),
                    style: OutlinedButton.styleFrom(
                      primary: Colors.white,
                      side:BorderSide(color: Colors.green),
                      padding:EdgeInsets.all(Configuration.tinpadding),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(Configuration.borderRadius),
                        side: BorderSide(color: Colors.black)
                      )
                    ),
                  ),
                  SizedBox(height: Configuration.verticalspacing*5)
                ],
              );
            }
          ), 
          "Interval Bell", 
          // NO HACE FALTA OBSERVER
          Container(
            
            constraints: BoxConstraints(
              maxWidth: Configuration.width*0.5
            ),
            child: OverflowBox(
              child: Row(
                mainAxisAlignment:MainAxisAlignment.end,
                children:_meditationstate.bells.length > 0 ?
                  [
                    Flexible(child: Text(getBellString(),
                    overflow: TextOverflow.ellipsis, 
                    style:Configuration.text('small',Colors.black,font: 'Helvetica'))
                    )
                  ]
                : [Text('None', style:Configuration.text('small',Colors.black,font: 'Helvetica'))]
              ),
            ),
          ),
          true
        ),

        SizedBox(height: Configuration.verticalspacing*2),
      
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            OutlinedButton(
            onPressed:(){
              showModalBottomSheet(
                isScrollControlled: false,
                barrierColor: Colors.black.withOpacity(0.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(Configuration.borderRadius/2)),
                ),
              context: context, 
              builder: (context){
                return savePreset();
                
              });
            },
            child:Text('Save this session', style: Configuration.text('small', Colors.lightBlue)),
            style: OutlinedButton.styleFrom(
              side:BorderSide(color: Colors.lightBlue, width: 1),
              primary: Colors.lightBlue,
              elevation: 0
            ),
          ),

          OutlinedButton(
          onPressed:(){
            showModalBottomSheet(
              isScrollControlled: true,
              barrierColor: Colors.black.withOpacity(0.5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(Configuration.borderRadius/2)),
              ),
              context: context, 
              builder: (context){
                return presets();  
              });
          },
          child:Text('Use saved session', style: Configuration.text('small', Colors.lightBlue)),
          style: OutlinedButton.styleFrom(
            side:BorderSide(color: Colors.lightBlue, width: 1),
            primary: Colors.lightBlue,
            elevation:0
          ))
          ],
        )
      ]), 
      () {
         //ESTO LO PODRÍAMOS HACER EN OTRO SITIO !!!
        _meditationstate.createIntervalBells();
        
        // METER ESTO DENTRO !!!
        if(_meditationstate.selmeditation.meditationSettings.warmuptime > 0){
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => WarmUpScreen(m:_meditationstate.selmeditation)
            )
          );
        }else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CountDownScreen(
                then: (value){
                  setState((){});
                },
                content: _meditationstate.selmeditation,
              )
            )
          );
        }

      }, _meditationstate.selmeditation.duration.inMinutes > 0,
        'Set the timer for a free meditation' 
      );
  }

  Widget games() {
    Widget gamelist(){
      return GridView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: _userstate.data.stages[0].games.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: Configuration.crossAxisCount
        ), 
        itemBuilder: (context,index) {
          var game = _userstate.data.stages[0].games[index];
          var _blocked = _userstate.user.isGameBlocked(game);
          var gamebefore = _userstate.data.stages[0].games[game.position == 0 ? 0 : game.position-1];

          return ClickableSquare(
            /*
            rightlabel: Chip(
              _userstate.user.answeredquestions[game.cod] ? 
            ),*/
            text: game.title,
            image: game.image,
            onTap: (){
              _gamestate.selectgame(game);
              setState(() {});
            },
            selected: _gamestate.selectedgame != null && _gamestate.selectedgame.cod == game.cod,
            blocked: _blocked,
            blockedtext: 'Complete '+ gamebefore.title,
          );
          /*
          return GestureDetector(
            onTap: ()=> setState((){
              
            }),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.0),
                color:    ? Colors.grey.withOpacity(0.1) : Colors.transparent,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 5),
                  Container(
                    width: Configuration.width*0.35,
                    height: _gamestate.selectedgame != null && _gamestate.selectedgame.cod == game.cod ?  
                    Configuration.width*0.3: Configuration.width * 0.26,
                    decoration: BoxDecoration(
                      image: DecorationImage(image: NetworkImage(game.image)),
                    ),
                   child:
                    _blocked ? 
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.7)
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(Icons.lock),
                          Text('Complete ' +  gamebefore.title , style: Configuration.text('verytiny', Colors.black), textAlign: TextAlign.center,)
                        ],
                      ),
                    )  :
                    Stack(
                     children: [
                       _gamestate.selectedgame != null && _gamestate.selectedgame.cod == game.cod ?
                       Positioned(
                         top: -5,
                         right: 25,
                         child:
                         Chip(
                           side: BorderSide.none,
                           label: Text( 
                             (_userstate.user.answeredGame(game.cod) ? _userstate.user.answeredquestions[game.cod].toString(): '0' )
                             + '/' + game.questions.length.toString(), 
                              style: Configuration.text('mini', Colors.white)
                            )
                          )
                       ) : Container()
                     ],
                   ),
                  ),
                  SizedBox(height: 10),
                  Text(game.title, style: Configuration.text('small', _blocked ?  Colors.grey:  Colors.black),)
                ]
              ),
            ),
          );*/
        });
    }

    return layout(
      gamelist(), 
      () {
         _gamestate.startgame();
        Navigator.pushNamed(context,'/gamestarted').then((value) => setState(()=>{}));
      },
      _gamestate.selectedgame != null,
      'Concentration games'
    );
  }

  Widget layout(child, onPressed, condition,[title]){
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        SizedBox(height: Configuration.verticalspacing*2.5),
        title != null ? Center(child: Text(title,style: Configuration.text('smallmedium', Colors.black),textAlign: TextAlign.center)): Container(),
        SizedBox(height: Configuration.verticalspacing), 
        Expanded(child: 
          child,
        ),
        BaseButton(
          margin:true,
          onPressed:condition ? ()=> onPressed() : null,
        ),
      ],
    );
  }

  /*
  Widget guidedMeditations(){
    return ListView(
        physics: ClampingScrollPhysics(),
        children:[
          SizedBox(height: Configuration.verticalspacing*2.5),
          MeditationList()
        ]
    );
  }*/

  @override 
  void initState(){
    super.initState();
  }

  @override 
  void didChangeDependencies(){
    super.didChangeDependencies();
    _userstate = Provider.of<UserState>(context);
    _meditationstate = Provider.of<MeditationState>(context);
    _meditationstate.practice = PageController(initialPage: _meditationstate.currentpage);
    selectedstage = _userstate.user.stagenumber;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _gamestate = Provider.of<GameState>(context);

    return PageView(
      physics: ClampingScrollPhysics(),
      controller: _meditationstate.practice,
      onPageChanged: (newPage) {
        setState(() {
          _meditationstate.switchpage(newPage, true);
        });
      },
      children: [freeMeditation(), games()],
    );
  }
}

class MeditationList extends StatefulWidget {

  const MeditationList({
    Key key,
  }) : super(key: key);

  @override
  State<MeditationList> createState() => _MeditationListState();
}

class _MeditationListState extends State<MeditationList> {
  MeditationState _meditationstate;
  UserState _userstate;
  List<int> stages = [1,2,3,4,5,6,7,8,9,10];
  List <Meditation> stageMeditations = new List.empty(growable:true);
  List<Meditation> optionalMeditations = new List.empty(growable: true);

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void didChangeDependencies(){
    super.didChangeDependencies();

    _meditationstate = Provider.of<MeditationState>(context);
    _userstate = Provider.of<UserState>(context);

    for(Stage s in _userstate.data.stages){
      for(Meditation m in s.meditpath){
        stageMeditations.add(m);
      }
    }

    optionalMeditations = _userstate.data.nostagemeditations;

  }

  List<Widget> meditations(meditations, optional) { 
    List<Widget> meditcontent = new List.empty(growable: true);

    for(Meditation m in meditations){
      var _blocked = !optional && _userstate.user.isBlocked(m);
      String blockedText = _blocked ?  'Unlocked ' + (_userstate.user.stagenumber == m.stagenumber ? 'after ' + meditations[m.position-1].title : 'at stage '+ m.stagenumber.toString()) : '';  

      meditcontent.add(
        ClickableSquare(
          rightlabel: _blocked ? null : 
          Container(
            padding: EdgeInsets.all(2),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Configuration.borderRadius),
              color: Colors.lightBlue,
            ),
            child: Icon(
              m.getIcon(),
              size: Configuration.smicon,
              color: Colors.white,
            ),
          ),
          blockedtext:blockedText,
          blocked: _blocked,
          text: m.title,
          selected: true,
          image: m.image,
          onTap:(){
            // ESTO HAY QUE PASARLO A UNA FUNCIÓN COMÚN
            meditationModal(m);
          
          }    
        )
      );
    }
      
    return meditcontent;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:EdgeInsets.symmetric(horizontal:Configuration.smpadding),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children:[ 
            Text('Stage meditations',style:Configuration.text('smallmedium',Colors.black)),
            SizedBox(height: Configuration.verticalspacing),
            GridView(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: Configuration.crossAxisCount,
                crossAxisSpacing: Configuration.verticalspacing,
                mainAxisSpacing: Configuration.verticalspacing
              ),
              children: meditations(stageMeditations,false)
            ),
            SizedBox(height: Configuration.verticalspacing),
            Text('Optional meditations',style:Configuration.text('smallmedium',Colors.black)),
            SizedBox(height: Configuration.verticalspacing),
            GridView(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate:SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: Configuration.crossAxisCount,
                crossAxisSpacing: Configuration.verticalspacing,
                mainAxisSpacing: Configuration.verticalspacing
              ),
              children: meditations(optionalMeditations,true)
            ),
          ]
        ),
      ),
    );
  }
}


// PASARLE CONTENT  !!!!!!!!!!!!
class ClickableSquare extends StatelessWidget {
  String blockedtext, image,text;
  bool selected; 
  dynamic onTap;
  bool blocked, border;
  Widget rightlabel;

  ClickableSquare({this.border = false, this.blockedtext,this.onTap,this.blocked= false,this.image,this.selected= false,this.text, this.rightlabel}) : super();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if(!blocked && onTap is Function){
          onTap();
        }
      },
      child: Container(
        padding: EdgeInsets.all(selected ? 0 : Configuration.tinpadding),
        decoration: BoxDecoration(
          border: border ? Border.all(color: Colors.grey, width: 1) : null,
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Stack(
          children: [
            Positioned.fill(child:ClipRRect(
              borderRadius: BorderRadius.circular(12.0),
              child: image != null && image != '' ? 
              Image(image: CachedNetworkImageProvider(image)) : Container(),
            )),
            
            
            
              
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(12.0),
                    bottomLeft: Radius.circular(12.0),
                  ),
                  color: blocked ? Colors.transparent : Colors.black.withOpacity(0.5),
                ),
                child: Center(
                  child: Text(
                    text,
                    style: Configuration.text('small', Colors.white),
                    textAlign: TextAlign.center,
                  ),
                )
              )
            ),



            Positioned.fill(
              child: AnimatedContainer(
                  padding: EdgeInsets.all(0),
                  key: Key(text),
                  duration: Duration(seconds: 2),
                  decoration:BoxDecoration(
                    color: blocked
                    ? Colors.black.withOpacity(0.7).withOpacity(0.8)
                    : Colors.transparent,
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: blocked ?
                   Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(Icons.lock, size:Configuration.smicon,color: Colors.white),
                      SizedBox(height: 4),
                      Text(blockedtext, style: Configuration.text('tiny', Colors.white), textAlign: TextAlign.center,)
                    ],
                  ): Container(), 
                ),
            ),

              
            rightlabel != null ?
              Align(
                alignment: Alignment.topRight,
                child: Container(
                  padding: EdgeInsets.only(right:4, top:4),
                  child: rightlabel,
                ),
              ): Container(),
          ],
        ),
      )
    );
  }
}


//VISTA DE MEDITACIÓN
class Countdown extends StatefulWidget {
  const Countdown({Key key}) :  super(key: key);

  @override
  _CountdownState createState() => _CountdownState();
}

class _CountdownState extends State<Countdown> {
  var started = false;
  MeditationState _meditationstate;
  UserState _userstate;
  int _index = 0;

  //podriamos utilizar meditationstate de arriba
  var meditationtype = 'free';
  var selectedstage = 1;
  var selectedtype = 'Meditation';
  var finished = false;
  var selectedduration = 15;

  bool shadow = false;
  bool delaying = false;

  Widget finish(context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        WeekList(),
        SizedBox(height: Configuration.verticalspacing*3),
        Text('Total meditations: ' + (_userstate.user.totalMeditations.length).toString(),
          style: Configuration.text('medium', Colors.white)),
        SizedBox(height: Configuration.verticalspacing*3),
        Text('Current streak: ' + (_userstate.user.userStats.streak).toString() + ' day' + (_userstate.user.userStats.streak > 1 ? 's':''),
          style: Configuration.text('medium', Colors.white)),
        SizedBox(height: Configuration.verticalspacing*3),
        Text('Total time meditated: ' + _userstate.user.timemeditated,
          style: Configuration.text('medium', Colors.white))
      ],
    );
  }

  Widget preguided(context) {
    List<Widget> getBalls() {
      List<Widget> res = new List.empty(growable: true);
      _meditationstate.selmeditation.content.forEach((key, value) {
        int index = int.parse(key);
        res.add(Container(
          width: Configuration.safeBlockHorizontal * 3,
          height: Configuration.safeBlockHorizontal * 3,
          margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _index == index
                ? Colors.white
                : Color.fromRGBO(0, 0, 0, 0.4),
          ),
        ));
      });
      return res;
    }

    List<Widget> getContent(index) {
      List<Widget> l = mapToWidget(_meditationstate.selmeditation.content[index.toString()]);

      if (finished && index != null && index == _meditationstate.selmeditation.content.length -1) {
        l.add(SizedBox(height: Configuration.height * 0.02));
        l.add(BaseButton(
          margin:true,
          text:'Start Timer',
          onPressed: () {
            // SE PODRÍA HACER EL START CUANDO SE ABRE LA VENTANA DE COUNTDOWN
             // _meditationstate.startMeditation(_userstate.user, _userstate.data);
            Navigator.pushReplacement(
                context, 
                PageRouteBuilder(
                    pageBuilder: (context, animation1, animation2){
                      return CountDownScreen(
                        onClose: (){
                          showAlertDialog(
                            context:context,
                            title: 'Are you sure you want to exit?',
                            text: 'This meditation will not count',
                            onYes:(){
                              _meditationstate.cancel();
                            },
                            onNo:(){
                              if(_meditationstate.state == _meditationstate.meditating || _meditationstate.state == _meditationstate.paused){
                                _meditationstate.startTimer();
                              }
                            }
                          );
                        },
                        onEnd:(){
                          Navigator.pushReplacement(
                            context, 
                            PageRouteBuilder(
                                pageBuilder: (context, animation1, animation2){
                                  return CountDownScreen(
                                    onClose:(){
                                      
                                    },
                                  );
                                },
                                transitionDuration: Duration.zero,
                                reverseTransitionDuration: Duration.zero,
                            ),
                          );
                        },
                       
                      );
                    },
                    transitionDuration: Duration.zero,
                    reverseTransitionDuration: Duration.zero,
                ),
              );
          },
        ));
      }

      return l;
    }

    /*
    Widget durationButton(duration){
      return OutlinedButton(
        onPressed: (){
          setState(() {
            selectedduration = int.parse(duration);
          });
        }, 
        style: OutlinedButton.styleFrom(
          backgroundColor: selectedduration.toString() == duration ? Configuration.maincolor : Colors.transparent,
          primary: Colors.white,
          textStyle: Configuration.text('small', Colors.white)
        ),
        child: Text(duration)
      );
    }*/

    return Stack(children: [
      CarouselSlider.builder(
          itemCount: _meditationstate.selmeditation.content.entries.length,
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
                  if (_index == _meditationstate.selmeditation.content.entries.length - 1) {
                    finished = true;
                  }
                });
              })),
      Align(
        alignment: Alignment.bottomCenter,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            CarouselBalls(
              activecolor: Colors.white,
              items: _meditationstate.selmeditation.content.entries.length,
              index: _index,
              key:Key(_index.toString())

              ),
          ],
        ),
        )
    ]);
  }

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

  Widget countdown(context){
   
    Widget slider(){
      return Slider(
        activeColor: Configuration.maincolor,
        inactiveColor: Colors.white,
        min: 0.0,
        max: _meditationstate.totalduration.inSeconds.toDouble(),
        onChanged: (a)=> null, 
        value: _meditationstate.totalduration.inSeconds - _meditationstate.duration.inSeconds.toDouble(),
        label: _meditationstate.duration.inHours > 0
              ? _meditationstate.duration.toString().substring(0, 7)
              : _meditationstate.duration.toString().substring(2, 7)
      );
    }

    Widget pauseButton(){
      return  FloatingActionButton(
      backgroundColor: Colors.white,
      onPressed: () => setState(()=> _meditationstate.state == _meditationstate.meditating ? _meditationstate.pause() :  _meditationstate.startTimer()),
      child: Icon(_meditationstate.state == _meditationstate.meditating ?  Icons.pause  : Icons.play_arrow, color: Colors.black)
      );           
    }

    Widget squareHeader(Meditation meditation){
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
           Container(
              height: Configuration.height*0.35,
              width: Configuration.height*0.35,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(Configuration.borderRadius/2),
                child: meditation != null ? Image(image: CachedNetworkImageProvider(meditation.image)) : Container(),
              ),
            ),
            SizedBox(height: Configuration.verticalspacing*2),
            GestureDetector(
              onDoubleTap: (){
                _meditationstate.finishMeditation();
              }, 
              child: Text(
                meditation != null ? 
                meditation.title : 
                "Enjoy meditating",style: Configuration.text('smallmedium',Colors.white))
          )
          
        ],
      );
    }

    Widget showSentence(){
      return Container(
        padding: EdgeInsets.all(Configuration.smpadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: mapToWidget(_meditationstate.currentsentence)
        ),
      );
    }


    return Stack(
      fit: StackFit.expand,
      children: [
      /*
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
      
      _meditationstate.currentsentence == null ?
      Align(
        alignment: Alignment.center,
        child: squareHeader(_meditationstate.selmeditation) ,
      ): Container(),*/
      /* 
      Positioned.fill(
        child: AudioLayout(
          onAudioEnd:(){

          },
          audioFile: _meditationstate.selmeditation.file,
          image: _meditationstate.selmeditation.image,
          title: _meditationstate.selmeditation.title,
          description: _meditationstate.selmeditation.description,
      )),*/
      // mejorar esto !!DE MOMENTO QUITAMOS EL SHADOW, QUEDA EXTRAÑO !!
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

      _meditationstate.currentsentence != null ? 
      showSentence() : Container(),
    ]);
  }

  // el warmup será algo rollo get ready ???
  Widget warmup(context){
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Observer(
          builder: (context) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(_meditationstate.warmuptime.floor().toString() + ' s',
                  style: Configuration.text('big', Colors.white)),
              ],
            );
          }
        ),
        SizedBox(height: Configuration.verticalspacing),
        Text('Get ready for the meditation', style: Configuration.text('small',Colors.white))
      ],
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _meditationstate = Provider.of<MeditationState>(context);
    _userstate = Provider.of<UserState>(context);

    _meditationstate.shadow = false;

    if(_meditationstate.state == _meditationstate.warmup){
      _meditationstate.startWarmup();
    }else if(_meditationstate.state != _meditationstate.premeditation){
     // _meditationstate.startMeditation(_userstate.user, _userstate.data);
    }else{
      // guardamos las imágenes en cache !!!
      if (_meditationstate.selmeditation != null && _meditationstate.selmeditation.followalong != null){
        var configuration = createLocalImageConfiguration(context);
        _meditationstate.selmeditation.followalong.values.forEach((value) {
          if(value['image']!=null){
            new NetworkImage(value['image'])..resolve(configuration);
          }
        });
      }
    }
  }

  dynamic exit(context,{nopop = false}){
    bool pop = true;

    if(_meditationstate.state == _meditationstate.meditating){
      _meditationstate.pause();
    }
    
    if(_meditationstate.state != _meditationstate.finished){
      showAlertDialog(
        context:context,
        title: 'Are you sure you want to exit?',
        text:'This meditation will not count',
        onYes:(){
          _meditationstate.cancel();
          pop = true;
        },
        onNo:(){
          if(_meditationstate.state == _meditationstate.meditating || _meditationstate.state == _meditationstate.paused){
            _meditationstate.startTimer();
            pop = false;
          }
        }
      );
    }else{
      if(!nopop){
        Navigator.pop(context);
      }
    }

    return pop;
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);

    return WillPopScope(
      onWillPop: () {  
        return Future.value(exit(context,nopop: true));
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: Observer(
            builder: (context) {
              return IconButton(
                icon: Icon(Icons.close),
                color: _meditationstate.shadow ? Colors.black : Colors.white,
                onPressed: () {
                  exit(context);
                },
                );
            }
          ),
        ),
        extendBodyBehindAppBar: true,
        body: Container(
          decoration:  BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  Colors.black.withOpacity(0.8),
                  Configuration.maincolor,
                ],
              )
            ),
          child: Observer(
            builder: (BuildContext context) {
              //MIRAR DE CAMBIAR ESTOS ESTADOS POR UN ENUM
              if (_meditationstate.state == _meditationstate.premeditation) {
                return preguided(context);
              } else if (_meditationstate.state == _meditationstate.meditating || _meditationstate.state == _meditationstate.paused ) {
                return countdown(context);
              }else if(_meditationstate.state == _meditationstate.warmup){
                return warmup(context);
              }else if(_meditationstate.state == _meditationstate.finished) {
                return finish(context);
              }else{
                return Container();
              }
            }
          ),
        )
      ),
    );
  }
}





// VISTA DE TABLETS !!!!
/*
class TabletMeditationScreen extends StatefulWidget {
  @override
  _TabletMeditationScreenState createState() => _TabletMeditationScreenState();
}

class _TabletMeditationScreenState extends State<TabletMeditationScreen> {
  UserState _userstate;
  MeditationState _meditationstate;
  GameState _gamestate;

  int _index;

  //podriamos utilizar meditationstate de arriba
  var meditationtype = 'free';
  var selectedstage = 1;
  var selectedtype = 'Meditation';
  var finished = false;

  Widget freeMeditation() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TimePicker(),
        SizedBox(height: Configuration.height * 0.1),
        TabletStartButton(
          onPressed: () => {
            _meditationstate.setMeditation(MeditationModel(duration: Duration(minutes: seltime), type:"free") , _userstate.user, _userstate.data),
            Navigator.pushNamed(context, '/tabletcountdown').then((value) => setState(()=>{
            })),
          },
        ),
      ],
    );
  }

  Widget guidedMeditation() {
    List<Widget> meditations() {
      List<Widget> meditations = new List.empty(growable:true);
      for (var meditation in _userstate.data.stages[selectedstage - 1].meditpath) {
        var _blocked = _userstate.user.meditposition < meditation.position && _userstate.user.stagenumber == meditation.stagenumber || _userstate.user.stagenumber < meditation.stagenumber;
        meditations.add(GestureDetector(
            onTap: () => !_blocked ? setState(() => _meditationstate.selmeditation = meditation) : null,
            child: Container(
              decoration: BoxDecoration(
                border: _meditationstate.selmeditation != null && _meditationstate.selmeditation.cod == meditation.cod ? 
                Border.all(color: Configuration.maincolor) : null),
              child: Column(children: [
                Container(
                  width: Configuration.width* 0.06,
                  height:Configuration.width* 0.06,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.0),
                    image: DecorationImage(
                        image: NetworkImage(meditation.image)))),
                Text(
                  meditation.title,
                  style: Configuration.tabletText('mini', _blocked ? Colors.grey : Colors.black),
                  textAlign: TextAlign.center,
                )
              ]),
            )
            )
          );
      }

      return meditations;
    }

    Widget stages() {
      var stages = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
      var types = ['Meditation', 'Game'];

      return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(children: [
              Text('Stage',
                style: Configuration.tabletText('verytiny', Colors.black),
              ),
              SizedBox(width: Configuration.blockSizeVertical * 1),
              DropdownButton<int>(
                  value: selectedstage,
                  elevation: 16,
                  style: TextStyle(color: Colors.black),
                  underline: Container(
                    height: 0,
                    color: Colors.deepPurpleAccent,
                  ),
                  onChanged: (int newValue) {
                    setState(() {
                      selectedstage = newValue;
                    });
                  },
                  items: stages.map<DropdownMenuItem<int>>((int value) {
                    return DropdownMenuItem<int>(
                      value: value,
                      child: Text(value.toString()),
                    );
                  }).toList())
            ]),
            Row(children: [
              Text(
                'Type',
                style: Configuration.tabletText('verytiny', Colors.black),
              ),
              SizedBox(width: Configuration.blockSizeVertical * 1),
              DropdownButton<String>(
                  value: selectedtype,
                  elevation: 16,
                  style: TextStyle(color: Colors.black),
                  underline: Container(
                    height: 0,
                    color: Colors.deepPurpleAccent,
                  ),
                  onChanged: (String newValue) {
                    setState(() {
                      selectedtype = newValue;
                    });
                  },
                  items: types.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value.toString()),
                    );
                  }).toList())
            ]),
          ]);
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
            height: Configuration.height * 0.45,
            width: Configuration.height*0.45,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.0)),
            child: Column(children: [
              Container(
                height: Configuration.height * 0.05,
                child: stages(),
              ),
              Expanded(
                child: GridView(
                    padding: EdgeInsets.all(12.0),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3),
                    children: meditations()),
              )
            ])
        ),
        SizedBox(height: 20),
        TabletStartButton(
          onPressed: () => {
            _meditationstate.state ='pre_guided', 
            Navigator.pushNamed(context, '/tabletcountdown').then(
              (value) => setState(()=>{
                _userstate.user.progress != null ? 
                autocloseDialog(context, _userstate.user, isTablet: true) : null
              })), 
          },
        )
      ],
    );
  }

  Widget games() {
    List<Widget> gamelist(){
        List<Widget> g = new List.empty(growable: true);
        for(var element in _userstate.data.stages[0].games){
          g.add(
            Column(
              children: [
                GestureDetector(
                    onTap: ()=> setState(()=> _gamestate.selectgame(element)),
                    child: Container(
                    decoration: BoxDecoration(border: _gamestate.selectedgame != null && _gamestate.selectedgame.cod == element.cod ? Border.all(color: Configuration.maincolor): Border()),
                    width: Configuration.width*0.12,
                    child: AspectRatio(
                      aspectRatio: 1/1,
                      child: Container( 
                        margin: EdgeInsets.all(Configuration.tinpadding),
                        decoration: BoxDecoration(color: Colors.grey))),
                  ),
                ),
                Text(element.title, style: Configuration.tabletText('tiny',Colors.black),)
              ],
            )
        );

      return g;
      }
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            height: Configuration.height * 0.4,
            child: Column(
              children: gamelist(),
              ), 
          ),
          TabletStartButton(
            onPressed: () { 
              _gamestate.startgame();
              Navigator.pushNamed(context,'/gamestarted');
            },
          )
      ]),
    );
  }

  Widget chiporText(String text, bool chip){
      Widget g;

      var types = {'Guided':'guided','Free':'free','Games':'games'};

      if (chip){
        g = Chip(padding: EdgeInsets.all(12), label: Text(text, style: Configuration.tabletText('tiny', Colors.black)));
      } else {
        g = Text(text, style: Configuration.tabletText('tiny', Colors.black));
      }

      return GestureDetector(
        onTap: () {
          setState(() {
            _meditationstate.switchtype(types[text]);
          });
        },
        child: Container(padding: EdgeInsets.all(14.0), child: g)
      );
    }

  @override
  void dispose() {
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    _meditationstate = Provider.of<MeditationState>(context);
    _gamestate = Provider.of<GameState>(context);
    _userstate = Provider.of<UserState>(context);

    return Column(
     children: [
      SizedBox(height: Configuration.height*0.1),
      Container(
          child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Observer(builder: (BuildContext context) {  
              return chiporText('Free', _meditationstate.currentpage == 0);
            }),
            
            Observer(builder: (BuildContext context) {  
              return chiporText('Guided', _meditationstate.currentpage == 1);
            }),
            
            Observer(builder: (BuildContext context) {  
              return chiporText('Games', _meditationstate.currentpage == 2);
            })
          ]
        ),
      ),
      SizedBox(height: Configuration.height*0.05),
      Container(
        height: Configuration.height*0.6,
        child:PageView(
          controller: _meditationstate.practice,
          onPageChanged: (newPage) {
            setState(() {
              _meditationstate.switchpage(newPage);
            });
          },
            children: [freeMeditation(), guidedMeditation(),games()],
          ) 
        )
      ]
    );
  }
}

class TabletCountdown extends StatefulWidget {
  TabletCountdown({
    Key key
  }) :  super(key: key);

  @override
  _TabletCountdownState createState() => _TabletCountdownState();
}

class _TabletCountdownState extends State<TabletCountdown> {
  var started = false;
  MeditationState _meditationstate;
  UserState _userstate;
  int _index;

  //podriamos utilizar meditationstate de arriba
  var meditationtype = 'free';
  var selectedstage = 1;
  var selectedtype = 'Meditation';
  var finished = false;

  Widget finish(context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          height: Configuration.height,
          width: Configuration.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              WeekList(),
              SizedBox(height: Configuration.height * 0.05),
              Text('Total meditations: ' + (_userstate.user.totalMeditations.length).toString(),
                style: Configuration.tabletText('tiny', Colors.black))
            ],
          ),
        )
      ],
    );
  }

  Widget guided(context) {
    List<Widget> getBalls() {
      List<Widget> res = new List.empty(growable: true);
      _meditationstate.selmeditation.content.forEach((key, value) {
        int index = int.parse(key);
        res.add(Container(
          width: Configuration.safeBlockHorizontal * 2,
          height: Configuration.safeBlockHorizontal * 2,
          margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _index == index
                ? Color.fromRGBO(0, 0, 0, 0.9)
                : Color.fromRGBO(0, 0, 0, 0.4),
          ),
        ));
      });
      return res;
    }

    Widget getContent(slide) {

      return Container(
        padding: EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            slide['title'] != null ? Text(slide['title'],style: Configuration.tabletText('small', Colors.black, font: 'Helvetica')) : Container(),
            slide['image'] != null ? Image(image: NetworkImage(slide['image'])) : Container(),
            slide['text'] != null ?  Text(slide['text'], style: Configuration.tabletText('tiny', Colors.white,font:'Helvetica')) : Container(),
            SizedBox(height: Configuration.height*0.02),
            AnimatedOpacity(
            duration: Duration(seconds: 5),
            opacity: finished ? 1 : 0,
            child: TabletStartButton(
              onPressed: ()=> {_meditationstate.setMeditation(_meditationstate.selmeditation, _userstate.user, _userstate.data)},
              ),
            )
        ]),
      );
    }

    return Stack(children: [
      CarouselSlider.builder(
          itemCount: _meditationstate.selmeditation.content.entries.length,
          itemBuilder: (context, index) {
            return getContent(_meditationstate.selmeditation.content[index.toString()]);
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
                  if (_index == _meditationstate.selmeditation.content.entries.length - 1) {
                    finished = true;
                  }
                });
              })
      ),
      Align(
        alignment: Alignment.bottomCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: getBalls(),
        ),
      ),
    ]);
  }

  Widget countdown(context){
    return Stack(
        children: [
        Align(
          alignment: Alignment.center,
          child: _meditationstate.selmeditation.type != 'free' ? 
            Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: Configuration.height*0.1,
                width: Configuration.height*0.1,
                child: Image(image: NetworkImage(_meditationstate.selmeditation.image),fit: BoxFit.cover),
                decoration: BoxDecoration(borderRadius: BorderRadius.circular(20.0)),
              ),
              SizedBox(height: Configuration.blockSizeVertical*3),
              Text(_meditationstate.selmeditation.title,style: Configuration.tabletText('tiny',Colors.white))
            ],
          ) :    
          Container(
            height: Configuration.blockSizeHorizontal * 30,
            width: Configuration.blockSizeHorizontal * 30,
            decoration: BoxDecoration(color: Configuration.grey, borderRadius: BorderRadius.circular(12.0)),
            child: Center(child: Text('free meditation', style:Configuration.tabletText('tiny', Colors.white))),
          ),
        ),
        Positioned(
          bottom: 50,
          right:10,
          left:10,
          child: Column(children: [
            Slider(
              activeColor: Configuration.maincolor,
              inactiveColor: Colors.white,
              min: 0.0,
              max: _meditationstate.selmeditation.duration.inMinutes.toDouble(),
              onChanged: (a)=> null, 
              value:_meditationstate.totalduration.inSeconds/60 - _meditationstate.duration.inSeconds/60 ,
              label:  _meditationstate.duration.inHours > 0
                    ? _meditationstate.duration.toString().substring(0, 7)
                    : _meditationstate.duration.toString().substring(2, 7)
            ),
            Observer(builder: (context) {
            if (_meditationstate.state == 'started') {
              return FloatingActionButton(
                  backgroundColor: Colors.white,
                  onPressed: () => _meditationstate.pause(),
                  child: Icon(Icons.pause, color: Colors.black));
            } else {
              return FloatingActionButton(
                  backgroundColor: Colors.white,
                  onPressed: () => _meditationstate.startTimer(),
                  child: Icon(Icons.play_arrow, color: Colors.black));
            }
          })
          ]),
        )
      ]);
  }

  @override
  Widget build(BuildContext context) {
    _meditationstate = Provider.of<MeditationState>(context);
    _userstate = Provider.of<UserState>(context);

    return Scaffold(
        appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
            icon: Icon(Icons.close),
            color: Colors.black,
            onPressed: () {
              _meditationstate.pause();
              Navigator.pop(context);
            },
          ),
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration:  BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [
                Color.fromRGBO(23,23,23,100),
                Configuration.maincolor,
              ],
            )
          ),
        child: Observer(
              builder: (BuildContext context) {
                if (_meditationstate.state == 'pre_guided') {
                  return guided(context);
                } else if (_meditationstate.state == 'started' || _meditationstate.state == 'paused') {
                  return countdown(context);
                } else {
                  return finish(context);
                }
              }
            ),
          )
        );
  }
}









*/

