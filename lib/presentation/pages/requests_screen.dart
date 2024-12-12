
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meditation_app/domain/entities/notification_entity.dart';
import 'package:meditation_app/domain/entities/request_entity.dart';
import 'package:meditation_app/presentation/mobx/actions/requests_state.dart';
import 'package:meditation_app/presentation/mobx/actions/user_state.dart';
import 'package:meditation_app/presentation/pages/commonWidget/date_tostring.dart';
import 'package:meditation_app/presentation/pages/commonWidget/dialogs.dart';
import 'package:meditation_app/presentation/pages/commonWidget/html_towidget.dart';
import 'package:meditation_app/presentation/pages/commonWidget/profile_widget.dart';
import 'package:meditation_app/presentation/pages/commonWidget/user_bottom_dialog.dart';
import 'package:provider/provider.dart';

import '../../domain/entities/stage_entity.dart';
import 'commonWidget/back_button.dart';
import 'commonWidget/start_button.dart';
import 'config/configuration.dart';


// CREAR COMPONENTE REQUESTHEADER !!!!!! 
// VISTA DE LISTA DE REQUESTS
class Requests extends StatefulWidget {
  const Requests() : super();

  @override
  _RequestsState createState() => _RequestsState();
}

class _RequestsState extends State<Requests> {
  UserState _userState;
  RequestState _requestState;
  PickedFile _image;
  final ImagePicker _picker = ImagePicker();
  bool uploading = false;

  String selectedtype = 'Suggestion';
  String uploadedImage;
  dynamic selectedStage;
  TextEditingController title = new TextEditingController();
  TextEditingController content = new TextEditingController();
  List<String> filters = ['Date', 'Votes'];
  List<String> types = [];
  List<String> tabs =  [];
  List<dynamic> stages = ['View all', 'none', 1,2,3,4,5,6,7,8,9,10];
  Stage stage;
  bool showingStage = false;


  bool pushedDialog = false;
  

  @override 
  void didChangeDependencies(){
    super.didChangeDependencies();
    _userState = Provider.of<UserState>(context);
    _requestState = Provider.of<RequestState>(context);
    _requestState.setUser(_userState.user);
    
    final arg = ModalRoute.of(context).settings.arguments as Map;
    
    if(arg != null && arg['stage'] != null){
      stage = arg['stage'];
      showingStage = true;
      selectedtype = 'Question';
      selectedStage = arg['type'] != null ? 'View all' : stage.stagenumber;
      types = ['Question', 'Discussion'];
      tabs = ['All', 'My posts'];
      _requestState.getStageRequests();
    }else{
      types = ['Suggestion', 'Issue'];
      tabs = ['Issues','Suggestions','My requests'];
      _requestState.getRequests(coduser:_userState.user.coduser);
    }
  }

