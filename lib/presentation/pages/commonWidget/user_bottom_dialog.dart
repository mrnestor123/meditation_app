
//DIALOGO  QUE muestra la información del usuario en el bottom

import 'package:flutter/material.dart';
import 'package:meditation_app/domain/entities/user_entity.dart';
import 'package:meditation_app/presentation/mobx/actions/user_state.dart';
import 'package:meditation_app/presentation/pages/commonWidget/profile_widget.dart';
import 'package:meditation_app/presentation/pages/config/configuration.dart';
import 'package:meditation_app/presentation/pages/main.dart';
import 'package:meditation_app/presentation/pages/messages_screen.dart';
import 'package:meditation_app/presentation/pages/profile_widget.dart';
import 'package:provider/provider.dart';

import '../../mobx/actions/messages_state.dart';

 Future showUserProfile({User user,String usercod, followbutton, followaction,  hideChat}) {

  var stateSetter;

  UserState userstate = Provider.of<UserState>(navigatorKey.currentContext, listen: false);
  MessagesState _messagestate = Provider.of<MessagesState>(navigatorKey.currentContext, listen: false);


  if(user == null){
    userstate.getUser(cod:usercod).then((value) => stateSetter(()=>{user = value}));
  }


  Widget outlineButton({IconData icon, onPressed, color}){
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        side: BorderSide(color: color),
        shape: CircleBorder()
      ),
      onPressed: onPressed,
      child: Padding(
        padding: EdgeInsets.all(Configuration.smpadding),
        child: Icon(icon , size: Configuration.smicon, color: color),
      )
    );
  }

  // se podría sacar el usuario sino ??? Con el usercod
  return showModalBottomSheet<void>(
      context: navigatorKey.currentContext,
      builder: (BuildContext context) {
        bool following = user != null ? userstate.user.following.where((element) => element.coduser == user.coduser).isNotEmpty : false;
        return StatefulBuilder(
            builder:(BuildContext context, StateSetter setState ) {
            stateSetter = setState;
            return  Container(
            color: Configuration.maincolor,
            child:  Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: 
              [
                SizedBox(height: Configuration.verticalspacing),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Flexible(
                      flex: 2,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ProfileCircle(
                            width: Configuration.width*0.2,
                            userImage: user != null ? user.image : null,
                            bordercolor: Colors.white,
                            color: Colors.white,
                          ),
                          SizedBox(height: Configuration.verticalspacing),
                          Text(user == null ? '' : user.nombre != null ? user.nombre : 'Anónimo', style: Configuration.text('small', Colors.white))
                        ],
                      ),
                    ),
                    Flexible(
                      flex: 4,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Table(
                            children: [
                              TableRow(
                                children: [
                                  ProfileInfoBigCard(
                                    firstText: user != null ?  user.userStats.total.meditations.toString() :'',
                                    secondText: "Meditations\ncompleted",
                                    icon: Icon(Icons.self_improvement, color: Colors.white),
                                    color: 'white',
                                  ),
                                  ProfileInfoBigCard(
                                      firstText: user != null ? user.userStats.total.lessons.toString() : '',
                                      secondText: "Lessons\ncompleted",
                                      icon: Icon(Icons.book, color: Colors.white),
                                      color: 'white',
                                  ),
                                ]
                              ),
                              TableRow(
                                children: [
                                    ProfileInfoBigCard(
                                    firstText:user != null ?  user.timemeditated : '',
                                    secondText: "Time meditated",
                                    color: 'white',
                                    icon: Icon(Icons.timer,  color: Colors.white),
                                  ),
                                  ProfileInfoBigCard(
                                    firstText:user != null ? (user.userStats.total.maxstreak.toString() + (user.userStats.total.maxstreak == 1 ? ' day' : ' days')) : '',
                                    secondText: "Max \nstreak",
                                    color: 'white',
                                    icon: Icon(Icons.calendar_today, color: Colors.white,),
                                  )
                                ]
                              )
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
                SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    followbutton != null ?
                    Row(
                      children: [
                        outlineButton(
                          icon:!following ? Icons.person_add :Icons.person_off,
                          onPressed:()async {
                            await userstate.follow(user, !following);
                            if(followaction != null){
                              followaction();
                            }
                            setState(() {
                              following = !following;
                            });
                          },
                          color: following ? Colors.red : Colors.green
                        ),
                        SizedBox(width: Configuration.verticalspacing)
                      ],
                    ) : Container(),

                    outlineButton(
                      color: Colors.white,
                      icon: Icons.person,
                      onPressed: (){
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProfileScreen(
                              user: user,
                            )
                          ),
                        );
                      }
                    ),
                    SizedBox(width: Configuration.verticalspacing),

                    hideChat != true ?
                    outlineButton(
                      color: Colors.white,
                      icon: Icons.message,
                      onPressed: (){
                        _messagestate.selectChat(user, userstate.user);
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChatScreen()
                          ),
                        );
                      }
                    ) : Container(),

                  ],
                ),
                SizedBox(height: Configuration.verticalspacing*2),
              ],
            )
          );
          }
        );
      },
    );
  }