

import 'package:collection/algorithms.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:meditation_app/domain/entities/message.dart';
import 'package:meditation_app/domain/entities/user_entity.dart';
import 'package:meditation_app/presentation/mobx/actions/messages_state.dart';
import 'package:meditation_app/presentation/mobx/actions/user_state.dart';
import 'package:meditation_app/presentation/pages/commonWidget/bottom_input.dart';
import 'package:meditation_app/presentation/pages/commonWidget/circular_progress.dart';
import 'package:meditation_app/presentation/pages/commonWidget/dialog.dart';
import 'package:meditation_app/presentation/pages/commonWidget/profile_widget.dart';
import 'package:meditation_app/presentation/pages/commonWidget/start_button.dart';
import 'package:meditation_app/presentation/pages/commonWidget/user_bottom_dialog.dart';
import 'package:meditation_app/presentation/pages/config/configuration.dart';
import 'package:meditation_app/presentation/pages/main.dart';
import 'package:provider/provider.dart';
import 'commonWidget/date_tostring.dart';
import 'config/configuration.dart';

class MessagesScreen extends StatefulWidget {
  const MessagesScreen() : super();

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  UserState _userstate;
  MessagesState _messagesState;

  Widget message(Message m){
    return ListTile(
      contentPadding: EdgeInsets.all(Configuration.tinpadding),
      title: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment:CrossAxisAlignment.start,
        children: [
          Text(m.username,style: Configuration.text('small', Colors.black)),
          Text(m.text,style: Configuration.text('small',Colors.black, font: 'Helvetica')),
        ],
      ),
      //trailing: ,
      subtitle: Text(
        m.date.toString().substring(0,16),style: Configuration.text('small',Colors.grey)),
      trailing:m.type == 'classrequest' ?
      Row(
        mainAxisSize:MainAxisSize.min,
        children: [
          IconButton(onPressed: (){_messagesState.acceptStudent(message:m, confirm:true, user: _userstate.user);  setState((){});},color: Colors.green, icon: Icon(Icons.check_circle_outline),iconSize: Configuration.smicon),
          IconButton(onPressed: (){_messagesState.acceptStudent(message:m,confirm:false,user: _userstate.user); setState((){});},color: Colors.red, icon: Icon(Icons.highlight_off),iconSize: Configuration.smicon)        
        ],
      ): IconButton(
        onPressed: (){
          _messagesState.deleteMessage(message:m,user:_userstate.user);
          setState((){});
        }, 
        icon: Icon(Icons.delete),
        color: Colors.red, 
        iconSize: Configuration.smicon
        ), 
    );
  }

  List<Widget> getMessages(){
    List<Widget> list = [];

    list.add(
      Row(
        children: [
          Container(
            margin: EdgeInsets.only(bottom: Configuration.verticalspacing/2),
            width: Configuration.width,
            color: Configuration.lightgrey,
            padding: EdgeInsets.all(Configuration.smpadding),
            child: Text('You can view and reply to your messages here',
              textAlign: TextAlign.center,
            style: Configuration.text('small',Colors.grey)),
          )
        ],
      )
    );

    for(Chat c in _messagesState.userChats){
      Message lastMessage = c.lastMessage;

      if(lastMessage != null){
          List<dynamic> unreadMessages =  c.me['unreadMessages']!= null && c.me['unreadMessages'].length ? 
          c.me['unreadMessages']:[];
        // HAY QUE LLEVAR LA CUENTA DE LOS MENSAJES SIN LEER ??????

        list.add(SizedBox(height: Configuration.verticalspacing/2));
        list.add(
          ListTile(
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              mainAxisSize: MainAxisSize.min,
              children: [
                c.me['unreadMessages']!= null && c.me['unreadMessages'].length ? 
                Text(c.me['unreadMessages'].length.toString(),style: Configuration.text('small',Colors.red))
                : SizedBox(height: Configuration.verticalspacing),

                DateTime.now().day == lastMessage.date.day && DateTime.now().month == lastMessage.date.month ?
                Text(getHour(lastMessage.date),style: Configuration.text('small',Colors.grey)):
                Text(lastMessage.date.day.toString() + ' ' + getMonth(lastMessage.date).substring(0,3),style: Configuration.text('small',Colors.grey)),
              
              ],
            ),
            leading: ProfileCircle(userImage:  c.notMe['userimage']),
            onTap: (){
              _messagesState.selectChat(null, _userstate.user, c);
              Navigator.push(context, 
                MaterialPageRoute(builder: (context)=>
                  ChatScreen()
                )
              ).then((value) => setState((){}));
            },
            title: Text(c.notMe['username'], style: Configuration.text('smallmedium',  unreadMessages.length > 0 ? Colors.black : Colors.black.withOpacity(0.5))),
            subtitle: Text(
              lastMessage.text
              ,style: Configuration.text('small',unreadMessages.length > 0 ? Colors.black : Colors.grey, font: 'Helvetica')),
          )
        );

        list.add(SizedBox(height: Configuration.verticalspacing/2));
  
      }
    }

    return list;
  }

  @override
  void didChangeDependencies(){
    super.didChangeDependencies();
    _userstate = Provider.of<UserState>(context);
    _messagesState = Provider.of<MessagesState>(context);
    _messagesState.getMessages(user: _userstate.user);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.pushNamed(context, '/messageusers');
        },
        child: Icon(Icons.add),
      ),
      appBar: AppBar(
        elevation:0,
        centerTitle:true,
        backgroundColor: Configuration.maincolor,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children:[
            Icon(Icons.mail, color: Colors.white,size: Configuration.smicon),
            SizedBox(width: Configuration.verticalspacing),
            Text('Messages',style:Configuration.text('medium',Colors.white))
          ]),
        leading: BackButton(color: Colors.white),
        actions:[
         
         /* IconButton(
            onPressed: (){
              showDialog(
                context: context,
                builder:(context){
                  return AbstractDialog(
                    content: Container(
                      padding: EdgeInsets.all(Configuration.smpadding),
                      width: Configuration.width*0.3,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.info, size: Configuration.smicon, color: Colors.lightBlue),
                          SizedBox(height: Configuration.verticalspacing),
                          Text('This is not a live chat, it behaves like email messages.\n \n Every time you enter a conversation, you download its messages.',
                            style: Configuration.text('small',Colors.black, font: 'Helvetica'),
                            textAlign: TextAlign.center,
                          )
                        ],
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(Configuration.borderRadius/2)
                      ),
                    ),

                  );
                }
              );
            },
            
            icon: Icon(Icons.info, color:Colors.white, size: Configuration.smicon))
            */
        ]
      ),
      body: Column(
        children: <Widget>[
          Expanded (child: 
            Observer(
              builder: (context) {
                if(_messagesState.isLoading){ 
                  return Center(
                    child: CircularProgress(color: Configuration.maincolor),
                  );
                }else {
                  if(_messagesState.userChats.length == 0){
                    return Center(
                      child: Text('No messages', style: Configuration.text('medium', Colors.grey)),
                    );
                  }else {
                    return ListView(
                      physics: ClampingScrollPhysics(),
                      children: getMessages()
                    );
                  }
                }
              }
            )
          )
        ],
      ),
    );
  }
}


