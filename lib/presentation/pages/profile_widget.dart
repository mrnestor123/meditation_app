import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:meditation_app/domain/entities/course_entity.dart';
import 'package:meditation_app/domain/entities/user_entity.dart';
import 'package:meditation_app/presentation/mobx/actions/messages_state.dart';
import 'package:meditation_app/presentation/mobx/actions/profile_state.dart';
import 'package:meditation_app/presentation/mobx/actions/user_state.dart';
import 'package:meditation_app/presentation/pages/calendar.dart';
import 'package:meditation_app/presentation/pages/commonWidget/bottom_sheet_modal.dart';
import 'package:meditation_app/presentation/pages/commonWidget/circular_progress.dart';
import 'package:meditation_app/presentation/pages/commonWidget/date_tostring.dart';
import 'package:meditation_app/presentation/pages/commonWidget/html_towidget.dart';
import 'package:meditation_app/presentation/pages/commonWidget/profile_widget.dart';
import 'package:meditation_app/presentation/pages/commonWidget/start_button.dart';
import 'package:meditation_app/presentation/pages/config/configuration.dart';
import 'package:meditation_app/presentation/pages/contentWidgets/content_card.dart';
import 'package:meditation_app/presentation/pages/explore_screen.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../domain/entities/content_entity.dart';
import '../../domain/entities/meditation_entity.dart';
import 'commonWidget/alert_dialog.dart';
import 'commonWidget/back_button.dart';
import 'commonWidget/image_upload_modal.dart';
import 'contentWidgets/meditation_screens.dart';


class ProfileScreen extends StatefulWidget {
  User user;

  ProfileScreen({this.user});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  User user;
  bool uploading = false;
  UserState _userstate;
  MessagesState _messagesState;
  ProfileState _profilestate;

  bool editingProfile = false;
  bool isMe = false;

  int personal_info = 0;
  int teacher_content = 1;
  int viewing;

  List<Tab> tabs = [Tab( text: 'Information')];

  int day_filter = 0;
  int week_filter = 1;
  int month_filter = 2;

  int selectedFilter = 0;


  int _index = 0;

  List<bool> selectedFilterBools =  [true,false,false];


