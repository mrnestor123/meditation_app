import 'package:flutter/material.dart';
import 'package:meditation_app/presentation/mobx/actions/user_state.dart';
import 'package:meditation_app/presentation/pages/config/configuration.dart';
import 'package:provider/provider.dart';
import 'package:vector_math/vector_math_64.dart' as math;

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _userstate = Provider.of<UserState>(context);
    return Scaffold(
      body: Stack(children: <Widget>[
        Column(
          children: <Widget>[
            Expanded(
                flex: 4,
                child: Container(
                  color: Configuration.maincolor,
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
                                size: Configuration.iconSize),
                            color: Colors.white,
                            onPressed: () => Navigator.pop(context),
                          ),
                        ),
                      ),
                      Column(children: <Widget>[MyInfo()]),
                    ],
                  ),
                )),
            Expanded(
                flex: 4,
                child: Container(
                  color: Colors.white,
                  child: Container(
                    margin: EdgeInsets.only(
                        top: Configuration.blockSizeVertical * 5),
                    child: ListView(
                      children: <Widget>[
                        Table(
                          children: [
                            TableRow(children: [
                              ProfileInfoBigCard(
                                firstText: _userstate.user.totalMeditations.length.toString(),
                                secondText: "Meditations completed",
                                icon: Icon(Icons.check),
                              ),
                              ProfileInfoBigCard(
                                  firstText: _userstate.user.lessonslearned.length.toString(),
                                  secondText: "lessons completed",
                                  icon: Icon(Icons.check))
                            ]),
                          ],
                        ),
                      ],
                    ),
                  ),
                )),
          ],
        ),
         Positioned(
              top:Configuration.height * 4/9 - ((Configuration.safeBlockVertical*12)/2),
              left: 16,
              right: 16,
              child: Container(
                height: Configuration.safeBlockVertical*12,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    ProfileInfoCard(firstText: ''+_userstate.user.stage.stagenumber.toString(), secondText: "Stage"),
                    SizedBox(
                      width: Configuration.safeBlockHorizontal*5,
                    ),
                    ProfileInfoCard(firstText:''+ '10 ' + ' %', secondText: "Completed"),
                  ],
                ),
              ),
            ),
      ]),
    );
  }
}

class MyInfo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _userstate = Provider.of<UserState>(context);
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          RadialProgress(
            width: Configuration.safeBlockHorizontal * 1,
            goalCompleted: _userstate.user.stage.stagenumber /10,
            child: RoundedImage(
              imagePath: "assets/sky.jpg",
              size: Size.fromWidth(Configuration.blockSizeHorizontal*12),
            ),
          ),
          SizedBox(
            height: Configuration.safeBlockVertical * 2,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                _userstate.user.usuario,
                style: Configuration.nombre,
              ),
            ],
          ),
          SizedBox(height: Configuration.safeBlockVertical * 2),
        ],
      ),
    );
  }
}

class RoundedImage extends StatelessWidget {
  final String imagePath;
  final Size size;

  const RoundedImage({Key key, @required this.imagePath, this.size})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: size.width,
      backgroundImage: AssetImage(imagePath)
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
        padding: const EdgeInsets.only(
          left: 16.0,
          top: 16,
          bottom: 24,
          right: 16,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Align(
              alignment: Alignment.topRight,
              child: icon,
            ),
            Text(firstText, style: Configuration.infoCardnumber),
            Text(secondText, style: Configuration.infoCarddescription),
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
          style: TextStyle(fontWeight:FontWeight.bold,fontSize: 20),
        ),
        Text(
          secondText,
          style: TextStyle(fontSize: 15),
        ),
      ],
    );
  }
}
