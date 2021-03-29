import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meditation_app/domain/entities/user_entity.dart';
import 'package:meditation_app/presentation/mobx/actions/user_state.dart';
import 'package:meditation_app/presentation/pages/commonWidget/radial_progress.dart';
import 'package:meditation_app/presentation/pages/config/configuration.dart';
import 'package:provider/provider.dart';
import 'package:charts_flutter/flutter.dart';


class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final _userstate = Provider.of<UserState>(context);
    return Scaffold(
      body: Stack(children: <Widget>[
        Container(
            height: Configuration.height,
            width: Configuration.width,
            color: Configuration.maincolor),
        Column(
          children: <Widget>[
            Expanded(
                flex: 2,
                child: Container(
                  child: Stack(
                    children: <Widget>[
                      new Positioned(
                        //Place it at the top, and not use the entire screen
                        top: 0.0,
                        left: 0.0,
                        right: 0.0,
                        child: AppBar(
                          backgroundColor: Colors.transparent,
                          elevation: 0,
                          leading: IconButton(
                            icon: Icon(Icons.arrow_back,
                                size: Configuration.smicon),
                            color: Colors.white,
                            onPressed: () => Navigator.pop(context),
                          ),
                        ),
                      ),
                      MyInfo(),
                    ],
                  ),
                )),
            Expanded(
                flex: 5,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  child: Container(
                    margin: EdgeInsets.only(
                        top: Configuration.blockSizeVertical * 2),
                    child: ListView(
                      children: <Widget>[
                        Table(children: [
                          TableRow(children: [
                            ProfileInfoBigCard(
                              firstText: _userstate
                                  .user.totalMeditations.length
                                  .toString(),
                              secondText: "Meditations\ncompleted",
                              icon: Icon(Icons.self_improvement),
                            ),
                            ProfileInfoBigCard(
                                firstText: _userstate
                                    .user.stats['total']['lecciones']
                                    .toString(),
                                secondText: "Lessons\ncompleted",
                                icon: Icon(Icons.book))
                          ]),
                        ]),
                        SizedBox(height: Configuration.blockSizeVertical * 3),
                        Padding(
                            padding: EdgeInsets.all(Configuration.smpadding),
                            child: Text('Meditation record',
                                style:
                                    Configuration.text('small', Colors.black))),
                        Container(
                            width: Configuration.width,
                            height: Configuration.height * 0.2,
                            child: SimpleBarChart(
                              date: DateTime.now().subtract(
                                  Duration(days: DateTime.now().weekday - 1)),
                            ))
                      ],
                    ),
                  ),
                )),
          ],
        ),
        /* Positioned(
          top: Configuration.height * 4 / 9 -
              ((Configuration.safeBlockVertical * 12) / 2),
          left: 16,
          right: 16,
          child: Container(
            height: Configuration.safeBlockVertical * 12,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                ProfileInfoCard(
                    firstText:
                        '' + _userstate.user.stage.stagenumber.toString(),
                    secondText: "Stage"),
                SizedBox(
                  width: Configuration.safeBlockHorizontal * 5,
                ),
                ProfileInfoCard(
                    firstText: '' + '10 ' + ' %', secondText: "Completed"),
              ],
            ),
          ),
        ),*/
      ]),
    );
  }
}

class MyInfo extends StatefulWidget {
  @override
  _MyInfoState createState() => _MyInfoState();
}

class _MyInfoState extends State<MyInfo> {
  final ImagePicker _picker = ImagePicker();
  UserState _userstate;

  PickedFile _image;

  _imgFromCamera() async {
    PickedFile image = await _picker.getImage(source: ImageSource.camera);
    
    if(image != null){
    _userstate.updateUser(image, 'image');
    
    setState(() {
      _image = image;
    });
    }
  }

  _imgFromGallery() async {
    PickedFile image = await _picker.getImage(source: ImageSource.gallery);

     if(image != null){
    _userstate.updateUser(image, 'image');
      setState(() {
        _image = image;
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
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          RadialProgress(
              width: Configuration.safeBlockHorizontal * 1,
              goalCompleted: _userstate.user.stage.stagenumber / 10,
              child: GestureDetector(
                onTap: () => _showPicker(context),
                child: CircleAvatar(
                    radius: Configuration.blockSizeHorizontal * 12,
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
                style: Configuration.text('small', Colors.white),
              ),
              IconButton(
                onPressed: () => Navigator.pushNamed(context, '/settings'),
                icon: Icon(
                  Icons.settings,
                  color: Colors.white,
                  size: Configuration.smicon,
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}

class ProfileInfoBigCard extends StatelessWidget {
  final String firstText, secondText;
  final Widget icon;

  const ProfileInfoBigCard(
      {Key key,
      @required this.firstText,
      @required this.secondText,
      @required this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: EdgeInsets.all(Configuration.smpadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Align(
              alignment: Alignment.topRight,
              child: icon,
            ),
            Text(firstText, style: Configuration.text('medium', Colors.black)),
            Text(secondText, style: Configuration.text('small', Colors.black)),
          ],
        ),
      ),
    );
  }
}

class ProfileInfoCard extends StatelessWidget {
  final firstText, secondText, hasImage, imagePath;

  const ProfileInfoCard(
      {Key key,
      this.firstText,
      this.secondText,
      this.hasImage = false,
      this.imagePath})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        elevation: 12,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: hasImage
            ? Center(child: Icon(Icons.wb_sunny))
            : TwoLineItem(
                firstText: firstText,
                secondText: secondText,
              ),
      ),
    );
  }
}

class TwoLineItem extends StatelessWidget {
  final String firstText, secondText;

  const TwoLineItem(
      {Key key, @required this.firstText, @required this.secondText})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
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
    return BarChart(
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
    );
  }

  /// Create one series with sample hard coded data.
  List<Series<Ordinal, String>> _createSampleData(User user) {
    final days = ['M', 'T', 'W', 'TH', 'F', 'S', 'S'];
    final data = List<Ordinal>.empty(growable: true);

    for (var day in days) {
      var time = user.stats['meditationtime'];
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
