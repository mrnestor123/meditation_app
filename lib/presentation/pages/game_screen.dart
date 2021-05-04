
import 'package:flutter/material.dart';
import 'package:meditation_app/presentation/mobx/actions/user_state.dart';
import 'package:meditation_app/presentation/pages/commonWidget/start_button.dart';
import 'package:meditation_app/presentation/pages/config/configuration.dart';
import 'package:provider/provider.dart';

class GameScreen extends StatelessWidget {
    UserState _userstate;
  
    List<Widget> games() {   
      List<Widget> g = new List.empty(growable: true);
      
      for(var element in _userstate.data.stages[0].games){
        g.add(
          Column(
            children: [
              Container(
                width: Configuration.width*0.3,
                child: AspectRatio(
                  aspectRatio: 1/1,
                  child: Container(decoration: BoxDecoration(color: Colors.grey))),
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
            Container(
              height: Configuration.height * 0.4,
              child: Column(
                children: games(),
                ), 
            ),
            StartButton(
              onPressed: () => Navigator.pushNamed(context,'/gamestarted'),
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
  @override
  Widget build(BuildContext context) {
    return Container(
        height: Configuration.height,
        child: Container(
        height: Configuration.height,
        width: Configuration.width,
        color: Configuration.lightgrey,
        padding: EdgeInsets.symmetric(horizontal: Configuration.medpadding),
        child: SingleChildScrollView(
        )
        )
    );
  }
}