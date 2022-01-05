import 'dart:io';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meditation_app/domain/entities/content_entity.dart';
import 'package:meditation_app/domain/entities/user_entity.dart';
import 'package:meditation_app/presentation/mobx/actions/user_state.dart';
import 'package:meditation_app/presentation/pages/commonWidget/circular_progress.dart';
import 'package:meditation_app/presentation/pages/commonWidget/dialog.dart';
import 'package:meditation_app/presentation/pages/commonWidget/messages_modal.dart';
import 'package:meditation_app/presentation/pages/commonWidget/profile_widget.dart';
import 'package:meditation_app/presentation/pages/commonWidget/start_button.dart';
import 'package:meditation_app/presentation/pages/profile_widget.dart';
import 'package:meditation_app/presentation/pages/requests_screen.dart';
import 'package:provider/provider.dart';

import 'config/configuration.dart';

class TeachersScreen extends StatefulWidget {
  const TeachersScreen() : super();

  @override
  State<TeachersScreen> createState() => _TeachersScreenState();
}

class _TeachersScreenState extends State<TeachersScreen> {
  UserState _userstate;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies()async {
    super.didChangeDependencies();
    _userstate = Provider.of<UserState>(context);
    //_userstate.getTeachers();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        leading: ButtonBack(color:Colors.white),
        backgroundColor: Configuration.maincolor,
        elevation:0,
        actions: [
          IconButton(
            iconSize: Configuration.smicon,
            onPressed: (){
              showDialog(context: context, builder: (context){
                return AbstractDialog(
                  content: Container(
                    padding: EdgeInsets.all(Configuration.smpadding),
                    height: Configuration.height*0.3,
                    width:Configuration.width,
                    decoration: BoxDecoration(
                      color:Colors.white,
                      borderRadius: BorderRadius.circular(Configuration.borderRadius)
                    ),
                    child: Center(
                      child: Text(
                        'Here can be added more information about TMI TEACHERS',
                        style: Configuration.text('small', Colors.black,font: 'Helvetica'),
                      ),
                    )
                  ),
                );
              });
            }, 
            icon: Icon(Icons.info)
          )
        ],
      ),
      body: Column(
        children: [
          Container(
            width: Configuration.width,
            padding:EdgeInsets.all(Configuration.medpadding),
            color:Configuration.maincolor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('TMI TEACHERS', style:Configuration.text('big',Colors.white)),
                SizedBox(height: Configuration.verticalspacing/2),
                Text('In order to reach the latter stages. Asking for help is the best option', style:Configuration.text('small',Colors.white))
              ],
            )
          ),
          Expanded(
            child: Container(
              width: Configuration.width,
              color:Configuration.lightgrey,
              child: Observer(
                builder: (context) {
                  if(_userstate.loading){
                    return Center(child: CircularProgress());
                  }else{
                  return ListView.separated(
                    physics: ClampingScrollPhysics(),
                    itemBuilder: (context,int){
                      User user = _userstate.teachers[int];
                      return TextButton(
                        onPressed:(){
                          Navigator.push(context, MaterialPageRoute(builder: (context){
                            return ProfileScreen(user:user);
                          }));
                        },
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.all(0)
                        ),
                        child: ListTile(
                          subtitle: Text('subtitle', 
                            style:Configuration.text('tiny',Colors.grey)
                          ),
                          leading: ProfileCircle(
                            width:30,
                            userImage: user.image,
                          ),
                          title: Text(
                            user.nombre,
                            style: Configuration.text('small',Colors.black),
                          ),
                          trailing: Icon(
                            Icons.arrow_right_outlined,
                            size:Configuration.smicon
                          ),
                        ),
                      );
                    }, 
                    separatorBuilder: (context,int){
                      return Divider();
                    }, 
                    itemCount: _userstate.teachers.length
                  );
                  }
                }
              ),
            ),
          )
        ],
      ),
    );
  }
}

class TeachersManagement extends StatefulWidget {
  const TeachersManagement() : super();

  @override
  _TeachersManagementState createState() => _TeachersManagementState();
}

class _TeachersManagementState extends State<TeachersManagement> {
  UserState _userstate;
  TabController _tabController;

  int selectedstage = 1;
  String contenttype = 'lesson';
  Content toAdd = new Content(stagenumber: 1, type:'meditation-practice');
  ImagePicker picker = new ImagePicker(); 