  Widget textIcon(IconData icon, String text, [onclick]){
    return Container(
      margin: EdgeInsets.only(
        bottom: Configuration.verticalspacing*2,
      ),
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          primary: Colors.black,
          side: BorderSide(color:onclick != null ? Colors.lightBlue : Colors.grey, width: 1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          padding: EdgeInsets.all(Configuration.smpadding)
        ),
        onPressed: (){
          if(onclick != null){
          onclick();
          }
        },
        child: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,

            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(icon,size: Configuration.smicon, color:Colors.black),
              SizedBox(width:Configuration.verticalspacing),
              Flexible(
                child: Text(text, 
                  style:Configuration.text('small',onclick != null ? Colors.lightBlue : Colors.black)
                ),
              ),
              
              /*onclick !=null ? 
              Container(
                margin:EdgeInsets.only(left:Configuration.verticalspacing),
                child: ElevatedButton(
                  onPressed: onclick, 
                  style:ElevatedButton.styleFrom(
                    primary: Colors.lightBlue,
                  ),
                  child:Text('View website',style:Configuration.text('small',Colors.white))
                ),
              ) : Container()*/
            ],
          ),
        ),
      ),
    );
  }

  Widget identificationText(){
    List<Widget> widgets = new List.empty(growable:true);

    Widget stageText() {
      return Row(
        children: [
          Icon(Icons.terrain, color: Colors.white),
          SizedBox(width: 5),
          Text("Stage " + user.stagenumber.toString(), 
            style: Configuration.text('small', Colors.white)
          )
        ],
      );
    }


    Widget identificationLabel({IconData icon, String text}){
      return Chip(
        backgroundColor: Colors.white,
        label: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: Configuration.smicon, color: Colors.black),
            SizedBox(width: 5),
            Text(text, style: Configuration.text('small', Colors.black))
          ],
        )
      );
    }

    if(user.isAdmin()){
      widgets.add(identificationLabel(icon:Icons.admin_panel_settings, text:'Admin'));
    }else if(user.isTeacher()){
      widgets.add(identificationLabel(icon:Icons.school, text:'TMI Teacher'));  
    }else{
      widgets.add(identificationLabel(icon:Icons.self_improvement, text:'Meditator'));
    }

    return Row(
      mainAxisAlignment: user.isTeacher() ? MainAxisAlignment.center : MainAxisAlignment.spaceAround,
      children:[
        Row(children: [
          widgets[0]
        ])
      ] 
    );
  }

  //NO  HACE FALTA  EL USUARIO !!!
  Widget teacherProfile(User user, int i){

    Widget addedContent(){
      return user.addedcontent.length > 0 ? 
        Column(
          children: [
            Row(
              children: [
                Icon(Icons.self_improvement, 
                  color: Colors.black, 
                  size: Configuration.medicon
                ),
                SizedBox(width: Configuration.verticalspacing),
                Text('Added content', 
                  style: Configuration.text('small',Colors.black)
                ),
              ],
            ),
            SizedBox(height: Configuration.verticalspacing),
            ListView.builder(
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              padding: EdgeInsets.all(0),
              itemCount: user.addedcontent.length,
              itemBuilder: (BuildContext context, int index) { 
                Content c = user.addedcontent[index];


                return ContentCard(
                  content: c,
                );
                /*return ClickableSquare(
                  blockedtext: '',
                  border: true,
                  onTap:()=>{
                    Navigator.push(context, 
                      MaterialPageRoute(builder: (context){
                        return ContentFrontPage(
                          content: c,
                        );
                      })
                    )
                  },
                  blocked: _userstate.user.isContentBlocked(c),
                  text: c.title,
                  selected: true,
                  image: c.image,
                );*/
              },
            ),
            
          ],
        ): Container();
    }
    
    Widget teacherView(){

      TeacherInfo teacherInfo = user.teacherInfo;

      return Container(
        margin: EdgeInsets.symmetric(horizontal: Configuration.smpadding),
        child: Column(
            children: [
              isMe ? Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                   TextButton(onPressed: ()=>{
                  Navigator.pushNamed(context, '/mymeditations')
                  }, child: Text('View all',style: Configuration.text('small', Colors.lightBlue))
                ),

                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor:Colors.lightBlue
                    ),
                    onPressed: () {  
                      setState(() {
                        editingProfile =true;
                      });
                    },
                    child: Text('Edit profile',style:Configuration.text('small',Colors.white)),
                  ),
                ],
              ) : Container(),
              
              Text(teacherInfo.description != null ? teacherInfo.description : 'The description goes here',
                style:Configuration.text('small',Colors.black, height:1.4, font:'Helvetica')
              ),

              SizedBox(height: Configuration.verticalspacing*1.5),
              /*SizedBox(height: Configuration.verticalspacing*1.5),
              textIcon(Icons.group, user.students.length.toString() + ' students', (){
                Navigator.push(
                    context,
                      MaterialPageRoute(
                          builder: (context) => ViewFollowers(
                          users: user.students,
                          title: 'Students'
                      )
                  ),
                );
              }),*/
              isMe || teacherInfo.website != null && teacherInfo.website.isNotEmpty ?
              textIcon(Icons.language, teacherInfo.website != null ?  teacherInfo.website : 'www.website.com',
              (){
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context)=> Scaffold(
                        appBar: AppBar(
                          leading: CloseButton(color: Colors.black),
                          backgroundColor:Colors.white,
                          elevation: 0,
                        ),
                        body: WebView(
                          initialUrl:'https:' + teacherInfo.website,
                          javascriptMode: JavascriptMode.unrestricted),
                      )
                      )
                  );
              }) : Container(),


              addedContent(),


              /*
              isMe || teacherInfo.location != null && teacherInfo.location.isNotEmpty ?
              textIcon(Icons.place, teacherInfo.location != null ?  teacherInfo.location : 'Add a location') : Container(),
              isMe || teacherInfo.teachinghours != null && teacherInfo.teachinghours.isNotEmpty  ?
              textIcon(Icons.date_range, teacherInfo.teachinghours != null ?  teacherInfo.teachinghours : 'Available times') :
              Container(),*/
              SizedBox(height: Configuration.verticalspacing*2),
              
              /*!isMe ? 
              BaseButton(
                margin:true,
                onPressed:(){
                  _messagesState.selectChat(user, _userstate.user);
                  Navigator.pushNamed(context, '/chat');
                },
                color:Configuration.maincolor,
                text: 'Contact teacher '
              ) : Container(),
              */
              SizedBox(height:Configuration.verticalspacing*2)
            ],
          ),
      );
    } 

    Widget teacherEdit(){
      Widget formElement(String text, value, onchange){  
        TextEditingController controller = new TextEditingController.fromValue(
          TextEditingValue(text:value != null ? value : '')
        );

        return Column(
          mainAxisAlignment:MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(text, style:Configuration.text('small',Colors.black)),
            TextField(
              textCapitalization: TextCapitalization.sentences,
              maxLines: 4,
              minLines: 1,
              controller: controller,
              onChanged:onchange 
            )
          ],
        );
      }

      return Container(
        margin: EdgeInsets.symmetric(horizontal: Configuration.smpadding),
        child: Column(
          children:[
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  style:ElevatedButton.styleFrom(
                    primary:Colors.lightBlue
                  ),
                  onPressed: (){
                    _userstate.updateUser();
                    setState(() {
                      editingProfile = false;
                    });
                  },
                  child:Text('Save', style:Configuration.text('small',Colors.white))
                ),
              ],
            ),
            formElement('Description', _userstate.user.teacherInfo.description, (text){
              user.teacherInfo.description = text;
              _userstate.user.teacherInfo.description = text;
            }),
            SizedBox(height:Configuration.verticalspacing*2),
            formElement('Website',  _userstate.user.teacherInfo.website, (text){
              user.teacherInfo.website = text;
              _userstate.user.teacherInfo.website = text;
            }),
            SizedBox(height:Configuration.verticalspacing*2),
            formElement('Hours available', _userstate.user.teacherInfo.teachinghours, (text){
              user.teacherInfo.teachinghours = text;
              _userstate.user.teacherInfo.teachinghours = text;
            }),
            SizedBox(height:Configuration.verticalspacing*2),
            formElement('Location',  _userstate.user.teacherInfo.location , (text){
              user.teacherInfo.location = text;
              _userstate.user.teacherInfo.location = text;
            })
          ]
        ),
      );
    }

    Widget addedCourses(){

      Widget courseCircle({Course course}){
        return AspectRatio(
          aspectRatio: 1,
          child: Container(
            decoration: BoxDecoration(
              color: Configuration.maincolor,
              shape: BoxShape.circle
            ),
            padding: EdgeInsets.all(8),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white,)
              ),
              child: Center(
                child: Icon(Icons.spa, color: Colors.white,  size: Configuration.medicon),
              ),
            ),
          ),
        );
      }

      List<Widget> getCourseStats({Course course}){
        List<Widget> w = new List.empty(growable: true);

        Widget columnText(int howMany, String  what){
          return Column(
            children: [
              Text(
                howMany.toString(),
                style: Configuration.text('medium',Colors.black)
              ),
              SizedBox(height: Configuration.verticalspacing/2),
              Text(what + (howMany > 1? 's':''),
                style: Configuration.text('tiny', Colors.grey,font: 'Helvetica')
              )
            ],
          );

        }

        if(course.content.where((element) => element.isLesson()).length > 0){
          w.add(columnText(course.content.where((element) => element.isLesson()).length,'lesson'));
        }

        if(course.content.where((element) => element.isVideo()).length > 0){
          w.add(columnText(course.content.where((element) => element.isVideo()).length,'video'));
        }

        if(course.content.where((element) => element.isMeditation()).length > 0){
          w.add(columnText(course.content.where((element) => element.isMeditation()).length,'meditation'));
        }

        if(course.content.where((element) => element.isRecording()).length > 0){
          w.add(columnText(course.content.where((element) => element.isRecording()).length,'recording'));
        }

        return w;
      }

      Widget dateContainer({String text, DateTime date}){

        return Row(
          children: [
            Icon(Icons.calendar_month, color: Colors.grey, size: Configuration.smicon),
            SizedBox(width: Configuration.verticalspacing),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(text, style: Configuration.text('tiny', Colors.grey,font: 'Helvetica')),
                SizedBox(height: Configuration.verticalspacing/2),
                Text(datetoString(date), style: Configuration.text('tiny', Colors.black,font: 'Helvetica')),
              ],
            )
          ],
        );
      }

      return Container(
        margin: EdgeInsets.symmetric(horizontal: Configuration.smpadding),
        child:user.addedcourses.length > 0  ?
          GridView.builder(
            itemCount: user.addedcourses.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: Configuration.crossAxisCount+1), 
            itemBuilder: (BuildContext context, int index) {
              Course course = user.addedcourses[index];
              
              return GestureDetector(
                onTap: ()=>{
                  showModalBottomSheet(
                    isScrollControlled: true,
                    context: context,
                    barrierColor: Colors.black.withOpacity(0.5),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.vertical(top: Radius.circular(Configuration.borderRadius/2)),
                    ), 
                    builder: (context){
                      return StatefulBuilder(
                        builder: (context,setState) {
                          bool hasJoined = user.joinedcourses.where((element) => element.cod == course.cod).length > 0;
                          bool canJoin = user.joinedcourses.length < 3;

                          return BottomSheetModal(
                            child: Container(
                              margin: EdgeInsets.all(Configuration.smpadding),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(height: Configuration.verticalspacing),
                                  Center(
                                    child: Container(
                                      width: Configuration.width*0.25,
                                      child: courseCircle(),
                                    ),
                                  ),
                                  SizedBox(height: Configuration.verticalspacing*2),
                                  Text(course.title, style: Configuration.text('medium',Colors.black),),
                                  SizedBox(height: Configuration.verticalspacing*1),
                                  
                                  Chip(
                                    label: Text(course.price > 0 ? course.price.toString() + '€' : 'Free', style: Configuration.text('tiny', Colors.white,font: 'Helvetica'),), 
                                    backgroundColor: course.price > 0 ? Colors.red : Colors.green,),
                                  
                                  Container(



                                  ),
                                  
                                  Container(
                                    width: Configuration.width*0.7,
                                    child: BaseButton(
                                      text: hasJoined ? 'View course': 'Join course',
                                      color: Colors.white,
                                      bordercolor: Configuration.maincolor,
                                      noelevation: true,
                                      textcolor: Configuration.maincolor,
                                      border: true,
                                      onPressed: (){
                                        if(!canJoin && !hasJoined){
                                          showAlertDialog(
                                            context:context,
                                            title: "You can't join this  course",
                                            // SURE ??
                                            text: 'You can only enrol to a maximum of three courses',
                                            hideYesButton:  true,
                                            noText: 'Close'
                                          );
                                        }else{
                                          if(!hasJoined){
                                            user.joinedcourses.add(course);
                                            _userstate.updateUser(u:user);
                                            setState(() {});
                                          }
                                          
                                          Navigator.push(context, MaterialPageRoute(builder: (context){
                                            return PathPage(
                                              path: course
                                            );
                                          })).then(((value) =>  setState((){})));
                                        }
                                      },
                                    ),
                                  ),
                                  SizedBox(height: Configuration.verticalspacing),
                                  Divider(),
                                  SizedBox(height: Configuration.verticalspacing),
                                  course.startDate != null && course.endDate != null ?
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      dateContainer(text: 'Start Date', date: course.startDate),
                                      dateContainer(text: 'End Date', date: course.endDate),
                                    ]
                                  ): Container(),
                                  
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: getCourseStats(course: course)
                                  ),
                                  SizedBox(height: Configuration.verticalspacing),

                                  Divider(),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      SizedBox(height: Configuration.verticalspacing),
                                      Text('Description',style: Configuration.text('small',Colors.black)),
                                      SizedBox(height: Configuration.verticalspacing),
                                      htmlToWidget(course.description)
                                    ],
                                  )
                                ],
                              ),
                            )
                          );
                        }
                      );
                    }
                  )
                },
                child: OverflowBox(
                  child: Container(
                    child: Column(
                      children: [
                        Container(
                          width: Configuration.width*0.2,
                          child: courseCircle()
                        ),
                        SizedBox(height: Configuration.verticalspacing/2),
                        Text(course.title,style: Configuration.text('small',Colors.black), overflow: TextOverflow.visible),
                      ],
                    ),
                  ),
                ),
              );
            }
          ): 
          Text('No courses have been created yet', style: Configuration.text('small',Colors.black,font: 'Helvetica'))
      );
    }

    List<Widget> l = new List.empty(growable: true);

    l.add(!editingProfile ? teacherView() : teacherEdit());

    if(!_profilestate.loading && user.addedcontent.length > 0){
      l.add(addedContent());
    }

    if(!_profilestate.loading &&  user.addedcourses.length > 0){
      l.add(addedCourses());
    }

    if(editingProfile){
      return teacherEdit();
    }else if(i == 0){
      return teacherView();
    }else if(i == 1){
      return addedContent();
    }else if(i == 2){
      return addedCourses();
    }
  }

  Widget userProfile(User user){
    Widget userInfo(){
      return Container(
        margin: EdgeInsets.symmetric(horizontal:Configuration.smpadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Table(children: [
              TableRow(children: [
                ProfileInfoBigCard(
                  firstText:  user.userStats.doneMeditations.toString(),
                  secondText: "Meditations\ncompleted",
                  icon: Icon(Icons.self_improvement),
                ),
                ProfileInfoBigCard(
                    firstText: user.userStats.readLessons.toString(),
                    secondText: "Lessons\ncompleted",
                    icon: Icon(Icons.book))
              ]),
              TableRow(
                children: [
                  ProfileInfoBigCard(
                    firstText:  user.timemeditated,
                    secondText: "Time \nmeditated",
                    icon: Icon(Icons.timer),
                  ),
                  ProfileInfoBigCard(
                    firstText: user.userStats.maxStreak.toString() + (user.userStats.maxStreak == 1 ? ' day' : ' days'),
                    secondText: "Max \nstreak",
                    icon: Icon(Icons.calendar_today),
                  )
                ]
              )
            ]),
            SizedBox(height: Configuration.verticalspacing*2),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(child: Text('Meditation record', style: Configuration.text('small', Colors.black))),
                
                isMe ?
                TextButton(
                  onPressed: ()=>{
                    Navigator.pushNamed(context, '/mymeditations')
                  }, 
                  child: Text('View all',style: Configuration.text('smallmedium', Colors.lightBlue))
                ) : Container(),
              ],
            ),
            SizedBox(height: Configuration.verticalspacing),
            user.userStats.streak > 1 ?
            Container(
              width: Configuration.width,
              padding: EdgeInsets.all(Configuration.smpadding),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey)
              ),
              child: Row(
                mainAxisAlignment:MainAxisAlignment.spaceAround,
                children:[
                  Text('Current streak', style:Configuration.text('small',Colors.black)),
                  Text(user.userStats.streak.toString() + ' DAYS',style:Configuration.text('smallmedium',Colors.black)),
                ]
              ), 
            ): Container(),

            CalendarWidget(  meditations: user.totalMeditations),
            SizedBox(height: Configuration.verticalspacing*3),
          ],
        ),
      );
    }

    Widget userStats(){

      List<String> days = ['M','T','W','TH','F','S','S'];
      List<String> months = ['J','F','M','A','M','J','J','A','S','O','N','D'];

      Widget bottomTitles(double value, TitleMeta meta) {
        const style = TextStyle(color: Color(0xff939393), fontSize: 10);
         
        return SideTitleWidget(
          child: Text(
            selectedFilter == month_filter ?
            months[value.toInt()]:
            selectedFilter == week_filter ? 
            'Week ' + value.toInt().toString() :
            days[value.toInt()], 
            style: style),
          axisSide: meta.axisSide,
        );
      }

      Widget leftTitles(double value, TitleMeta meta) {
          if (value == meta.max) {
            return Container();
          }

          // ESTO SE PODRÍA COMBINAR CON ARRIBA
          const style = TextStyle(
            color: Color(
              0xff939393,
            ),
            fontSize: 10,
          );

          return SideTitleWidget(
            child: Text(
              meta.formattedValue + 'min',
              style: style,
            ),
            axisSide: meta.axisSide,
          );
        } 

      List<BarChartGroupData> chartData(){
        Object m = new Object();
        List<BarChartGroupData> charts= new List.empty(growable: true);

        DateTime now = DateTime.now();
        DateTime startingFilter = selectedFilter == month_filter  ?
          DateTime(now.year, 1, 1):
          selectedFilter == week_filter  ?
          DateTime(now.year,now.month,0):
          now.subtract(Duration(days: now.weekday - 1));
    
    
        List<double> daysMeditated = new List.filled(selectedFilter == month_filter ? 12:  selectedFilter == week_filter ? 4 : 7,0);
        int day = 0;

        // HAY QUE SACAR LAS DE ESTA SEMANA  DE ESTE MES Y TOTAL
        for(Meditation m in _profilestate.selected.totalMeditations.where((element) => element.day.isAfter(startingFilter))){
          if(m.day != null){
            print(m.day.month);

            daysMeditated[selectedFilter == week_filter ?
              1: selectedFilter ==  month_filter ?
              m.day.month-1: m.day.weekday-1
            ] += m.duration.inMinutes.toDouble();
          }
        }
        
        for(double d in daysMeditated){
          charts.add(BarChartGroupData(
            x: day++,
            barRods: [
              BarChartRodData(toY: d)
            ])
          );
        }

        return charts;
      }

      return Container(
        margin: EdgeInsets.symmetric(horizontal: Configuration.smpadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ToggleButtons(children: ['Day','Week','Month'].map((e) => 
              Container(
                padding: EdgeInsets.all(Configuration.smpadding),
                child: Text(e))
            ).toList(), 
            constraints: const BoxConstraints(
              minHeight: 40.0,
              minWidth: 80.0,
            ),
            onPressed: (index) => {
              setState((){
                selectedFilter = index;
               for (int i = 0; i < selectedFilterBools.length; i++) {
                  selectedFilterBools[i] = i == index;
                }
              })
            },
            
            selectedColor: Colors.white,
            fillColor: Colors.lightBlue,
            borderRadius: const BorderRadius.all(Radius.circular(8)),
            isSelected: selectedFilterBools
            ),

            SizedBox(height: Configuration.verticalspacing*2),
            Text('Time meditated',style: Configuration.text('small',Colors.black)),

            SizedBox(height: Configuration.verticalspacing*2),
            Container(
              width: Configuration.width,
              child: AspectRatio(
                aspectRatio: 1.66,
                child: BarChart(
                BarChartData(

                  groupsSpace: Configuration.width*0.9/
                    (selectedFilter == week_filter ? 4 :
                    selectedFilter == month_filter ? 12 :
                    7),
                  alignment: BarChartAlignment.center,
                  barTouchData: BarTouchData(
                    enabled: false,
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: bottomTitles,
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        getTitlesWidget: leftTitles,
                      ),
                    ),
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  barGroups: chartData()
                  ),
                  swapAnimationDuration: Duration(milliseconds: 0),
                ),
              ),
            ),
            Container(),
          ],
        ),
      );
    }

    return userInfo();
  }

  void didChangeDependencies(){
    super.didChangeDependencies();

    viewing = personal_info;
    _profilestate = Provider.of<ProfileState>(context);
    _userstate = Provider.of<UserState>(context);
    _messagesState = Provider.of<MessagesState>(context);
    

    // LAS  TABS DEBERÍAN  SER  ANTES NO???
    _profilestate.init(
      widget.user != null ? widget.user : _userstate.user, 
      _userstate.user
    ).then((res){

      // PASAR TABS A PROFILESTATE ??
      if(_profilestate.selected.isTeacher()){
        if(_profilestate.selected.addedcontent.length > 0){
          tabs.add(Tab(text:'Added Content'));
        }
      }else{
        //tabs.add(Tab(text:'Mastery'));
      }

      setState((){});          
    });
  }

  void changeImage(){
    if(isMe){
      showPicker(onSelectImage: (image) async{
        if(image != null){          
          setState(() {
            uploading = true;
          });

          await _userstate.changeImage(image);
          
          setState(() {
            uploading = false;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    user = _profilestate.selected;
    isMe = _profilestate.isMe;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: Configuration.maincolor, 
            statusBarIconBrightness: Brightness.dark, // For Android (dark icons)
            statusBarBrightness: Brightness.dark, // For iOS (dark icons)
          ),
          backgroundColor: Configuration.maincolor,
          elevation: 0,
          leading: ButtonBack(color: Colors.white),
          actions: isMe ? [
             //MessagesIcon(color: Colors.white),
              IconButton(
                padding: EdgeInsets.all(0.0),
                onPressed: () => Navigator.pushNamed(context, '/settings'),
                icon: Icon(
                  Icons.settings,
                  color: Colors.white,
                  size: Configuration.smicon,
                ),
              ),
            ]: 
            [
              Container(),
              //PÂRA ENVIAR MENSAJES !!!
              /*Container(
                margin:EdgeInsets.only(right:Configuration.verticalspacing),
                child: PopupMenuButton<String>(
                  padding: EdgeInsets.all(0.0),
                  itemBuilder: (BuildContext context) {  
                    
                    return [
                      PopupMenuItem(
                        onTap:(){
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            _messagesState.selectChat(user, _userstate.user);
                            Navigator.pushNamed(context, '/chat');
                          });
                        },
                        value: 'tap',
                        child: Text('Send a message',style: Configuration.text('small',Colors.black, font: 'Helvetica')),
                      ),
                    ];
                  },
                  child: Icon(
                    Icons.more_vert,
                    color: Colors.white,
                    size: Configuration.medicon,
                  ),
                ),
              ),*/
          ],
      ),
      body: ListView(
        physics: ClampingScrollPhysics(),
        children: <Widget>[
          Container(
            width: Configuration.width,
            color: Configuration.maincolor,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Stack(
                  fit:StackFit.passthrough,
                  alignment:AlignmentDirectional.center,
                  children: [
                    ProfileCircle(
                      width: Configuration.width > 500 ? Configuration.width*0.3 : 100,
                      bordercolor: Colors.white,
                      userImage: user.image,
                      color:Colors.transparent,
                      onTap:()=>{
                        changeImage()
                      }
                    ),
                    uploading ? 
                    Align(
                      alignment:Alignment.center,
                      child: CircularProgress(
                        color:Colors.white
                      )
                    ): Container(width: 0),
                    isMe ? Positioned(
                      right:0,
                      top:0,
                      child: GestureDetector(
                        onTap: ()=>{
                          changeImage()
                        },
                        child: Container(
                          padding: EdgeInsets.all(Configuration.tinpadding),
                          decoration:BoxDecoration(
                            shape:BoxShape.circle,
                            color:Colors.white
                          ),
                          child: Icon(Icons.edit_rounded,
                          size: Configuration.tinicon, color:Colors.black
                          ),
                        ),
                      ),
                    ) :Container(),
                  ],
                ),
                SizedBox(height: Configuration.verticalspacing),
                Text(
                  user.nombre != null ? user.nombre : 'Guest',
                  style: Configuration.text('subtitle', Colors.white)
                ),
                identificationText(),
                SizedBox(height:Configuration.verticalspacing*2),
              ],
            ),
          ),
          Container(
            height: Configuration.verticalspacing*2,
            decoration: BoxDecoration(
              color: Configuration.lightgrey
            ),
          ),
          SizedBox(height: Configuration.verticalspacing*2),
          Container(
            constraints: BoxConstraints(
              minHeight: Configuration.height*0.6
            ),
            child: Observer(builder: (context){
              return _profilestate.loading != null && _profilestate.loading ? 
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgress(),
                  ],
                ) :                    
              user.isTeacher() ? teacherProfile(_profilestate.selected, _index): 
              userProfile(_profilestate.selected);
            }),
          )
      ])
    );
  }
}


