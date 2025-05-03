import 'dart:async';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:meditation_app/domain/entities/meditation_entity.dart';
import 'package:meditation_app/domain/entities/stage_entity.dart';
import 'package:meditation_app/presentation/mobx/actions/game_state.dart';
import 'package:meditation_app/presentation/mobx/actions/meditation_state.dart';
import 'package:meditation_app/presentation/mobx/actions/user_state.dart';
import 'package:meditation_app/presentation/pages/commonWidget/back_button.dart';
import 'package:meditation_app/presentation/pages/commonWidget/carousel_balls.dart';
import 'package:meditation_app/presentation/pages/commonWidget/dialogs.dart';
import 'package:meditation_app/presentation/pages/commonWidget/html_towidget.dart';
import 'package:meditation_app/presentation/pages/commonWidget/start_button.dart';
import 'package:meditation_app/presentation/pages/contentWidgets/content_card.dart';
import 'package:meditation_app/presentation/pages/contentWidgets/meditation_screens.dart';
import 'package:meditation_app/presentation/pages/mainpages/game_screen.dart';
import 'package:provider/provider.dart';

import '../../../domain/entities/milestone_entity.dart';
import '../../../domain/entities/technique_entity.dart';
import '../commonWidget/horizontal_picker.dart';
import '../commonWidget/page_title.dart';
import '../config/configuration.dart';
import '../contentWidgets/meditation_widgets.dart';


List<IntervalBell> bells = [
  IntervalBell(sound: 'assets/audios/bowl-sound.mp3',name:'Bowl sound',image:'assets/audios/bowl.png'),
  IntervalBell(sound: 'assets/audios/gong.mp3',name:'Gong', image:'assets/audios/gong.mp3'),
  IntervalBell(sound: 'assets/audios/high-gong.wav',name:'High gong',image:'assets/audios/high-gong.png'),
  IntervalBell(sound: 'assets/audios/church-bell.mp3',name: 'Church bell', image:'assets/audios/church-bell.png'),
  IntervalBell(sound: 'assets/audios/bronze-bell.wav',name: 'Bronze bell', image:'assets/audios/bronze-bell.png'),
];


class MeditationWrapperScreen extends StatelessWidget {
  const MeditationWrapperScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: ButtonBack(color:Colors.black),
        title: Text('Free meditation', style: Configuration.text('subtitle', Colors.black)),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      backgroundColor: Configuration.lightgrey,
      body: MeditationScreen(),
    );
  }
}


class MeditationScreen extends StatefulWidget {
  bool  offline;

  MeditationScreen({this.offline = false}) : super();

  @override
  _MeditationScreenState createState() => _MeditationScreenState();
}

class _MeditationScreenState extends State<MeditationScreen> {
  UserState _userstate;
  MeditationState _meditationstate;
  GameState _gamestate;
  int seltime = 5;  

  //podriamos utilizar meditationstate de arriba
  var meditationtype = 'free';
  var selectedstage = 1;
  var selectedtype = 'Meditation';
  var finished = false;
  bool canStart = false;

  AssetsAudioPlayer assetsAudioPlayer = new AssetsAudioPlayer();

  bool pushedDialog = false;

  Widget buttonModal(child, text, selected,[scroll = false,then]){
    return AspectRatio(
      aspectRatio: Configuration.width>500 ? Configuration.buttonRatio : 11/2,
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
            }).then((value) {
              setState((){}); 
              if(then != null){
                then();
              }           
            })
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

