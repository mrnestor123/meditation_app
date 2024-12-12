
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:meditation_app/presentation/mobx/actions/game_state.dart';
import 'package:meditation_app/presentation/mobx/actions/user_state.dart';
import 'package:meditation_app/presentation/pages/commonWidget/page_title.dart';
import 'package:meditation_app/presentation/pages/config/configuration.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

import '../../../domain/entities/content_entity.dart';
import './meditation_screen.dart';




class SelectGame extends StatefulWidget {
  SelectGame({Key key}) : super(key: key);

  @override
  State<SelectGame> createState() => _SelectGameState();
}

class _SelectGameState extends State<SelectGame> {
  @override
  Widget build(BuildContext context) {
    final _gamestate = Provider.of<GameState>(context);
    final _userstate = Provider.of<UserState>(context);

    return Column(
      children: [
        SizedBox(height: Configuration.verticalspacing),
        pageTitle(
          'Test your attention and awareness',
          'Test your attention and awareness', 
          Icons.gamepad
        ),

        
        SizedBox(height: Configuration.verticalspacing),
        Container(
            margin: EdgeInsets.symmetric(horizontal: Configuration.smpadding),
            child: GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: _userstate.data.games.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: Configuration.crossAxisCount
              ), 
              itemBuilder: (context,index) {
                Game game = _userstate.data.games[index];
                var _blocked = _userstate.user.isGameBlocked(game);
                var gamebefore = _userstate.data.games[game.position == 0 ? 0 : game.position-1];

                return ClickableSquare(
                  text: game.title,
                  image: game.image,
                  onTap: (){
                    _gamestate.selectgame(game);
                    _gamestate.startgame();
                    Navigator.pushNamed(context,'/gamestarted').then((value) => setState(()=>{}));
                  },
                  blocked: _blocked,
                  blockedtext: 'Complete '+ gamebefore.title,
                );            
              }),
          ),
      ],
    );
    }
}



class GameScreen extends StatelessWidget {
  const GameScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}



class GameStarted extends StatefulWidget {
  @override
  _GameStartedState createState() => _GameStartedState();
}

class _GameStartedState extends State<GameStarted> {
  VideoPlayerController controller;
  GameState _gamestate;
  UserState _userstate;
  bool started = false;
  bool fullscreen = false;
  int lastsecond;
  bool loadingVideo = false;

  @override
  void initState() {
    super.initState();
  }