//ES IGUAL PARA TABLET QUE PARA Móvil ?? //DEBERÍA
class ViewFollowers extends StatefulWidget {
  final List<dynamic> cods;
  final String title;

  final List<User> users;

  ViewFollowers({this.cods, this.title,this.users});

  @override
  State<ViewFollowers> createState() => _ViewFollowersState();
}

class _ViewFollowersState extends State<ViewFollowers> {
  List<User> users = new List.empty(growable: true);

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    final _userstate = Provider.of<UserState>(context);

    // A LO MEJOR ESTO ES LO QUE FALLA !!!
    if(widget.cods != null){
      users = await _userstate.getUsersList(widget.cods);  
    }else{
      users = widget.users;
    }
  }

  @override
  Widget build(BuildContext context) {
    final _userstate =Provider.of<UserState>(context);
    
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: ButtonBack(color: Colors.black),
        title: Text(widget.title, style: Configuration.text('small', Colors.black)),
      ),
      body: Container(
        height: Configuration.height,
        width: Configuration.width,
        color: Configuration.lightgrey,
        child: SingleChildScrollView(
            child: Padding(
                padding: EdgeInsets.all(Configuration.smpadding),
                child: 
                Observer(
                  builder: (context) {
                    if(_userstate.loading){ 
                    return Column(
                      children: [
                        CircularProgressIndicator(
                          color: Configuration.maincolor,
                        ),
                      ],
                    );
                    }else{
                      return Table( 
                      defaultVerticalAlignment: TableCellVerticalAlignment.middle, 
                      columnWidths: {
                      0: FractionColumnWidth(0.2),
                      1: FractionColumnWidth(0.5),
                      2: FractionColumnWidth(0.3)
                    },
                    children: users.map((u) {
                      return TableRow(
                        children: [
                          ProfileCircle(
                            userImage: u.image,
                          ),
                          Container(
                            padding: EdgeInsets.all(5.0),
                            margin: EdgeInsets.symmetric(vertical: 7),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(u.nombre == null ? 'Anónimo' : u.nombre,
                                  style: Configuration.text('small', Colors.black)),
                                
                              ],
                            ),
                          ),

                          OutlinedButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ProfileScreen(
                                        user: u,
                                      )
                                    ),
                                );
                              },
                              style: OutlinedButton.styleFrom(
                                elevation: 0.0,
                                primary: Configuration.maincolor,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0))
                              ),
                              child: Text(
                                'Profile',
                                style: Configuration.text('small', Colors.black),
                              ),
                            )
                            ]);
                        }).toList());
                    }
                  }
                )
              )    
            )
        )
    );
  }
}