  Widget bottomButton(String text,onPressed, IconData icon ){
    return Align(
      alignment: Alignment.bottomRight,
      child: ElevatedButton(
        onPressed:onPressed,
        style: ElevatedButton.styleFrom(
          primary:Colors.lightBlue
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(text, style:Configuration.text('tiny',Colors.white)),
            SizedBox(width: Configuration.verticalspacing),
            Icon(icon,size: Configuration.smicon)
          ],
        ),
      )
    );
  }


  Widget students(){
    if(_userstate.user.students.length >0){
      return Stack(
        children: [
          ListView.separated(
          physics:ClampingScrollPhysics(),
          itemBuilder: (BuildContext context, int index) {  
            User user  = _userstate.user.students[index];
            return ListTile(
              onTap:(){
                sendMessage(state:_userstate, to: user,context:context);
              },
              leading: ProfileCircle(
                width:30,
                userImage: user.image,
              ),
              title: Text(user.nombre,style:Configuration.text('small',Colors.black)),
              trailing: Icon(Icons.mail,size: Configuration.smicon)
            );
          }, 
          itemCount: _userstate.user.students.length, 
          separatorBuilder: (BuildContext context, int index) {  
            return Divider();
          },
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: ElevatedButton(
              onPressed: (){
                sendMessage(state:_userstate,context: context);
              }, 
              style: ElevatedButton.styleFrom(
                primary:Colors.lightBlue
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Send a message to everyone', style:Configuration.text('tiny',Colors.white)),
                  SizedBox(width: Configuration.verticalspacing),
                  Icon(Icons.mail,size: Configuration.smicon)
                ],
              ),
            )
          )
        ],
      );
    }else{
      return Center(
        child: Text("You don't have any students at the moment",
          style:Configuration.text('small',Colors.black)
        )
      );
    }
  } 

  Widget content(){

    void contentAdd(){
      List<int> stages = [1,2,3,4,5,6,7,8,9,10];
      List<dynamic> types = [
        {'label':'Meditation practice','value':'meditation-practice'},
        {'label':'lesson','value':'lesson'},
        {'label':'Meditation lesson', 'value':'meditation'}
      ];
      var currentStep = 0;
      TextEditingController controller = new TextEditingController(text:toAdd.title);
      var setState;
      
      FilePickerResult audio;
      XFile video;

      Widget basicInformation(){

        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children:[
            SizedBox(height: Configuration.verticalspacing*1.5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Stagenumber',style:Configuration.text('tiny',Colors.black)),
                DropdownButton(
                  value: toAdd.stagenumber,
                  onChanged: (value){
                    setState(() {
                      toAdd.stagenumber = value;
                    });
                  },
                  items: stages.map<DropdownMenuItem<int>>((int value) {
                      return DropdownMenuItem<int>(
                        value: value,
                        child: Text(value.toString()),
                      );
                    }).toList()
                  )
                ]
              ),
              SizedBox(height: Configuration.verticalspacing*1.5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Type of content',style:Configuration.text('tiny',Colors.black)),
                  DropdownButton(
                    value: toAdd.type,
                    onChanged:(value){
                      setState(() {
                        toAdd.type = value;
                      });
                    },
                    items: types.map<DropdownMenuItem<String>>((dynamic value) {
                      return DropdownMenuItem<String>(
                        value: value['value'],
                        child: Text(value['label'],style:Configuration.text('tiny',Colors.black)),
                      );
                    }).toList())
                ],
              ),
              SizedBox(height: Configuration.verticalspacing*1.5),
              Text('Title',style:Configuration.text('tiny',Colors.black)),
              TextField(
                controller:controller,
                onChanged:(string){
                  toAdd.title = string;
                },
                style: Configuration.text('tiny',Colors.black),
              ),
              SizedBox(height: Configuration.verticalspacing*2),
              BaseButton(
                text:'Continue',
                color:Colors.lightBlue,
                margin: true,
                noelevation: true,
                onPressed:(){
                   setState(() {
                     currentStep++;
                    });
                }
              )
              ],
            );
      }

      Widget addcontent(){

        Widget squareButton(IconData icon, String text,onPressed){
          return ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary:Colors.lightBlue
            ),
            onPressed: onPressed,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children:[
                Text(text,style:Configuration.text('small', Colors.white)),
                Icon(icon,size:Configuration.smicon)
              ]
            ),
          );
        }
        
        Widget uploadFile(){
          return Column(
            children:[
              squareButton(Icons.video_camera_front, 'Add Video', () async {
                XFile result = await  picker.pickVideo(source: ImageSource.gallery);

                if(result != null){
                  video = result;
                  setState((){});
                }

              }),
              SizedBox(height:Configuration.verticalspacing *1.5),
              squareButton(Icons.audiotrack, 'Add recording', ()async {
                FilePickerResult result = await FilePicker.platform.pickFiles();

                if(result != null){
                  audio = result;
                  setState((){});
                }
              }),
            ]
          );
        }


        
        Widget fileSelected(){
          bool isVideo = video != null;
          
          return Column(
            children:[  
              Text('You have added ' + (isVideo ? ' a video' : ' an audio')),
              Text((isVideo ? video.name : audio.names.toString()), style:Configuration.text('small',Colors.black))
            ] 
          );
        }

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: Configuration.verticalspacing*2),
            Text('Add the content', style: Configuration.text('small',Colors.black)),

            video == null && audio == null ?
            uploadFile(): fileSelected(),
           
            SizedBox(height:Configuration.verticalspacing *2),
            BaseButton(
              text:'Finish',
              margin:true,
              color: Colors.lightBlue,
              onPressed: video != null || audio != null ? 
                () {
                  _userstate.uploadContent(c:toAdd,audio:audio,video:video);
                } : null
              ,
            )

          ],
        );
      }


      showDialog(
        context: context, 
        builder: (context){
          return StatefulBuilder(
            builder: (context,s) {
              setState= s;
              return AbstractDialog(
                content:Container(
                  padding: EdgeInsets.symmetric(horizontal:Configuration.smpadding),
                  decoration: BoxDecoration(
                    color: Colors.white,


                  ),
                  child: currentStep == 0 ?
                  basicInformation(): addcontent()
                  ),
              );
            }
          );
        });

    }


    return Stack(
      children: [
        _userstate.user.addedcontent.length > 0 ? 
        Container() :
        Center(
          child: Text("You have not added any content",
            style:Configuration.text('small',Colors.black)
          )
        ),
        bottomButton('Add content',contentAdd, Icons.add)

      ],
    );
  }


  Widget files(){
    var audio, video;


    Widget displayFile(File file){
      List<String> splittedfile = file.path.split('/');
      String filename =  splittedfile[splittedfile.length-1].split('?')[0];

      if(file.path.toLowerCase().contains('aud')){
        return OutlinedButton(
          onPressed: (){
            AssetsAudioPlayer().open(Audio.network(file.path));
          }, 
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment:MainAxisAlignment.spaceBetween,
            children: [
              Flexible(child: Text(filename,style:Configuration.text('tiny',Colors.black))),
              Icon(Icons.audiotrack, size: Configuration.smicon)
            ]
          ) 
        );
      }else if(file.path.contains('jpg|png')){

      }else{
        return Container();
      }


    }


    Widget squareButton(IconData icon, String text,onPressed){
      return ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary:Colors.lightBlue
        ),
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children:[
            Text(text,style:Configuration.text('small', Colors.white)),
            Icon(icon,size:Configuration.smicon)
          ]
        ),
      );
    }

    Widget uploadFile(){
      return Column(  
        children:[
          squareButton(Icons.video_camera_front, 'Add Video', () async {
            XFile result = await picker.pickVideo(source: ImageSource.gallery);

            if(result != null){
              video = result;
              _userstate.uploadFile(video: video);
              setState((){});
            }

          }),
          SizedBox(height:Configuration.verticalspacing *1.5),

          squareButton(Icons.audiotrack, 'Add recording', ()async {
            FilePickerResult result = await FilePicker.platform.pickFiles(
              withData: true
            );

            if(result != null){
              audio = result;
              _userstate.uploadFile(audio:audio);
              setState((){});
            }
          }),
        ]
      );
    }
    
    return Column(
      children:[
        _userstate.user.files.length > 0 ?
        
        GridView.builder(
          shrinkWrap:true,
          itemCount: _userstate.user.files.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
          itemBuilder: (context,i){
            File file = _userstate.user.files[i];

            return displayFile(file);
          }
          )
        :
        Text('You have not uploaded any files', style:Configuration.text('small',Colors.black)),
        SizedBox(height:Configuration.verticalspacing),
        uploadFile()

      ]
    );
  }


  @override
  Widget build(BuildContext context) {
    _userstate = Provider.of<UserState>(context);

    return DefaultTabController(
      length: 3,
      child: Column(
        children: [
          SizedBox(height: Configuration.verticalspacing),
          Text('Teachers management', style:Configuration.text('medium',Colors.black)),
          SizedBox(height:Configuration.verticalspacing),
          Text('Here you can see how many students you have, send a message to them, manage the content and so on.', 
            style:Configuration.text('small',Colors.black)
          ),
          SizedBox(height: Configuration.verticalspacing),
          Container(
            color: Configuration.maincolor,
            width: Configuration.width,
            child: TabBar(
              controller: _tabController,
              indicatorWeight: Configuration.width > 500 ? 5 : 2.5 ,
              indicatorColor: Colors.grey,
              tabs: [
                Tab(child: Text('Students',style: Configuration.text('small', Colors.black))),
                Tab(child: Text('Content', style:Configuration.text('small', Colors.black))),
                Tab(child: Text('Files', style:Configuration.text('small', Colors.black))),
              ]
            ),
          ),
          Expanded(child:
          Container(
            padding:EdgeInsets.all(Configuration.tinpadding),
            color: Colors.white,
            child: TabBarView(
              controller: _tabController,
              children: [
                students(),content(), files()
              ]),
            )
          ),
          SizedBox(height:Configuration.verticalspacing)
          
        ],
      ),
    );
  }
}