  @override 
  void didChangeDependencies(){
    super.didChangeDependencies();
    _gamestate = Provider.of<GameState>(context);
    loadingVideo = true;
    controller = new VideoPlayerController.network(_gamestate.selectedgame.video)..initialize().then(((value) => 
      // HAY UN PROBLEMA SI SE SALE MIENTRAS ESTA LOADEANDO
      setState(() {
        loadingVideo = false;
      })
    ));

    lastsecond= 0;
    controller.addListener(() {
      //QUITAR ESTOS SET STATE !!!!!!!!!!!!!!!!!!!!!
      if(lastsecond != controller.value.position.inSeconds){
        setState(() {});
      }

      if(controller.value.duration.inSeconds > 0 && started && controller.value.position == controller.value.duration) {
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
    bool showfullscreen = false;  //MediaQuery.of(context).orientation == Orientation.landscape || fullscreen;
    
    Widget video(){
      return GestureDetector(
        onTap: ()=> {
          if(!loadingVideo){
            setState((){started = true; controller.play();})
          }
        },
        child: Container(
          //height: showfullscreen ? Configuration.height : Configuration.width / controller.value.aspectRatio,
         // width:!showfullscreen ? Configuration.width : Configuration.height * controller.value.aspectRatio,
         // ESTO ESTA BIEN ???
          height: Configuration.width / controller.value.aspectRatio,
          width: Configuration.height * controller.value.aspectRatio,
          child: Stack(children:[
            VideoPlayer(controller),
            !started && !controller.value.isPlaying && !loadingVideo ? 
            Positioned.fill(
                child: Container(
                  color: Colors.black.withOpacity(0.9),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Press to start', 
                        style: Configuration.text('subtitle', Colors.white)
                      ),
                      SizedBox(height: Configuration.verticalspacing/3),
                      Text("Be sure you are focused. You won't be able to pause it", 
                        style:Configuration.text('small',Colors.white)
                      ),
                      SizedBox(height: Configuration.verticalspacing),
                      Icon(Icons.play_arrow, color:Colors.white, size: Configuration.bigicon), 
                        
                    ],
                  ),
                )
              ) : Container(),

              loadingVideo ? 
              Positioned.fill(
                child: Container(
                  color: Colors.black.withOpacity(0.9),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Loading video...', 
                        style: Configuration.text('medium', Colors.white)
                      ),
                      SizedBox(height: Configuration.verticalspacing/3),
                      CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      )
                    ],
                  ),
                )
              ) : Container(),
 

            /* Positioned(
              right: 0,
              bottom: 0,
              child: IconButton(
                onPressed: ()=> setState(() {
                  fullscreen = !fullscreen;
                  if(fullscreen){
                    SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);
                  }else{
                    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
                  }
                }), 
                icon: Icon(showfullscreen ? Icons.close : Icons.fullscreen, color: Colors.white, size: Configuration.smicon))
              )*/
          ] ),
        )
      );
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Try to be aware of as many things as possible', 
        style: Configuration.text('smallmedium', Colors.black),
        textAlign: TextAlign.center,
        ),
        SizedBox(height: 20),


        /*showfullscreen ? 
        Positioned.fill(
          child: Container(
            color: Colors.black,
          ),
        ):Container(),
        */
        video(),

       

        Container(
          padding: EdgeInsets.all(10.0),
          width: showfullscreen? Configuration.width *0.5: Configuration.width,
          child: Slider(
            activeColor: Configuration.maincolor,
            inactiveColor: Colors.grey,
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
      l.add(Container(
        padding: EdgeInsets.all(6.0),
        child: Text( _gamestate.selectedquestion.question, 
        textAlign: TextAlign.center,
        style: Configuration.text('medium', Colors.black)))
      );

      l.add(SizedBox(height: Configuration.verticalspacing));
      
      for(int i = 0; i < _gamestate.selectedquestion.options.length;i++){
        dynamic option = _gamestate.selectedquestion.options[i];
        l.add(Container(
          margin: EdgeInsets.all(6.0),
          width: Configuration.width*0.9,
          child: OutlinedButton(
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.all(Configuration.smpadding),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Configuration.borderRadius)),
              primary: _gamestate.state ==_gamestate.question_answered && _gamestate.selectedanswer == i ? _gamestate.success ? Colors.green : Colors.red : Colors.white,
              elevation: 0.0
            ),
            onPressed: () => {
              _gamestate.state != _gamestate.question_answered ? _gamestate.userAnswer(i,_userstate.user) : null,
              setState(()=> {
              })
            },
            child: Text(option,style: Configuration.text('small', _gamestate.state == _gamestate.question_answered && _gamestate.selectedanswer == i  ? Colors.white : Colors.black)),  
          ),
        ));
      }

      return l;
    }

    return Stack(
        children: [
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            margin: EdgeInsets.only(bottom:Configuration.verticalspacing*3),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text('Questions right', style: Configuration.text('smallmedium', Colors.black)),
                Text(_gamestate.answeredquestions.length.toString()  + '/'+  _gamestate.selectedgame.questions.length.toString(),
                  style: Configuration.text('medium',Colors.black),
                )
              ],
            ),
          ),
        ),
        SizedBox(height: 10),
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: getQuestions()
          ),
        )
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
            Text('Questions answered', style: Configuration.text('medium', Colors.grey)),
            SizedBox(width: 10),
            Text(_gamestate.answeredquestions.length.toString()  + '/'+  _gamestate.selectedgame.questions.length.toString(),style: Configuration.text('medium', Colors.black))
          ]),
          SizedBox(height: 15),
          !_gamestate.success ? 
          Text('''You failed!.\n But don't worry you can try it again''', textAlign: TextAlign.center, style: Configuration.text('smallmedium', Colors.black)):
          Text('Good job you answered right !', style: Configuration.text('smallmedium', Colors.black))
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    _userstate = Provider.of<UserState>(context);
  
    return Scaffold(
          extendBodyBehindAppBar: true,
          backgroundColor: Configuration.lightgrey,
          appBar: AppBar(
            systemOverlayStyle: SystemUiOverlayStyle(
              // Status bar color
              statusBarColor: Configuration.lightgrey, 
              // Status bar brightness (optional)
              statusBarIconBrightness: Brightness.dark, // For Android (dark icons)
              statusBarBrightness: Brightness.light, // For iOS (dark icons)
            ),
            elevation: 0,
            backgroundColor: Colors.transparent,
            leading: IconButton(
              iconSize: Configuration.smicon,
              icon: Icon(Icons.close) , 
              onPressed: () { 
                Navigator.pop(context); 
              }, color: Colors.black),
          ),
          body: Observer(
            builder: (context) {
              return  _gamestate.state == _gamestate.question_ask || _gamestate.state == _gamestate.question_answered 
                ? questionAsk()
                : _gamestate.state == _gamestate.finished 
                ? questionSolved():
                showingVideo();
            }
          )
    );
  }
}