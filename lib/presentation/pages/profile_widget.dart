import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meditation_app/domain/entities/user_entity.dart';
import 'package:meditation_app/presentation/mobx/actions/user_state.dart';
import 'package:meditation_app/presentation/pages/commonWidget/radial_progress.dart';
import 'package:meditation_app/presentation/pages/config/configuration.dart';
import 'package:meditation_app/presentation/pages/calendar.dart';
import 'package:provider/provider.dart';
import 'package:charts_flutter/flutter.dart';
import 'package:table_calendar/table_calendar.dart';


class ProfileScreen extends StatefulWidget {
  User user;

  ProfileScreen({this.user});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final _userstate = Provider.of<UserState>(context);
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back,
                size: Configuration.smicon),
            color: Colors.white,
            onPressed: () => Navigator.pop(context),
          ),
          actions: [
            widget.user != null ?
            Container() :
            IconButton(
              padding: EdgeInsets.all(0.0),
              onPressed: () => Navigator.pushNamed(context, '/settings'),
              icon: Icon(
                Icons.settings,
                color: Colors.white,
                size: Configuration.smicon,
              ),
            ),
          ],
      ),
      extendBodyBehindAppBar: true,
      body: Stack(children: <Widget>[
        Container(
            height: Configuration.height,
            width: Configuration.width,
            color: Configuration.maincolor),
        Column(
          children: <Widget>[
            //REFACTORIZAR ESTO
            Expanded(
                flex: 2,
                child: widget.user != null ?
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: Configuration.blockSizeVertical*1),
                    RadialProgress(
                        width: Configuration.safeBlockHorizontal * 1,
                        goalCompleted: _userstate.user.stage.stagenumber / 10,
                        child: CircleAvatar(
                            radius:  Configuration.blockSizeHorizontal * 12,
                            backgroundColor: Colors.transparent,
                            backgroundImage: widget.user.image == null
                                ? null
                                : NetworkImage(widget.user.image)
                        )
                      ),
                    SizedBox(
                      height: Configuration.safeBlockVertical * 2,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                            widget.user.nombre != null ? widget.user.nombre : 'Guest',style: Configuration.text('medium', Colors.white),
                        ),
                      ],
                    ),
                  ],
                )
                : 
                MyInfo()
              ),
            Expanded(
              flex: 4,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
                ),
                child: ListView(
                  padding: EdgeInsets.all(12.0),
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton(
                        onPressed: ()=>  
                        widget.user != null ? null :
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ViewFollowers(
                                    users: _userstate.user.following,
                                    title: 'Following',
                          )),
                      ), 
                      child: Column(
                          children: [
                            Text('Following', style: Configuration.text('tiny', Colors.black)),
                            Text(widget.user != null ? widget.user.followedcods.length.toString() : _userstate.user.following.length.toString(), style: Configuration.text('tiny',Colors.black))
                          ],
                        ),
                      ),
                      TextButton(
                        onPressed: ()=>  
                        widget.user != null ? null :
                          Navigator.push(
                            context,
                              MaterialPageRoute(
                                  builder: (context) => ViewFollowers(
                                        users: _userstate.user.followsyou,
                                        title: 'Followers',
                              )
                            ),
                          ),
                          child: Column(
                          children: [
                            Text('Followers', style: Configuration.text('tiny', Colors.black)),
                            Text(widget.user != null ? widget.user.followsyoucods.length.toString() :  _userstate.user.followsyou.length.toString(), style: Configuration.text('tiny',Colors.black))
                          ],
                        ),
                      ) 
                    ],
                    ),
                    SizedBox(height: Configuration.blockSizeVertical*3),
                    Table(children: [
                      TableRow(children: [
                        ProfileInfoBigCard(
                          firstText:  widget.user != null ? widget.user.userStats.total.meditations.toString() :_userstate.user.userStats.total.meditations.toString(),
                          secondText: "Meditations\ncompleted",
                          icon: Icon(Icons.self_improvement),
                        ),
                        ProfileInfoBigCard(
                            firstText: 
                             widget.user != null ? widget.user.userStats.total.lessons.toString() :
                            
                            _userstate
                                .user.userStats.total.lessons
                                .toString(),
                            secondText: "Lessons\ncompleted",
                            icon: Icon(Icons.book))
                      ]),
                    ]),
                    SizedBox(height: Configuration.blockSizeVertical * 3),
                    Text('Meditation record', style: Configuration.text('small', Colors.black)),
                    SizedBox(height: Configuration.blockSizeVertical*1),
                    CalendarWidget(meditations: widget.user != null ? widget.user.totalMeditations : _userstate.user.totalMeditations),
                  ],
                ),
              ),
            ),
          ],
        ),
      ]),
    );
  }
}


