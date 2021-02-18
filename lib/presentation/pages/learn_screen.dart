import 'dart:async';

import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:meditation_app/domain/entities/content_entity.dart';
import 'package:meditation_app/domain/entities/lesson_entity.dart';
import 'package:meditation_app/domain/entities/meditation_entity.dart';
import 'package:meditation_app/domain/entities/stage_entity.dart';
import 'package:meditation_app/presentation/mobx/actions/user_state.dart';
import 'package:meditation_app/presentation/pages/config/configuration.dart';
import 'package:meditation_app/presentation/pages/layout.dart';
import 'package:meditation_app/presentation/pages/oldwidgets/button.dart';
import 'package:provider/provider.dart';

class LearnScreen extends StatefulWidget {
  LearnScreen();

  @override
  _LearnScreenState createState() => _LearnScreenState();
}

class _LearnScreenState extends State<LearnScreen> {
  @override
  Widget build(BuildContext context) {
    final _userstate = Provider.of<UserState>(context);
    return Container(
      height: Configuration.height,
      width: Configuration.width,
      color: Configuration.lightgrey,
      padding: EdgeInsets.all(Configuration.medmargin),
      child: Column(
        children: [
          Expanded(
              child: GridView.builder(
                  itemCount: _userstate.data.stages.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2),
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () => _userstate.user.stagenumber > index
                          ? Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => StageView(
                                        stage: _userstate.data.stages[index],
                                      )),
                            ).then((value) => setState(() => null))
                          : null,
                      child: Stack(
                        children: [
                          Container(
                            margin: EdgeInsets.all(Configuration.medmargin),
                            decoration: BoxDecoration(
                                color: Configuration.maincolor,
                                borderRadius: BorderRadius.circular(16.0)),
                            child: Center(
                                child: Text(
                              'Stage ' +
                                  _userstate.data.stages[index].stagenumber
                                      .toString(),
                              style: Configuration.text("medium", Colors.white),
                            )),
                          ),
                          AnimatedContainer(
                            duration: Duration(seconds: 2),
                            margin: EdgeInsets.all(Configuration.medmargin),
                            decoration: BoxDecoration(
                                color: _userstate.user.stagenumber < (index + 1)
                                    ? Colors.grey
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(16.0)),
                          ),
                        ],
                      ),
                    );
                  }))
        ],
      ),
    );
  }
}

class StageView extends StatefulWidget {
  Stage stage;

  StageView({this.stage});

  @override
  _StageViewState createState() => _StageViewState();
}

class _StageViewState extends State<StageView> {
  UserState _userstate;

  var filter = ['all'];

  FutureOr onGoBack(dynamic value) {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    print('init');
  }