  // ESTO TIENE QUE SER UN STATELESS WIDGET !!!
  Widget freeMeditation() {
    String whatIsplaying;
    
    // LISTA DE SONIDOS AMBIENTALES
    List<IntervalBell> ambientSounds = [
      IntervalBell(sound: 'assets/ambient_sounds/bonfire.mp3',name:'Bonfire',image:'assets/ambient_sounds/bonfire.jpg'),
      IntervalBell(sound: 'assets/ambient_sounds/ocean.mp3',name:'Ocean Waves ',image:'assets/ambient_sounds/ocean.jpg'),
      IntervalBell(sound: 'assets/ambient_sounds/rain.mp3',name: 'Rain', image:'assets/ambient_sounds/rain.jpg'),
      IntervalBell(sound: 'assets/ambient_sounds/thunderStorm.m4a',name: 'Thunder Storm', image:'assets/ambient_sounds/thunder.jpg'),
    ];


    Widget presets(){
      bool isEditingPresets = false;
      List<MeditationPreset> toRemove = new List.empty(growable: true);

      Widget myPresets(setSt){
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
                      maxWidth:Configuration.width*0.7,
                    ),
                    child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.timer,size: Configuration.tinicon),
                          Text(p.settings.isUnlimited ? 'Unlimited': '${p.duration} min', style: Configuration.text('tiny', Colors.black, font:'Helvetica')),
                                                    
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


                          p.settings.ambientsound != null && p.settings.ambientsound.name.isNotEmpty ? 
                          Container(
                            constraints: BoxConstraints(
                              maxWidth: Configuration.width*0.2
                            ),
                            child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.audiotrack,size: Configuration.tinicon),
                                  Flexible(
                                    child: Text(p.settings.ambientsound.name,
                                    overflow: TextOverflow.ellipsis,
                                    style: Configuration.text('tiny', Colors.black, font:'Helvetica')),
                                  ),
                                ],
                            ),
                          ) : Container(),

                          p.settings.bells != null && p.settings.bells.length > 0 ?
                          Container(
                          constraints: BoxConstraints(
                            maxWidth: Configuration.width*0.25
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.notifications,size: Configuration.tinicon),
                              Flexible(
                                child: Text(getBellString(bells:p.settings.bells), 
                                overflow: TextOverflow.ellipsis,
                                style: Configuration.text('tiny', Colors.black, font:'Helvetica'))
                              ),
                            ],
                          )): Container(),
                          
                          p.settings.warmuptime > 0 ?  
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.local_fire_department, size:  Configuration.tinicon),
                              Text('${p.settings.warmuptime.floor().toString()} s', style: Configuration.text('tiny', Colors.black, font:'Helvetica')),
                            ],
                          ) : Container()
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
                              setSt((){});
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
                    ): Container()
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
                   widget.offline ? Container():
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
      String presetName = '';

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
          return Padding(
            padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Container(
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
                  item('Duration',_meditationstate.selmeditation.meditationSettings.isUnlimited  ? 'Unlimited':   _meditationstate.selmeditation.duration.inMinutes.toString() + ' min'),
                  SizedBox(height: Configuration.verticalspacing),
                  item('Warm up time', _meditationstate.selmeditation.meditationSettings.warmuptime.floor().toString() + ' s'),
                  SizedBox(height: Configuration.verticalspacing),
                  item('Interval', _meditationstate.bells.length > 0 ? getBellString(bells: _meditationstate.bells) : 'No interval'),
                  SizedBox(height: Configuration.verticalspacing),
                  item('Ambient sound', _meditationstate.selmeditation.meditationSettings.ambientsound != null ? _meditationstate.selmeditation.meditationSettings.ambientsound.name : 'None'),
                  SizedBox(height: Configuration.verticalspacing),
                  item('Add Six step preparation', _meditationstate.selmeditation.meditationSettings.addSixStepPreparation ? 'Yes' : 'No'),
                  
                  SizedBox(height: Configuration.verticalspacing*2),

                  BaseButton(
                    onPressed: presetName.isNotEmpty ? (){
                      
                      MeditationPreset p = new MeditationPreset(
                        name: presetName,
                        duration: _meditationstate.selmeditation.duration.inMinutes,
                        settings:  _meditationstate.selmeditation.meditationSettings
                      );

                      // de momento esto hace falta !!
                      p.settings.bells = _meditationstate.bells;

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
            ),
          );
        }
      );
    }
    
    Widget volumeSlider({String text, String audio, onPressed, double value, onChanged, setState}){
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(text,style: Configuration.text('small',Colors.white)),
                  SizedBox(width: Configuration.verticalspacing),
                  Text(value.floor().toString() + '%',
                    style: Configuration.text('small',Colors.white.withOpacity(0.8),font: 'Helvetica'),
                  )
                ],
              ),

              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.white,
                  shape: CircleBorder(),
                  minimumSize: Size(0,0),
                  surfaceTintColor: Colors.white,
                  padding: EdgeInsets.all(6),
                  side: BorderSide(color: Colors.white)
                ),
                onPressed: (){
                  if(assetsAudioPlayer.isPlaying.value){
                    assetsAudioPlayer.stop().then((value) => setState((){})); 
                  }else{
                    whatIsplaying = text;
                    assetsAudioPlayer.open(
                      Audio(audio),
                      volume: value /  100
                    ).then((value) => setState((){}));
                  }
              }, child: Icon(
                assetsAudioPlayer.isPlaying.value  && whatIsplaying == text ? Icons.pause : Icons.play_arrow,
                color: Colors.white,
                size: Configuration.tinicon
              ))
            ],
          ),

          // CAMBIAR TODOS LOS SLIDERS A UN SLIDER COMÚN !!!
          SizedBox(
            height: Configuration.verticalspacing*2,
            child: SliderTheme(
              data: SliderThemeData(
                trackShape: CustomTrackShape(),
                thumbShape: RoundSliderThumbShape(enabledThumbRadius: Configuration.verticalspacing*1),
                minThumbSeparation: 5
              ),
              child: Slider(
                max: 100,
                activeColor: Colors.white,
                inactiveColor: Colors.grey,
                label: value.floor().toString() + '%',
                value: value, 
                divisions: 100,
                onChanged: (e){
                  assetsAudioPlayer.setVolume(e/100);
                  onChanged(e);
                }
              ),
            ),
          ),
        ]
      );
    }

    Widget settingsPage(){

      Widget bellSelector({String value, String text, Function onchange}){
        
        Widget bellSelectorDialog(){
          List<IntervalBell> currentbells = List.from(bells);

          if(text == 'Starting bell'){
            currentbells.insert(0, IntervalBell(name: 'None'));
          }

          return StatefulBuilder(
            builder: (context, setState) {
              return AbstractDialog(
                content: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(Configuration.borderRadius/4),
                    color: Configuration.lightgrey
                  ),
                  padding: EdgeInsets.all(Configuration.smpadding),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Select a bell',
                        style: Configuration.text('medium',Colors.black),
                      ),
                      Divider(color: Colors.black,thickness: 2),
                      SizedBox(height: Configuration.verticalspacing),
                      ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: currentbells.length,
                        itemBuilder: (context,index){
                          return RadioListTile(
                            activeColor: Colors.lightBlue,
                            groupValue: value,
                            value: currentbells[index].name,
                            title: Text(currentbells[index].name,
                              style: Configuration.text('small',Colors.black),
                            ),
                            onChanged: (String name){
                              assetsAudioPlayer.stop();
                              if(name != 'None'){
                                // hear the bell sound 
                                assetsAudioPlayer.open(
                                  Audio(currentbells[index].sound),
                                  volume: 1
                                );
                              }
                              setState(() {
                                value = name;
                              });

                              onchange(name);
                             // Navigator.pop(context);
                            },
                          );
                        },
                      ),
                      SizedBox(height: Configuration.verticalspacing),
                      BaseButton(
                        onPressed: (){
                          // se updateará cuando meditemos!! jejeje
                          _userstate.user.settings.meditation = _meditationstate.selmeditation.meditationSettings;
                          Navigator.pop(context);
                        },
                        text: 'Close',
                      ),
                      SizedBox(height: Configuration.verticalspacing*2)
                    ],
                  ),
                ),
              );
            }
          );
        }

        return TextButton(
          style: TextButton.styleFrom(
            padding: EdgeInsets.symmetric(vertical: Configuration.verticalspacing)
          ),
          onPressed: (){
            // open a dialog and show a list of available bells
            showDialog(
              context: context,
              builder: (context) => bellSelectorDialog()
            );              
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(text,style: Configuration.text('small',Colors.white)),
              value !=null && value != 'None' ?  
              Text(value, style: Configuration.text('small',Colors.white.withOpacity(0.8),font: 'Helvetica')) :
              Icon(Icons.add_circle_outline,color: Colors.white,size: Configuration.smicon),
            ],
          ),
        );
      }

      return StatefulBuilder(
        builder: (context,setState) {
          return AbstractDialog(
            content: SafeArea(
              top:true,
              child: ListView(
                physics: ClampingScrollPhysics(),
                children: <Widget>[
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Meditation settings',
                        style: Configuration.text('medium',Colors.white),
                      ),
                      Divider(color: Colors.white,thickness: 2),
                    ],
                  ),
                  Container(
                    constraints: BoxConstraints(
                      minHeight: Configuration.height * 0.65
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: Configuration.smpadding
                    ),
                    child: Column(
                      children: [
                        
                        bellSelector(
                          value: _meditationstate.selmeditation.meditationSettings.startingBell, 
                          onchange:(value)=>{
                            setState((){
                              _meditationstate.selmeditation.meditationSettings.startingBell = value;
                            })
                          },
                          text:'Starting bell'
                        ),
            
                        SizedBox(height: Configuration.verticalspacing*2),
            
                        bellSelector(
                          value:_meditationstate.selmeditation.meditationSettings.endingBell != null ? 
                          _meditationstate.selmeditation.meditationSettings.endingBell : 'Gong'
                          , 
                          onchange:(value)=>{
                            setState((){
                              _meditationstate.selmeditation.meditationSettings.endingBell = value;
                            })
                          },
                          text:'Ending bell'
                        ),
            
            
                        SizedBox(height: Configuration.verticalspacing*2),
            
                        TextButton(
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.all(0)
                          ),
                          onPressed: (){
                            setState((){
                              _meditationstate.selmeditation.meditationSettings.addSixStepPreparation  = !_meditationstate.selmeditation.meditationSettings.addSixStepPreparation;
                            });
                          },
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              // starting and ending bell
                              
            
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Add six step preparation',
                                      style: Configuration.text('small',Colors.white),
                                    ),
                                    SizedBox(height: Configuration.verticalspacing/2),
                                    Text('An audio guiding the six step preparation will be introduced at the beginning of the meditation',
                                      style: Configuration.text('tiny',Colors.white,font: 'Helvetica'),
                                    ),
                                    SizedBox(height: Configuration.verticalspacing/2),
                                    Text('5 extra minutes will be added',
                                      style: Configuration.text('tiny',Colors.white.withOpacity(0.7),font: 'Helvetica'),
                                    ),
                                  ],
                                ),
                              ),
                        
                              Container(
                                width: Configuration.width*0.2,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(_meditationstate.selmeditation.meditationSettings.addSixStepPreparation 
                                      ? 'Yes': 'No',
                                      style: Configuration.text('small',Colors.white,font:'Helvetica'),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      
                        SizedBox(height: Configuration.verticalspacing*2),
            
                        // ESTO ES DEL USUARIO MÁS QUE DE LA  MEDITACIÓN
                        volumeSlider(
                          text: 'Ambient volume',
                          value: _meditationstate.selmeditation.meditationSettings.ambientvolume,
                          audio: ambientSounds[0].sound,
                          onChanged:(e)=>{
                            setState((){
                              _meditationstate.selmeditation.meditationSettings.ambientvolume = e;
                            })
                          },
                          setState: setState
                        ),
                        
                        SizedBox(height: Configuration.verticalspacing*2),
            
                        volumeSlider(
                          text: 'Bells volume',
                          value: _meditationstate.selmeditation.meditationSettings.bellsvolume,
                          audio: bells[0].sound,
                          onChanged:(e)=>{
                            setState((){
                              _meditationstate.selmeditation.meditationSettings.bellsvolume = e;
                            })
                          },
                          setState: setState
                        ),
                      ],
                    ),
                  ),
                  
                  
                  SizedBox(height: Configuration.verticalspacing*2),
                  BaseButton(
                    text: 'Close',
                    textcolor: Colors.white,
                    color: Colors.white,
                    onPressed: (){
                      assetsAudioPlayer.stop();
                      Navigator.pop(context);
                    }
                  )
                ],
              ),
            ),
          );
        }
      );
    }

    Widget iconButton({IconData icon, Function onPressed, Color color = Colors.white, String text, width}){
      return OutlinedButton(
        style: OutlinedButton.styleFrom(
          minimumSize: Size( width != null ? width:  Configuration.width*0.4,0),
          padding: EdgeInsets.all(Configuration.tinpadding),
          side: BorderSide(color:Colors.grey)
        ),
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon,size: Configuration.smicon,color: Colors.black),
            SizedBox(width: Configuration.verticalspacing*2),
            Text(text, style: Configuration.text('small', Colors.black, font:'Helvetica'))
          ],
        ), 
      );
    }


    return SingleChildScrollView(
      physics: ClampingScrollPhysics(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SizedBox(height: Configuration.verticalspacing),
          
          pageTitle(
            'Free meditation',
            'Set a timer and meditate on your own',
            Icons.timer
          ),
          
          SizedBox(height: Configuration.verticalspacing),
          
          Container(
            padding: EdgeInsets.symmetric(horizontal: Configuration.smpadding),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: iconButton(
                    icon: Icons.settings,
                    onPressed: (){
                      setState(() {
                        pushedDialog = true;
                      });
                      showGeneralDialog(
                        context: context,
                        barrierColor: Colors.black12.withOpacity(0.93), // Background color
                        barrierDismissible: false,
                        barrierLabel: 'Dialog',
                        transitionDuration: Duration(milliseconds: 400),
                        pageBuilder: (_, __, ___) {
                          return settingsPage();
                        },
                      );
                    },
                    text: 'Settings'
                  ),
                ),
                
                
                
                SizedBox(width: Configuration.verticalspacing*2),
    
                
                iconButton(
                  icon: Icons.self_improvement,
                  onPressed: ()=>{
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: ((context) => PracticeSummary()))
                    )
                  },
                  text: 'Summary'
                )   
              ],
            ),
          ),
          
          
          SizedBox(height: Configuration.verticalspacing), 
          Container(
            margin: EdgeInsets.symmetric(horizontal: Configuration.smpadding),
            child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                ],
              ),
              
              SizedBox(height: Configuration.verticalspacing),
    
    
              buttonModal(
                MeditationDuration(),
                'Duration', 
                Observer(
                    builder: (context) {
                      return Text(
                        _meditationstate.selmeditation.meditationSettings.isUnlimited ? ' Unlimited':
                        _meditationstate.selmeditation.duration.inMinutes.toString() + ' min ', style: Configuration.text('small', Colors.black, font:'Helvetica'));
                    }
                  ),
                  true
              ),
              SizedBox(height: Configuration.verticalspacing*2),
              buttonModal(
                StatefulBuilder(
                  builder: (context,setState) {
                    return  GridView.builder(
                      itemCount: ambientSounds.length,
                      shrinkWrap: true,
                      itemBuilder: (context,index){
                        IntervalBell ambientsound = ambientSounds[index];
                        bool isSelected =_meditationstate.selmeditation.meditationSettings.ambientsound != null && _meditationstate.selmeditation.meditationSettings.ambientsound.name == ambientsound.name;
                        
                        return ClickableSquare(
                          fit: BoxFit.cover,
                          isAsset:true,
                          onTap: (){
                            _meditationstate.selmeditation.meditationSettings.ambientsound = isSelected ? null : ambientsound;
                            
                            assetsAudioPlayer.stop().then((s){
                              if(!isSelected){
                                assetsAudioPlayer.open(Audio(ambientsound.sound));
                              }
                            });
    
                            setState(() {});
                          },
                          selected: isSelected,
                          image: ambientsound.image,
                          text: ambientsound.name,
                        );
                      },
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: Configuration.crossAxisCount
                      )
                    );
                  }
                ), 
                "Ambient Sound", 
                Text(_meditationstate.selmeditation.meditationSettings.ambientsound != null ?
                  _meditationstate.selmeditation.meditationSettings.ambientsound.name : 'None',
                  style: Configuration.text('small', Colors.black, font:'Helvetica')),
                true,
                ()=> assetsAudioPlayer.stop()
              ),
              SizedBox(height: Configuration.verticalspacing*2),
              buttonModal(
                IntervalBells(),
                "Interval Bell", 
                
                // NO HACE FALTA OBSERVER
                Container(
                  constraints: BoxConstraints(
                    maxWidth: Configuration.width*0.4
                  ),
                  child:  _meditationstate.bells.length > 0 ?
                    OverflowBox(
                    child: Row(
                      mainAxisAlignment:MainAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children:[
                          Flexible(child: Text(getBellString(bells: _meditationstate.bells),
                          overflow: TextOverflow.ellipsis, 
                          style:Configuration.text('small',Colors.black,font: 'Helvetica'))
                          )
                      ]
                    ),
                  ) :
                  
                   Text('None', 
                      overflow: TextOverflow.ellipsis,
                      style:Configuration.text('small',Colors.black,font: 'Helvetica')
                    )
                ),
                true
              ),
    
              SizedBox(height: Configuration.verticalspacing*2),
            
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: 
                  widget.offline ? 
                  [
                  // ESTO  SE REPITE !!!
                  Container(
                    constraints: BoxConstraints(
                      maxWidth: Configuration.width*0.4
                    ),
                    child: OutlinedButton(
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
                          }
                        );
                      },
                      child:Text('Use saved session', style: Configuration.text('small', Colors.lightBlue), textAlign: TextAlign.center),
                      style: OutlinedButton.styleFrom(
                      side:BorderSide(color: Colors.lightBlue, width: 1),
                      foregroundColor: Colors.lightBlue,
                      elevation:0
                    )),
                  )
                  ]:
                  [
                  Container(
                    constraints: BoxConstraints(
                      maxWidth: Configuration.width*0.4,
                      minWidth: Configuration.width*0.4
                    ),
                    child: OutlinedButton(
                    onPressed:(){
                      showModalBottomSheet(
                        isScrollControlled: true,
                        barrierColor: Colors.black.withOpacity(0.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.vertical(top: Radius.circular(Configuration.borderRadius/2)),
                        ),
                        context: context, 
                        builder: (context){
                          return savePreset();
                        }
                      );
                    },
                    child:Text('Save session', 
                      style: Configuration.text('small', Colors.lightBlue),
                      textAlign: TextAlign.center
                    ),
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.all(Configuration.smpadding),
                      side:BorderSide(color: Colors.lightBlue, width: 1),
                      foregroundColor: Colors.lightBlue,
                      elevation: 0
                    ),
                                  ),
                  ),
    
                  // HAY QUE HACER ESTO RESIZABLE !!!
                  Container(
                    constraints: BoxConstraints(
                      maxWidth: Configuration.width*0.4,
                      minWidth: Configuration.width*0.4
                    ),
                    child: OutlinedButton(
                      
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
                    child:Text('Use saved', style: Configuration.text('small', Colors.lightBlue), textAlign: TextAlign.center),
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.all(Configuration.smpadding),
                      side:BorderSide(color: Colors.lightBlue, width: 1),
                      foregroundColor: Colors.lightBlue,
                      elevation:0
                    )
                                  ),
                  )
              ])
            ]),
          ),

          SizedBox(height: Configuration.verticalspacing*2.5),
          
          BaseButton(
            margin:true,
            filled: true,
            textcolor: Colors.white,
            onPressed:
            _meditationstate.selmeditation.duration.inMinutes >= 5 || 
            _meditationstate.selmeditation.meditationSettings.isUnlimited ? 
            () {
              Iterable<Meditation> freeMeditations = 
              _userstate.user.totalMeditations.where((element) => element.title == null);
              if(freeMeditations.length == 0 ){
                showInfoDialog(
                  type: 'info',
                  description: "Timer doesn't work in the background, the screen will darken automatically as if the phone was locked.",
                  header: "Please, don't lock the phone",
                ).then((value) => startMeditation());
              }else{
                startMeditation();
              }
            } : null,
          ),
        ],
      ),
    );
  }

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

    _meditationstate.selmeditation  = new Meditation(
      duration: Duration(minutes: 
        _userstate.user.settings.lastMeditDuration != null 
        && _userstate.user.settings.lastMeditDuration > 0
        ? _userstate.user.settings.lastMeditDuration  
        : 5 
      ),
      meditationSettings: _userstate.user.settings.meditation
    );
    selectedstage = _userstate.user.stagenumber;
    
    print('DIDCHANGEDEPENDENCIES');
  }

  @override
  void dispose() {
    super.dispose();
  }

  void startMeditation(){
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
            content: _meditationstate.selmeditation,
          )
        )
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return PageView(  
      physics: ClampingScrollPhysics(),
      controller: _meditationstate.practice,
      onPageChanged: (newPage) {
        setState(() {
          _meditationstate.switchpage(newPage, true);
        });
      },
      children: [freeMeditation(), SelectGame()],
      );
  }
}

