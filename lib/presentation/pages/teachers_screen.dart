import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:meditation_app/domain/entities/user_entity.dart';
import 'package:meditation_app/presentation/mobx/actions/user_state.dart';
import 'package:meditation_app/presentation/pages/commonWidget/circular_progress.dart';
import 'package:meditation_app/presentation/pages/commonWidget/dialog.dart';
import 'package:meditation_app/presentation/pages/commonWidget/profile_widget.dart';
import 'package:meditation_app/presentation/pages/leaderboard.dart';
import 'package:meditation_app/presentation/pages/profile_widget.dart';
import 'package:meditation_app/presentation/pages/requests_screen.dart';
import 'package:provider/provider.dart';

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
    //_userstate.getTeachers();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        leading: ButtonBack(color:Colors.white),
        backgroundColor: Configuration.maincolor,
        elevation:0,
        actions: [
          IconButton(
            iconSize: Configuration.smicon,
            onPressed: (){
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
                        'Here can be added more information about TMI TEACHERS',
                        style: Configuration.text('small', Colors.black,font: 'Helvetica'),
                      ),
                    )
                  ),
                );
              });
            }, 
            icon: Icon(Icons.info)
          )
        ],
      ),
      body: Column(
        children: [
          Container(
            width: Configuration.width,
            padding:EdgeInsets.all(Configuration.medpadding),
            color:Configuration.maincolor,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('TMI TEACHERS', style:Configuration.text('big',Colors.white)),
                SizedBox(height: Configuration.verticalspacing/2),
                Text('In order to reach the latter stages. Asking for help is the best option', style:Configuration.text('small',Colors.white))
              ],
            )
          ),
          Expanded(
            child: Container(
              width: Configuration.width,
              color:Configuration.lightgrey,
              child: Observer(
                builder: (context) {
                  if(_userstate.loading){
                    return Center(child: CircularProgress());
                  }else{
                  return ListView.separated(
                    physics: ClampingScrollPhysics(),
                    itemBuilder: (context,int){
                      User user = _userstate.teachers[int];
                      return TextButton(
                        onPressed:(){
                          Navigator.push(context, MaterialPageRoute(builder: (context){
                            return ProfileScreen(user:user);
                          }));
                        },
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.all(0)
                        ),
                        child: ListTile(
                          subtitle: Text('subtitle', 
                            style:Configuration.text('tiny',Colors.grey)
                          ),
                          leading: ProfileCircle(
                            width:30,
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
          )
        ],
      ),
    );
  }
}



class TeachersManagement extends StatefulWidget {
  const TeachersManagement() : super();

  @override
  _TeachersManagementState createState() => _TeachersManagementState();
}

class _TeachersManagementState extends State<TeachersManagement> {
  UserState _userstate;
  TabController _tabController;


  Widget students(){
    if(_userstate.user.students.length >0){
      return Container();
    }else{
      return Center(
        child: Text("You don't have any students at the moment",
          style:Configuration.text('small',Colors.black)
        )
      );
    }
  } 

  Widget content(){
    if(_userstate.user.students.length >0){
      return Container();
    }else{
      return Center(
        child: Text("You have not added any content",
          style:Configuration.text('small',Colors.black)
        )
      );
    }
  }



  @override
  Widget build(BuildContext context) {
    _userstate = Provider.of<UserState>(context);
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          SizedBox(height: Configuration.verticalspacing),
          Text('Teachers management', style:Configuration.text('medium',Colors.black)),
          SizedBox(height:Configuration.verticalspacing),
          Text('Here you can see how many students you have, send a message to them, manage the content and so on.', 
            style:Configuration.text('small',Colors.black)
          ),
          SizedBox(height: Configuration.verticalspacing),
          Container(
            color: Colors.grey,
            width: Configuration.width,
            child: TabBar(
              controller: _tabController,
              indicatorWeight: Configuration.width > 500 ? 5 : 2.5 ,
              indicatorColor: Colors.white,
              tabs: [
                Tab(child: Text('Students',style: Configuration.text('small', Colors.black))),
                Tab(child: Text('Content', style:Configuration.text('small', Colors.black))),
              ]
            ),
          ),
          Expanded(child:
          Container(
            padding:EdgeInsets.all(Configuration.tinpadding),
            color: Colors.white,
            child: TabBarView(
              controller: _tabController,
              children: [
                students(),content()
              ]),
            )
          ),
          SizedBox(height:Configuration.verticalspacing)
          
        ],
      ),
    );
  }
}