  Widget stageSelector(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text('Stage', style: Configuration.text('small', Colors.grey)), 
        SizedBox(width: Configuration.verticalspacing),
        DropdownButton<dynamic>(
          value: selectedStage,
          elevation: 16,
          style: Configuration.text('small',Colors.black),
          underline: Container(
            height: 0,
            color: Colors.black,
          ),
          onChanged: (dynamic newValue) {
            setState(() {
              selectedStage = newValue;
            });
          },
          items: stages.map<DropdownMenuItem<dynamic>>((dynamic value) {
            return DropdownMenuItem<dynamic>(
              value: value,
              child: Text(value.toString(), style: Configuration.text('small', Colors.black)),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget addRequestModal(context){
    var stateSetter;
    dynamic stageToAdd = selectedStage == 'View all' ? 'none': selectedStage;

    return StatefulBuilder(
      builder:(BuildContext context, StateSetter setState ) {
      stateSetter = setState;
      
      return Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
            padding: EdgeInsets.all(12.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                stage  != null ? 
                Text("Feel free to ask any question or share any thoughts about meditation or spirituality.", 
                  style: Configuration.text('small', Colors.black, font: 'Helvetica'),
                  textAlign: TextAlign.center,
                ): Container(),
                SizedBox(height: Configuration.verticalspacing),
                Text('Title', style:Configuration.text('small', Colors.black)),
                SizedBox(height: Configuration.verticalspacing/2),
                TextField(
                  controller: title,
                  maxLines: 1,
                  decoration: InputDecoration(
                    hintText: "Enter title",
                    hintMaxLines: 2,
                    border: new OutlineInputBorder(
                        borderSide: new BorderSide(color: Colors.black)
                    )),
                ),
                SizedBox(height:Configuration.verticalspacing),
                Text('Content', style:Configuration.text('small', Colors.black)),
                SizedBox(height: Configuration.verticalspacing/2),
                TextField(
                  textCapitalization: TextCapitalization.sentences,
                  controller: content,
                  maxLines: 5,
                  decoration: InputDecoration(
                    hintText: "Enter your text here",
                    border: new OutlineInputBorder(
                        borderSide: new BorderSide(color: Colors.black)
                    ),),
                ),
                SizedBox(height: Configuration.verticalspacing),
                
                stage != null ?  Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('What stage is it in?', style: Configuration.text('small', Colors.black)), 
                    DropdownButton<dynamic>(
                      value: stageToAdd,
                      elevation: 16,
                      style: Configuration.text('small',Colors.black),
                      underline: Container(
                        height: 0,
                        color: Colors.black,
                      ),
                      onChanged: (dynamic newValue) {
                        setState(() {
                          stageToAdd = newValue;
                        });
                      },
                      items: stages.sublist(1).map<DropdownMenuItem<dynamic>>((dynamic value) {
                        return DropdownMenuItem<dynamic>(
                          value: value,
                          child: Text(value.toString()),
                        );
                      }).toList(),
                    ),
                  ],
                ) :  Container(),

                SizedBox(height: Configuration.verticalspacing),
                
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Type', style: Configuration.text('small', Colors.black)), 
                    DropdownButton<String>(
                      value: selectedtype,
                      elevation: 16,
                      style: Configuration.text('small',Colors.black),
                      underline: Container(
                        height: 0,
                        color: Colors.black,
                      ),
                      onChanged: (String newValue) {
                        setState(() {
                          selectedtype = newValue;
                        });
                      },
                      items: types.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ],
                ),
                SizedBox(height: Configuration.verticalspacing*2),
                /*stage != null ? Container() :
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Add Image', style: Configuration.text('small', Colors.black)),
                    uploadedImage != null ? 
                    Row(
                      children: [
                        Image(image: CachedNetworkImageProvider(uploadedImage), height: 50),
                        IconButton(
                          iconSize:Configuration.smicon,
                          onPressed: ()=> setState((){ uploadedImage = null; }), 
                          icon: Icon(Icons.delete, color: Colors.red)
                        )
                      ],
                    )
                    : 
                    uploading ? CircularProgress(strokewidth: 2):
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.all(Configuration.tinpadding)
                      ),
                      onPressed: () => showPicker(onSelectImage: (image) async{
                            setState((){
                              uploading = true;
                            });

                            String imgstring = await _userState.uploadFile(image:image);
                            
                            print({'UPLoaded image',imgstring});

                            setState(() {
                              uploading = false;
                              uploadedImage  = imgstring;  
                            });
                          }), 
                      child: Text('Image', style:Configuration.text('small',Colors.white))
                    )
                  ],
                ),
                SizedBox(height: Configuration.verticalspacing),

                */

                Center(
                  child: BaseButton(
                    onPressed: () async { 
                      if(title.value.text.isNotEmpty && content.value.text.isNotEmpty){
                        // PODRÍAMOS  UTILIZAR RREQUEST AQUI !!!!
                        Request r = await _requestState.uploadRequest(
                          title.value.text,content.value.text,uploadedImage, selectedtype.toLowerCase(), stageToAdd
                        );
                        
                        if(r != null){
                          title.clear();
                          content.clear();
                          uploadedImage = null;
                          Navigator.pop(context);
                          
                          _requestState.setRequest(r: r);

                          Navigator.push(context, 
                            MaterialPageRoute(builder: (context){
                              return RequestView();
                            })
                          );
                        }
                      }else{
                        showDialog(
                          context:context,
                          builder:(context)=>
                            AbstractDialog(
                              content:Container(
                                padding:EdgeInsets.all(Configuration.smpadding),
                                decoration: BoxDecoration(
                                  color:Colors.white,
                                  borderRadius: BorderRadius.circular(Configuration.borderRadius/2),
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.error, size: Configuration.smicon,color:Colors.red),
                                    SizedBox(height: Configuration.verticalspacing),
                                    Text(
                                      'You must type a title and a content for creating a request', style: Configuration.text('small',Colors.red)),
                                  ],
                                ),
                              )
                          ));
                      }
                    },
                    text: stage != null ?  'Start discussion': 'Send Request'
                  ),
                ),
                SizedBox(height: Configuration.verticalspacing*2)
              ],
            )
          ),
      );
    });
  }

  Widget requests({String tipo, dynamic stagenumber}){
    List<Request> request = tipo == null  && stagenumber == null ? 
    _requestState.requests.where((element) => element.coduser == _userState.user.coduser).toList() : 
    stagenumber != null ?
    _requestState.requests.where((element) => (stagenumber == 'View all' || element.stagenumber == stagenumber) && element.state != 'closed').toList() : 
    _requestState.requests.where((element) => element.type == tipo && element.state != 'closed').toList();

    String tipostring = stage != null ? 'discussions':  tipo != null ? tipo =='suggestion' ? 'suggestions' :'issues': 'Issues/Request';

    return request.length == 0 ? 
     Container(
        padding:EdgeInsets.symmetric(horizontal:Configuration.smpadding),
       child: Column(
         children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text('Filter',style:Configuration.text('small',Colors.grey)),
                  SizedBox(width: Configuration.verticalspacing),
                  DropdownButton<String>(
                    value: _requestState.selectedfilter,
                    elevation: 16,
                    style: Configuration.text('small', Colors.black),
                    underline: Container(
                      height: 0,
                      color: Colors.deepPurpleAccent,
                    ),
                    onChanged: (String newValue) {
                      setState(() {
                        _requestState.selectedfilter = newValue;
                      });
                    },
                    items: _requestState.filters.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList()
                  )
              ]),
              stage != null ? 
              stageSelector() 
              : Container(),
            ],
          ),
          SizedBox(height: Configuration.verticalspacing*4),
          Center(
            child: Text('There are no open $tipostring at the moment. You can add one pressing at the bottom-page button', 
              style: Configuration.text('small', Colors.black),
              textAlign: TextAlign.center,
            )
          )
         ],
       ),
     ) :
     Container(
       margin: EdgeInsets.only(bottom:Configuration.height * 0.09),
       child: ListView.builder(
        physics:ClampingScrollPhysics(),
        // ESTO eSTA HECHO MUY RARO !!!
        itemCount:request.length + 1,
        itemBuilder: (context,index) {
          if(index == 0){
            return Container(
              padding:EdgeInsets.symmetric(horizontal:Configuration.smpadding),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text('Filter',style:Configuration.text('small',Colors.grey)),
                      SizedBox(width: Configuration.verticalspacing),
                      DropdownButton<String>(
                        value: _requestState.selectedfilter,
                        elevation: 16,
                        style: Configuration.text('small', Colors.black),
                        underline: Container(
                          height: 0,
                          color: Colors.deepPurpleAccent,
                        ),
                        onChanged: (String newValue) {
                          _requestState.filterRequests(newValue);
                          setState(() {});
                        },
                        items: _requestState.filters.map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList()
                      )
                  ]),

                  stage != null ? 
                  stageSelector() : Container()
                  
                ],
              ),
            );
          }else{
            --index;
            return GestureDetector(
            onTap: (){
              _requestState.setRequest(cod:request[index].cod);
              Navigator.pushNamed(context, '/requestview').then((value) => setState((){}));
            },
            child: Card(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal:Configuration.smpadding,vertical:6),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            ProfileCircle(
                              userImage:request[index].userimage,
                              width: 40, 
                              marginLeft: 2, 
                              marginRight: 2
                            ),
                            SizedBox(width: Configuration.verticalspacing),
                            Text(request[index].username, style: Configuration.text('small', Colors.black)),
                            SizedBox(width:Configuration.verticalspacing/2),
                            request[index].date != null ? 
                            Text(datetoString(request[index].date),style: Configuration.text('tiny',Colors.grey)) 
                            : Container(),
                        ]),
                        stage != null ? 
                        Icon(
                          request[index].type == 'question' ? Icons.question_mark: Icons.question_answer, 
                          color: Colors.grey
                        ) :  StateChip(request: request[index])
                      ],
                    ),
                    SizedBox(height: 5.0),
                    
                    Container(
                      margin: EdgeInsets.only(left:5),
                      child: Text(request[index].title != null ? request[index].title : 'no title', style: Configuration.text('smallmedium', Colors.black))
                    ),

                    stage != null && request[index].stagenumber != 'none' ?  
                    Chip(
                      label: Text('Stage ${request[index].stagenumber}', style: Configuration.text('tiny', Colors.grey)),
                      backgroundColor: Colors.grey[200],
                    ) : Container(),
                    
                    SizedBox(height: 5.0),
                    Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children:[
                             IconButton(
                              iconSize:Configuration.smicon,
                              onPressed: ()=> 
                                setState(() {
                                  _requestState.updateRequest(request[index], true); 
                                }), 
                              icon: Icon(Icons.arrow_upward, color: request[index].votes[_userState.user.coduser] == 1 ? Colors.green : Colors.black)
                            ),
                            Text(request[index].points.toString(), style: Configuration.text('small', Colors.black),),
                            IconButton(
                              iconSize: Configuration.smicon,
                              onPressed: ()=> 
                                setState(() {
                                  _requestState.updateRequest(request[index], false);
                                }),
                              icon:  Icon(Icons.arrow_downward, color:  request[index].votes[_userState.user.coduser] == -1 ? Colors.red : Colors.black)
                            ),
                          ]
                        ),
                        Row(
                          children: [
                            Icon(Icons.comment, size:Configuration.smicon),
                            SizedBox(width:4),
                            Text(request[index].shortcomments != null && request[index].shortcomments.length > 0 ? request[index].shortcomments.length.toString() : request[index].comments == null ? '0': request[index].comments.length.toString()),
                            SizedBox(width:Configuration.verticalspacing)
                          ],
                        )
                    ])
                  ]
                ),
              ),
            ),
          );
        }
        }
    ),
     );
  }
  
  Widget notifications(){
    List<Notify> n = _userState.user.notifications;

    n.sort((a,b)=> b.date.compareTo(a.date));
    for(Notify n in _userState.user.notifications){
      if(!n.seen){
        _requestState.viewNotification(n);
      }
    }

    return AbstractDialog(
      content: Container(
        height: Configuration.height*0.5,
        width: Configuration.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Configuration.borderRadius/3),
          color: Colors.white,
        ),
        child: Column(
          children: [
            SizedBox(height: Configuration.verticalspacing),
            Text('Notifications', style: Configuration.text('medium',Colors.black)),
            SizedBox(height: Configuration.verticalspacing),
            Expanded(
              child: Container(
                decoration:BoxDecoration(
                  color:Configuration.lightgrey,
                  borderRadius: BorderRadius.circular(Configuration.borderRadius/4)
                ),
                child: ListView.separated(
                  physics: ClampingScrollPhysics(),
                  itemBuilder: (context,index){
                    return ListTile(
                      onTap: () {  
                        _requestState.setRequest(cod:n[index].codrequest);
                        Navigator.push(context, 
                          MaterialPageRoute(builder: (context){
                            return RequestView();
                          })
                        );
                      },
                      leading:Icon(n[index].getIcon(), size: Configuration.smicon, color: Colors.lightBlue),
                      title: Text(n[index].message,style: Configuration.text('small',Colors.black,font:'Helvetica')),
                      subtitle: Text(datetoString(n[index].date),style: Configuration.text('small',Colors.grey,font:'Helvetica')),
                      
                    );
                  }, 
                  separatorBuilder: (context,index){
                    return Divider();
                  }, 
                  itemCount: n.length
                ),
              ) 
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle(
          // Status bar color
          statusBarColor: pushedDialog ? Colors.black.withOpacity(0.1): Configuration.lightgrey, 

          // Status bar brightness (optional)
          statusBarIconBrightness: Brightness.dark, // For Android (dark icons)
          statusBarBrightness: Brightness.light, // For iOS (dark icons)
        ),
        leading: ButtonBack(color: Colors.black),
        actions: [
          Stack(
            children:[
              IconButton(
                onPressed:(){
                  // pushed dialog true 
                  pushedDialog  = true;

                  showDialog(
                    context: context, 
                    builder: (context){
                      return notifications();
                    }
                  ).then((value) => setState((){
                    pushedDialog  =  false;
                    //print(_userState.user.notifications.where((element) => element.seen != true).length);
                  }));
                }, 
                iconSize:Configuration.smicon,
                icon: Icon(Icons.notifications,color: Colors.black)
              ),
              
              _userState.user.notifications.where((element) => !element.seen).toList().length > 0 ?
              Positioned(
                right: 5,
                top: 0,
                child: Container(
                  padding: EdgeInsets.all(5.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.red
                  ),
                  child: Text(_userState.user.notifications.where((element) => !element.seen).toList().length.toString(),style: Configuration.text('small', Colors.white))
                )
              ) : Container()
            ]
          )
        ],
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      bottomSheet: Wrap(
        children: [
          Material(
            elevation: 10,
            child: Container(        
              width: Configuration.width,
              padding: EdgeInsets.all(Configuration.smpadding),
              decoration: BoxDecoration(
                border: Border(top: BorderSide(color: Colors.grey, width: 1.0)),
                color: Colors.white,
              ),
              child: Center(
                child: Container(
                  margin: EdgeInsets.only(bottom: Configuration.verticalspacing*2),
                  width: Configuration.width * 0.6,
                  child: AspectRatio(
                    aspectRatio:Configuration.buttonRatio,
                    child: ElevatedButton(
                      onPressed: (){
                        return showModalBottomSheet<void>(
                          isScrollControlled: true,
                          context: context,
                          builder: (BuildContext context) {
                            return addRequestModal(context);
                          }
                        ).then((value) => setState((){}));
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Configuration.maincolor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(Configuration.borderRadius)
                        )
                      ),
                      child: Text(
                        'Create Request',
                        style: Configuration.text('smallmedium', Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      extendBody: false,
      body: DefaultTabController(
        length: tabs.length,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(stage != null ?
                'Share your doubts, start a new discussion or participate in one':
                'Here you can add issues and suggestions to the app', 
                textAlign: TextAlign.center,
                style: Configuration.text('small', Colors.black),),
            ),
            SizedBox(height: 10),
            TabBar(
              indicatorSize: TabBarIndicatorSize.tab,
              indicatorWeight: 2.5,
              indicatorColor: Configuration.maincolor,
              tabs: tabs.map((tab){

                return Tab(
                  child: Text(tab, style:Configuration.text('small', Colors.black)),
                );
              }).toList()
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: Configuration.smpadding),
                color: Configuration.lightgrey,
                width: Configuration.width,
                child: Observer(builder: (context)  {
                  return _requestState.gettingrequests ? 
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: EdgeInsets.all(8.0),
                        width: 50,
                        height: 50,
                        child: CircularProgressIndicator(
                          color: Configuration.maincolor,
                        ),
                      ),
                    ],
                  ) : 
                  TabBarView(
                    physics: NeverScrollableScrollPhysics(),
                    children: stage != null ? 
                      [
                        requests(stagenumber: selectedStage),
                        requests(),
                      ] :
                      [
                      requests(tipo: 'issue') ,
                      requests(tipo: 'suggestion'),
                      requests()
                    ]);
                })
              ),
            )
          ],
        ),
      )
    );
  }
}

class RequestView extends StatefulWidget {
  Request request;

  RequestView({this.request});

  @override
  _RequestViewState createState() => _RequestViewState();
}

class _RequestViewState extends State<RequestView> {
  
  UserState _userState;
  
  Widget comment(Comment comment){
    return Container(
      padding: EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: (){
              showUserProfile(usercod: comment.coduser);
            },
            child: ListTile(
              contentPadding: EdgeInsets.all(0),
              leading: ProfileCircle(
                userImage: comment.userimage, 
                width: 25
              ),
              minLeadingWidth: 25,
              title: Text(comment.username != null ? comment.username : 'Guest',style: Configuration.text('small',Colors.black)),
              subtitle: Text(comment.date != null ? datetoString(comment.date): '',style: Configuration.text('small',Colors.grey,font: 'Helvetica')),
             ),
          ),
          htmlToWidget(comment.comment != null ? comment.comment :'xx'),
          comment.images.length > 0 ?
          GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            padding: EdgeInsets.all(0),
            itemCount: comment.images.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, childAspectRatio: 2.5), 
            itemBuilder:  (context, index) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    child: ImageView(image:comment.images[index]),
                  ),
                ],
              );
            }
          ):  Container()

        ],
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    _userState = Provider.of<UserState>(context);
    RequestState _requestState = Provider.of<RequestState>(context);

    return Scaffold(
      bottomSheet: Material(
        elevation: 10,
        child: Container(
          padding: EdgeInsets.all(Configuration.smpadding),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: (){
                  Navigator.pushNamed(context, '/sendcomment').then((value) => setState((){}));
                },
                child: Container(
                  width: Configuration.width,
                  padding: EdgeInsets.all(Configuration.smpadding),
                  decoration: BoxDecoration(
                    color: Configuration.lightgrey,
                    borderRadius: BorderRadius.circular(Configuration.borderRadius/2),
                  ),
                  child: Text('Add a comment', style: Configuration.text('small',Colors.grey,font: 'Helvetica')),
                ),
              ),
              SizedBox(height: Configuration.verticalspacing)
            ],
          ),
        ),
      ),
      backgroundColor: Configuration.lightgrey,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Configuration.lightgrey,
        leading: ButtonBack(color: Colors.black),
        actions: [
           //Pasar esto a admin
           _userState.user.isAdmin() ?
          Observer(
            builder: (context) {
              if(!_requestState.gettingrequests){
              return Container(
                padding: EdgeInsets.all(12.0),
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    //side: BorderSide(width: 2.0, color: _requestState.selectedrequest.nextStateColor())
                  ),
                  onPressed: () {
                    setState(() {
                      _requestState.selectedrequest.changeState(_userState.user);
                      _requestState.updateRequest(_requestState.selectedrequest, null);
                    });
                  }, 
                  child: Text('Change Request to ' + _requestState.selectedrequest.nextState(), style: Configuration.text('small', Colors.black),)
                ),
              );
              }else{
                return Container();
              }
            }
          ) : Container(),
        ],
      ),
      body: Observer(
        builder: (context) {
          if(_requestState.gettingrequests){
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(child: CircularProgressIndicator(color: Configuration.maincolor,)),
              ]);
          }else return ListView(
            physics:ClampingScrollPhysics(),
            children: [
              Container(
                color: Colors.white,
                width: Configuration.width,
                padding: EdgeInsets.all(8.0),
                child:  Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                  Row(
                    mainAxisAlignment:MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: (){
                          showUserProfile(usercod:_requestState.selectedrequest.coduser);
                        },
                        child: Row(
                          children: [
                            ProfileCircle(
                                userImage:_requestState.selectedrequest.userimage, 
                                width: 40,
                                marginLeft: 3,
                                marginRight: 3,
                            ),
                            SizedBox(width: Configuration.verticalspacing),
                            Text(_requestState.selectedrequest.username,style:Configuration.text('small',Colors.black))
                          ],
                        ),
                      ),
                      StateChip(request: _requestState.selectedrequest)
                    ],
                  ),
                  SizedBox(height: 10),
                  Text(_requestState.selectedrequest.title, style: Configuration.text('medium', Colors.black)),
                  SizedBox(height: 10),
                  Text(_requestState.selectedrequest.content, style:Configuration.text('small', Colors.black, font:'Helvetica')),
                  SizedBox(height: 10),
                  _requestState.selectedrequest.image != null ?
                  Container(
                    child: ImageView(
                      image: _requestState.selectedrequest.image
                      ),
                      //Image(image: CachedNetworkImageProvider(_requestState.selectedrequest.image))
                  ) : Container()
                ])
              ),
              SizedBox(height: 5),
              
              Padding(
                padding: EdgeInsets.all(Configuration.smpadding),
                child: Text('Comments', style: Configuration.text('medium', Colors.black)),
              ),
              SizedBox(height: 5),
              Container(
                width: Configuration.width,
                decoration: BoxDecoration(color: Colors.white),
                child:  _requestState.selectedrequest.comments.length > 0 ?
                  ListView.separated(
                    shrinkWrap: true,
                    reverse: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: _requestState.selectedrequest.comments.length,
                    itemBuilder: (context,index){
                      int i = _requestState.selectedrequest.comments.length - index - 1;
                      return comment(_requestState.selectedrequest.comments[i]);
                    }, 
                    separatorBuilder: (BuildContext context, int index) {  
                      return Container(
                        width: Configuration.width,
                        height: Configuration.verticalspacing,
                        color: Configuration.lightgrey,
                      );
                    }
                  )
                  :
                  Padding(
                    padding: EdgeInsets.all(Configuration.smpadding),
                    child: Text(
                      'There are no comments at the moment. You can add one at the bottom',
                      
                      style: Configuration.text('small', Colors.black, font: 'Helvetica'),
                      
                      ),
                  ) 
              ),
              SizedBox(height: Configuration.verticalspacing*10)
            ],
          );
        }
      ),
    );
  }
}

