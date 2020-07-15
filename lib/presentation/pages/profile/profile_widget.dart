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
                            TableRow(children: [
                              ProfileInfoBigCard(
                                firstText: "4",
                                secondText: "meditations completed",
                                icon: Icon(Icons.check),
                              ),
                              ProfileInfoBigCard(
                                  firstText: "4",
                                  secondText: "lessons completed",
                                  icon: Icon(Icons.check))
                            ]),
                            TableRow(children: [
                              ProfileInfoBigCard(
                                firstText: "4",
                                secondText: "meditations completed",
                                icon: Icon(Icons.check),
                              ),
                              ProfileInfoBigCard(
                                  firstText: "4",
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    ProfileInfoCard(firstText: "54%", secondText: "Progress"),
                    SizedBox(
                      width: 10,
                    ),
                    ProfileInfoCard(
                      hasImage: true,
                      imagePath: "assets/icons/pulse.png",
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    ProfileInfoCard(firstText: "152", secondText: "Level"),
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
            goalCompleted: 0.9,
            child: RoundedImage(
              imagePath: "images/sky.jpg",
              size: Configuration.safeBlockHorizontal * 25,
            ),
          ),
          SizedBox(
            height: Configuration.safeBlockVertical * 2,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                _userstate.user.nombre,
                style: Configuration.nombre,
              ),
            ],
          ),
          SizedBox(height: Configuration.safeBlockVertical * 2),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "  Level 10",
              )
            ],
          ),
        ],
      ),
    );
  }
}

class RoundedImage extends StatelessWidget {
  final String imagePath;
  final double size;

  const RoundedImage({Key key, @required this.imagePath, this.size})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Image.asset(
        imagePath,
        width: size,
        height: size,
        fit: BoxFit.fitWidth,
      ),
    );
  }
}

class RadialProgress extends StatefulWidget {
  final double goalCompleted;
  final Widget child;
  final Color progressColor;
  final Color progressBackgroundColor;
  final double width;

  const RadialProgress(
      {Key key,
      @required this.child,
      this.goalCompleted = 0.7,
      this.progressColor = Colors.white,
      this.progressBackgroundColor = Colors.white,
      this.width = 8})
      : super(key: key);

  @override
  _RadialProgressState createState() => _RadialProgressState();
}

class _RadialProgressState extends State<RadialProgress>
    with SingleTickerProviderStateMixin {
  AnimationController _radialProgressAnimationController;
  Animation<double> _progressAnimation;
  final Duration fadeInDuration = Duration(milliseconds: 500);
  final Duration fillDuration = Duration(seconds: 2);

  double progressDegrees = 0;
  var count = 0;

  @override
  void initState() {
    super.initState();
    _radialProgressAnimationController =
        AnimationController(vsync: this, duration: fillDuration);
    _progressAnimation = Tween(begin: 0.0, end: 360.0).animate(CurvedAnimation(
        parent: _radialProgressAnimationController, curve: Curves.easeIn))
      ..addListener(() {
        setState(() {
          progressDegrees = widget.goalCompleted * _progressAnimation.value;
        });
      });

    _radialProgressAnimationController.forward();
  }

  @override
  void dispose() {
    _radialProgressAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: widget.child,
      ),
      painter: RadialPainter(
        progressDegrees,
        widget.progressColor,
        widget.progressBackgroundColor,
        widget.width,
      ),
    );
  }
}

class RadialPainter extends CustomPainter {
  double progressInDegrees, width;
  final Color progressColor, progressBackgroundColor;

  RadialPainter(this.progressInDegrees, this.progressColor,
      this.progressBackgroundColor, this.width);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = progressBackgroundColor.withOpacity(0.5)
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = width;

    Offset center = Offset(size.width / 2, size.height / 2);
    canvas.drawCircle(center, size.width / 2, paint);

    Paint progressPaint = Paint()
      ..color = progressColor
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeWidth = width;

    canvas.drawArc(
        Rect.fromCircle(center: center, radius: size.width / 2),
        math.radians(-90),
        math.radians(progressInDegrees),
        false,
        progressPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
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
        ),
        Text(
          secondText,
        ),
      ],
    );
  }
}
