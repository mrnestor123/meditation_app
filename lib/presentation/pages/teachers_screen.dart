import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:meditation_app/domain/entities/user_entity.dart';
import 'package:meditation_app/presentation/mobx/actions/user_state.dart';
import 'package:meditation_app/presentation/pages/commonWidget/circular_progress.dart';
import 'package:meditation_app/presentation/pages/commonWidget/profile_widget.dart';
import 'package:meditation_app/presentation/pages/profile_screen.dart';
import 'package:provider/provider.dart';

import 'commonWidget/back_button.dart';
import 'commonWidget/dialogs.dart';
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
      backgroundColor: Configuration.lightgrey,
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle(
          // Status bar color
          statusBarColor: Configuration.maincolor, 
          // Status bar brightness (optional)
          statusBarIconBrightness: Brightness.light, // For Android (dark icons)
          statusBarBrightness: Brightness.dark, // For iOS (dark icons)
        ),
        leading: ButtonBack(color:Colors.white),
        backgroundColor: Configuration.maincolor,
        elevation:0,
       /* actions: [
          IconButton(
            iconSize: Configuration.smicon,
            onPressed: (){
              // REPASAR ESTO !!!!
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
                        _userstate.data.settings.teachersText !=null ?
                        _userstate.data.settings.teachersText :
                        "Tmi Teachers have participated in the training's course done by Culadasa",
                        style: Configuration.text('small', Colors.black,font: 'Helvetica'),
                      ),
                    )
                  ),
                );
              });
            }, 

            color: Colors.white,
            icon: Icon(Icons.info)
          )
        ],*/
      ),
      body: ListView(
        physics: ClampingScrollPhysics(),
        children: [
          Container(
            width: Configuration.width,
            padding:EdgeInsets.all(Configuration.medpadding),
            color:Configuration.maincolor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('TMI TEACHERS', style:Configuration.text('subtitle',Colors.white)),
                SizedBox(height: Configuration.verticalspacing/2),
                Text('In order to reach advanced stages or clearing your doubts. Asking for help is the best option', style:Configuration.text('small',Colors.white))
              ],
            )
          ),
          Container(
            width: Configuration.width,
            color:Configuration.lightgrey,
            child: Observer(
                builder: (context) {
                  if(_userstate.loading){
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          margin: EdgeInsets.only(
                            top: Configuration.verticalspacing*4
                          ),
                          child: CircularProgress()),
                      ],
                    );
                  }else{
                    return ListView.separated(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
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
                          subtitle: user.teacherInfo.description != null && user.teacherInfo.description.isNotEmpty ? Container(
                            padding: EdgeInsets.only(top:Configuration.verticalspacing/2),
                            child: Text(user.teacherInfo.description, 
                            maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style:Configuration.text('tiny',Colors.grey)
                            ),
                          ): Container(),
                          leading: ProfileCircle(
                            width: Configuration.verticalspacing*3,
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
                }
              ),
          ),

          SizedBox(height: Configuration.verticalspacing*2)
        ],
      ),
    );
  }
}