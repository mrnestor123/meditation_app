import 'dart:io';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meditation_app/domain/entities/content_entity.dart';
import 'package:meditation_app/domain/entities/meditation_entity.dart';
import 'package:meditation_app/domain/entities/user_entity.dart';
import 'package:meditation_app/presentation/mobx/actions/profile_state.dart';
import 'package:meditation_app/presentation/mobx/actions/user_state.dart';
import 'package:meditation_app/presentation/pages/commonWidget/circular_progress.dart';
import 'package:meditation_app/presentation/pages/commonWidget/content_view.dart';
import 'package:meditation_app/presentation/pages/commonWidget/dialog.dart';
import 'package:meditation_app/presentation/pages/commonWidget/file_helpers.dart';
import 'package:meditation_app/presentation/pages/commonWidget/messages_modal.dart';
import 'package:meditation_app/presentation/pages/commonWidget/profile_widget.dart';
import 'package:meditation_app/presentation/pages/commonWidget/start_button.dart';
import 'package:meditation_app/presentation/pages/learn_screen.dart';
import 'package:meditation_app/presentation/pages/meditation_screen.dart';
import 'package:meditation_app/presentation/pages/profile_widget.dart';
import 'package:meditation_app/presentation/pages/requests_screen.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

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
    if(_userstate.teachers.isEmpty){
      _userstate.getTeachers();
    }
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
                  return ListView.separated(
                    physics: ClampingScrollPhysics(),
                    itemBuilder: (context,int){
                      User user = _userstate.teachers[int];
                      return TextButton(
                        onPressed:(){
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProfileScreen(
                                user: user,
                              )
                            ),
                          );
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

    return Stack(
      children: [
        _userstate.user.addedcontent.length > 0 ? 
        GridView.builder(
          itemCount: _userstate.user.addedcontent.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2), 
          itemBuilder: (context,i){
            Content content = _userstate.user.addedcontent[i];

            return ClickableSquare(
              text: content.title,
              onTap: (){
                Navigator.push(context, 
                MaterialPageRoute(builder:(context)=> ContentShow(content:content))
                );
              },
            );
          }
        ):
        Center(
          child: Text("You have not added any content",
            style:Configuration.text('small',Colors.black)
          )
        ),
        bottomButton('Add content', (){
          Navigator.pushNamed(context, '/addcontent').then((value) => setState((){}));
        }, Icons.add)
      ],
    );
  }

  Widget files(){
    var audio, video;

    Widget squareButton(IconData icon, String text,onPressed){
      return ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary:Colors.lightBlue
        ),
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children:[
            Text(text,style:Configuration.text('tiny', Colors.white)),
            SizedBox(width:Configuration.verticalspacing/2),
            Icon(icon,size:Configuration.smicon)
          ]
        ),
      );
    }
    
    return Stack(
      children:[
        _userstate.user.files.length > 0 ?
          FilesGrid()
          : Text('You have not uploaded any files', style:Configuration.text('small',Colors.black)),
       
        Positioned(
          bottom:0,
          right:0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end, 
            children:[
              squareButton(Icons.video_camera_front, 'Add Video', () async {
                XFile result = await picker.pickVideo(source: ImageSource.gallery);

                if(result != null){
                  video = result;
                  await _userstate.uploadFile(video: video);
                  setState((){});
                }

              }),
              SizedBox(height:Configuration.verticalspacing),
              squareButton(Icons.audiotrack, 'Add recording', ()async {
                FilePickerResult result = await FilePicker.platform.pickFiles(
                  type: FileType.audio,
                  withData: true
                );

                if(result != null){
                  audio = result;
                  await _userstate.uploadFile(audio:audio);
                  setState((){});
                }
              }),
            ]
          )
        )
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

class FilesGrid extends StatefulWidget {
  
  bool selectable;
  dynamic onSelect;


  FilesGrid({this.selectable=false,this.onSelect});

  @override
  State<FilesGrid> createState() => _FilesGridState();
}

class _FilesGridState extends State<FilesGrid> {
  int selectedindex = -1; 

  UserState _userstate;

  Widget displayFile(File file,context){
      List<String> splittedfile = file.path.split('/');
      String filename =  splittedfile[splittedfile.length-1].split('?')[0];
      
      void viewAudio(){
        AssetsAudioPlayer player = new AssetsAudioPlayer();
        bool isPlaying = false;
        bool started = false;
         
        showModalBottomSheet(
          isDismissible: false,
          context: context, 
          builder: (context){
            return StatefulBuilder(
              builder: (context,setState) {
                return WillPopScope(
                  onWillPop:(){
                    player.pause();
                    player.dispose();

                    return Future.value(true);
                  },
                  child: Container(
                    color:Colors.black,
                    padding: EdgeInsets.all(Configuration.smpadding),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(filename, style: Configuration.text('small',Colors.white)),
                        SizedBox(height:Configuration.verticalspacing),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            IconButton(
                              color:Colors.white,
                              iconSize: Configuration.medicon,
                              onPressed: (){
                                if(!started){
                                  player.open(Audio.network(file.path));
                                  started = true;
                                }
                                
                                player.playOrPause();
                                isPlaying = !isPlaying;
                                setState((){});
                              }, 
                              icon: Icon(isPlaying ? Icons.pause: Icons.play_arrow)
                            ),
                            IconButton(
                              color:Colors.white,
                              iconSize: Configuration.medicon,
                              onPressed: (){
                                player.stop();
                                player.dispose();
                                Navigator.pop(context);
                              }, 
                              icon: Icon(Icons.stop)
                            )
                          ],
                        )  
                      ],
                    ),
                  ),
                );
              }
            );
        });
      }

      void viewVideo()async{
        VideoPlayerController controller =  VideoPlayerController.network(file.path);
        await controller.initialize();
        bool hasStarted = false;

        showDialog(
          context: context, 
          barrierDismissible: false,
          builder: (context){
            return StatefulBuilder(
              builder: (context,setState) {
                return WillPopScope(
                  onWillPop:(){
                    if(controller.value.isPlaying){
                      controller.pause();
                    }
                    controller.dispose();
                    return Future.value(true);
                  },
                  child: AbstractDialog(
                    content: Container(
                      height: Configuration.width / controller.value.aspectRatio,
                      width: Configuration.height * controller.value.aspectRatio,
                      child: Stack(
                        children: [
                          VideoPlayer(controller),
                          !hasStarted ? Align(
                            alignment: Alignment.center,
                            child: IconButton(
                              iconSize: Configuration.medicon,
                              color: Colors.white,
                              onPressed: (){controller.play(); hasStarted = true; setState((){});}, 
                              icon: Icon(Icons.play_arrow
                            ))
                          ): Container(),
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color:Colors.red
                            ),
                            child: IconButton(
                              padding:EdgeInsets.all(4),
                              onPressed: (){
                                if(controller.value.isPlaying){
                                  controller.pause();
                                }
                                controller.dispose();
                                Navigator.pop(context);
                              },
                              icon:Icon(Icons.close),
                              iconSize: Configuration.smicon,
                              color:Colors.white
                            ),
                          ),
                        ],
                      )
                    )
                  ),
                );
              }
            );
          });
      }


      if(isAudio(file.path)){
        return OutlinedButton(
          onPressed: (){
           viewAudio();
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
        //HAY QUE QUITAR ESTO !!!
      }else if(isImage(file.path)){
        return Container(
          child: Image.network(file.path)
        );
      }else{
        return OutlinedButton(
          onPressed: (){
           viewVideo();
          }, 
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment:MainAxisAlignment.spaceBetween,
            children: [
              Flexible(child: Text(filename,style:Configuration.text('tiny',Colors.black))),
              Icon(Icons.video_library, size: Configuration.smicon)
            ]
          ) 
        );
      }
    }

  @override
  Widget build(BuildContext context) {
    _userstate = Provider.of<UserState>(context);
    
    return ListView.builder(
          shrinkWrap:true,
          itemCount: _userstate.user.files.length,
         // gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,crossAxisSpacing: 10,mainAxisSpacing: 10),
          itemBuilder: (context,i){
            File file = _userstate.user.files[i];
            bool selected = i == selectedindex;
            return Row(
              mainAxisSize:MainAxisSize.max,
              children: [
                Expanded(child: displayFile(file,context)),
                widget.selectable ? GestureDetector(
                  onTap: (){
                    setState(() {
                      selectedindex = i;
                      widget.onSelect(file);
                    });
                  },
                  child: Container(
                    margin: EdgeInsets.only(left:Configuration.verticalspacing),
                    width:Configuration.verticalspacing*3,
                    height: Configuration.verticalspacing*3,
                    decoration: BoxDecoration(
                      color: selected ? Colors.black : Colors.white,
                      shape:BoxShape.circle,
                      border: Border.all(color:Colors.black)
                    ),
                  ),
                ): Container()

              ],
            );
          }
    );


  }
}