class Students extends StatefulWidget {
  const Students() : super();

  @override
  _StudentsState createState() => _StudentsState();
}

class _StudentsState extends State<Students> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(


      body: Container(
        
      ),
    );
  }
}


class MyMeditations extends StatelessWidget {
  const MyMeditations({Key key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    final _userstate = Provider.of<UserState>(context);
    
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.white,
          statusBarIconBrightness: Brightness.dark
        ),
        elevation: 0,
        leading: CloseButton(color: Colors.black),
        title: Text('Meditation record',style: Configuration.text('subtitle', Colors.black),),
      ),
      body: Container(
        color: Configuration.lightgrey,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(Configuration.smpadding),
              width: Configuration.width,
              color: Configuration.maincolor,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Total meditations ',style: Configuration.text('subtitle', Colors.white)),
                  Text(_userstate.user.totalMeditations.length.toString(),style: Configuration.text('subtitle', Colors.white)),
                ],
              ),
            ),
            
            Expanded(
              child: _userstate.user.totalMeditations.length  > 0 ?  ListView.separated(
                padding: EdgeInsets.only(top: 10),
                itemBuilder: ((context, index) {
                  Meditation m = _userstate.user.totalMeditations[(_userstate.user.totalMeditations.length-1)-index];
            
                  return ListTile(
                    onTap: ()=>{
                      // SHOW  MODAL BOTTOM SHEET WITH REPORT 
                      showModalBottomSheet(
                        isScrollControlled: true,
                        context: context,
                        builder: (context)=>
                          Wrap(
                            children: [
                              Container(
                                  padding: EdgeInsets.all(
                                    Configuration.smpadding
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: Configuration.width*0.8,
                                        child: Text((m.title != null ? m.title :'Free Meditation'),
                                          style: Configuration.text('medium',Colors.black)
                                        ),
                                      ),
                                      SizedBox(height: Configuration.verticalspacing),
                                      Row(
                                        children: [
                                          Icon(Icons.timer,
                                            size: Configuration.smicon,
                                          ),
                                          SizedBox(width: Configuration.verticalspacing),
                                          Text(m.duration.inMinutes.toString() + ' min',
                                            style: Configuration.text('small',Colors.black),
                                          ),
                                        ],
                                      ),

                                      SizedBox(height: Configuration.verticalspacing*3),
                                      Row(
                                        children: [

                                          Icon(Icons.calendar_month,
                                            size: Configuration.smicon,
                                          ),
                                          SizedBox(width: Configuration.verticalspacing),
                                          Text(getMonth(m.day) + ' '+  m.day.day.toString() + ', ' + m.day.year.toString() + ' '+ getHour(m.day),
                                            style: Configuration.text('small',Colors.black),
                                          ),
                                        ],

                                      ),

                                      SizedBox(height: Configuration.verticalspacing),

                                      m.report != null ?
                                      MeditationReportWidget(
                                        m: m.report
                                      ) : Container(),
                                      SizedBox(height: Configuration.verticalspacing*3),
                                    ],
                                  ),
                                ),
                            ],
                          )
                      )
                    },
                    title: Text(getMonth(m.day) + ' '+  m.day.day.toString() + ', ' + m.day.year.toString() + ' '+ getHour(m.day),
                      style: Configuration.text('small',Colors.black),
                    
                    ),
                    
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text((m.title != null ? m.title :'Free Meditation') + ' ' + m.duration.inMinutes.toString() + ' min',
                        
                          style: Configuration.text('small',Colors.black.withOpacity(0.8), font:'Helvetica')
                        ),
                      
                        m.notes != null && m.notes.isNotEmpty ? 
                        Text(m.notes,style: Configuration.text('small',Colors.grey, font:'Helvetica')) : Container(),


                        m.report != null ?  
                        Text('Press to view report ',
                          style: Configuration.text('small',Colors.grey, font:'Helvetica')
                        ) : Container()
                      ],
                    ),
                  );
                }),
                separatorBuilder: ((context, index) {
                  return Divider();
                }), 

                itemCount: _userstate.user.totalMeditations.length
              ) :  Container(
                padding: EdgeInsets.all(Configuration.smpadding),
                child: Text('Your meditation record is empty', 
                  style: Configuration.text('small',Colors.black))
                ),
            ),
          ],
        ),
      ),
    );
  }
}





