
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:meditation_app/presentation/mobx/actions/game_state.dart';
import 'package:meditation_app/presentation/mobx/actions/user_state.dart';
import 'package:meditation_app/presentation/pages/commonWidget/start_button.dart';
import 'package:meditation_app/presentation/pages/config/configuration.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

class GameScreen extends StatefulWidget {
  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  UserState _userstate;

  GameState _gamestate;

  List<Widget> games() {   
    List<Widget> g = new List.empty(growable: true);
    for(var element in _userstate.data.stages[0].games){
      g.add(
        Column(
          children: [
            GestureDetector(
                onTap: ()=> setState(()=> _gamestate.selectgame(element)),
                child: Container(
                decoration: BoxDecoration(border: _gamestate.selectedgame != null && _gamestate.selectedgame.cod == element.cod ? Border.all(color: Configuration.maincolor): Border()),
                width: Configuration.width*0.3,
                child: AspectRatio(
                  aspectRatio: 1/1,
                  child: Container( 
                    margin: EdgeInsets.all(Configuration.tinpadding),
                    decoration: BoxDecoration(color: Colors.grey))),
              ),
            ),
            Text(element.title, style: Configuration.text('small',Colors.black),)
          ],
        )
    );

    return g;
    }
  }

  @override
  Widget build(BuildContext context) {
    _gamestate = Provider.of<GameState>(context);
    _userstate = Provider.of<UserState>(context);
    return Container(
      height: Configuration.height,
      width: Configuration.width,
      color: Configuration.lightgrey,
      padding: EdgeInsets.symmetric(horizontal: Configuration.medpadding),
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: Configuration.height * 0.025),
            Text('Concentration games', style: Configuration.text('medium', Colors.black),),
            SizedBox(height: Configuration.height*0.05),
            Container(
              height: Configuration.height * 0.4,
              child: Column(
                children: games(),
                ), 
            ),
            StartButton(
              onPressed: () { 
                _gamestate.startgame();
                Navigator.pushNamed(context,'/gamestarted');
              },
            )
        ]),
      )
    );
  }
}


class GameStarted extends StatefulWidget {
  @override
  _GameStartedState createState() => _GameStartedState();
}

class _GameStartedState extends State<GameStarted> {
  TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var _gamestate = Provider.of<GameState>(context);

    return Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            leading: IconButton(icon: Icon(Icons.close) , onPressed: ()=> Navigator.pop(context), color: Colors.black),
          ),
          body: Container(
          height: Configuration.height,
          child: Container(
          height: Configuration.height,
          width: Configuration.width,
          color: Configuration.lightgrey,
          padding: EdgeInsets.symmetric(horizontal: Configuration.medpadding),
          child: Observer(builder: (context) =>
            _gamestate.state == 'question' ?
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                Text(_gamestate.selectedquestion.question, style: Configuration.text('medium', Colors.black)),
                SizedBox(height: Configuration.height*0.03),
                TextField( controller: _controller),
                ElevatedButton(
                  onPressed: ()=> _gamestate.userAnswer(_controller.text), 
                  child: Text('Submit',style:Configuration.text('medium', Colors.white)),
                  style: ElevatedButton.styleFrom(
                    primary: Configuration.maincolor
                  )
                  )
              ])
            : _gamestate.state == 'answer' ?
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children:[
                    !_gamestate.success ? 
                  Icon(Icons.error, color: Colors.red):
                  Icon(Icons.done, color:Colors.green),
                  SizedBox(height: Configuration.height*0.05),
                  !_gamestate.success ? 
                  Text('''You failed!.\n But don't worry you can try it again''', textAlign: TextAlign.center, style: Configuration.text('medium', Colors.black)):
                  Text('Good job you answered right !', style: Configuration.text('medium', Colors.black)),
                
                ])  
            : Center(
              child: AspectRatio(aspectRatio: _gamestate.controller.value.aspectRatio,
              child: Stack(
                children: [
                  VideoPlayer(                  
                    _gamestate.controller
                  ),
                  !_gamestate.started ? Align(
                    alignment: Alignment.center,
                    child: IconButton(icon: Icon(Icons.play_arrow), color: Colors.white, onPressed: ()=> setState(()=> _gamestate.play()), iconSize: Configuration.bigicon)
                    ) : Container(),
                ],
              )
              ),
            )
          )
          )
      ),
    );
  }
}