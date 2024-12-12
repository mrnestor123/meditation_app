import 'dart:async';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_circular_slider/flutter_circular_slider.dart';
import 'package:provider/provider.dart';

import '../../../domain/entities/meditation_entity.dart';
import '../../mobx/actions/meditation_state.dart';
import '../../mobx/actions/user_state.dart';
import '../commonWidget/dialogs.dart';
import '../commonWidget/start_button.dart';
import '../config/configuration.dart';

class WeekList extends StatefulWidget {
  @override
  _WeekListState createState() => _WeekListState();
}

class _WeekListState extends State<WeekList> {
  UserState _userstate;
  //REFACTORIZAR ESTO CON EL TIEMPO!!
  List<Map> weekDays = [
    {'day': "M", 'meditated': false, 'index': 1},
    {'day': 'T', 'meditated': false, 'index': 2},
    {'day': 'W', 'meditated': false, 'index': 3},
    {'day': 'TH', 'meditated': false, 'index': 4},
    {'day': 'F', 'meditated': false, 'index': 5},
    {'day': 'S', 'meditated': false, 'index': 6},
    {'day': 'S', 'meditated': false, 'index': 7}
  ];


  List<Widget> getDays() {
    List<Widget> result = new List.empty(growable: true);
    var dayOfWeek = 1;
    DateTime today = DateTime.now();
    var weekday = today.weekday;
    DateTime monday = today.subtract(Duration(days: today.weekday - dayOfWeek));
    var meditationstreak = _userstate.user.userStats.streak;
    List<Meditation> filteredmeditations = _userstate.user.totalMeditations.where((meditation)=>
      meditation.day.isAfter(monday)&&
      meditation.day.isBefore(today)
    ).toList();


    for (var item in weekDays) {
      bool hasMeditated = filteredmeditations.where((meditation)=>
        meditation.day.weekday == item['index']
      ).isNotEmpty;

      result.add(WeekItem(
          day: item['day'],
          meditated: hasMeditated,
          animate: today.weekday == item['index'])
      );
    }


    /*
    if (meditationstreak == 1) {
      weekDays[--weekday]['meditated'] = true;
    } else {
      while (meditationstreak != 0 && (weekday + 1) != monday) {
        weekDays[(monday-1)]['meditated'] = true;
        monday++;
        meditationstreak--;
      }
    }

    for (var e in weekDays) {
      result.add(WeekItem(
          day: e['day'],
          meditated: e['meditated'],
          animate: today.weekday == e['index']));
    }*/
    return result;
  }

  @override
  Widget build(BuildContext context) {
    _userstate = Provider.of<UserState>(context);
    return  Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: getDays()
    );
  }
}

class WeekItem extends StatefulWidget {
  bool meditated;
  bool animate;
  String day;

  WeekItem({this.day, this.meditated, this.animate});

  @override
  _WeekItemState createState() => _WeekItemState();
}

class _WeekItemState extends State<WeekItem> {
  bool changed = false;
  
  @override
  Widget build(BuildContext context) {
    if (widget.animate && !changed) {
      var timer = Timer(Duration(seconds: 1), () => setState(() => changed = true));
    }

    bool showColor = widget.meditated && !widget.animate || widget.animate && changed;

    return AnimatedContainer(
      padding: EdgeInsets.all(3),
      width: Configuration.width * 0.1,
      height: Configuration.width * 0.1,
      duration: Duration(seconds: 3),
      curve: Curves.easeIn,
      decoration: new BoxDecoration(
        color: widget.meditated && !widget.animate || widget.animate && changed
            ? Configuration.maincolor
            : Configuration.grey,
        shape: BoxShape.circle,
      ),
      child: AnimatedContainer(
        duration: Duration(seconds:3),
        curve: Curves.easeIn,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
                color: widget.meditated && !widget.animate || widget.animate && changed ? 
                Colors.white  :  Colors.grey,
                width: 2)

        ),
        child: Center(
            child: Text(widget.day,
                style: Configuration.text(
                  'small', 
                  showColor ?
                  Colors.black :
                  Colors.black.withOpacity(0.4)
                  
                  )
                ),
        ),
      )
    );
  }
}

