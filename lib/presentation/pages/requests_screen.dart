
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meditation_app/domain/entities/request_entity.dart';
import 'package:meditation_app/presentation/mobx/actions/user_state.dart';
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
   PickedFile _image;
  final ImagePicker _picker = ImagePicker();
  bool uploading;
  Request addedReq = new Request(type: 'suggestion', state: 'open');

  TextEditingController title = new TextEditingController();
  TextEditingController content = new TextEditingController();

  @override 
  void didChangeDependencies(){
    super.didChangeDependencies();
    _userState = Provider.of<UserState>(context);
    _userState.getRequests();
  }

  Widget addRequestModal(context){
    
    void _showPicker(context) {
      _imgFromCamera() async {
      PickedFile image = await _picker.getImage(source: ImageSource.camera);
      
      if(image != null){
      setState(() {
        uploading =true;
      });
      
      setState(() {
        uploading = false;
      });
      }
    }

    _imgFromGallery() async {
      PickedFile image = await _picker.getImage(source: ImageSource.gallery);

      if(image != null){
        setState(() {
          uploading =true;
        });
        setState(() {
          uploading = false;
        });
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
  
    String selectedtype = 'Suggestion';

    return StatefulBuilder(
      builder:(BuildContext context, StateSetter setState ) {
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
                    ElevatedButton(
                      onPressed: ()=> _showPicker(context), 
                      child: Text('Image')
                    )
                  ],
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: (){ 
                    _userState.uploadRequest(addedReq);
                    setState(() async{
                      addedReq.title ='';
                      addedReq.content = '';
                      addedReq.type = 'suggestion';
                      await _userState.getRequests();
                      Navigator.pop(context);
                    });
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
      _userState.requests.where((element) => element.coduser == _userState.user.coduser).toList() : 
      _userState.requests.where((element) => element.type == tipo && element.state != 'closed').toList();

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
          onTap: ()=> 
          Navigator.push(context,
            MaterialPageRoute(
              builder: (context) => RequestView(request: request[index],)
            )
          ).then((value) => setState((){})),
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
                              userImage:request[index].image, 
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
                                _userState.updateRequest(request[index], true); 
                              }), 
                            icon: Icon(Icons.arrow_upward, color: request[index].votes[_userState.user.coduser] == 1 ? Colors.green : Colors.black)
                          ),
                          Text(request[index].points.toString(), style: Configuration.text('small', Colors.black),),
                          IconButton(
                            onPressed: ()=> 
                              setState(() {
                                _userState.updateRequest(request[index], false);
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
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      floatingActionButton: FloatingActionButton(
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
        backgroundColor: Colors.transparent,
        elevation: 0.0,
      ),
      extendBody: false,
      body: DefaultTabController(
        length: 3,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
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
                padding: EdgeInsets.symmetric(horizontal:Configuration.smpadding),
                color: Configuration.lightgrey,
                width: Configuration.width,
                child: Observer(builder: (context)  {
                  return _userState.requests == null ? 
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Center(
                        child: Container(
                          height: 40,
                          width: 40,
                          child: CircularProgressIndicator(color:Configuration.maincolor),
                        ),
                      ),
                    ],
                  )
                  :
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
  var _controller = TextEditingController();
  
  Widget comment(Comment comment){
    return Container(
      padding: EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(comment.username != null ? comment.username : 'x', style: Configuration.text('small', Colors.black),),
          SizedBox(height: 10),
          Text(comment.comment != null ? comment.comment :'xx')
        ],
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    UserState _userState = Provider.of<UserState>(context);

    return Scaffold(
      bottomSheet: Container(
        child: TextField(
          controller: _controller,
          decoration: InputDecoration(
            hintText: 'Add comment',
            isDense: true,
            suffixIcon: IconButton(
              onPressed: (){
                setState(() {
                  _userState.updateRequest(widget.request, null, _controller.text);
                  _controller.clear();
                });
              },   
              icon: Icon(Icons.send)
            )
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
          Container(
            padding: EdgeInsets.all(12.0),
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                side: BorderSide(width: 2.0, color: widget.request.nextStateColor())
              ),
              onPressed: () {
                setState(() {
                  widget.request.changeState(_userState.user);
                  _userState.updateRequest(widget.request, null);
                });
              }, 
              child: Text('Change Request to ' + widget.request.nextState(), style: Configuration.text('small', Colors.black),)
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: Colors.white,
              width: Configuration.width,
              padding: EdgeInsets.all(8.0),
              child:Column(
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
                            userImage:widget.request.image, 
                            width: 2,
                            marginLeft: 3,
                            marginRight: 3,
                          )
                        ),
                        Text(widget.request.username,style:Configuration.text('small',Colors.black))
                      ],
                    ),
                    
                    StateChip(request: widget.request)
                  ],
                ),
                SizedBox(height: 10),
                Text(widget.request.title, style: Configuration.text('medium', Colors.black)),
                SizedBox(height: 10),
                Text(widget.request.content, style:Configuration.text('small', Colors.black, font:'Helvetica'))
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
              widget.request.comments.length > 0 ?
              ListView.separated(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: widget.request.comments.length,
                itemBuilder: (context,index){
                  return comment(widget.request.comments[index]);
                }, 
                separatorBuilder: (BuildContext context, int index) {  
                  return Container(
                    width: Configuration.width,
                    height: 10,
                    color: Configuration.lightgrey,
                  );
                })
                :
                Text('There are no comments at the moment. You can add one at the bottom') 
            )
          ],
        ),
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