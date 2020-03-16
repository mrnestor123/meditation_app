import 'package:flutter/material.dart';
import 'package:meditation_app/interface/commonWidget/bottomMenu.dart';

class ProfileWidget extends StatefulWidget {
  final int selectedIndex;

  const ProfileWidget({Key key, this.selectedIndex}) : super(key: key);
  @override
  _ProfileWidgetState createState() => _ProfileWidgetState();
}

class _ProfileWidgetState extends State<ProfileWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () {},
          )
        ],
      ),
      body: ListView(
        children: <Widget>[
          Column(mainAxisAlignment: MainAxisAlignment.center, children: <
              Widget>[
            Hero(
              tag: 'assets/sky.jpg',
              child: Container(
                  height: 125.0,
                  width: 125.0,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(62.5),
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image: AssetImage('images/sky.jpg')))),
            ),
            SizedBox(
              height: 25.0,
            ),
            Text(
              'Jose García',
              style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 4.0,
            ),
            Text(
              'Valencia',
              style: TextStyle(fontFamily: 'Montserrat', color: Colors.grey),
            ),
            Padding(
                padding: EdgeInsets.all(30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    CountWidget(text: 'Lessons', selection: 0),
                    CountWidget(
                      text: 'Meditations',
                      selection: 1,
                    )
                  ],
                )),
            Padding(
              padding: EdgeInsets.only(left: 15.0),
              child: Row(
                children: <Widget>[
                  IconButton(icon: Icon(Icons.table_chart), onPressed: () {}),
                  IconButton(
                    icon: Icon(Icons.menu),
                    onPressed: () {},
                  )
                ],
              ),
            ),
            buildImages(),
            buildinfoDetail(),
            buildImages(),
            buildinfoDetail()
          ])
        ],
      ),
      bottomNavigationBar: BottomNavyBar(widget.selectedIndex),
    );
  }

  Widget buildImages() {
    return Padding(
      padding: EdgeInsets.only(top: 25.0, left: 15.0, right: 15.0),
      child: Container(
          height: 200.0,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.0),
              image: DecorationImage(
                  image: AssetImage('images/sky.jpg'), fit: BoxFit.cover))),
    );
  }

  Widget buildinfoDetail() {
    return Padding(
        padding:
            EdgeInsets.only(left: 25.0, right: 25.0, top: 15.0, bottom: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              'Peripheral awareness vs attention',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Montserrat',
                  fontSize: 15.0),
            ),
          ],
        ));
  }
}

class CountWidget extends StatelessWidget {
  //0 for lessons, 1 for meditations
  final int selection;
  final String text;

  const CountWidget({
    this.text,
    this.selection,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text('5',
            style: TextStyle(
                fontFamily: 'Montserrat', fontWeight: FontWeight.bold)),
        SizedBox(
          height: 5.0,
        ),
        Text(
          text,
          style: TextStyle(fontFamily: 'Montserrat', color: Colors.grey),
        )
      ],
    );
  }
}