class CirclePicker extends StatefulWidget {
  const CirclePicker() : super();

  @override
  _CirclePickerState createState() => _CirclePickerState();
}

class _CirclePickerState extends State<CirclePicker> {
  @override
  Widget build(BuildContext context) {
    final _meditationstate = Provider.of<MeditationState>(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SingleCircularSlider(
          120,
          _meditationstate.selmeditation.duration.inMinutes,
          baseColor: Colors.grey.withOpacity(0.6),
          handlerColor: Colors.transparent,
          handlerOutterRadius: 10,
          onSelectionChange: (a, b, c) {
            setState(() { _meditationstate.setDuration(b);});
          },
          height: Configuration.width > 600 ? Configuration.width*0.7 : Configuration.width*0.9,
          width: Configuration.width > 600 ? Configuration.width*0.7: Configuration.width*0.9,
          selectionColor: Colors.lightBlue,
          sliderStrokeWidth: Configuration.width > 600 ? 80:  40,
          child: Center(
            child: Text(
            _meditationstate.selmeditation.duration.inMinutes.toString() + ' min',
            style: Configuration.text('smallmedium', Colors.black),
          )),
        ),
      ],
    );
  }
}


Widget secondaryButton(IconData icon, onPressed, tag){
    return FloatingActionButton(mini: true,
    heroTag: tag,
      backgroundColor: Colors.black.withOpacity(0.7),
      onPressed: ()=>{
        onPressed()
      },
      child: Icon(icon,color: Colors.white,size: Configuration.smicon)
    );
  }


void wantToExitDialog(context){
  showAlertDialog(
    context:context,
    title: 'Are you sure you want to exit?',
    text: 'This meditation will not count',
    onYes:(){
      //_meditationstate.cancel();
    },
    onNo:(){
      /*if(_meditationstate.state == _meditationstate.meditating || _meditationstate.state == _meditationstate.paused){
        _meditationstate.startTimer();
      }*/
    }
  );
}




class IntervalBells extends StatefulWidget {

  Duration time;
  
  IntervalBells({Key key, this.time}) : super(key: key);

  @override
  State<IntervalBells> createState() => _IntervalBellsState();
}

class _IntervalBellsState extends State<IntervalBells> {

  List<IntervalBell> bells = [
    IntervalBell(sound: 'assets/audios/bowl-new.wav',name:'Bowl sound',image:'assets/audios/bowl.png'),
    IntervalBell(sound: 'assets/audios/high-gong.wav',name:'High gong',image:'assets/audios/high-gong.png'),
    IntervalBell(sound: 'assets/audios/church-new.mp3',name: 'Church bell', image:'assets/audios/church-bell.png'),
    IntervalBell(sound: 'assets/audios/bronze-bell.wav',name: 'Bronze bell', image:'assets/audios/bronze-bell.png'),
    IntervalBell(sound: 'assets/audios/bowl-sound.mp3',name:'Bowl sound',image:'assets/audios/bowl.png', disabled:true),
    IntervalBell(sound: 'assets/audios/church-bell.mp3',name: 'Church bell', image:'assets/audios/church-bell.png', disabled:true),
  ];

  int i = 0;
  AssetsAudioPlayer assetsAudioPlayer = new AssetsAudioPlayer();
  MeditationState  _meditationstate;

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

          double time =  widget.time !=null ?
            widget.time.inMinutes.toDouble() 
            :  _meditationstate.selmeditation.meditationSettings.isUnlimited ? 61 
            :  _meditationstate.selmeditation.duration.inMinutes.toDouble();
          
