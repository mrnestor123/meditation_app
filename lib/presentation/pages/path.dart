import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meditation_app/domain/entities/stage_entity.dart';
import 'package:meditation_app/presentation/mobx/actions/user_state.dart';
import 'package:meditation_app/presentation/pages/commonWidget/stage_dialog.dart';
import 'package:meditation_app/presentation/pages/config/configuration.dart';
import 'package:provider/provider.dart';

import 'commonWidget/back_button.dart';

class ImagePath extends StatefulWidget {
  Stage stage;


  ImagePath({this.stage});

  @override
  State<ImagePath> createState() => _ImagePathState();
}

class _ImagePathState extends State<ImagePath> {
  ScrollController scrollController = new ScrollController(
    initialScrollOffset: Configuration.height,
  );

  bool pushedDialog = false;

  @override
  Widget build(BuildContext context) {
    final _userstate = Provider.of<UserState>(context);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
         systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor:   pushedDialog ? Colors.black.withOpacity(0.01): Color.fromRGBO(220,208, 186, 1), 
          statusBarIconBrightness: Brightness.dark, // For Android (dark icons)
          statusBarBrightness: Brightness.light, // For iOS (dark icons)
        ),
        
        bottom: PreferredSize(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal:Configuration.smpadding),
            child: Text(widget.stage.description, textAlign: TextAlign.center, style: Configuration.text('small', Colors.black)),
          ), 
          preferredSize: Size.fromHeight(Configuration.width > 500 ? 60: 20)
        ),
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: Text('Stage ' + widget.stage.stagenumber.toString(), style: Configuration.text('subtitle', Colors.black)),
        actions: [
          IconButton(
            onPressed: (){
              pushedDialog = true;
              setState(() {});
              stageDialog(context, widget.stage).then((v)=> setState(()=> pushedDialog = false));
            }, 
            icon: Icon(Icons.info),
            color: Colors.black,
            iconSize: Configuration.smicon,
          )
        ],
        elevation: 0,
        leading: ButtonBack(color: Colors.black)
      ),
      backgroundColor: Color.fromARGB(255,220,208,186),
      body: Stack(
        children: <Widget>[
          Image(
            image: CachedNetworkImageProvider(widget.stage != null ? widget.stage.longimage : _userstate.user.stage.longimage) ,
            width: Configuration.width,
            height: Configuration.height
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
                image: CachedNetworkImageProvider(_userstate.user.stage.longimage) ,
                width: Configuration.width,
                height: Configuration.height,
              ),
            ),
          ),
          //Place it at the top, and not use the entire screen
          Positioned(
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