class ImageView extends StatelessWidget {
  
  ImageView({
    Key key,
    this.image
  }): super(key: key);

  String image;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        padding: EdgeInsets.all(0)
      ),
      onPressed: (){
        showGeneralDialog(
          barrierColor: Colors.black12.withOpacity(0.93), // Background color
          barrierLabel: 'Dialog',
          transitionDuration: Duration(milliseconds: 400),
          context: context, 
          pageBuilder: (_,__,___){
          return AbstractDialog(
            content: Stack(
              children: [
                Container(
                  margin: EdgeInsets.only(top: Configuration.verticalspacing*2),
                  child: Row(
                    children: [
                      CloseButton(
                        color: Colors.white,
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      )
                    ],
                  ),
                ),
                Center(child: Image(image: CachedNetworkImageProvider(image))),
              ],
            )
          );
        });
      },
      child: Text('View Image', style: Configuration.text('small', Colors.lightBlue)),

    );
  }
}


class SendComment extends StatefulWidget {
  const SendComment({Key key}) : super(key: key);

  @override
  State<SendComment> createState() => _SendCommentState();
}

class _SendCommentState extends State<SendComment> {
  String addedComment = '';
  Comment c = new Comment();
  TextEditingController _controller = new TextEditingController();

  List<XFile> files = new List.empty(growable: true);