class MeditationDuration extends StatefulWidget {
  const MeditationDuration({
    Key key
  }) : super(key: key);

  @override
  State<MeditationDuration> createState() => _MeditationDurationState();
}

class _MeditationDurationState extends State<MeditationDuration> {
  String selectedMeditation;

  @override
  Widget build(BuildContext context) {
    MeditationState _meditationstate = Provider.of<MeditationState>(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        _meditationstate.selmeditation.meditationSettings.isUnlimited ? 
        Container() :
        Center(child: CirclePicker()),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Transform.scale(
              scale: Configuration.width > 500 ? 1.5 :1.2,
              child: Switch(
                activeColor: Colors.lightBlue,
              splashRadius: Configuration.verticalspacing*5,
              value: _meditationstate.selmeditation.meditationSettings.isUnlimited,
              onChanged: (bool){
                print({'isfree',bool});
                setState(()=>{
                  _meditationstate.selmeditation.meditationSettings.isUnlimited = bool
                });
              }),
            ),
            Flexible(
              child: Text('Meditate without a given duration', style: Configuration.text('small',Colors.black,font: 'Helvetica'),))
          ],
        ),
        SizedBox(height: Configuration.verticalspacing*1.5),
        Text('Warm up', style: Configuration.text('small',Colors.black)),
        SizedBox(height: Configuration.verticalspacing),
        HorizontalPicker(
          minValue: 0,
          maxValue: 180,
          divisions: 12,
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
    );
  }
}


