
//DIALOGO  QUE muestra la información del usuario en el bottom

import 'package:flutter/material.dart';
import 'package:meditation_app/domain/entities/user_entity.dart';
import 'package:meditation_app/presentation/pages/config/configuration.dart';
import 'package:meditation_app/presentation/pages/profile_widget.dart';

dynamic showUserProfile(User user,  context,[followbutton, followaction, following]) {
   return showModalBottomSheet<void>(
     
        context: context,
        builder: (BuildContext context) {
          //bool following = userstate.user.following.contains(user.coduser);

          return StatefulBuilder(
              builder:(BuildContext context, StateSetter setState ) {
              return  Container(
              color: Configuration.maincolor,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Flexible(
                        flex: 2,
                        child: Column(
                          children: [
                            Center(
                              child: Column(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(2.0),
                                    decoration: BoxDecoration(
                                      image: user.image != null ? DecorationImage(image: NetworkImage(user.image), fit: BoxFit.contain) : null,
                                      border: Border.all(color: Colors.white, width: 2.5),
                                      shape: BoxShape.circle
                                      ),
                                    height: Configuration.width* 0.25,
                                    width:  Configuration.width* 0.25,
                                  ),
                                  SizedBox(height: 4.0),
                                  Text(user.nombre != null ? user.nombre : 'Anónimo', style: Configuration.text('small', Colors.white)),
                                  SizedBox(height: 10.0),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Column(
                                        children: [
                                          Text('Following', style: Configuration.text('tiny', Colors.white)),
                                          Text(user.following.length.toString(), style: Configuration.text('tiny',Colors.white))   
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          Text('Followers', style: Configuration.text('tiny', Colors.white)),
                                          Text(user.followers.length.toString(), style: Configuration.text('tiny',Colors.white))
                                        ],
                                      )
                                  ]),
                                ],
                              ),
                            ),
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
                                      firstText: user.userStats.total.meditations.toString(),
                                      secondText: "Meditations\ncompleted",
                                      icon: Icon(Icons.self_improvement, color: Colors.white),
                                      color: 'white',
                                    ),
                                    ProfileInfoBigCard(
                                        firstText: user.userStats.total.lessons.toString(),
                                        secondText: "Lessons\ncompleted",
                                        icon: Icon(Icons.book, color: Colors.white),
                                        color: 'white',
                                    ),
                                  ]
                                ),
                                TableRow(
                                  children: [
                                      ProfileInfoBigCard(
                                      firstText:  user.timemeditated,
                                      secondText: "Time meditated",
                                      color: 'white',
                                      icon: Icon(Icons.timer,  color: Colors.white),
                                    ),
                                    ProfileInfoBigCard(
                                      firstText:  user.userStats.total.maxstreak.toString() + (user.userStats.total.maxstreak == 1 ? ' day' : ' days'),
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
                          OutlinedButton(
                            onPressed: () async{
                              following = !following;
                              await followaction();
                              setState((){ });
                            }, 
                            child: Text(!following ? 
                            'Follow' : 'Unfollow', style:  Configuration.text('tiny', following ? Colors.red : Colors.green)),
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color:  following? Colors.red : Colors.green) 
                            ),
                          ),
                          SizedBox(width: 15)
                        ],
                      ) : Container(),
                      OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: Colors.white)
                        ),
                        onPressed: (){
                          Navigator.push(context, 
                            MaterialPageRoute(
                            builder: (context) => ProfileScreen(user:user)
                            )
                          );
                        }, 
                        child: Text('View Profile', style: Configuration.text('small', Colors.white)))
                    ],
                  ),
                  SizedBox(height: 15),
                ],
              )
            );
            }
          );
        },
    );
  }