  bool uploadingImages = false;
  String linkName, linkDirection;

  Widget insertLink(){

    return StatefulBuilder(
      builder: (context, setState) {
        return Container(
          width: Configuration.width*0.9,
          padding: EdgeInsets.all(Configuration.smpadding),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10)
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Insert a link', style: Configuration.text('smallmedium',Colors.black)),
              SizedBox(height: Configuration.verticalspacing),
              TextField(
                onChanged: (str)=> setState(()=> { linkName = str}),
                style: Configuration.text('small', Colors.black,font: 'Helvetica'),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Name'
                ),
              ),
              SizedBox(height: Configuration.verticalspacing),
              TextField(
                onChanged: (str)=> setState(()=> { linkDirection = str}),
                style: Configuration.text('small', Colors.black,font: 'Helvetica'),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  
                  hintText: 'Direction'
                ),
              ),
              SizedBox(height: Configuration.verticalspacing),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.black,
                      padding: EdgeInsets.all(0)
                    ),
                    onPressed: (){
                      Navigator.pop(context); 
                     }, 
                    child: Text('Cancel', style: Configuration.text('small', Colors.black))
                  ),
    
                  SizedBox(width: Configuration.verticalspacing),
    
                  TextButton(
                    onPressed: linkDirection != null && linkName != null ? (){
                      setState(() {
                        addedComment += '<a href=$linkDirection> $linkName </a>';
                        _controller.text = addedComment;
                        Navigator.pop(context);
                      });
                    }:null, 
                    child: Text('Add link', style: Configuration.text('small', Colors.lightBlue))
                  ),
    
                 
                ],
              )
            ]
          )
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    RequestState _requestState = Provider.of<RequestState>(context);
    final _userstate =  Provider.of<UserState>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: CloseButton(color: Colors.black),
        elevation: 1,
        title: Text("Add comment",
          style:  Configuration.text('smallmedium',Colors.black),
        ),
      ),
      body: Container(
        color: Configuration.lightgrey,
        padding: EdgeInsets.all(Configuration.smpadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(_requestState.selectedrequest.title, 
              style: Configuration.text('small', Colors.black)
            ),
            SizedBox(height: Configuration.verticalspacing),
            Divider(),
            SizedBox(height: Configuration.verticalspacing),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    textCapitalization: TextCapitalization.sentences,
                    onChanged: (str)=> setState(()=> { c.comment = str}),
                    controller: _controller,
                    style: Configuration.text('small', Colors.black,font: 'Helvetica'),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Your comment here'
                    ),
                    maxLines: 10,
                    minLines: 1,
                  ),
                  files.length > 0 ?
                  Container(
                    height: Configuration.height*0.3,
                    child: GridView.builder(
                      itemCount: files.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
                      shrinkWrap: true,
                      itemBuilder: (context,index){
                        return Container(
                          margin: EdgeInsets.all(5),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.file(File(files[index].path))
                          ),
                        );
                      }
                    ),
                  ) : Container(),
                ],
              ),
            ),
            /*
            Divider(),
            Row(
              children: [
                IconButton(
                  onPressed: ()=>{
                    showPicker(onSelectImage: (file){
                      if(file != null){
                        files.add(file);
                        setState(() {});
                      }
                    })
                  }, 
                  icon: Icon(Icons.image, color: Colors.lightBlue)
                ),
              ],
            ),*/
            
            Divider(),


            BaseButton(
              text: 'Send Comment',
              color: Configuration.maincolor,
              onPressed: _controller.text.isNotEmpty && !uploadingImages 
              ? () async {
                  setState(() {
                    uploadingImages = true;
                  });

                  if(files.length > 0){
                    for(var file in files){
                      c.images.add(await _userstate.uploadFile(image: file));
                    }
                  }

                  setState(() {
                    uploadingImages = false;
                  });

                  _requestState.updateRequest(_requestState.selectedrequest, null,c);
                  Navigator.pop(context);

              }: null,
            ),
            SizedBox(height: Configuration.verticalspacing)
          ],
        ),
      )
    );
  }
}