class AddContent extends StatefulWidget {

  AddContent() : super();

  @override
  State<AddContent> createState() => _AddContentState();
}

class _AddContentState extends State<AddContent> {
  List<int> stages = [1,2,3,4,5,6,7,8,9,10];

  List<dynamic> types = [
    {'label':'Meditation practice','value':'meditation-practice'},
    //{'label':'lesson','value':'lesson'},
   // {'label':'Meditation lesson', 'value':'meditation'}
  ];

  UserState _userstate;
  var currentStep = 0;
  Content toAdd = new Content(stagenumber: 1, type:'meditation-practice');
  File selectedFile;

  Widget basicInformation(){
      TextEditingController controller = new TextEditingController(text:toAdd.title);

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
            SizedBox(height: Configuration.verticalspacing),
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
            SizedBox(height: Configuration.verticalspacing),
            Row(
              children: [
                Text('Title',style:Configuration.text('tiny',Colors.black)),
                SizedBox(width:Configuration.verticalspacing),
                Expanded(
                   child: TextField(
                      
                      onChanged:(string){
                        toAdd.title = string;
                        setState(() {});
                      },
                      style: Configuration.text('tiny',Colors.black),
                    ),
                 ),
              ],
            ),
           
            SizedBox(height: Configuration.verticalspacing*2),
            Text('Description',style: Configuration.text('tiny',Colors.black)),
            TextField(
              onChanged:(string){
                toAdd.description = string;
                setState(() {});
              },
              style: Configuration.text('tiny',Colors.black),
            ),
            ],
          );
    }

  @override
  Widget build(BuildContext context) {
    _userstate = Provider.of<UserState>(context);

    return Scaffold(
      appBar: AppBar(
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1.0),
          child: Container(
                color: Colors.grey,
                height: 1.0,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0.0,
        centerTitle:true,
        leading: CloseButton(
          color: Colors.black,
        ),
        title: Text('Add Content',style: Configuration.text('medium',Colors.black),),
      ),
      body: Container(
        color:Colors.white,
        padding: EdgeInsets.symmetric(horizontal: Configuration.smpadding),
        child: Column(
          children:[
            SizedBox(height: Configuration.verticalspacing),
            Text('First, input basic information',style: Configuration.text('small',Colors.black)),
            basicInformation(),
            SizedBox(height:Configuration.verticalspacing*1.5),
            Text('Add Video or recording', style:Configuration.text('small',Colors.black)),
            SizedBox(height:Configuration.verticalspacing),
            _userstate.user.files.length > 0 ? 
            Expanded(child: FilesGrid(
              selectable: true, 
              onSelect:(file){
                toAdd.file = file.path;
                setState((){});
            })): 
            Text('First, you have to upload the files in the files manager',style: Configuration.text('tiny', Colors.black)),
            BaseButton(
              text:'Finish',
              margin:true,
              color: Configuration.maincolor,
              onPressed: toAdd.file != null && toAdd.title != null && toAdd.description != null ? 
                () {
                  if(toAdd.isMeditation()){
                    toAdd = new Meditation.fromContent(toAdd);
                  }else {
                    //toAdd = new Lesson.fromContent();
                  }
                  _userstate.uploadContent(c:toAdd);
                  Navigator.pop(context);
                } : null
              ,
            ),
            SizedBox(height: Configuration.verticalspacing)
          ]
        ),
      ),
    );
  }
}




// WIDGE