class MessagesIcon extends StatefulWidget {
  Color color;
  MessagesIcon({this.color}) : super();

  @override
  State<MessagesIcon> createState() => _MessagesIconState();
}

class _MessagesIconState extends State<MessagesIcon> {

  UserState _userstate;
  MessagesState _messagesstate;

  @override
  Widget build(BuildContext context) {
    _userstate = Provider.of<UserState>(context);

    return Stack(
       alignment:Alignment.center,
        children:[
          IconButton(
            onPressed:(){
              Navigator.pushNamed(context, '/messages');
            }, 
            icon: Icon(Icons.mail),
            color: widget.color != null ? widget.color : Colors.black,
            iconSize: Configuration.smicon
          ),
          _userstate.user.unreadmessages.length > 0 ?
          Positioned(
            top:0,
            right:0,
            child: Container(
              padding: EdgeInsets.all(Configuration.tinpadding - 2),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.lightBlue
              ),
              child: Text(_userstate.user.unreadmessages.length.toString(), style: Configuration.text('tiny',Colors.white)),
            ) 
          ):  Container()
        ]
      );
  }
}


class NewMessageScreen extends StatefulWidget {
  const NewMessageScreen() : super();

  @override
  State<NewMessageScreen> createState() => _NewMessageScreenState();
}

