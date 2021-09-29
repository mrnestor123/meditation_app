
//DIALOGO  QUE muestra la información del usuario en el bottom

import 'package:flutter/material.dart';
import 'package:meditation_app/domain/entities/user_entity.dart';
import 'package:meditation_app/presentation/pages/config/configuration.dart';
import 'package:meditation_app/presentation/pages/profile_widget.dart';

dynamic showUserProfile(User user, userstate, context) {
   return showModalBottomSheet<void>(
        context: context,
        builder: (BuildContext context) {
          bool following = userstate.user.following.contains(user.coduser);

          return StatefulBuilder(
              builder:(BuildContext context, StateSetter setState ) {
              return  Container(
              height: Configuration.height * 0.4,
              color: Configuration.maincolor,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Column(
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
                                    SizedBox(height: 2.0),
                                    Text(user.timemeditated, style: Configuration.text('tiny', Colors.white, font: 'Helvetica'))
                                  ],
                                ),
                              ),
                            ],
                          ),
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
                          ])
                        ],
                      ),
                      Column(
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
                          )
                        ],
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      OutlinedButton(
                        onPressed: () async{
                          following = !following;
                          await userstate.follow(user, following);
                        }, 
                        child: Text(!following ? 
                        'Follow' : 'Unfollow', style:  Configuration.text('tiny', following ? Colors.red : Colors.lightBlue)),
                        style: OutlinedButton.styleFrom(
                        ),
                      )
                    ],
                  )
                ],
              )
            );
            }
          );
        },
    );
  }