//ES IGUAL PARA TABLET QUE PARA Móvil ?? //DEBERÍA
class ViewFollowers extends StatelessWidget {
  final List<User> users;
  final String title;

  ViewFollowers({this.users, this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(onPressed: ()=> Navigator.pop(context),  icon: Icon(Icons.arrow_back), color: Colors.black),
        title: Text(title, style: Configuration.text('small', Colors.black)),
      ),
      body: Container(
        height: Configuration.height,
        width: Configuration.width,
        color: Configuration.lightgrey,
        child: SingleChildScrollView(
            child: Padding(
                padding: EdgeInsets.all(Configuration.smpadding),
                child: users.length > 0 ? Table(  
                columnWidths: {
                0: FractionColumnWidth(0.2),
                1: FractionColumnWidth(0.5),
                2: FractionColumnWidth(0.3)
               },
                children: users.map((u) {
                  return TableRow(
                  children: [
                    CircleAvatar(
                      backgroundColor: u.image != null ? Colors.transparent : Configuration.maincolor,
                      backgroundImage: u.image != null ? NetworkImage(u.image) : null,
                      child: u.image == null ? null : null,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(u.nombre == null ? 'Anónimo' : u.nombre,
                            style: Configuration.text('small', Colors.black)),
                        Text('Stage ' + u.stagenumber.toString(),
                            style: Configuration.text('tiny', Colors.grey))
                      ],
                    ),
                    OutlinedButton(
                        onPressed: () {
                           Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ProfileScreen(
                                        user: u,
                                  )
                                ),
                            );
                        },
                        style: OutlinedButton.styleFrom(
                          elevation: 0.0,
                          primary: Configuration.maincolor,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50.0))
                        ),
                        child: Text(
                          'Profile',
                          style: Configuration.text('small', Colors.black),
                        ),
                    )
                ]);
              }).toList()
              ) :  title == 'Following' ? 
                Text('You are not following any users', style: Configuration.text('tiny',Colors.black)) :
                Text('You are not being followed by anyone', style:Configuration.text('tiny', Colors.black))    
            )
        ),
      )
    );
  }
}

class ViewData extends StatefulWidget {
  const ViewData({ Key key }) : super(key: key);

  @override
  _ViewDataState createState() => _ViewDataState();
}

class _ViewDataState extends State<ViewData> {
  @override
  Widget build(BuildContext context) {
    return Container(
      
    );
  }
}

class MyInfo extends StatefulWidget {
  bool isTablet;

  MyInfo({this.isTablet = false});

  @override
  _MyInfoState createState() => _MyInfoState();
}

class _MyInfoState extends State<MyInfo> {
  final ImagePicker _picker = ImagePicker();
  UserState _userstate;
  bool uploading = false;

  PickedFile _image;

  _imgFromCamera() async {
    PickedFile image = await _picker.getImage(source: ImageSource.camera);
    
    if(image != null){
    setState(() {
      uploading =true;
    });
    await _userstate.changeImage(image);
    
    setState(() {
      uploading = false;
    });
    }
  }

  _imgFromGallery() async {
    PickedFile image = await _picker.getImage(source: ImageSource.gallery);

     if(image != null){
      setState(() {
        uploading =true;
      });
      await _userstate.changeImage(image);
      setState(() {
        uploading = false;
      });
     }
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Photo Library'),
                      onTap: () {
                        _imgFromGallery();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      _imgFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    _userstate = Provider.of<UserState>(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(height: Configuration.blockSizeVertical*1),
        RadialProgress(
            //Mirar de hacer esto de una forma bien en el config!!!
            width: widget.isTablet ? Configuration.blockSizeHorizontal* 0.3 :Configuration.safeBlockHorizontal * 1,
            goalCompleted: _userstate.user.stage.stagenumber / 10,
            child: GestureDetector(
              onTap: () => _showPicker(context),
              child: CircleAvatar(
                  radius: widget.isTablet ? Configuration.blockSizeHorizontal*7 : Configuration.blockSizeHorizontal * 12,
                  backgroundColor: Colors.transparent,
                  backgroundImage: _userstate.user.image == null
                      ? null
                      : NetworkImage(_userstate.user.image),
                  child: Icon(
                    Icons.camera_alt_outlined,
                    size: Configuration.medpadding,
                    color: _userstate.user.image != null
                        ? Colors.white.withOpacity(0.1)
                        : Colors.white,
                  )),
            )),
        SizedBox(
          height: Configuration.safeBlockVertical * 2,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
                _userstate.user.nombre,
                style: Configuration.text('medium', Colors.white),
            ),
          ],
        ),
      ],
    );
  }
}

