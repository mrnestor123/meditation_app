
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meditation_app/domain/entities/notification_entity.dart';
import 'package:meditation_app/domain/entities/request_entity.dart';
import 'package:meditation_app/presentation/mobx/actions/requests_state.dart';
import 'package:meditation_app/presentation/mobx/actions/user_state.dart';
import 'package:meditation_app/presentation/pages/commonWidget/dialog.dart';
import 'package:meditation_app/presentation/pages/commonWidget/profile_widget.dart';
import 'package:provider/provider.dart';

import 'config/configuration.dart';

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
  bool uploading;
  Request addedReq = new Request(type: 'suggestion', state: 'open');
  String selectedtype = 'Suggestion';

  TextEditingController title = new TextEditingController();
  TextEditingController content = new TextEditingController();

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
    
    void _showPicker(context) {
      void setImage(image) async{
          uploading = true;
          String imgstring = await _userState.uploadImage(image);
          print(imgstring);
          stateSetter(() {
            addedReq.image = imgstring;  
          });
        }

      _imgFromCamera() async {
        PickedFile image = await _picker.getImage(source: ImageSource.camera);
        
        if(image != null){
          setImage(image);
        }
      }

      _imgFromGallery() async {
      PickedFile image = await _picker.getImage(source: ImageSource.gallery);

        if(image != null){
          setImage(image);
        }
      }

      showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                ListTile(
                    leading: new Icon(Icons.photo_library),
                    title: new Text('Photo Library'),
                    onTap: () {
                      _imgFromGallery();
                      Navigator.of(context).pop();
                    }),
                ListTile(
                  leading: new Icon(Icons.photo_camera),
                  title: new Text('Camera'),
                  onTap: () {
                    _imgFromCamera();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
        );
      });
    }
  
    return StatefulBuilder(
      builder:(BuildContext context, StateSetter setState ) {
      stateSetter = setState;
      return  Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
            height: Configuration.height * 0.5,
            padding: EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10),
                Text('Title', style:Configuration.text('small', Colors.black)),
                TextField(
                  controller: title,
                  maxLines: 1,
                  onChanged: (str){addedReq.title = str;},
                  decoration: InputDecoration(
                    hintText: "Enter title",
                    hintMaxLines: 2,
                    border: new OutlineInputBorder(
                        borderSide: new BorderSide(color: Colors.black)
                    ),),
                ),
                Text('Content', style:Configuration.text('small', Colors.black)),
                SizedBox(height: 6),
                Expanded(
                  child: TextField(
                    controller: content,
                    onChanged: (str) {
                      addedReq.content = str;
                    },
                    expands: true,
                    maxLines: null,
                    decoration: InputDecoration(
                      hintText: "Enter your text here",
                      border: new OutlineInputBorder(
                          borderSide: new BorderSide(color: Colors.black)
                      ),),
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Type of request', style: Configuration.text('small', Colors.black)), 
                    DropdownButton<String>(
                      value: selectedtype,
                      icon: Icon(Icons.arrow_downward_sharp, color: Colors.black,size: Configuration.smicon),
                      elevation: 16,
                      style: TextStyle(color: Colors.black),
                      underline: Container(
                        height: 2,
                        color: Colors.black,
                      ),
                      onChanged: (String newValue) {
                        setState(() {
                          if(newValue =='Suggestion'){
                            addedReq.type = 'suggestion';
                          }else{
                            addedReq.type = 'issue';  
                          }
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
                SizedBox(height: 10),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Add Image', style: Configuration.text('small', Colors.black)),
                    addedReq.image  != null ? 
                    Row(
                      children: [
                        Image(image: NetworkImage(addedReq.image), height: 50),
                        IconButton(
                          onPressed: ()=> setState((){ addedReq.image = null;}), 
                          icon: Icon(Icons.delete, color: Colors.red)
                        )
                      ],
                    )
                    :
                    ElevatedButton(
                      onPressed: () => _showPicker(context), 
                      child: Text('Image')
                    )
                  ],
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () async { 
                    _requestState.uploadRequest(addedReq);
                    addedReq.title ='';
                    addedReq.content = '';
                    addedReq.type = 'suggestion';
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    fixedSize: Size.fromWidth(Configuration.width),
                    primary: Configuration.maincolor,
                    padding: EdgeInsets.symmetric(vertical:10.0,horizontal: 4.0)
                  ), 
                  child: Text('Send Request', style: Configuration.text('small', Colors.white))
                )
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
     ListView.builder(
      itemCount:request.length,
      itemBuilder: (context,index) => 
        GestureDetector(
          onTap: (){
          _requestState.setRequest(request[index]);
          Navigator.push(context,
            MaterialPageRoute(
              builder: (context) => RequestView(request: request[index])
            )
          ).then((value) => setState((){}));
          },
          child: Card(
            child: Container(
              padding: EdgeInsets.all(6.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 40,
                            child:ProfileCircle(
                              userImage:request[index].userimage, 
                              width: 2, 
                              marginLeft: 2, 
                              marginRight: 2
                            ),
                          ),
                          SizedBox(width: 4),
                          Text(request[index].username, style: Configuration.text('tiny', Colors.black)),
                      ]),
                      StateChip(request: request[index])
                    ],
                  ),
                  SizedBox(height: 5.0),
                  Text(request[index].title, style: Configuration.text('small', Colors.black)),
                  SizedBox(height: 5.0),
                  Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children:[
                           IconButton(
                            onPressed: ()=> 
                              setState(() {
                                _requestState.updateRequest(request[index], true); 
                              }), 
                            icon: Icon(Icons.arrow_upward, color: request[index].votes[_userState.user.coduser] == 1 ? Colors.green : Colors.black)
                          ),
                          Text(request[index].points.toString(), style: Configuration.text('small', Colors.black),),
                          IconButton(
                            onPressed: ()=> 
                              setState(() {
                                _requestState.updateRequest(request[index], false);
                              }),
                            icon:  Icon(Icons.arrow_downward , color:  request[index].votes[_userState.user.coduser] == -1 ? Colors.red : Colors.black)
                          ),
                         
                        ]
                      ),
                      Row(
                        children: [
                          Icon(Icons.comment),
                          Text(request[index].comments == null ? '0': request[index].comments.length.toString()),
                        ],
                      )
                  ])
                ]
              ),
            ),
          ),
        )
      );
  }
  
  Widget notifications(){
    List<Notify> n = _userState.user.notifications;

    return AbstractDialog(
      content: Container(
        height: Configuration.height*0.5,
        width: Configuration.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
        ),
        child: Column(
          children: [
            SizedBox(height: 10),
            Text('Notifications', style: Configuration.text('medium',Colors.black)),
            SizedBox(height: 10),
            Expanded(
              child: Container(
                color: Configuration.lightgrey,
                child: ListView.separated(
                  itemBuilder: (context,index){
                    return TextButton(
                      onPressed: () {  
                        _requestState.viewNotification(n[index]);
                        _requestState.setRequest(n[index].codrequest);
                        Navigator.push(context, 
                        MaterialPageRoute(builder: (context){
                          return RequestView();
                        })
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            ProfileCircle(
                                userImage:n[index].userimage, 
                                width: 2, 
                                marginLeft: 2, 
                                marginRight: 2
                              ),
                            Flexible(child: Text(n[index].message,style: Configuration.text('small',Colors.black),))
                          ],
                        ),
                      ),
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
      floatingActionButton: FloatingActionButton(
        backgroundColor: Configuration.maincolor,
        onPressed: () {
          if(addedReq.title != null){
            title.text = addedReq.title;
          }
          if(addedReq.content != null){
            content.text = addedReq.content;
          }
          return showModalBottomSheet<void>(
            isScrollControlled: true,
            context: context,
            builder: (BuildContext context) {
              return addRequestModal(context);
            }
          );
        },
        child: Icon(Icons.add),
      ),
      appBar: AppBar(
        leading: ButtonBack(),
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
                  )
                }, 
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
      extendBody: false,
      body: DefaultTabController(
        length: 3,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('Here you can add isues and suggestions to the app', style: Configuration.text('small', Colors.black),),
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
                padding: EdgeInsets.all(8.0),
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
                  ): TabBarView(
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
  var _controller = TextEditingController();
  
  Widget comment(Comment comment){
    return Container(
      padding: EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(comment.username != null ? comment.username : 'x', style: Configuration.text('small', Colors.black),),
          SizedBox(height: 10),
          Text(comment.comment != null ? comment.comment :'xx'),
        ],
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    UserState _userState = Provider.of<UserState>(context);
    RequestState _requestState = Provider.of<RequestState>(context);

    return Scaffold(
      bottomSheet: Material(
        elevation: 10,
        child: Container(
          child: TextField(
            controller: _controller,
            textAlignVertical: TextAlignVertical.center,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.all(6.0),
              hintText: 'Add comment',
              isDense: true,
              suffixIcon: IconButton(
                onPressed: (){
                  setState(() {
                    _requestState.updateRequest(_requestState.selectedrequest, null, _controller.text);
                    _controller.clear();
                  });
                },   
                icon: Icon(Icons.send)
              )
            ),
          ),
        ),
      ),
      backgroundColor: Configuration.lightgrey,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Configuration.lightgrey,
        leading: ButtonBack(),
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
              ],
            );
          }else return ListView(
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
                      Row(
                        children: [
                          Container(
                            width: Configuration.width*0.12,
                            child:ProfileCircle(
                              userImage:_requestState.selectedrequest.userimage, 
                              width: 2,
                              marginLeft: 3,
                              marginRight: 3,
                            )
                          ),
                          Text(_requestState.selectedrequest.username,style:Configuration.text('small',Colors.black))
                        ],
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
                      Image(image: NetworkImage(_requestState.selectedrequest.image))
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
                child: 
                _requestState.selectedrequest.comments.length > 0 ?
                ListView.separated(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: _requestState.selectedrequest.comments.length,
                  itemBuilder: (context,index){
                    return comment(_requestState.selectedrequest.comments[index]);
                  }, 
                  separatorBuilder: (BuildContext context, int index) {  
                    return Container(
                      width: Configuration.width,
                      height: 10,
                      color: Configuration.lightgrey,
                    );
                  })
                  :
                  Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Text('There are no comments at the moment. You can add one at the bottom'),
                  ) 
              ),
              SizedBox(height: 70)
            ],
          );
        }
      ),
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

class ButtonBack extends StatelessWidget {
  Color color;
  
  ButtonBack({this.color}) : super();

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: ()=> Navigator.pop(context), 
      icon: Icon(
        Icons.arrow_back_ios,
        size: Configuration.smicon,
        color: color != null ? color : Colors.black,
        )
      );
  }
}