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
import 'package:provider/provider.dart';

class LearnScreen extends StatelessWidget {
  LearnScreen();

  @override
  Widget build(BuildContext context) {
    final _userstate = Provider.of<UserState>(context);
    return Column(
      children: [
        SizedBox(height: Configuration.height * 0.05),
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
                          )
                        : null,
                    child: Stack(
                      children: [
                        Container(
                          margin: EdgeInsets.all(Configuration.smmargin),
                          decoration: BoxDecoration(
                              color: Configuration.accentcolor,
                              borderRadius: BorderRadius.circular(16.0)),
                          child: Center(
                              child: Text(
                            'Stage ' +
                                _userstate.data.stages[index].stagenumber
                                    .toString(),
                            style: Configuration.text("medium", Colors.white),
                          )),
                        ),
                        _userstate.user.stagenumber > index
                            ? Container()
                            : Container(
                                margin: EdgeInsets.all(Configuration.smmargin),
                                decoration: BoxDecoration(
                                    color: Colors.grey.withOpacity(0.6),
                                    borderRadius: BorderRadius.circular(16.0)),
                              ),
                      ],
                    ),
                  );
                }))
      ],
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

  var filter = ['lesson', 'meditation'];

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
        if (filter.contains(content.type)) {
          lessons.add(GestureDetector(
            onTap: () {
              if (_userstate.user.position >= int.parse(key)) {
                if (content.type == 'meditation') {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ContentView(
                              meditation: content,
                              content: content,
                              slider: image)));
                } else {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ContentView(
                              content: content,
                              lesson: content,
                              slider: image)));
                }
              }
            },
            child: Container(
              height: Configuration.height * 0.1,
              margin: EdgeInsets.all(Configuration.medmargin),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(16)),
              child: Stack(
                children: [
                  Positioned(
                      top: 0,
                      right: 0,
                      child: Padding(
                        padding: EdgeInsets.all(Configuration.smpadding),
                        child: Container(
                          width: Configuration.safeBlockHorizontal * 5,
                          height: Configuration.safeBlockHorizontal * 5,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: content.type == 'meditation'
                                  ? Colors.green
                                  : Colors.yellow),
                        ),
                      )),
                  Positioned(
                      left: 0,
                      bottom: 0,
                      child: Padding(
                        padding: EdgeInsets.all(Configuration.smpadding),
                        child: Text(
                          content.title,
                          style: Configuration.text(
                              "tiny", Colors.black, "bold", 1),
                        ),
                      )),
                  _userstate.user.position < int.parse(key)
                      ? Positioned(
                          left: 0,
                          bottom: 0,
                          top: 0,
                          right: 0,
                          child: Container(
                              height: Configuration.height * 0.1,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  gradient: LinearGradient(
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.topCenter,
                                    colors: [
                                      Colors.grey.withOpacity(0.6),
                                      Colors.grey.withOpacity(0.6)
                                    ],
                                  ))))
                      : Container()
                ],
              ),
            ),
          ));
        }
      }
    });

    return Container(
      padding: EdgeInsets.all(Configuration.smpadding),
      child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: lessons),
    );
  }

  @override
  Widget build(BuildContext context) {
    _userstate = Provider.of<UserState>(context);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Stage ' + widget.stage.stagenumber.toString(),
            style: Configuration.text('big', Colors.white)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, size: Configuration.smicon),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Configuration.maincolor,
        elevation: 0,
      ),
      body: Container(
        height: Configuration.height,
        width: Configuration.width,
        color: Configuration.maincolor,
        child: Column(
          children: [
            Container(
              height: Configuration.height * 0.2,
              width: Configuration.width,
              margin: EdgeInsets.only(
                  left: Configuration.smmargin,
                  right: Configuration.smmargin,
                  top: Configuration.medmargin,
                  bottom: Configuration.bigmargin),
              decoration: BoxDecoration(
                  color: Configuration.darkpurple,
                  borderRadius: BorderRadius.circular(12.0)),
            ),
            Container(
                padding:
                    EdgeInsets.symmetric(horizontal: Configuration.medpadding),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Filter',
                      style: Configuration.text('small', Colors.white),
                    ),
                    SizedBox(width: Configuration.width * 0.05),
                    OutlinedButton(
                      onPressed: () => setState(() => filter.contains('lesson')
                          ? filter.remove('lesson')
                          : filter.add('lesson')),
                      child: Text('Lesson',
                          style: Configuration.text(
                              'small',
                              filter.contains('lesson')
                                  ? Colors.black
                                  : Colors.black.withOpacity(0.5))),
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
                              ? filter.remove('meditation')
                              : filter.add('meditation')),
                      child: Text('Meditation',
                          style: Configuration.text(
                              'small',
                              filter.contains('meditation')
                                  ? Colors.black
                                  : Colors.black.withOpacity(0.5))),
                      style: ButtonStyle(
                        backgroundColor: filter.contains('meditation')
                            ? MaterialStateProperty.all<Color>(Colors.white)
                            : null,
                      ),
                    ),
                  ],
                )),
            Divider(
              color: Colors.white,
            ),
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
  int _index = 0;
  var _userstate;
  Map<int, NetworkImage> textimages = new Map();

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
                  onTap: () => setState(() => _index = 1),
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
            height: Configuration.height,
            color: Configuration.lightpurple,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.network(
                  widget.lesson.text[index]["image"],
                  width: Configuration.width,
                ),
                Container(
                    width: Configuration.width,
                    padding: EdgeInsets.all(Configuration.smpadding),
                    child: Center(
                        child: Text(widget.lesson.text[index]["text"],
                            style: Configuration.text('small', Colors.white))))
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
              if (index == widget.lesson.text.length - 1) {
                setState(() {
                  _index = 2;
                });
              } else {
                if (_index == 2 && index < widget.lesson.text.length - 1) {
                  setState(() {
                    _index = 1;
                  });
                }
              }
            }));
  }

  @override
  void initState() {
    super.initState();

    _index = 0;
  }

  @override
  Widget build(BuildContext context) {
    _userstate = Provider.of<UserState>(context);
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              icon: Icon(Icons.close, size: Configuration.smicon),
              onPressed: () => Navigator.pop(context)),
          backgroundColor: Colors.transparent,
          actions: [
            _index == 2
                ? IconButton(
                    icon: Icon(Icons.check_circle),
                    onPressed: () async {
                      await _userstate.takeLesson(widget.lesson);
                      Navigator.pop(context);
                    })
                : Container()
          ],
          elevation: 0,
        ),
        extendBodyBehindAppBar: true,
        body: _index == 0 ? portada() : vistaLeccion());
  }
}
