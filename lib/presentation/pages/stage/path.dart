import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:meditation_app/domain/entities/stage_entity.dart';
import 'package:meditation_app/presentation/mobx/actions/user_state.dart';
import 'package:meditation_app/presentation/pages/commonWidget/dialog.dart';
import 'package:meditation_app/presentation/pages/commonWidget/stage_dialog.dart';
import 'package:meditation_app/presentation/pages/config/configuration.dart';
import 'package:meditation_app/presentation/pages/requests_screen.dart';
import 'package:provider/provider.dart';

class ImagePath extends StatelessWidget {
  ScrollController scrollController = new ScrollController(
    initialScrollOffset: Configuration.height,
  );
  
  Stage stage;

  ImagePath({this.stage});

  @override
  Widget build(BuildContext context) {
    final _userstate = Provider.of<UserState>(context);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        bottom: PreferredSize(
          child:Flexible(child: Text(stage.description, style: Configuration.text('small', Colors.black))), 
          preferredSize: Size.fromHeight(20)
        ),
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: Text('Stage ' + stage.stagenumber.toString(), style: Configuration.text('medium', Colors.black)),
        actions: [
          IconButton(onPressed: ()=> stageDialog(context, stage)
          , icon: Icon(Icons.info),color: Colors.black,)
        ],
        elevation: 0,
        leading: ButtonBack()
      ),
      backgroundColor: Color.fromARGB(255,220,208,186),
      body: Stack(
        children: <Widget>[
          SingleChildScrollView(
            child: Image(
              image: NetworkImage(stage != null? stage.longimage : _userstate.user.stage.longimage) ,
              width: Configuration.width,
              height: Configuration.height,
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Column(
              children: [
                SizedBox(height: 15),
               
              ],
            ),
          ),
          
        ],
      ),
    );
  }
}


class TabletImagePath extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final _userstate = Provider.of<UserState>(context);

    return Scaffold(
      body: Stack(
        children: <Widget>[
          SingleChildScrollView(
            child: SizedBox(
              width: Configuration.width,
              height: Configuration.height,
              child: Image(
                image: NetworkImage(_userstate.user.stage.longimage) ,
                width: Configuration.width,
                height: Configuration.height,
              ),
            ),
          ),
          Positioned(
            //Place it at the top, and not use the entire screen
            top: 0.0,
            left: 0.0,
            right: 0.0,
            child: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                icon: Icon(Icons.arrow_back,
                    size: Configuration.tabletsmicon, color: Colors.black),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}