class RequestHeader extends StatelessWidget {
  const RequestHeader() : super();

  @override
  Widget build(BuildContext context) {
    return Container(
      
    );
  }
}


class StateChip extends StatelessWidget {
  const StateChip({
    Key key,
    @required this.request,
  }) : super(key: key);

  final Request request;

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(request.getState(), style:Configuration.text('small', Colors.white)),
      backgroundColor: request.getColor(),
    );
  }
}


/*
class DiscussionScreen extends StatefulWidget {
  const DiscussionScreen({Key key}) : super(key: key);

  @override
  State<DiscussionScreen> createState() => _DiscussionScreenState();
}

class _DiscussionScreenState extends State<DiscussionScreen> {
  Stage stage;

  @override 
  void initState() {
    super.initState();
  }

  //override didChangeDependencies
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    //stage = ModalRoute.of(context).settings.arguments;
    final arg = ModalRoute.of(context).settings.arguments as Map;
    stage = arg['stage'];
  }

  Widget addQuestionModal(context){
    return BottomSheetModal(
      child: Container() 
    );
  }



  @override
  Widget build(BuildContext context) {
    final _userstate = Provider.of<UserState>(context);
    
    return Scaffold(
      bottomSheet: Material(
        elevation: 10,
        child: Container(        
          width: Configuration.width,
          height:Configuration.height * 0.09,
          decoration: BoxDecoration(
            border: Border(top: BorderSide(color: Colors.grey, width: 1.0)),
            color: Colors.white,
          ),
          child: Center(
            child: Container(
              width: Configuration.width *0.6,
              child: AspectRatio(
                aspectRatio:Configuration.buttonRatio,
                child: ElevatedButton(
                  onPressed: (){
                    return showModalBottomSheet<void>(
                      isScrollControlled: false,
                      context: context,
                      builder: (BuildContext context) {
                        return addQuestionModal(context);
                      }
                    ).then((value) => setState((){}));
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Configuration.maincolor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(Configuration.borderRadius)
                    )
                  ),
                  child: Text(
                    'Add a topic',
                    style: Configuration.text('smallmedium', Colors.white),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      appBar: AppBar(
        elevation: 0,
        leading: ButtonBack(color: Colors.black),
        backgroundColor: Colors.white,
        title: Text('Stage ' +  stage.stagenumber.toString() + '  discussion' , 
          style: Configuration.text('small',Colors.black)
        ),
      ),
      body: Column(
        children: [
          Container(
            height: Configuration.height * 0.15,
            color: Colors.white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Here you can ask questions about the stage or any particular meditation-related topic you may have ', 
                  style: Configuration.text('small', Colors.black, font:'Helvetica')
                ),
                Text(stage.description, style: Configuration.text('small', Colors.black),),
                /*
                Container(
                  height: Configuration.height * 0.2,
                  width: Configuration.width,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/meditation.jpg'),
                      fit: BoxFit.cover
                    )
                  ),
                ),*/
              ],
            ),
          ),
        ],
      ),
    );
  }
}
*/
