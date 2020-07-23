import 'package:flutter/material.dart';
import 'package:meditation_app/interface/commonWidget/bottomMenu.dart';

class FeedWidget extends StatelessWidget {
  final int selectedIndex;

  FeedWidget(this.selectedIndex);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: CustomScrollView(slivers: <Widget>[
        slider,
        SliverList(
          delegate: SliverChildListDelegate(<Widget>[
            PeopleMeditatingWidget(),
            Container(
              padding:
                  EdgeInsets.only(top: 16, bottom: 16, left: 32, right: 32),
              child: Column(
                children: <Widget>[
                  TitleWidget(key: UniqueKey(), title: 'Stages'),
                  Row(
                    children: <Widget>[
                      Expanded(child: Text('You are currently on stage 1')),
                      Container(
                          padding: EdgeInsets.all(4),
                          child: Text(
                            'View more',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ))
                    ],
                  )
                ],
              ),
            ),
            Container(
                padding:
                    EdgeInsets.only(top: 16, bottom: 16, left: 32, right: 32),
                child: Column(
                  children: <Widget>[
                    TitleWidget(
                      key: UniqueKey(),
                      title: 'Lessons',
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                              'List of lessons that scrolls left to right'),
                        )
                      ],
                    )
                  ],
                )),
            Container(
              padding:
                  EdgeInsets.only(top: 16, bottom: 16, left: 32, right: 32),
              child: Column(
                children: <Widget>[
                  TitleWidget(key: UniqueKey(), title: 'Meditation'),
                  Row(
                    children: <Widget>[
                      Expanded(
                          child:
                              Text('You are currently on a five day streak! ')),
                      Container(
                          padding: EdgeInsets.all(4),
                          child: Text(
                            'Keep going',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ))
                    ],
                  )
                ],
              ),
            ),
          ]),
        )
      ]),
      bottomNavigationBar: BottomNavyBar(selectedIndex),
    );
  }

  // at the moment it has only one image but it will scale
  final Widget slider = SliverAppBar(
    expandedHeight: 200.0,
    floating: false,
    pinned: false,
    flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: Text("Today is a great day to start",
            style: TextStyle(color: Colors.white, fontSize: 16.0)),
        background: Image.asset('images/sky.jpg', fit: BoxFit.cover)),
  );
}

class PeopleMeditatingWidget extends StatelessWidget {
  const PeopleMeditatingWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 32, bottom: 16, left: 32, right: 32),
      child: Row(children: <Widget>[
        Expanded(
          child: Text('People meditating right now'),
        ),
        Container(
          padding: EdgeInsets.all(4),
          decoration: BoxDecoration(color: Colors.lightBlue),
          child: Text('240',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold)),
        )
      ]),
    );
  }
}

class TitleWidget extends StatelessWidget {
  final String title;
  const TitleWidget({
    this.title,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(bottom: 16),
          child: Center(
              child: Text(this.title,
                  style: TextStyle(
                      fontFamily: 'Ubuntu',
                      fontWeight: FontWeight.bold,
                      fontSize: 23.0,
                      color: Colors.blueGrey))),
        )
      ],
    );
  }
}

class DataWidget extends StatelessWidget {
  //Here I will place the User's bloc

  @override
  Widget build(BuildContext context) {
    return new Container();
  }
}