/*
class MyInfo extends StatefulWidget {
  bool isTablet;

  MyInfo({this.isTablet = false});

  @override
  _MyInfoState createState() => _MyInfoState();
}

class _MyInfoState extends State<MyInfo> {
  final ImagePicker _picker = ImagePicker();
  UserState _userstate;
  bool uploading = false;

  PickedFile _image;

  

 

  @override
  Widget build(BuildContext context) {
    _userstate = Provider.of<UserState>(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: Configuration.blockSizeVertical*1),
        RadialProgress(
            width: widget.isTablet ? Configuration.blockSizeHorizontal* 0.3 : Configuration.safeBlockHorizontal * 1,
            goalCompleted: _userstate.user.stage.stagenumber / 10,
            child: GestureDetector(
              onTap: () => _showPicker(context),
              child: CircleAvatar(
                  radius: widget.isTablet ? Configuration.blockSizeHorizontal*7 : Configuration.blockSizeHorizontal * 12,
                  backgroundColor: Colors.transparent,
                  backgroundImage: _userstate.user.image == null
                      ? null
                      : NetworkImage(_userstate.user.image),
                  child: Icon(
                    Icons.camera_alt_outlined,
                    size: Configuration.medpadding,
                    color: _userstate.user.image != null
                        ? Colors.white.withOpacity(0.1)
                        : Colors.white,
                  )),
            )),
        SizedBox(
          height: Configuration.safeBlockVertical * 2,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
                _userstate.user.nombre,
                style: Configuration.text('medium', Colors.white),
            ),
          ],
        ),
      ],
    );
  }
}
*/
class ProfileInfoBigCard extends StatelessWidget {
  final String firstText, secondText, color;
  final Widget icon;

