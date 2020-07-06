import 'package:flutter/material.dart';
import 'package:meditation_app/presentation/pages/config/configuration.dart';

List<Map> sidebarItems = [
  {'icon': Icons.explore, 'text': 'Explore'},
  {'icon': Icons.view_headline, 'text': 'Stages'},
  {'icon': Icons.school,'text': 'Meditation'},
  {'icon': Icons.chat, 'text': 'Chat'}
];

class SideBar extends StatefulWidget {
  @override
  _SideBarState createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.only(top:40,bottom:60,left:20),
        color: Configuration.maincolor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(children: <Widget>[
              CircleAvatar(),
              SizedBox(width: 10),
              Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('Ernest Barrachina',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold)),
                    Text('Level 10', style: TextStyle(color: Colors.grey))
                  ])
            ]),
            Column(
              children: sidebarItems.map((element) => Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: <Widget>[
                    Icon(element['icon'],color:Colors.white,size: 30),
                    SizedBox(width:10),
                    Text(element['text'],style: TextStyle(color:Colors.white),)
                  ]),
              )
              ).toList()
            ),

            Row(
              children: <Widget>[
                Icon(Icons.settings, color: Colors.white),
                 SizedBox(width: 10),
                Text('Settings', style: TextStyle(color: Colors.white)),
                 SizedBox(width: 10),
                Container(width: 2, height: 20, color: Colors.white),
                SizedBox(width: 10),
                Text('Log out', style: TextStyle(color: Colors.white))
              ],
            )
          ],
        ));
  }
}
