import 'dart:async';

import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:meditation_app/domain/entities/content_entity.dart';
import 'package:meditation_app/domain/entities/lesson_entity.dart';
import 'package:meditation_app/domain/entities/meditation_entity.dart';
import 'package:meditation_app/domain/entities/stage_entity.dart';
import 'package:meditation_app/presentation/mobx/actions/user_state.dart';
import 'package:meditation_app/presentation/pages/commonWidget/start_button.dart';
import 'package:meditation_app/presentation/pages/config/configuration.dart';
import 'package:provider/provider.dart';
import 'commonWidget/progress_dialog.dart';

class LearnScreen extends StatefulWidget {
  LearnScreen();

  @override
  _LearnScreenState createState() => _LearnScreenState();
}

class _LearnScreenState extends State<LearnScreen> {
  @override
  Widget build(BuildContext context) {
    final _userstate = Provider.of<UserState>(context);
    return GridView.builder(
        shrinkWrap: true,
        itemCount: _userstate.data.stages.length,
        gridDelegate: 
          SliverGridDelegateWithMaxCrossAxisExtent(
            childAspectRatio: 1.0, 
            maxCrossAxisExtent: Configuration.width > 1000 ? 400.0 : 200.0,
            crossAxisSpacing: 10,
        ),
        itemBuilder: (context, index) {
          var flex = ((_userstate.user.userStats.stage.lessons / _userstate.user.stage.stobjectives.lecciones)*6).round();
          return Container(
            margin: EdgeInsets.only(top: 10),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(16.0)),
            child: ElevatedButton(
              onPressed: _userstate.user.stagenumber > index
                  ?  () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => StageView(
                                stage:_userstate.data.stages[index],
                              )),
                    ).then((value) => setState(() { 
                      
                  }))
                  : null,
              child: 
              Stack(
                children: [
                  Center(
                    child: Text('Stage ' +  _userstate.data.stages[index].stagenumber.toString(),
                      style: Configuration.text("smallmedium", _userstate.user.stagenumber > index ? Colors.white : Colors.grey),
                    ),
                  ),
                  _userstate.user.stagenumber > index ? 
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: AspectRatio(
                     aspectRatio: 9/1,
                     child: Container(  
                       decoration: flex < 6 && _userstate.user.stagenumber == (index +1) ? BoxDecoration(
                          borderRadius: BorderRadius.circular(16.0),
                          border: Border.all(color:Colors.grey), 
                          color: Colors.white
                        ) : BoxDecoration(color: Colors.transparent), 
                       child: Row(
                         mainAxisAlignment: MainAxisAlignment.center,
                         children: [
                           flex < 6 && _userstate.user.stagenumber == (index +1) ? 
                           Flexible(
                             flex: flex,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.green, 
                                  borderRadius: BorderRadius.circular(16.0)
                                ),
                              ) ,
                           ) : Padding(
                             padding: const EdgeInsets.only(bottom:16.0),
                             child: Icon(Icons.check_circle,color: Colors.green),
                           ),
                          flex < 6 && _userstate.user.stagenumber == (index +1) ?
                           Flexible(
                             child: Container(),
                             flex:6-flex
                            ) : Container()
                       ])
                       ),
                     )
                    ) : Container()
                ]
              ) ,
              style: ElevatedButton.styleFrom(
                  primary: Configuration.maincolor,
                  onPrimary: Colors.white,
                  padding: EdgeInsets.all(Configuration.smpadding),
                  minimumSize:Size(double.infinity, double.infinity),
                  animationDuration: Duration(milliseconds: 50)        
                  ),
            ),
          );
        });
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
    setState(() {
      if(_userstate.user.progress != null) autocloseDialog(context, _userstate.user);
      
      });
  }

  @override
  void initState() {
    super.initState();
    print('init');
  }

  Widget getLessons(context) {
    List<Widget> lessons = new List.empty(growable: true);
    var count = 0;

    widget.stage.path.forEach((content) {
      count++;
      var image;
      if (content.image != null) {
        var configuration = createLocalImageConfiguration(context);
        image = new NetworkImage(content.image)..resolve(configuration);
      }
      if (filter.contains(content.type) || filter.contains('all')) {
        lessons.add(AspectRatio(
            aspectRatio: 8/3,
            child: Container(
            margin: EdgeInsets.all(Configuration.medmargin),
            decoration: BoxDecoration(
              color: Configuration.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: ElevatedButton(
              onPressed: () {
                if (_userstate.user.position >= content.position ||
                    _userstate.user.stagenumber > content.stagenumber) {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ContentView(
                              lesson: content,
                              content: content,
                              slider: image
                              ))).then(onGoBack);
                }
              },
              style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.all(0),
                  primary: Colors.white,
                  onPrimary: Colors.white,
                  minimumSize: Size(double.infinity, double.infinity)),
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: Hero(tag: content.cod ,child: Image.network(content.image)),
                  ),
                  Positioned(
                      top: 15,
                      left: 15,
                      child: Row(
                        children: [
                          Container(
                            margin: EdgeInsets.only(right: Configuration.blockSizeHorizontal *2),
                            width: Configuration.safeBlockHorizontal * 5,
                            height: Configuration.safeBlockHorizontal * 5,
                            child: Icon(
                                content.type == 'meditation'
                                    ? Icons.self_improvement
                                    : Icons.book,
                                color: Colors.grey),
                          ),
                          content.position < _userstate.user.position || 
                            content.stagenumber < _userstate.user.stagenumber || 
                            _userstate.user.userStats.lastread.where((c) => c['cod'] == content.cod).length > 0
                            ?  
                            Container(
                              width: Configuration.safeBlockHorizontal * 5,
                              height: Configuration.safeBlockHorizontal * 5,
                              child: Icon(Icons.visibility,
                                color: Colors.lightBlue
                              ),
                            ): Container(),
                        ],
                      )),
                  Positioned(
                      left: 15,
                      bottom: 15,
                      child: Container(
                        width: Configuration.width * 0.5,
                        child: Text(
                          content.title,
                          style:
                              Configuration.text("verytiny", _userstate.user.position < content.position &&
                                  _userstate.user.stagenumber <= content.stagenumber ? Colors.grey : Colors.black, 
                                   ),
                        ),
                      )),
                  Positioned(
                    left: 0,
                    bottom: 0,
                    right: 0,
                    top: 0,
                    child: AnimatedContainer(
                      padding: EdgeInsets.all(0),
                      key: Key(content.cod),
                      duration: Duration(seconds: 2),
                      decoration: BoxDecoration(
                          color: _userstate.user.position < content.position &&
                                  _userstate.user.stagenumber <= content.stagenumber
                              ? Colors.grey.withOpacity(0.6)
                              : Colors.transparent),
                      curve: Curves.fastOutSlowIn,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
      }
    });

    return Container(
      padding: EdgeInsets.all(Configuration.smpadding),
      width: Configuration.width,
      color: Configuration.lightgrey,
      child: SingleChildScrollView(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: lessons.length > 0 ? lessons : [Text('There are no lessons')]),
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
            style: Configuration.text('medium', Colors.black)),
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
            AspectRatio(
              aspectRatio: 9/4,
                child: Container(
                width: Configuration.width,
                margin: EdgeInsets.only(
                    left: Configuration.smmargin,
                    right: Configuration.smmargin,
                    top: Configuration.medmargin),
                decoration: BoxDecoration(
                    color: Configuration.maincolor,
                    borderRadius: BorderRadius.circular(12.0)),
              ),
            ),
            Container(
                padding: EdgeInsets.symmetric(
                    vertical: Configuration.tinpadding),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text('Filter',
                      style: Configuration.text('tiny', Colors.black),
                    ),
                    OutlinedButton(
                      onPressed: () => setState(
                          () => filter.contains('all') ? '' : filter = ['all']),
                      child: Icon(Icons.more_vert,
                          color: filter.contains('all')
                              ? Colors.white
                              : Colors.black.withOpacity(0.5)),
                      style: ButtonStyle(
                        backgroundColor: filter.contains('all')
                            ? MaterialStateProperty.all<Color>(
                                Configuration.maincolor)
                            : null,
                      ),
                    ),
                    OutlinedButton(
                      onPressed: () => setState(() {
                        filter.contains('lesson') ? '' : filter = ['lesson'];
                      }),
                      child: Icon(Icons.book,
                          color: filter.contains('lesson')
                              ? Colors.white
                              : Colors.black.withOpacity(0.5)),
                      style: ButtonStyle(
                        backgroundColor: filter.contains('lesson')
                            ? MaterialStateProperty.all<Color>(
                                Configuration.maincolor)
                            : null,
                      ),
                    ),
                    OutlinedButton(
                      onPressed: () => setState(() =>
                          filter.contains('meditation')
                              ? ''
                              : filter = ['meditation']),
                      child: Icon(Icons.self_improvement,
                          color: filter.contains('meditation')
                              ? Colors.white
                              : Colors.black.withOpacity(0.5)),
                      style: ButtonStyle(
                        backgroundColor: filter.contains('meditation')
                            ? MaterialStateProperty.all<Color>(
                                Configuration.maincolor)
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
        Center(child: Hero(tag: widget.content.cod, child: Image(image: widget.slider,width: Configuration.width,))),
      ]),
      Expanded(
        child: Container(
          width: Configuration.width,
          child: Stack(
            children: [
              Align(
                alignment: Alignment.topCenter,
                  child: Padding(
                  padding: EdgeInsets.only(
                      left: Configuration.smpadding,
                      right: Configuration.smpadding,
                      top: Configuration.smpadding),
                  child: Text(widget.content.title,
                      textAlign: TextAlign.center,
                      style: Configuration.text('small', Colors.black)),
                ),
              ),
              Center(
                child: StartButton(
                  onPressed: () async{
                      setState(() => _index = 0);
                  } 
                )
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
            color: Configuration.lightgrey,
            child: Column(
              mainAxisAlignment: widget.lesson.text[index]['image'] == ''
                  ? MainAxisAlignment.center
                  : MainAxisAlignment.start,
              children: [
                 widget.lesson.text[index]["image"] != '' && widget.lesson.text[index]["image"] != null ? Image.network(
                  widget.lesson.text[index]["image"],
                  width: Configuration.width,
                ) : Container(),
                Container(
                    width: Configuration.width,
                    padding: EdgeInsets.all(Configuration.smpadding),
                    child: Html(
                      data:widget.lesson.text[index]["text"],
                    )
                   ),
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
                                width: reachedend ? Configuration.width * 0.5 : 0,
                                padding: EdgeInsets.all(Configuration.smpadding),
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
                       Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                  /*MaterialButton(
                                    onPressed: () async {
                                      await _userstate
                                          .takeLesson(widget.lesson);
                                      Navigator.pop(context, true);
                                    },
                                    color: Configuration.maincolor,
                                    textColor: Colors.white,
                                    child: Text(
                                      'Next lesson',
                                      style: Configuration.text(
                                          'medium', Colors.white),
                                    ),
                                    padding: EdgeInsets.all(
                                        Configuration.medpadding),
                                    shape: CircleBorder(),
                                  ),*/
                                  AnimatedOpacity(
                                    opacity: reachedend ? 1.0 : 0.0, 
                                    duration: Duration(seconds: 1),
                                    child: Container(
                                      width: Configuration.width*0.5,
                                      child: AspectRatio(
                                        aspectRatio: 9/2,
                                        child: ElevatedButton(
                                            onPressed: () async {
                                            await _userstate.takeLesson(widget.lesson);
                                            Navigator.pop(context, true);
                                          },
                                          style: ElevatedButton.styleFrom(
                                            primary: Configuration.maincolor,
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
                                          ), 
                                          child: Text(
                                            'Finish',
                                            style: Configuration.text('small', Colors.white),
                                          )
                                        ),
                                      ),
                                    ),
                                  ),

                                  /*ClipOval(
                                    child: Material(
                                      color: Configuration
                                          .maincolor, // button color
                                      child: InkWell(
                                        splashColor:
                                            Colors.red, // inkwell color
                                        child: SizedBox(
                                            width: Configuration.width*0.2,
                                            height: Configuration.width*0.2,
                                            child: Center(child: Text('Finish', style: Configuration.text('medium',Colors.white),))),
                                        onTap: () async {
                                          await _userstate
                                              .takeLesson(widget.lesson);
                                          Navigator.pop(context, true);
                                        },
                                      ),
                                    ),
                                  ),*/
                                ])
                          ,

                      /*GestureDetector(
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
                      ) : Container(),*/
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
                  Future.delayed(Duration(seconds: 2),() => setState(()=> reachedend = true));
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
    super.initState();
    _index = -1;
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
            : Stack(children: [
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
              ]));
  }
}



// HAY QUE PENSAR OTRA FORMA MAS EFICIENTE DE HACER LAS COSAS !!!
/*
class TabletStageView extends StatefulWidget {
   Stage stage;

   TabletStageView({this.stage});

  @override
  _TabletStageViewState createState() => _TabletStageViewState();
}

class _TabletStageViewState extends State<TabletStageView> {

  UserState _userstate;

  var filter = ['all'];

  FutureOr onGoBack(dynamic value) {
    setState(() {
      if(_userstate.user.progress != null) autocloseDialog(context, _userstate.user, isTablet: true);});
  }

  @override
  void initState() {
    super.initState();
    print('init');
  }

  Widget getLessons(context) {
    List<Widget> lessons = new List.empty(growable: true);

    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3), 
      padding: EdgeInsets.all(0.0),
      itemCount: widget.stage.path.length,
      itemBuilder: (context,index) {
        var content = widget.stage.path[index];
        var image;
        if (content.image != null) {
          var configuration = createLocalImageConfiguration(context);
          image = new NetworkImage(content.image)..resolve(configuration);
        }

        return Container(
        margin: EdgeInsets.only(left:16.0,right:16.0,bottom: 32.0),
        decoration: BoxDecoration(
          color: Configuration.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: ElevatedButton(
          onPressed: () {
            if (_userstate.user.position >= content.position || _userstate.user.stagenumber > content.stagenumber) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => TabletContentView(
                          lesson: content,
                          content: content,
                          slider: image
                          ))).then(onGoBack);
            }
          },
          style: ElevatedButton.styleFrom(
              padding: EdgeInsets.all(0),
              primary: Colors.white,
              onPrimary: Colors.white,
              minimumSize: Size(double.infinity, double.infinity)),
          child: Stack(
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: Hero(tag: content.cod ,child: Image.network(content.image)),
              ),
              Positioned(
                  top: 15,
                  left: 15,
                  child: Container(
                    child: Icon(
                        content.type == 'meditation'
                            ? Icons.self_improvement
                            : Icons.book,
                        color: Colors.grey,
                        size: Configuration.tabletsmicon,
                        ),
                  )
              ),
              content.position < _userstate.user.position || 
              content.stagenumber < _userstate.user.stagenumber || 
              _userstate.user.userStats.lastread.where((c) => c['cod'] == content.cod).length > 0
              ? 
              Positioned(
                  top: 15,
                  right: 15,
                  child: Container(
                    child: Icon(Icons.visibility,
                        color: Colors.lightBlue,
                        size: Configuration.tabletsmicon,
                        ),
                )
              ) : Container(),
              Positioned(
                  left: 15,
                  bottom: 15,
                  child: Container(
                    width: Configuration.width*0.23,
                    child: Text(
                      content.title,
                      style:
                          Configuration.tabletText("verytiny", _userstate.user.position < content.position &&
                              _userstate.user.stagenumber <= content.stagenumber ? Colors.grey : Colors.black, 
                               ),
                    ),
                  )),
              /*Positioned(
                  bottom: 0.0,
                  left: 0.0,
                  width: Configuration.safeBlockHorizontal * 40,
                  height: Configuration.safeBlockHorizontal * 5,
                  child:  Container(
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [Colors.grey.withOpacity(0.9), Colors.grey.withOpacity(0.1)],
                          )),
                        )
              ),*/
              Positioned(
                left: 0,
                bottom: 0,
                right: 0,
                top: 0,
                child: AnimatedContainer(
                  padding: EdgeInsets.all(0),
                  key: Key(content.cod),
                  duration: Duration(seconds: 2),
                  decoration: BoxDecoration(
                      color: _userstate.user.position < content.position &&
                              _userstate.user.stagenumber <= content.stagenumber
                          ? Colors.grey.withOpacity(0.6)
                          : Colors.transparent),
                  curve: Curves.fastOutSlowIn,
                ),
              ),
            ],
          ),
        )
        );
      });
    
    
    
    //lessons.length > 0 ? Container(child: Text('hello'), height: Configuration.height*0.1, width: Configuration.width*0.5) : Text('There are no lessons');
          
  }

  @override
  Widget build(BuildContext context) {
    _userstate = Provider.of<UserState>(context);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back,
              size: Configuration.tabletsmicon, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        height: Configuration.height,
        width: Configuration.width,
        color: Configuration.lightgrey,
        padding: EdgeInsets.only(top:Configuration.height*0.07,left:16.0,right:16.0,bottom: 16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: Configuration.width*0.3,
              child: Column(
                children: [
                  Container(
                  height: Configuration.height* 0.4,
                  width: Configuration.width,
                  padding: EdgeInsets.all(16.0),
                  child: Text('Stage ' + widget.stage.stagenumber.toString(), style: Configuration.tabletText('small', Colors.white),),
                  decoration: BoxDecoration(
                      color: Configuration.maincolor,
                      borderRadius: BorderRadius.circular(12.0)),
                  ),
                  Text('Filter',
                      style: Configuration.tabletText('tiny', Colors.black),
                    ),
                    OutlinedButton(
                      onPressed: () => setState(
                          () => filter.contains('all') ? '' : filter = ['all']),
                      child: Icon(Icons.more_vert,
                          color: filter.contains('all')
                              ? Colors.white
                              : Colors.black.withOpacity(0.5)),
                      style: ButtonStyle(
                        backgroundColor: filter.contains('all')
                            ? MaterialStateProperty.all<Color>(
                                Configuration.maincolor)
                            : null,
                      ),
                    ),
                    OutlinedButton(
                      onPressed: () => setState(() {
                        filter.contains('lesson') ? '' : filter = ['lesson'];
                      }),
                      child: Icon(Icons.book,
                          color: filter.contains('lesson')
                              ? Colors.white
                              : Colors.black.withOpacity(0.5)),
                      style: ButtonStyle(
                        backgroundColor: filter.contains('lesson')
                            ? MaterialStateProperty.all<Color>(
                                Configuration.maincolor)
                            : null,
                      ),
                    ),
                    OutlinedButton(
                      onPressed: () => setState(() =>
                          filter.contains('meditation')
                              ? ''
                              : filter = ['meditation']),
                      child: Icon(Icons.self_improvement,
                          color: filter.contains('meditation')
                              ? Colors.white
                              : Colors.black.withOpacity(0.5)),
                      style: ButtonStyle(
                        backgroundColor: filter.contains('meditation')
                            ? MaterialStateProperty.all<Color>(
                                Configuration.maincolor)
                            : null,
                      ),
                    ),


                ],
              ),
            ),
            Expanded(child: getLessons(context))
          ],
        ),
      ),
    );
  }
}