  const ProfileInfoBigCard(
      {Key key,
      @required this.firstText,
      @required this.secondText,
      this.color,
      @required this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), 
        border: Border.all(color: color != null ? Colors.white : Colors.grey, width: Configuration.strokewidth/2)
      ),
      child: Padding(
        padding: EdgeInsets.all(Configuration.smpadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: Text(firstText, style: Configuration.text('smallmedium', color != null ? Colors.white: Colors.black))),
                icon
            ]),
            Text(secondText, style: Configuration.text('tiny', color != null ? Colors.white : Colors.black)),
          ],
        ),
      ),
    );
  }
}

class ProfileInfoCard extends StatelessWidget {
  final firstText, secondText, hasImage, imagePath, isTablet;

  const ProfileInfoCard(
      {Key key,
      this.firstText,
      this.secondText,
      this.hasImage = false,
      this.isTablet = false,
      this.imagePath})
      : super(key: key);

  Widget twoLineItem(firstText,secondText){
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          firstText,
          style: Configuration.text('small', Colors.white),
        ),
        Text(secondText, style: Configuration.text('small', Colors.white)),
      ],
    );
  }

  Widget tabletTwolineItem(firsText,secondText){
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          firstText,
          style: Configuration.tabletText('tiny', Colors.white),
        ),
        Text(secondText, style: Configuration.tabletText('tiny', Colors.white)),
      ],
    );
  }


  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        elevation: 12,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: hasImage
            ? Center(child: Icon(Icons.wb_sunny))
            : isTablet ? twoLineItem(
                firstText,
                secondText,
              ) : tabletTwolineItem(firstText,secondText,),
      ),
    );
  }
}