          return StatefulBuilder(
            builder: (context,setState) {
              return SafeArea(
                child: Wrap(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(vertical:Configuration.smpadding),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text('Interval bell',  style: Configuration.text('smallmedium',Colors.black)),
                          SizedBox(height: Configuration.verticalspacing),
              
                          CarouselSlider.builder(
                            itemCount: bells.where((element) => !element.disabled).length,
                            
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
                                      Expanded(
                                        child: Image.asset(b.image,fit: BoxFit.contain,
                                        
                                        ),
                                      ),
                                      SizedBox(height: Configuration.verticalspacing),
                                      Text(b.name, style: Configuration.text('small',Colors.black))
                                  ])
                                ),
                              );
                            },
                            options: CarouselOptions(
                              scrollPhysics: ClampingScrollPhysics(),
                              viewportFraction:0.5,
                              aspectRatio: Configuration.width > 500 ?
                              5/2: 4/2,
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
                                  style: Configuration.text('smallmedium',Colors.black,font:'Helvetica'),
                                  items: ["Repeat","Once", 'Halfway'].map<DropdownMenuItem<String>>((String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value.toString()),
                                    );
                                  }).toList(),
                                  value:selectedMode,
                                  onChanged: (newValue){
                                    if(newValue == 'Halfway'){
                                      selectedTime = time ~/ 2;
                                    }
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
                              max:time -1,
                              divisions:  time.floor() - 2,
                              onChanged: (a){
                                setState((){selectedTime = a.toInt();});
                              }, 
                              value: selectedTime.toDouble(),
                            ),
                          ),
                          
                          Text(selectedMode == 'Repeat' ? 
                          'The bell will ring every $selectedTime minute' + (selectedTime!=1 ? 's':''):
                          'The bell will ring at minute $selectedTime  ', 
                          style: Configuration.text('small',Colors.grey,font:'Helvetica')),
              
                          SizedBox(height: Configuration.verticalspacing*2),
              
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: Configuration.smpadding),
                            child: BaseButton(
                              aspectRatio: Configuration.buttonRatio*1.2,
                              text: 'Confirm',
                              onPressed:(){
                                IntervalBell bell = new IntervalBell(
                                  playAt: selectedTime,
                                  repeat: selectedMode == 'Repeat',
                                  name: bells[selectedIndex].name,
                                  image: bells[selectedIndex].image,
                                  sound:bells[selectedIndex].sound
                                ); 
                                        
                                // hay que pasar esto a meditation settings !!
                                if(b != null){
                                  _meditationstate.bells[i] = bell;
                                }else{
                                  _meditationstate.bells.add(bell);
                                }
                                Navigator.pop(context);
                              },
                              color: Configuration.maincolor
                            ),
                          ),
                          SizedBox(height: Configuration.verticalspacing),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: Configuration.smpadding),
                            child: BaseButton(
                              text:'Cancel',
                              aspectRatio: Configuration.buttonRatio * 1.2,
                              border: true,
                              bordercolor:Colors.red,
                              color:Colors.red,
                              onPressed:(){
                                Navigator.pop(context);
                              },
                              textcolor: Colors.red,
                            ),
                          ),
                          SizedBox(height: Configuration.verticalspacing*3),
                        ],
                      )
                    ),
                  ],
                ),
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


  @override
  Widget build(BuildContext context) {
    _meditationstate = Provider.of<MeditationState>(context);
    i = 0;

    bool canAddBell = 
    
    
    _meditationstate.selmeditation.meditationSettings.isUnlimited  ||  
      widget.time != null && widget.time.inMinutes > 5 ||
     _meditationstate.selmeditation.duration.inMinutes > 5;

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
            onPressed: canAddBell ? (){
              addModifyBell().then((d){setState((){});});
            } : null,
            child: Row(
              mainAxisSize:MainAxisSize.min,
              children: [
                Text('Add new interval bell',style: Configuration.text('tiny', Colors.green)),
                Icon(Icons.add, color: Colors.green,size: Configuration.smicon-5),
              ],
            ),
            style: OutlinedButton.styleFrom(
              side:BorderSide(color: Colors.green),
              padding:EdgeInsets.all(Configuration.tinpadding),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(Configuration.borderRadius),
                side: BorderSide(color: Colors.black)
              )
            ),
          ),
          SizedBox(height: Configuration.verticalspacing),

          !canAddBell ? 
          Text('The meditation duration should be more than 5 minutes to set a bell',
            style:Configuration.text('small',Colors.grey,font: 'Helvetica'))
          :  Container(),
          SizedBox(height: Configuration.verticalspacing*5)
        ],
      );
  }
}



String getBellString({List<IntervalBell> bells}){

  String bellsString= '';

  for(IntervalBell b in  bells ){
    bellsString += b.name != null  && b.name.isNotEmpty ? b.name + ' ' : '';
  };

  return bellsString;
}