  Widget getLessons(context) {
    List<Widget> lessons = new List();
    List<Image> imagelist = new List();

    widget.stage.path.forEach((key, list) {
      for (var content in list) {
        var image;
        if (content.image != null) {
          var configuration = createLocalImageConfiguration(context);
          image = new NetworkImage(content.image)..resolve(configuration);
        }
        if (filter.contains(content.type) || filter.contains('all')) {
          lessons.add(GestureDetector(
            onTap: () {
              if (_userstate.user.position >= int.parse(key) ||
                  _userstate.user.stagenumber > content.stagenumber) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ContentView(
                            lesson: content,
                            content: content,
                            slider: image))).then(onGoBack);
              }
            },
            child: Container(
              height: Configuration.height * 0.13,
              margin: EdgeInsets.all(Configuration.medmargin),
              decoration: BoxDecoration(
                color: Configuration.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 0.4,
                    blurRadius: 0.4,
                    offset: Offset(0.6, 0.6), // changes position of shadow
                  ),
                ],
              ),
              child: Stack(
                children: [
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Stack(children: [
                      ClipRRect(
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(16),
                            bottomRight: Radius.circular(16)),
                        child: Image.network(content.image,
                            height: Configuration.height * 0.13),
                      ),
                    ]),
                  ),
                  Positioned(
                      top: 0,
                      left: 0,
                      child: Padding(
                        padding: EdgeInsets.all(Configuration.smpadding),
                        child: Container(
                          width: Configuration.safeBlockHorizontal * 5,
                          height: Configuration.safeBlockHorizontal * 5,
                          child: Icon(
                              content.type == 'meditation'
                                  ? Icons.self_improvement
                                  : Icons.book,
                              color: Colors.grey),
                        ),
                      )),
                  Positioned(
                      left: 0,
                      bottom: 0,
                      child: Container(
                        width: Configuration.width * 0.6,
                        padding: EdgeInsets.all(Configuration.smpadding),
                        child: Text(
                          content.title,
                          style: Configuration.text(
                              "tiny", Colors.black, "bold", 1),
                        ),
                      )),
                  Positioned(
                    left: 0,
                    bottom: 0,
                    right: 0,
                    top: 0,
                    child: AnimatedContainer(
                      key: Key(content.cod),
                      duration: Duration(seconds: 2),
                      width: Configuration.height * 0.1,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: _userstate.user.position < int.parse(key) &&
                                  _userstate.user.stagenumber <=
                                      content.stagenumber
                              ? Colors.grey.withOpacity(0.6)
                              : Colors.transparent),
                      curve: Curves.fastOutSlowIn,
                    ),
                  ),
                ],
              ),
            ),
          ));
        }
      }
    });

    return Container(
      padding: EdgeInsets.all(Configuration.smpadding),
      color: Configuration.lightgrey,
      child: SingleChildScrollView(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: lessons),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _userstate = Provider.of<UserState>(context);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Stage ' + widget.stage.stagenumber.toString(),
            style: Configuration.text('big', Colors.black)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back,
              size: Configuration.smicon, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Configuration.white,
        elevation: 0,
      ),
      body: Container(
        height: Configuration.height,
        width: Configuration.width,
        color: Configuration.white,
        child: Column(
          children: [
            Container(
              height: Configuration.height * 0.2,
              width: Configuration.width,
              margin: EdgeInsets.only(
                  left: Configuration.smmargin,
                  right: Configuration.smmargin,
                  top: Configuration.medmargin),
              decoration: BoxDecoration(
                  color: Configuration.lightpurple,
                  borderRadius: BorderRadius.circular(12.0)),
            ),
            Container(
                padding: EdgeInsets.symmetric(
                    horizontal: Configuration.medpadding,
                    vertical: Configuration.tinpadding),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Filter',
                      style: Configuration.text('small', Colors.black),
                    ),
                    SizedBox(width: Configuration.width * 0.05),
                    OutlinedButton(
                      onPressed: () => setState(
                          () => filter.contains('all') ? '' : filter = ['all']),
                      child: Icon(Icons.more_vert,
                          color: filter.contains('all')
                              ? Colors.black
                              : Colors.black.withOpacity(0.5)),
                      style: ButtonStyle(
                        backgroundColor: filter.contains('all')
                            ? MaterialStateProperty.all<Color>(Colors.white)
                            : null,
                      ),
                    ),
                    SizedBox(width: Configuration.width * 0.05),
                    OutlinedButton(
                      onPressed: () => setState(() {
                        filter.contains('lesson') ? '' : filter = ['lesson'];
                      }),
                      child: Icon(Icons.book,
                          color: filter.contains('lesson')
                              ? Colors.black
                              : Colors.black.withOpacity(0.5)),
                      style: ButtonStyle(
                        backgroundColor: filter.contains('lesson')
                            ? MaterialStateProperty.all<Color>(Colors.white)
                            : null,
                      ),
                    ),
                    SizedBox(width: Configuration.width * 0.05),
                    OutlinedButton(
                      onPressed: () => setState(() =>
                          filter.contains('meditation')
                              ? ''
                              : filter = ['meditation']),
                      child: Icon(Icons.self_improvement,
                          color: filter.contains('meditation')
                              ? Colors.black
                              : Colors.black.withOpacity(0.5)),
                      style: ButtonStyle(
                        backgroundColor: filter.contains('meditation')
                            ? MaterialStateProperty.all<Color>(Colors.white)
                            : null,
                      ),
                    ),
                  ],
                )),
            Expanded(child: getLessons(context))
          ],
        ),
      ),
    );
  }
}

class ContentView extends StatefulWidget {
  Content content;
  Meditation meditation;
  Lesson lesson;
  NetworkImage slider;

  ContentView({this.content, this.lesson, this.meditation, this.slider});

  @override
  _ContentViewState createState() => _ContentViewState();
}

class _ContentViewState extends State<ContentView> {
  int _index = -1;
  var _userstate;
  Map<int, NetworkImage> textimages = new Map();
  var reachedend = false;