class _NewMessageScreenState extends State<NewMessageScreen> {

  // you only can send messages to users that you have added to your contacts
  @override
  Widget build(BuildContext context) {
    final _userstate = Provider.of<UserState>(context);
    final _messagestate =   Provider.of<MessagesState>(context);
  
    return Scaffold(
      appBar: AppBar(
        elevation:0,
        backgroundColor: Configuration.maincolor,
        title: Text('Send Message to', style: Configuration.text('medium', Colors.white),),
      ),
      body: _userstate.user.following.length > 0 ?
          ListView.separated(
            itemCount: _userstate.user.following.length,
            padding: EdgeInsets.symmetric(vertical: Configuration.verticalspacing),
            itemBuilder: (context, index){
              return ListTile(
                onTap: (){
                  _messagestate.selectChat(_userstate.user.following[index], _userstate.user);
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/chat');
                },
                leading: ProfileCircle(userImage: _userstate.user.following[index].image,),
                title: Text(_userstate.user.following[index].nombre, style: Configuration.text('smallmedium', Colors.black)),
              );
            },
            separatorBuilder: (context, index){
              return SizedBox(height: Configuration.verticalspacing);
            },
          ): 
          Center(
            child: Text('You need to follow users to send them messages to', style: Configuration.text('medium', Colors.black)
          )
      )
    );
  }
}



class ChatScreen extends StatefulWidget {

  ChatScreen() : super();

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  
  String lastUser;

  MessagesState _messagesState;

  ScrollController controller = new ScrollController();

  @override
  void didChangeDependencies(){
    super.didChangeDependencies();
  }


  Widget message(Message m , bool isMe){
    print(m.toJson());
    return Container(
      margin: EdgeInsets.only(bottom: Configuration.verticalspacing, top: Configuration.verticalspacing),
      padding: EdgeInsets.all(Configuration.smpadding),
      child: Column(
        crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(m.text != null ? m.text : 'Sent a class request', style: Configuration.text('smallmedium', isMe ? Colors.white : Colors.black, font: 'Helvetica')),
          SizedBox(height: Configuration.verticalspacing),
          Text(m.date.toString().substring(0,16), style: Configuration.text('small', isMe ? Colors.white.withOpacity(0.7) : Colors.black.withOpacity(0.6))),
        ],
      ),
      decoration: BoxDecoration(
        color: isMe ? Colors.lightBlue : Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: isMe ? Radius.circular(Configuration.smpadding) : Radius.circular(0),
          topRight: isMe ? Radius.circular(0) : Radius.circular(Configuration.smpadding),
          bottomLeft: isMe ? Radius.circular(0) : Radius.circular(Configuration.smpadding),
          bottomRight: isMe ? Radius.circular(Configuration.smpadding) : Radius.circular(0),
        )
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    _messagesState = Provider.of<MessagesState>(context);
    var _userstate = Provider.of<UserState>(context);

    return Scaffold(      
      backgroundColor: Configuration.lightgrey,
      appBar: AppBar(
        elevation:1,
        centerTitle: true,
        backgroundColor: Colors.white,
        leading: CloseButton(
          color: Colors.black,
        ),
        title: GestureDetector(
          onTap: (){
            showUserProfile(
              user:_messagesState.selecteduser, 
              usercod: _messagesState.selectedChat.notMe['coduser'], 
              hideChat: true
            );
          },
          child: Observer(
            builder: (context) { 
              if(_messagesState.isLoading || _messagesState.selectedChat == null){
                return Container();
              }else {
              return Row(
                mainAxisSize: MainAxisSize.min,
                children:[
                  ProfileCircle(
                    width: 35,
                    bordercolor: Configuration.maincolor,
                    userImage: _messagesState.selectedChat.notMe['userimage'],
                  ),
                  SizedBox(width: Configuration.verticalspacing),
                  Text(_messagesState.selectedChat.notMe['username'],style: Configuration.text('medium', Colors.black)),
                  ]);
              }
            }
          ),
        ),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Column(
          children: [
            Expanded(
              child: Observer(
                builder: (context) {
                  if(_messagesState.isLoading){
                    return Container();
                  }else {
                    return Container(
                      padding: EdgeInsets.symmetric(horizontal:Configuration.smpadding),
                      child: _messagesState.realTimeMessages.length > 0 ? 
                        ClipRRect(
                          child: ListView.builder(
                            reverse: true,
                            padding: EdgeInsets.only(top:Configuration.verticalspacing, bottom: Configuration.verticalspacing),
                            controller: controller,
                            physics: ClampingScrollPhysics(),
                            itemBuilder: (context,i){
                              return message(_messagesState.realTimeMessages[i], _messagesState.realTimeMessages[i].sender == _userstate.user.coduser );
                            }, 
                            itemCount: _messagesState.realTimeMessages.length
                          ),
                        ) : 
                      Center(
                        child: Text('No messages', style: Configuration.text('medium', Colors.grey)),
                      ),
                    );
                  }
                }
              )
            ),
            BottomInput(
              placeholder:'Send a message',
              noPop:true,
              onSend: (text) async {
                _messagesState.sendMessage(from: _userstate.user,text:text, type:'text');
                if(controller.positions.length > 0 ){
                  controller.jumpTo(controller.position.minScrollExtent);
                }
                setState(() {});
                // CÓDIGO REPETIDO !!!!!! MALO 
              // _messagesState.selectedMessages.add(m);
              },
            )
          ],
        ),
      ),
      resizeToAvoidBottomInset: true,
    );
  }
}