class ProfileInfoBigCard extends StatelessWidget {
  final String firstText, secondText, color;
  final Widget icon;

  const ProfileInfoBigCard(
      {Key key,
      @required this.firstText,
      @required this.secondText,
      this.color,
      @required this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), 
        border: Border.all(color: color != null ? Colors.white : Colors.grey, width: 0.35)
      ),
      child: Padding(
        padding: EdgeInsets.all(Configuration.smpadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(firstText, style: Configuration.text('small', color != null ? Colors.white: Colors.black)),
                Align(alignment: Alignment.centerRight, child: icon),
            ]),
            Text(secondText, style: Configuration.text('tiny', color != null ? Colors.white : Colors.black)),
          ],
        ),
      ),
    );
  }
}

class ProfileInfoCard extends StatelessWidget {
  final firstText, secondText, hasImage, imagePath, isTablet;

  const ProfileInfoCard(
      {Key key,
      this.firstText,
      this.secondText,
      this.hasImage = false,
      this.isTablet = false,
      this.imagePath})
      : super(key: key);

  Widget twoLineItem(firstText,secondText){
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          firstText,
          style: Configuration.text('small', Colors.white),
        ),
        Text(secondText, style: Configuration.text('small', Colors.white)),
      ],
    );
  }

  Widget tabletTwolineItem(firsText,secondText){
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          firstText,
          style: Configuration.tabletText('tiny', Colors.white),
        ),
        Text(secondText, style: Configuration.tabletText('tiny', Colors.white)),
      ],
    );
  }


  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        elevation: 12,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: hasImage
            ? Center(child: Icon(Icons.wb_sunny))
            : isTablet ? twoLineItem(
                firstText,
                secondText,
              ) : tabletTwolineItem(firstText,secondText,),
      ),
    );
  }
}


class SimpleBarChart extends StatelessWidget {
  final List<Series> seriesList;
  final bool animate;
  DateTime date;
  UserState _userstate;

  SimpleBarChart({this.seriesList, this.animate, this.date});

  @override
  Widget build(BuildContext context) {
    _userstate = Provider.of<UserState>(context);
    return Container(
      height: Configuration.height*0.3,
      child: BarChart(
        _createSampleData(_userstate.user),
        behaviors: [LinePointHighlighter(symbolRenderer: CircleSymbolRenderer())],
        selectionModels: [
          SelectionModelConfig(changedListener: (SelectionModel model) {
            if (model.hasDatumSelection)
              print(model.selectedSeries[0]
                  .measureFn(model.selectedDatum[0].index));
          })
        ],

        // Disable animations for image tests.
        animate: true,
      ),
    );
  }

  /// Create one series with sample hard coded data.
  List<Series<Ordinal, String>> _createSampleData(User user) {
    final days = ['M', 'T', 'W', 'TH', 'F', 'S', 'S'];
    final data = List<Ordinal>.empty(growable: true);

    for (var day in days) {
      var time = user.userStats.meditationtime;
      var datestring = date.day.toString() + '-' + date.month.toString();
      date = date.add(Duration(days: 1));
      data.add(new Ordinal(
          day,
          time != null
              ? time[datestring] != null
                  ? time[datestring]
                  : 0
              : 0));
    }

    return [
      new Series<Ordinal, String>(
        id: 'Time meditated',
        colorFn: (_, __) => MaterialPalette.blue.shadeDefault,
        domainFn: (Ordinal sales, _) => sales.day,
        measureFn: (Ordinal sales, _) => sales.min,
        data: data,
      )
    ];
  }
}

/// Sample ordinal data type.
class Ordinal {
  final String day;
  final int min;

  Ordinal(this.day, this.min);
}

