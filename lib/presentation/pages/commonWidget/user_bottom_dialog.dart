
//DIALOGO  QUE muestra la información del usuario en el bottom

import 'package:flutter/material.dart';
import 'package:meditation_app/domain/entities/user_entity.dart';
import 'package:meditation_app/presentation/mobx/actions/user_state.dart';
import 'package:meditation_app/presentation/pages/commonWidget/profile_widget.dart';
import 'package:meditation_app/presentation/pages/config/configuration.dart';
import 'package:meditation_app/presentation/pages/main.dart';
import 'package:meditation_app/presentation/pages/profile_screen.dart';
import 'package:provider/provider.dart';


Future showUserProfile({ 
  User user, String usercod, followbutton, 
  followaction,  hideChat, isTeacher = false
}) {

  var stateSetter;
  bool closed = false;
  UserState userstate = Provider.of<UserState>(navigatorKey.currentContext, listen: false);

  if(user == null){
    userstate.getUser(cod:usercod).then((value) => !closed ? stateSetter(()=>{user = value}) : null);
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
        child: Icon(icon, size: Configuration.smicon, color: color),
      )
    );
  }

  // se podría sacar el usuario sino ??? Con el usercod
  return showModalBottomSheet<void>(
      context: navigatorKey.currentContext,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Wrap(
          children: [
            StatefulBuilder(
              builder:(BuildContext context, StateSetter setState ) {
                stateSetter = setState;
                return Container(
                  color: Configuration.maincolor,
                  constraints: BoxConstraints(
                    minHeight: Configuration.height*0.25
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
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
                                Text(
                                  user == null ? '' : user.nombre != null ? user.nombre : 'Anónimo', 
                                  style: Configuration.text('subtitle', Colors.white),
                                  textAlign: TextAlign.center
                                )
                              ],
                            ),
                          ),
                          Flexible(
                            flex: 4,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                isTeacher ? 
                                user== null ? Row(): 
                                Text(user.teacherInfo.description, style: Configuration.text('small',Colors.white))
                                :
                                
                                IntrinsicHeight(
                                  child: Table(
                                    
                                    children: [
                                      TableRow(
                                        children: [
                                          ProfileInfoBigCard(
                                            firstText: user != null ?  user.userStats.doneMeditations.toString() :'',
                                            secondText: "Meditations\ndone",
                                            icon: Icon(Icons.self_improvement, color: Colors.white),
                                            color: 'white',
                                          ),
                                          ProfileInfoBigCard(
                                              firstText: user != null ? user.userStats.readLessons.toString() : '',
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
                                            secondText: "Time\nmeditated",
                                            color: 'white',
                                            icon: Icon(Icons.timer,  color: Colors.white),
                                          ),
                                          ProfileInfoBigCard(
                                            firstText:user != null 
                                            ? (user.userStats.maxStreak.toString() + (user.userStats.maxStreak == 1 ? ' day' : ' days')) 
                                            : '',
                                            secondText: "Max \nstreak",
                                            color: 'white',
                                            icon: Icon(Icons.calendar_today, color: Colors.white,),
                                          )
                                        ]
                                      )
                                    ],
                                  ),
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
                          /*
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
                          ) : Container(),*/
                          
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
                          /*
                          SizedBox(width: Configuration.verticalspacing),

                          user != null &&  (true ) ?
                          outlineButton(
                            color: Colors.white,
                            icon: Icons.message,
                            onPressed: (){
                              showDialog(
                                context: context, 
                                builder: (context) => ChatDialog(user: user)
                              );
                            }
                          ) : Container(),*/
                        ],
                      ),
                      SizedBox(height: Configuration.verticalspacing*2),
                    ],
                  )
                );
              }
            ),
          ],
        );
      },
    ).whenComplete(() => closed = true);
  }