class PepeInformatic extends StatefulWidget {
  const PepeInformatic() : super();

  @override
  State<PepeInformatic> createState() => _PepeInformaticState();
}

class _PepeInformaticState extends State<PepeInformatic> {

  bool enamorado = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text('PP TE QUIERO'),
          Text('Mi corazón cuando te ve'),
          enamorado ? 
          Text('AMOOOOOOOOR'): Container(),
          ElevatedButton(
            onPressed: (){
              setState(() {
                enamorado = true;
              });
          }, child: Text('Mi corazon')
          ),
          CircularProgressIndicator(
           color: Colors.blue,
          ),
        ],
      )
    );
  }
}



// ESTO SOBRA !!
void sendMessage({MessagesState state, User to, User from, then, context}){
    TextEditingController controller = new TextEditingController();

    showDialog(
    context: context != null ? context : navigatorKey.currentContext, 
    builder: (context){
      return AbstractDialog(
        content: Container(
          padding: EdgeInsets.all(Configuration.smpadding),
          width:Configuration.width,
          height: Configuration.height*0.5,
          decoration: BoxDecoration(
            color:Colors.white,
            borderRadius: BorderRadius.circular(Configuration.borderRadius)
          ),
          child: Column(
            children: [
              Text('Send a message to ' + (to !=null ? to.nombre : 'everyone'),style:Configuration.text('small',Colors.black)),
              SizedBox(height: Configuration.verticalspacing),
              Expanded(
                child: TextField(
                  controller:controller,
                  maxLines:null,
                  decoration: InputDecoration(
                    hintText: 'Write your message here',
                    fillColor: Configuration.lightgrey,
                    filled:true,
                    border: OutlineInputBorder()
                  ),
                  expands: true,
                ),
              ),
              SizedBox(height: Configuration.verticalspacing),
              BaseButton(
                text:'Send Message',
                color: Colors.lightBlue,
                onPressed: (){
                  if(controller.text.isNotEmpty){
                    state.sendMessage(
                      type:'text', 
                      text:controller.text,
                      from: from
                    );
                    showDialog(
                      context: context,
                       builder: (context){
                         return AlertDialog(
                           content: Column(
                             mainAxisSize: MainAxisSize.min,
                             mainAxisAlignment: MainAxisAlignment.center,
                             children: [
                              Icon(Icons.check_circle_outline, color: Colors.green, size: Configuration.medicon),
                              SizedBox(height: Configuration.verticalspacing),
                              Text('Message sent', style:Configuration.text('small',Colors.black)),
                              SizedBox(height: Configuration.verticalspacing)
                             ],
                           ),
                         );
                       });
                    };
                    Navigator.pop(context);
                    Navigator.pop(context);

                },
              ),
              SizedBox(height:Configuration.verticalspacing),
              BaseButton(
                text:'Cancel',
                color: Colors.red,
                onPressed: (){
                  Navigator.pop(context);
                },
              )
            ],
          ),
        ),
      );
  }).then((value) {if(then !=null){then();}});
}