// PASARLE CONTENT  !!!!!!!!!!!!
// MUY IMPORTANTE !!!!!!!
class ClickableSquare extends StatelessWidget {
  String blockedtext, image,text;
  bool selected, isAsset; 
  dynamic onTap;
  bool blocked, border;
  Widget rightlabel;
  BoxFit fit;


  ClickableSquare({this.border = false, this.fit = BoxFit.contain, this.isAsset = false, this.blockedtext,this.onTap,this.blocked= false,this.image,this.selected= false,this.text, this.rightlabel}) : super();

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
            
            Positioned.fill(child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Container(color: Colors.white))
            ),

            Positioned.fill(child:ClipRRect(
              borderRadius: BorderRadius.circular(12.0),
              child: image != null && image != '' ? 
              Image(
                fit: fit,
                image: isAsset ?  AssetImage(image): 
                CachedNetworkImageProvider(image)) : Container(),
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
// ESTO YA NO SE UTILIZA !!!!!!
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


  Widget addNotes(context){
    return Container(
      padding: EdgeInsets.all(Configuration.tinpadding),
      child: Column(
        children: [
          Text('Add notes', style: Configuration.text('smallmedium', Colors.black)),
          SizedBox(height: Configuration.verticalspacing),
          TextField(
            maxLines: 5,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Write your notes here',
            ),
          ),
          SizedBox(height: Configuration.verticalspacing),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Cancel', style: Configuration.text('smallmedium', Colors.black)),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Save', style: Configuration.text('smallmedium', Colors.black)),
              ),
            ],
          )
        ],
      ),
    );


  }


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
          filled: true,
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

    return Stack(
      
      children: [
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

    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersive);
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
              return ButtonClose(
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

class CustomTrackShape extends RoundedRectSliderTrackShape {
  Rect getPreferredRect({
    @required RenderBox parentBox,
    Offset offset = Offset.zero,
    @required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final double trackHeight = sliderTheme.trackHeight;
    final double trackLeft = offset.dx;
    final double trackTop = offset.dy + (parentBox.size.height - trackHeight) / 2;
    final double trackWidth = parentBox.size.width;
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }
}

class NoTrackShape extends RoundedRectSliderTrackShape {
  Rect getPreferredRect({
    @required RenderBox parentBox,
    Offset offset = Offset.zero,
    @required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final double trackHeight = sliderTheme.trackHeight;
    final double trackLeft = offset.dx;
    final double trackTop = offset.dy + (parentBox.size.height - trackHeight) / 2;
    final double trackWidth = parentBox.size.width;
    return Rect.fromLTWH(trackLeft, trackTop, trackWidth, trackHeight);
  }
}




class PracticeSummary extends StatefulWidget {

  PracticeSummary({Key key}) : super(key: key);

  @override
  State<PracticeSummary> createState() => _PracticeSummaryState();
}

class _PracticeSummaryState extends State<PracticeSummary> {
  Stage selectedStage;
  int _index = 0;

  UserState _userstate;

  List<Stage> stageSummaries =  new List.empty(growable: true);

  List<Technique> techniques = new List.empty(growable: true);

  List<Technique> distractions = new List.empty(growable: true);

  @override
  void didChangeDependencies(){
    super.didChangeDependencies();

    _userstate = Provider.of<UserState>(context); 

    techniques.sort((a,b) => a.startingStage == b.startingStage ? 
      a.position.compareTo(b.position) : 
      a.startingStage.compareTo(b.startingStage)
    );

    distractions.sort((a,b) => a.startingStage == b.startingStage   
      ? a.position.compareTo(b.position) 
      : -a.startingStage.compareTo(b.startingStage)
    );
  }

  @override
  Widget build(BuildContext context) {

    bool changedState = false;
    int lastStage = null;

    Milestone m = _userstate.data.milestones[_userstate.user.milestonenumber-1];

    Widget containerTitle(String title){
      return Container(
        width: Configuration.width,
        padding: EdgeInsets.all(Configuration.smpadding),
        decoration: BoxDecoration(
          border: Border.symmetric(
            horizontal: BorderSide(
              color: Colors.grey,
              width: 1,
            ),
          ),
          color: Colors.white
        ),
        child: Text(title, style: Configuration.text('smallmedium',Colors.black)),
      );
    }


    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor:Colors.transparent,
        leading: CloseButton(color: Colors.black)
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Configuration.lightgrey
          /*gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [
              Configuration.maincolor.withOpacity(0.9),
              Colors.black.withOpacity(0.8),
              Configuration.maincolor,
            ],
          ),*/
        ),
        child: ListView(
          physics: ClampingScrollPhysics(),
          children: [
            /*
            Container(
              padding: EdgeInsets.all(Configuration.smpadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [

                  Material(
                    elevation: 2,
                    borderRadius: BorderRadius.circular(
                      Configuration.borderRadius/3
                    ),
                    child: Container(
                      padding: EdgeInsets.all(
                        Configuration.smpadding
                      ),
                      decoration: BoxDecoration(
                        color: Color.fromARGB(255,236,225,197),
                        borderRadius: BorderRadius.circular(
                          Configuration.borderRadius/3
                        )
                      ),

                      child: Text('Meditation is only improved with a calm and relaxed attitude.\n\nUse your heart, we are not machines',
                      textAlign: TextAlign.center,
                        style: Configuration.text('smallmedium',Colors.black),
                      ),
                    )
                  ),

                ],
              ),
            ),
            */

            Text('First Milestone',
              style: Configuration.text('small',Colors.black)
            ),
            SizedBox(height: Configuration.verticalspacing*1.5),
            Text(m.title,
              style: Configuration.text('small',Colors.black)
            ),
            
            SizedBox(height: Configuration.verticalspacing*2),
            m.practiceSummary != null && m.practiceSummary.isNotEmpty ?
            htmlToWidget(
              m.practiceSummary
            ): Container(),

            SizedBox(height: Configuration.verticalspacing),

            m.techniques.length > 0 ?
              Text('Techniques')
            : Container()

            /*
            Container(
              padding: EdgeInsets.all(
                Configuration.smpadding
              ),
              decoration: BoxDecoration(
                border: Border.symmetric(
                  horizontal: BorderSide(
                    color: Colors.black,
                    width: 1
                  )
                ),
                color: Color.fromARGB(255,236,225,197),
              ),
              child: Row(
                children: [
                  Icon(Icons.self_improvement,
                    color: Colors.black,
                    size: Configuration.smicon,
                  ),
                  SizedBox(width: Configuration.verticalspacing),

                  Text(
                    'Meditation techniques'.toUpperCase(),
                    style: Configuration.text('smallmedium',Colors.black),
                  ),
                ],
              ),
            ),

            Container(
              decoration: BoxDecoration(
                color: Configuration.lightgrey
              ),
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(Configuration.smpadding),
                    child: Text('''Work through the steps but don't overemphasize it, the most important thing is to be relaxed and aware. Whenever you find tension, remember to relax.\n\nStart your practice always with the first step and then gradually build up your practice. Some techniques can be mixed''',
                      style: Configuration.text('small',Colors.black, font:'Helvetica'),
                      textAlign: TextAlign.justify
                    ),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: techniques.length,
                    itemBuilder: ((context, index){
                      bool changedStage = lastStage != techniques[index].startingStage;
                      lastStage = techniques[index].startingStage;

                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          changedStage ? 
                            containerTitle(
                              lastStage == 0 ? "Preliminary techniques" :
                              'Stage ' + lastStage.toString()
                            ) 
                            : Container(),

                          ListTile(
                            onTap:() {
                              selectContent(content:techniques[index]);
                            },
                            //IMAGE OF THE TECHNIQUE
                            leading: Container(
                              height: Configuration.verticalspacing*4,
                              width: Configuration.verticalspacing*4,
                              decoration:  BoxDecoration(
                                shape: BoxShape.circle,
                              ),
                              child:techniques[index].image != null && techniques[index].image.isNotEmpty ? 
                              CachedNetworkImage(
                                imageUrl: techniques[index].image,
                                fit: BoxFit.cover
                              ): Container(),
                            ),
                            title: Text(techniques[index].title, style: Configuration.text('smallmedium',Colors.black)),
                            subtitle: Text(techniques[index].shortDescription, style: Configuration.text('small',Colors.black,font: 'Helvetica')),
                            trailing: Icon(
                              Icons.info,
                              color:Colors.black,
                              size: Configuration.smicon
                            ),

                          ),
                        ],
                      );
                    })
                  ),
                ],
              ),
            ),
            

            // DISTRACTIONS  !!!
            Container(
              padding: EdgeInsets.all(
                Configuration.smpadding
              ),
              decoration: BoxDecoration(
                border: Border.symmetric(
                  horizontal: BorderSide(
                    color: Colors.black,
                    width: 1
                  )
                ),
                color: Color.fromARGB(255,236,225,197),
              ),
              child: Row(
                children: [
                  Icon(Icons.psychology,
                    color: Colors.black,
                    size: Configuration.smicon,
                  ),
                  SizedBox(width: Configuration.verticalspacing),

                  Text(
                    'Distractions'.toUpperCase(),
                    style: Configuration.text('smallmedium',Colors.black),
                  ),
                ],
              ),
              ),
              // SAME AS TECHNIQUES


            Container(
              decoration: BoxDecoration(
                color: Configuration.lightgrey
              ),
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(Configuration.smpadding),
                    child: Text('''Distractions are part of the practice. The most important skill to build, is to learn to accept this fact and enjoy the moment we wake up. The more you enjoy this, the sooner you'll realize next time. Smile. \n\n All distractions follow the same path, in reverse order, starting from the upper stage to the lowest one. ''', 
                      textAlign: TextAlign.justify,
                      style: Configuration.text('small', Colors.black, font: 'Helvetica'),
                    )
                  ),

                  //listview with distractions

                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: distractions.length,
                    itemBuilder: ((context, index){
                      bool changedStage = lastStage != distractions[index].startingStage;
                      lastStage = distractions[index].startingStage;

                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          changedStage ? 
                            containerTitle(
                              lastStage == 0 ? "Preliminary distractions" :
                              'Stage ' + lastStage.toString()
                            ) 
                            : Container(),

                          ListTile(
                            onTap:() {
                              selectContent(content:distractions[index]);
                            },
                            //IMAGE OF THE TECHNIQUE
                            leading: Container(
                              height: Configuration.verticalspacing*4,
                              width: Configuration.verticalspacing*4,
                              decoration:  BoxDecoration(
                                shape: BoxShape.circle,
                              ),
                              child:distractions[index].image != null && distractions[index].image.isNotEmpty ? 
                              CachedNetworkImage(
                                imageUrl: distractions[index].image,
                                fit: BoxFit.cover
                              ): Container(),
                            ),
                            title: Text(distractions[index].title, style: Configuration.text('smallmedium',Colors.black)),
                            subtitle: Text(distractions[index].shortDescription, style: Configuration.text('small',Colors.black,font: 'Helvetica')),
                            trailing: Icon(
                              Icons.info,
                              color:Colors.black,
                              size: Configuration.smicon
                            ),

                          ),
                        ],
                      );
                    })
                  ),
                  
                ]
              )
            ),    
                */ 
          ],
        ),
      ),
    );
  }
}




class LifecycleEventHandler extends WidgetsBindingObserver {
  LifecycleEventHandler({this.resumeCallBack, this.detachedCallBack});

  final dynamic resumeCallBack;
  final dynamic detachedCallBack;

//  @override
//  Future<bool> didPopRoute()

//  @override
//  void didHaveMemoryPressure()

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
        await detachedCallBack();
        break;
      case AppLifecycleState.resumed:
        await resumeCallBack();
        break;
    }
  }

//  @override
//  void didChangeLocale(Locale locale)

//  @override
//  void didChangeTextScaleFactor()

//  @override
//  void didChangeMetrics();

//  @override
//  Future<bool> didPushRoute(String route)
}
