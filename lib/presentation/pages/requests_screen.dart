
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meditation_app/domain/entities/notification_entity.dart';
import 'package:meditation_app/domain/entities/request_entity.dart';
import 'package:meditation_app/presentation/mobx/actions/requests_state.dart';
import 'package:meditation_app/presentation/mobx/actions/user_state.dart';
import 'package:meditation_app/presentation/pages/commonWidget/alert_dialog.dart';
import 'package:meditation_app/presentation/pages/commonWidget/bottom_input.dart';
import 'package:meditation_app/presentation/pages/commonWidget/circular_progress.dart';
import 'package:meditation_app/presentation/pages/commonWidget/date_tostring.dart';
import 'package:meditation_app/presentation/pages/commonWidget/dialog.dart';
import 'package:meditation_app/presentation/pages/commonWidget/profile_widget.dart';
import 'package:meditation_app/presentation/pages/commonWidget/user_bottom_dialog.dart';
import 'package:provider/provider.dart';

import 'commonWidget/image_upload_modal.dart';
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

  TextEditingController title = new TextEditingController();
  TextEditingController content = new TextEditingController();

  List<String> filters = ['Date', 'Votes'];

  @override 
  void didChangeDependencies(){
    super.didChangeDependencies();
    _userState = Provider.of<UserState>(context);
    _requestState = Provider.of<RequestState>(context);
    _requestState.setUser(_userState.user);
    _requestState.getRequests();
  }

  Widget addRequestModal(context){
    var stateSetter;
    
 
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
                    ),),
                ),
                SizedBox(height:Configuration.verticalspacing),
                Text('Content', style:Configuration.text('small', Colors.black)),
                SizedBox(height: Configuration.verticalspacing/2),
                TextField(
                  controller: content,
                  maxLines: 5,
                  decoration: InputDecoration(
                    hintText: "Enter your text here",
                    border: new OutlineInputBorder(
                        borderSide: new BorderSide(color: Colors.black)
                    ),),
                ),
                SizedBox(height: Configuration.verticalspacing),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Type of request', style: Configuration.text('small', Colors.black)), 
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
                      items: <String>['Suggestion', 'Issue'].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ],
                ),
                SizedBox(height: Configuration.verticalspacing*2),
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
                            
                            print(imgstring);
                            setState(() {
                              uploading= false;
                              uploadedImage  = imgstring;  
                            });
                          }), 
                      child: Text('Image', style:Configuration.text('small',Colors.white))
                    )
                  ],
                ),
                SizedBox(height: Configuration.verticalspacing),
                Center(
                  child: BaseButton(
                    onPressed: () async { 
                      if(title.value.text.isNotEmpty && content.value.text.isNotEmpty){
                        Request r = await _requestState.uploadRequest(title.value.text,content.value.text,uploadedImage, selectedtype.toLowerCase());
                        
                        if(r != null){
                          title.clear();
                          content.clear();
                          Navigator.pop(context);
                          _requestState.setRequest(r: r);

                          Navigator.push(context, 
                            MaterialPageRoute(builder: (context){
                              return RequestView();
                            })
                          ).then((value) => setState((){}));
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
                    text: 'Send Request'
                  ),
                ),
                SizedBox(height: Configuration.verticalspacing*2)
              ],
            )
          ),
      );
    });
  }

  Widget requests([String tipo]){
    List<Request> request = tipo == null ? 
    _requestState.requests.where((element) => element.coduser == _userState.user.coduser).toList() : 
    _requestState.requests.where((element) => element.type == tipo && element.state != 'closed').toList();

    String tipostring = tipo != null ? tipo =='suggestion' ? 'suggestions' :'issues': 'Issues/Request';

    return request.length == 0 ? 
     Center(
       child: Text('There are no open $tipostring at the moment. You can add one pressing at the plus button', 
          style: Configuration.text('small', Colors.black),
          textAlign: TextAlign.center,
        )
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
                        StateChip(request: request[index])
                      ],
                    ),
                    SizedBox(height: 5.0),
                    Container(
                      margin: EdgeInsets.only(left:5),
                      child: Text(request[index].title != null ? request[index].title : 'no title', style: Configuration.text('smallmedium', Colors.black))
                    ),
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
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        leading: BackButton(color: Colors.black),
        actions: [
          Stack(
            children:[
              IconButton(
                onPressed:()=> {
                  showDialog(
                    context: context, 
                    builder: (context){
                      return notifications();
                    }
                  ).then((value) => setState((){
                    print(_userState.user.notifications.where((element) => element.seen != true).length);
                  }))
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
      bottomSheet: Material(
        elevation: 10,
        child: Container(        
          width: Configuration.width,
          height:Configuration.height * 0.09,
          decoration: BoxDecoration(
            border:   Border(top: BorderSide(color: Colors.grey, width: 1.0)),
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
      extendBody: false,
      body: DefaultTabController(
        length: 3,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('Here you can add issues and suggestions to the app', style: Configuration.text('small', Colors.black),),
            ),
            SizedBox(height: 10),
            TabBar(
              indicatorSize: TabBarIndicatorSize.tab,
              indicatorWeight: 2.5,
              indicatorColor: Configuration.maincolor,
              tabs: [
                Tab(
                  child: Text('Issues', style:Configuration.text('small', Colors.black)),
                ),
                Tab(
                  child: Text('Suggestions',style: Configuration.text('small', Colors.black))
                ),
                Tab(
                  child: Text('My Requests', style:Configuration.text('small', Colors.black)),
                )
            ]),
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
                    children: [
                      requests('issue') ,
                      requests('suggestion'),
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
          Text(comment.comment != null ? comment.comment :'xx'),
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
        leading: BackButton(color: Colors.black),
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
                    width: Configuration.width*0.2,
                    child:
                      Image(image: CachedNetworkImageProvider(_requestState.selectedrequest.image))
                  ) : Container()
                ])
              ),
              SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.all(8.0),
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
                        height: 10,
                        color: Configuration.lightgrey,
                      );
                    }
                  )
                  :
                  Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Text('There are no comments at the moment. You can add one at the bottom'),
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


class SendComment extends StatefulWidget {
  const SendComment({Key key}) : super(key: key);

  @override
  State<SendComment> createState() => _SendCommentState();
}

class _SendCommentState extends State<SendComment> {
  String addedComment = '';
  TextEditingController _controller = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    RequestState _requestState = Provider.of<RequestState>(context);

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
              child: TextField(
                
                onChanged: (str)=> setState(()=>{}),
                controller: _controller,
                style: Configuration.text('small', Colors.black,font: 'Helvetica'),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Your comment here'
                ),
                expands: true,
                maxLines: null,
                minLines: null,
              ),
            ),

            BaseButton(
              text: 'Send Comment',
              color: Configuration.maincolor,
              onPressed: _controller.text.isNotEmpty ? (){
                _requestState.updateRequest(_requestState.selectedrequest, null,_controller.text);
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