  Widget portada() {
    return Column(children: [
      Stack(children: [
        Image(image: widget.slider),
        Container(
            width: Configuration.width,
            color: Configuration.darkpurple.withOpacity(0.9),
            height: Configuration.height * 0.5),
      ]),
      Divider(color: Colors.white, height: 1),
      Expanded(
        child: Container(
          color: Configuration.lightpurple,
          width: Configuration.width,
          child: Stack(
            children: [
              Padding(
                padding: EdgeInsets.only(
                    left: Configuration.smpadding,
                    right: Configuration.smpadding,
                    top: Configuration.smpadding),
                child: Text(widget.content.title,
                    style: Configuration.text('medium', Colors.white)),
              ),
              Center(
                child: GestureDetector(
                  onTap: () => setState(() => _index = 0),
                  child: Container(
                    width: Configuration.width * 0.25,
                    height: Configuration.width * 0.25,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: Colors.white),
                    child: Center(
                      child: Text('Start',
                          style: Configuration.text(
                              'medium', Configuration.lightpurple)),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      )
    ]);
  }

  Widget vistaLeccion() {
    return CarouselSlider.builder(
        itemCount: widget.lesson.text.length,
        itemBuilder: (context, index) {
          return Container(
            width: Configuration.width,
            color: Configuration.lightpurple,
            child: Column(
              mainAxisAlignment: widget.lesson.text[index]['image'] == ''
                  ? MainAxisAlignment.center
                  : MainAxisAlignment.start,
              children: [
                Image.network(
                  widget.lesson.text[index]["image"],
                  width: Configuration.width,
                ),
                Container(
                    width: Configuration.width,
                    padding: EdgeInsets.all(Configuration.smpadding),
                    child: Text(widget.lesson.text[index]["text"],
                        style: Configuration.text('small', Colors.white))),
                Row(
                    mainAxisAlignment: widget.lesson.type == 'meditation'
                        ? MainAxisAlignment.spaceEvenly
                        : MainAxisAlignment.center,
                    children: [
                      widget.lesson.type == 'meditation'
                          ? GestureDetector(
                              onTap: () async {
                                await _userstate.takeLesson(widget.lesson);
                                Navigator.pop(context, true);
                              },
                              child: AnimatedContainer(
                                width:
                                    reachedend ? Configuration.width * 0.5 : 0,
                                padding:
                                    EdgeInsets.all(Configuration.smpadding),
                                decoration: BoxDecoration(
                                    color: Configuration.maincolor,
                                    shape: BoxShape.circle),
                                duration: Duration(seconds: 1),
                                curve: Curves.easeIn,
                                child: reachedend
                                    ? Center(
                                        child: Text(
                                          'Practice',
                                          style: Configuration.text(
                                              'medium', Colors.white),
                                        ),
                                      )
                                    : Container(),
                              ),
                            )
                          : Container(),
                      GestureDetector(
                        onTap: () async {
                          await _userstate.takeLesson(widget.lesson);
                          Navigator.pop(context, true);
                        },
                        child: AnimatedContainer(
                          width: reachedend ? Configuration.width * 0.5 : 0,
                          curve: Curves.easeIn,
                          duration: Duration(seconds: 1),
                          padding: EdgeInsets.all(Configuration.smpadding),
                          decoration: BoxDecoration(
                              color: Configuration.darkpurple,
                              shape: BoxShape.circle),
                          child: reachedend
                              ? Center(
                                  child: Text(
                                    'Finish',
                                    style: Configuration.text(
                                        'medium', Colors.white),
                                  ),
                                )
                              : Container(),
                        ),
                      ),
                    ])
              ],
            ),
          );
        },
        options: CarouselOptions(
            height: Configuration.height,
            viewportFraction: 1,
            initialPage: 0,
            enableInfiniteScroll: false,
            reverse: false,
            onPageChanged: (index, reason) {
              setState(() {
                _index = index;
                if (_index == widget.lesson.text.length - 1) {
                  reachedend = true;
                }
              });
            }));
  }

  //esto se mezclará
  Widget vistaMeditacion() {
    return Container();
  }

  @override
  void initState() {
    _index = -1;
    super.initState();
  }

  @override
  void didChangeDependencies() {
    var configuration = createLocalImageConfiguration(context);

    if (widget.content.type == 'lesson') {
      widget.lesson.text.forEach((slide) {
        print(slide['image']);
        if (slide['image'] != '') {
          new NetworkImage(slide['image'])..resolve(configuration);
        }
      });
    }

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    _userstate = Provider.of<UserState>(context);
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              icon: Icon(Icons.close,
                  size: Configuration.smicon, color: Colors.black),
              onPressed: () => Navigator.pop(context)),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        extendBodyBehindAppBar: true,
        body: _index == -1
            ? portada()
            :Stack(children: [
                    vistaLeccion(),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        margin: EdgeInsets.all(Configuration.bigmargin),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: widget.lesson.text.map((url) {
                            int index = widget.lesson.text.indexOf(url);
                            return Container(
                              width: Configuration.safeBlockHorizontal * 3,
                              height: Configuration.safeBlockHorizontal * 3,
                              margin: EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 2.0),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: _index == index
                                    ? Color.fromRGBO(0, 0, 0, 0.9)
                                    : Color.fromRGBO(0, 0, 0, 0.4),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ])
                );
  }
}