/*
class SimpleBarChart extends StatelessWidget {
  final List<Series> seriesList;
  final bool animate;
  DateTime date;
  UserState _userstate;

  SimpleBarChart({this.seriesList, this.animate, this.date});

  @override
  Widget build(BuildContext context) {
    _userstate = Provider.of<UserState>(context);
    return Container(
      height: Configuration.height*0.3,
      child: BarChart(
        _createSampleData(_userstate.user),
        behaviors: [LinePointHighlighter(symbolRenderer: CircleSymbolRenderer())],
        selectionModels: [
          SelectionModelConfig(changedListener: (SelectionModel model) {
            if (model.hasDatumSelection)
              print(model.selectedSeries[0]
                  .measureFn(model.selectedDatum[0].index));
          })
        ],

        // Disable animations for image tests.
        animate: true,
      ),
    );
  }

  /// Create one series with sample hard coded data.
  List<Series<Ordinal, String>> _createSampleData(User user) {
    final days = ['M', 'T', 'W', 'TH', 'F', 'S', 'S'];
    final data = List<Ordinal>.empty(growable: true);

    for (var day in days) {
      var time = user.userStats.meditationtime;
      var datestring = date.day.toString() + '-' + date.month.toString();
      date = date.add(Duration(days: 1));
      data.add(new Ordinal(
          day,
          time != null
              ? time[datestring] != null
                  ? time[datestring]
                  : 0
              : 0));
    }

    return [
      new Series<Ordinal, String>(
        id: 'Time meditated',
        colorFn: (_, __) => MaterialPalette.blue.shadeDefault,
        domainFn: (Ordinal sales, _) => sales.day,
        measureFn: (Ordinal sales, _) => sales.min,
        data: data,
      )
    ];
  }
}

/// Sample ordinal data type.
class Ordinal {
  final String day;
  final int min;

  Ordinal(this.day, this.min);
}*/

