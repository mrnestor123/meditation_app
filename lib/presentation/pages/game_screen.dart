
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:meditation_app/presentation/mobx/actions/game_state.dart';
import 'package:meditation_app/presentation/mobx/actions/user_state.dart';
import 'package:meditation_app/presentation/pages/config/configuration.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';


class GameStarted extends StatefulWidget {
  @override
  _GameStartedState createState() => _GameStartedState();
}

class _GameStartedState extends State<GameStarted> {
  VideoPlayerController controller;
  GameState _gamestate;
  UserState _userstate;
  bool started = false;
  int lastsecond;

  @override
  void initState() {
    super.initState();
  }

  @override 
  void didChangeDependencies(){
    super.didChangeDependencies();
    _gamestate = Provider.of<GameState>(context);
    controller = new VideoPlayerController.network(_gamestate.selectedgame.video)..initialize();
    lastsecond= 0;
    controller.addListener(() {
      if(lastsecond != controller.value.position.inSeconds){
        setState(() {});
      }

      if(started && controller.value.position == controller.value.duration) {
        setState(() {
          _gamestate.finishvideo();          
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  Widget showingVideo(){
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Stack(
            children: [
        GestureDetector(
          onTap: ()=> {
            if(controller.value.isPlaying){
              setState((){controller.pause();})
            }else{
              setState((){started = true; controller.play();})
            }
          },
          child: AspectRatio(
                aspectRatio: controller.value.aspectRatio,
                child: VideoPlayer(                  
                  controller
                ),
        )),
          !started || !controller.value.isPlaying ? 
          Positioned.fill(
            child: Align(
                alignment: Alignment.center,
                child: IconButton(
                  icon: Icon(Icons.play_arrow), 
                  color: Colors.white, 
                  onPressed: ()=> setState((){ started = true; controller.play();}), 
                  iconSize: Configuration.medicon
                  )
              ),
          ) : Container(),
            
            Positioned(
              right: 0,
              bottom: 0,
              child: IconButton(
                onPressed: ()=> null, 
                icon: Icon(Icons.fullscreen, color: Colors.white, size: Configuration.smicon))
              )
        ],
        ),
      
        Container(
          width: Configuration.width*0.8,
          child: Slider(
            max: controller.value.duration.inSeconds.roundToDouble(),
            value:controller.value.position.inSeconds.roundToDouble(), 
            onChanged: (double){}
            ),
        ), 
      ],
    );
  }

  Widget questionAsk(){
    List<Widget> getQuestions(){
      List<Widget> l = new List.empty(growable: true);
      for(var option in _gamestate.selectedquestion.options){
        int index =  _gamestate.selectedquestion.options.indexOf(option);
        l.add(Container(
          margin: EdgeInsets.all(6.0),
          width: Configuration.width*0.9,
          child: OutlinedButton(
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.all(12.0),
              shape: RoundedRectangleBorder(),
              primary: _gamestate.state =='answer' && _gamestate.selectedanswer == index ? _gamestate.success ? Colors.green : Colors.red : Colors.white,
              elevation: 0.0
            ),
            onPressed: () => {
              setState(()=> {
                _gamestate.state != 'answer' ? 
              _gamestate.userAnswer(index,_userstate.user) : 
              null
              })
            },
            child: Text(option,style: Configuration.text('small', _gamestate.state =='answer' && _gamestate.selectedanswer == index  ? Colors.white : Colors.black)),  
          ),
        ));
      }

      return l;
    }

    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text('Questions right'),
            Text(_gamestate.answeredquestions.length.toString()  + '/'+  _gamestate.selectedgame.questions.length.toString())
          ],
        ),
        SizedBox(height: 10),
        Text(
          _gamestate.selectedquestion.question, 
          style: Configuration.text('medium', Colors.black)
        ),
        SizedBox(height: Configuration.height * 0.03),
        Column(children: getQuestions()),
      ]);
  }

  Widget questionSolved(){
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
          !_gamestate.success ? Icon(Icons.error, color: Colors.red, size: Configuration.medicon): Icon(Icons.done, color:Colors.green, size: Configuration.medicon),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
            Text('Questions answered', style: Configuration.text('small', Colors.grey)),
            SizedBox(width: 10),
            Text(_gamestate.answeredquestions.length.toString()  + '/'+  _gamestate.selectedgame.questions.length.toString(),style: Configuration.text('medium', Colors.black))
          ]),
          SizedBox(height: 15),
          !_gamestate.success ? 
          Text('''You failed!.\n But don't worry you can try it again''', textAlign: TextAlign.center, style: Configuration.text('small', Colors.black)):
          Text('Good job you answered right !', style: Configuration.text('small', Colors.black))
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    _userstate = Provider.of<UserState>(context);

    return Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            leading: IconButton(icon: Icon(Icons.close) , 
              onPressed: () { 
                Navigator.pop(context); 
              }, color: Colors.black),
          ),
          body: Container(
          height: Configuration.height,
          width: Configuration.width,
          color: Configuration.lightgrey,
          padding: EdgeInsets.symmetric(horizontal: Configuration.medpadding),
          child: _gamestate.state == 'question' ? 
            questionAsk()
            :  _gamestate.state == 'answer' ? 
            questionSolved():
            showingVideo()
          ),
    );
  }
}