/* VISTAS DE TABLET
class TabletProfileScreen extends StatefulWidget {
  User user;

  TabletProfileScreen({this.user});

  @override
  _TabletProfileScreenState createState() => _TabletProfileScreenState();
}

class _TabletProfileScreenState extends State<TabletProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final _userstate = Provider.of<UserState>(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children:[
            Container(
            decoration: BoxDecoration(color: Configuration.maincolor, borderRadius: BorderRadius.circular(16.0)),
            width: Configuration.width*0.25,
            height: Configuration.width*0.25,
            child: Column( 
              children:[
                MyInfo(isTablet: true),
                IconButton(
                  padding: EdgeInsets.all(0.0),
                  onPressed: () => Navigator.pushNamed(context, '/settings').then((value) => setState(()=> null)),
                  icon: Icon(
                    Icons.settings,
                    color: Colors.white,
                    size: 15.0,
                  ),
                )
              ])
            ),
            Container(
          width: Configuration.width*0.3,
          height: Configuration.width*0.3,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Table(children: [
                TableRow(
                  children: [
                    TextButton(
                        onPressed: ()=>  
                        widget.user != null ? null :
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ViewFollowers(
                                    users: _userstate.user.following,
                                    title: 'Following',
                          )),
                      ), 
                      child: Column(
                          children: [
                            Text('Following', style: Configuration.tabletText('tiny', Colors.black)),
                            Text(widget.user != null ? widget.user.followedcods.length.toString() : _userstate.user.following.length.toString(), style: Configuration.tabletText('verytiny',Colors.black))
                          ],
                        ),
                      ),
                    TextButton(
                      onPressed: ()=>  
                      widget.user != null ? null :
                        Navigator.push(
                          context,
                            MaterialPageRoute(
                                builder: (context) => ViewFollowers(
                                      users: _userstate.user.followsyou,
                                      title: 'Followers',
                            )
                          ),
                        ),
                        child: Column(
                        children: [
                          Text('Followers', style: Configuration.tabletText('tiny', Colors.black)),
                          Text(widget.user != null ? widget.user.followsyoucods.length.toString() :  _userstate.user.followsyou.length.toString(), style: Configuration.tabletText('verytiny',Colors.black))
                        ],
                      ),
                    ),
                  ]
                ),
                TableRow(children: [
                  TabletInfoCard(
                    firstText: _userstate.user.userStats.total.meditations.toString(),
                    secondText: "Meditations\ncompleted",
                    icon: Icon(Icons.self_improvement),
                  ),
                  TabletInfoCard(
                      firstText: _userstate.user.userStats.total.lessons.toString(),
                      secondText: "Lessons\ncompleted",
                      icon: Icon(Icons.book)
                  ),
                ]),
              ]),
              SizedBox(height: Configuration.blockSizeVertical * 3),
              
            ],
          ),
        ),
        ]
        ),
        Container(
            width: Configuration.width*0.35,
            height: Configuration.width*0.35,
            decoration:BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16.0)) ,
            child: Column(
              children: [
                SizedBox(height: 10),
                Text('Meditation record',style:Configuration.tabletText('tiny', Colors.black)),
                CalendarWidget(meditations: widget.user != null ? widget.user.totalMeditations : _userstate.user.totalMeditations)                    
              ],
          )
        ),
        
      ],
    );
  }
}

class TabletViewData extends StatefulWidget {
  String title;

  TabletViewData({ Key key , this.title}) : super(key: key);

  @override
  _TabletViewDataState createState() => _TabletViewDataState();
}

class _TabletViewDataState extends State<TabletViewData> {
  UserState _userstate;
  
  Widget getList(){
    var items = {
      'Following': _userstate.user.following.length,
      'Followers': _userstate.user.followsyou.length,
    };
  
    return items[widget.title] > 0 ?
     GridView.builder(
      itemCount: items[widget.title],
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4), 
      itemBuilder: (context,index){
        if(widget.title == 'Following'){
          return Card(
            child: Text(_userstate.user.following[index].nombre != null ?_userstate.user.following[index].nombre :' Anónimo' ),
          );
        } else if(widget.title =='Followers'){

        }
      }    
    ) : Center(child: Text('You are not followed', style: Configuration.tabletText('tiny', Colors.black)));
    
  }
  
  
  @override
  Widget build(BuildContext context) {
     _userstate = Provider.of<UserState>(context);
    return Scaffold(
        body: Container(
        height: Configuration.height,
        width: Configuration.width,
        color: Configuration.lightgrey,
        child: Column(
          children: [
            AppBar(
              centerTitle: true,
              title: Text(widget.title, style: Configuration.tabletText('small', Colors.black)),
              leading: IconButton(
                icon:Icon(Icons.arrow_back),
                onPressed: ()=> Navigator.pop(context), 
                iconSize: Configuration.tabletsmicon, 
                color: Colors.black
              ),
              elevation: 0,
              backgroundColor: Colors.transparent,
            ),
            Expanded(
              child: getList()
            )
        ]),
      ),
    );
  }
}



*/