/* VISTAS DE TABLET
class TabletProfileScreen extends StatefulWidget {
  User user;

  TabletProfileScreen({this.user});

  @override
  _TabletProfileScreenState createState() => _TabletProfileScreenState();
}

class _TabletProfileScreenState extends State<TabletProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final _userstate = Provider.of<UserState>(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children:[
            Container(
            decoration: BoxDecoration(color: Configuration.maincolor, borderRadius: BorderRadius.circular(16.0)),
            width: Configuration.width*0.25,
            height: Configuration.width*0.25,
            child: Column( 
              children:[
                MyInfo(isTablet: true),
                IconButton(
                  padding: EdgeInsets.all(0.0),
                  onPressed: () => Navigator.pushNamed(context, '/settings').then((value) => setState(()=> null)),
                  icon: Icon(
                    Icons.settings,
                    color: Colors.white,
                    size: 15.0,
                  ),
                )
              ])
            ),
            Container(
          width: Configuration.width*0.3,
          height: Configuration.width*0.3,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Table(children: [
                TableRow(
                  children: [
                    TextButton(
                        onPressed: ()=>  
                        widget.user != null ? null :
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ViewFollowers(
                                    users: _userstate.user.following,
                                    title: 'Following',
                          )),
                      ), 
                      child: Column(
                          children: [
                            Text('Following', style: Configuration.tabletText('tiny', Colors.black)),
                            Text(widget.user != null ? widget.user.followedcods.length.toString() : _userstate.user.following.length.toString(), style: Configuration.tabletText('verytiny',Colors.black))
                          ],
                        ),
                      ),
                    TextButton(
                      onPressed: ()=>  
                      widget.user != null ? null :
                        Navigator.push(
                          context,
                            MaterialPageRoute(
                                builder: (context) => ViewFollowers(
                                      users: _userstate.user.followsyou,
                                      title: 'Followers',
                            )
                          ),
                        ),
                        child: Column(
                        children: [
                          Text('Followers', style: Configuration.tabletText('tiny', Colors.black)),
                          Text(widget.user != null ? widget.user.followsyoucods.length.toString() :  _userstate.user.followsyou.length.toString(), style: Configuration.tabletText('verytiny',Colors.black))
                        ],
                      ),
                    ),
                  ]
                ),
                TableRow(children: [
                  TabletInfoCard(
                    firstText: _userstate.user.userStats.total.meditations.toString(),
                    secondText: "Meditations\ncompleted",
                    icon: Icon(Icons.self_improvement),
                  ),
                  TabletInfoCard(
                      firstText: _userstate.user.userStats.total.lessons.toString(),
                      secondText: "Lessons\ncompleted",
                      icon: Icon(Icons.book)
                  ),
                ]),
              ]),
              SizedBox(height: Configuration.blockSizeVertical * 3),
              
            ],
          ),
        ),
        ]
        ),
        Container(
            width: Configuration.width*0.35,
            height: Configuration.width*0.35,
            decoration:BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16.0)) ,
            child: Column(
              children: [
                SizedBox(height: 10),
                Text('Meditation record',style:Configuration.tabletText('tiny', Colors.black)),
                CalendarWidget(meditations: widget.user != null ? widget.user.totalMeditations : _userstate.user.totalMeditations)                    
              ],
          )
        ),
        
      ],
    );
  }
}

class TabletViewData extends StatefulWidget {
  String title;

  TabletViewData({ Key key , this.title}) : super(key: key);

  @override
  _TabletViewDataState createState() => _TabletViewDataState();
}

class _TabletViewDataState extends State<TabletViewData> {
  UserState _userstate;
  
  Widget getList(){
    var items = {
      'Following': _userstate.user.following.length,
      'Followers': _userstate.user.followsyou.length,
    };
  
    return items[widget.title] > 0 ?
     GridView.builder(
      itemCount: items[widget.title],
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4), 
      itemBuilder: (context,index){
        if(widget.title == 'Following'){
          return Card(
            child: Text(_userstate.user.following[index].nombre != null ?_userstate.user.following[index].nombre :' Anónimo' ),
          );
        } else if(widget.title =='Followers'){

        }
      }    
    ) : Center(child: Text('You are not followed', style: Configuration.tabletText('tiny', Colors.black)));
    
  }
  
  
  @override
  Widget build(BuildContext context) {
     _userstate = Provider.of<UserState>(context);
    return Scaffold(
        body: Container(
        height: Configuration.height,
        width: Configuration.width,
        color: Configuration.lightgrey,
        child: Column(
          children: [
            AppBar(
              centerTitle: true,
              title: Text(widget.title, style: Configuration.tabletText('small', Colors.black)),
              leading: IconButton(
                icon:Icon(Icons.arrow_back),
                onPressed: ()=> Navigator.pop(context), 
                iconSize: Configuration.tabletsmicon, 
                color: Colors.black
              ),
              elevation: 0,
              backgroundColor: Colors.transparent,
            ),
            Expanded(
              child: getList()
            )
        ]),
      ),
    );
  }
}



*/