class TabletContentView extends StatefulWidget {
  Content content;
  Meditation meditation;
  Lesson lesson;
  NetworkImage slider;

  TabletContentView({this.content, this.lesson, this.meditation, this.slider});
  
  @override
  _TabletContentViewState createState() => _TabletContentViewState();
}

class _TabletContentViewState extends State<TabletContentView> {
  int _index = -1;
  var _userstate;
  Map<int, NetworkImage> textimages = new Map();
  var reachedend = false;
  List balls = new List.empty(growable: true);

  Widget portada() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
      Hero(tag: widget.content.cod, 
        child: Container(
          width: Configuration.width*0.4, 
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(16.0)), 
          child: Image(image: widget.slider)
          )
      ),
      Expanded(
        child: Container(
          height: Configuration.height,
          color: Configuration.lightgrey,
          padding: EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
                  Text(widget.content.title,
                      style: Configuration.tabletText('small', Colors.black)),
                  SizedBox(height: Configuration.height*0.01),
                  Text(widget.lesson.description,
                      style: Configuration.tabletText('tiny', Colors.grey)),
                  SizedBox(height: Configuration.height*0.05),
                  TabletStartButton(
                    onPressed: () async{
                        setState(() => _index = 0);
                    } 
                  )
            ],
          ),
        ),
      )
    ]);
  }

  Widget vistaLeccion() {

    Widget vistaSlide(slide) {
      return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                slide['image'] != null && slide['image'] != '' ? Image.network(slide["image"], width: Configuration.width*0.4) : Container(),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(16.0),
                    child: Text(slide["text"], style: Configuration.tabletText('tiny', Colors.black, font: 'Helvetica')),
                    ),
                )
            ]),
            SizedBox(height: 30),
            AnimatedOpacity(
              opacity: reachedend ? 1.0 : 0.0, 
              duration: Duration(seconds: 4),
              child: Container(
                width: Configuration.width*0.3,
                child: AspectRatio(
                  aspectRatio: 9/2,
                  child: ElevatedButton(
                      onPressed: () async {
                      await _userstate.takeLesson(widget.lesson);
                      Navigator.pop(context, true);
                    },
                    style: ElevatedButton.styleFrom(
                      primary: Configuration.maincolor,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32.0)),
                    ), 
                    child: Text(
                      'Finish',
                      style: Configuration.tabletText('tiny', Colors.white),
                    )
                  ),
                ),
              ),
            )
          ],
        );

    }
    
    return CarouselSlider.builder(
        itemCount: widget.lesson.text.length,
        itemBuilder: (context, index) {
          return Container(
            width: Configuration.width,
            height: Configuration.height,
            color: Configuration.lightgrey,
            padding: EdgeInsets.all(32),
            child: vistaSlide(widget.lesson.text[index]),
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
                _index = index ;
                if (_index == widget.lesson.text.length - 1) {
                  setState(()=> reachedend = true);
                }
              });
            }));
  }

  @override
  void initState() {
    super.initState();
    _index = -1;
  }

  @override
  void didChangeDependencies() {
    var configuration = createLocalImageConfiguration(context);

    widget.lesson.text.forEach((slide) {
      if (slide['image'] != null) {
        new NetworkImage(slide['image'])..resolve(configuration);
      }
    });
  
    var count = 0;

    for(var lesson in widget.lesson.text){
      balls.add(count++);
    }

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    _userstate = Provider.of<UserState>(context);

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: IconButton(
              icon: Icon(Icons.close, size: Configuration.tabletsmicon, color: Colors.black),
              onPressed: () => Navigator.pop(context)
              ),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        extendBodyBehindAppBar: true,
        body: _index == -1
            ? portada()
            : Stack(children: [
                vistaLeccion(),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    margin: EdgeInsets.all(Configuration.smmargin),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: balls.map((index) {
                        return Container(
                          width: Configuration.safeBlockHorizontal * 2,
                          height: Configuration.safeBlockHorizontal * 2,
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
*/