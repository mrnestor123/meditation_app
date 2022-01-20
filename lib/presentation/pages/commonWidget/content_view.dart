
// WIDGET COMÚN DE VISTA DE CONTENIDO
// SE PODRÁN VER LECCIONES Y MEDITACIONES, Y EDITAR 
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:meditation_app/domain/entities/content_entity.dart';
import 'package:meditation_app/domain/entities/lesson_entity.dart';
import 'package:meditation_app/domain/entities/meditation_entity.dart';
import 'package:meditation_app/presentation/mobx/actions/meditation_state.dart';
import 'package:meditation_app/presentation/pages/commonWidget/alert_dialog.dart';
import 'package:meditation_app/presentation/pages/commonWidget/file_helpers.dart';
import 'package:meditation_app/presentation/pages/commonWidget/start_button.dart';
import 'package:meditation_app/presentation/pages/config/configuration.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';


class ContentShow extends StatefulWidget {
  Content content;
  Meditation m;
  Lesson l;

  //NO ESTOY MUY SEGURO DE ESTO !!!
  ContentShow({this.content, this.m, this.l}) : super();

  @override
  _ContentShowState createState() => _ContentShowState();
}

/*
  SE PODRÁ VER MEDITACIONES,LECCIONES Y EDITARLAS
*/
class _ContentShowState extends State<ContentShow> {

  bool started = false;

  bool isMeditation;

  String type;
  AssetsAudioPlayer player = new AssetsAudioPlayer();
  VideoPlayerController controller;
  bool initialized = false;

  String text = '';

  MeditationState _meditationstate;

  @override
  void didChangeDependencies(){
    super.didChangeDependencies();

    if(widget.content.isMeditation()){
      isMeditation = true;
      text = 'This meditation will not count';
      type = 'Meditation';
    }else{
      text = "This lesson will not count as a read one";
      isMeditation = false;
      type = 'Lesson';
    }
  }

  Widget portada({Content c}) {
    return Column(children: [
      widget.content.image != null && widget.content.image.isNotEmpty ?
      Image.network(
          widget.content.image,
          width: Configuration.width,
          height: Configuration.height*0.6,
          fit: BoxFit.cover,
      ) : Container(color: Configuration.lightgrey, height: Configuration.height * 0.6),
      Expanded(
        child: Container(
          width: Configuration.width,
          child: Stack(
            children: [
              Align(
                alignment: Alignment.topLeft,
                  child: Padding(
                  padding: EdgeInsets.only(
                      left: Configuration.smpadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(height: Configuration.verticalspacing*2),
                      Text(widget.content.title,textAlign: TextAlign.left,
                        style: Configuration.text('smallmedium', Colors.black)),
                      SizedBox(height: Configuration.verticalspacing),
                      Text(widget.content.description,
                        style:Configuration.text('small',Colors.grey)
                      )
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    BaseButton(
                      margin:true,
                      text:'Start ' + type,
                      onPressed: () async{
                        if(c.isMeditation()){
                          _meditationstate.selectMeditation(c);
                        }
                        setState(() => started = true);
                      } 
                    ),
                    SizedBox(height: Configuration.verticalspacing*1.5)
                  ],
                )
              )
            ],
          ),
        ),
      )
    ]);
  }


  Widget meditation(Content c){
    
    List<Widget> mapToWidget(map){  
     List<Widget> l = new List.empty(growable: true);
     l.add(SizedBox(height: 30));
      
      if (map['title'] != null) {
        l.add(Center(
          child: Text(map['title'],style: Configuration.text('medium', Colors.white)),
        ));
        l.add(SizedBox(height:15));
      }

      if (map['image'] != null) {
        l.add(ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Image(image: NetworkImage( map['image']), width: Configuration.width*0.6)));
      }

      if (map['text'] != null) {
        l.add(SizedBox(height:15));
        l.add(Text(map['text'],
            style: Configuration.text('small', Colors.white,font:'Helvetica')));
      }

      if(map['html'] != null){
        l.add(SizedBox(height: 15));
        l.add(Center(child: Html(data: map['html'],
        style: {
          "body": Style(color: Colors.white,fontSize: FontSize(18)),
          "li": Style(margin: EdgeInsets.symmetric(vertical: 10.0)),
          "h2":Style(textAlign: TextAlign.center)
        })));
      }

    return l;
    
  }


    Widget slider(){
      return Slider(
        activeColor: Configuration.maincolor,
        inactiveColor: Colors.white,
        min: 0.0,
        max: _meditationstate.totalduration.inSeconds.toDouble(),
        onChanged: (a)=> null, 
        value: _meditationstate.totalduration.inSeconds - _meditationstate.duration.inSeconds.toDouble() ,
        label:  _meditationstate.duration.inHours > 0
              ? _meditationstate.duration.toString().substring(0, 7)
              : _meditationstate.duration.toString().substring(2, 7)
      );
    }

    Widget pauseButton(){
      return  FloatingActionButton(
      backgroundColor: Colors.white,
      onPressed: () => setState(()=> _meditationstate.state == 'started' ? _meditationstate.pause() :  _meditationstate.startTimer()),
      child: Icon(_meditationstate.state == 'started' ?  Icons.pause  : Icons.play_arrow, color: Colors.black)
      );           
    }

    Widget freeMeditation(){
      return Center(
        child: Container(
          height: Configuration.blockSizeHorizontal * 60,
          width: Configuration.blockSizeHorizontal * 60,
          decoration: BoxDecoration(color: Configuration.grey, borderRadius: BorderRadius.circular(12.0)),
          child: Center(
            child:GestureDetector(
              onDoubleTap: (){ _meditationstate.finishMeditation();}, 
              child:Text('free meditation', style:Configuration.text('smallmedium', Colors.white))
            )
          ),
        ),
      );
    }

    Widget guidedMeditation(){
      return Align(
        alignment:Alignment.center,
        child: Padding(
          padding: EdgeInsets.all(Configuration.smpadding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: 
               _meditationstate.currentsentence != null ?  
                mapToWidget(_meditationstate.currentsentence)
                : 
               [
                 ClipRRect(
                    borderRadius: BorderRadius.circular(12.0),
                    child: Image(image: NetworkImage(_meditationstate.selmeditation.image),
                    height: Configuration.height*0.35,
                    width: Configuration.height*0.35
                    ),
                  ),
                SizedBox(height: Configuration.blockSizeVertical*3),
                GestureDetector(
                  onDoubleTap: (){
                    _meditationstate.finishMeditation();
                  }, 
                  child: Text(_meditationstate.selmeditation.title,style: Configuration.text('smallmedium',Colors.white))
                )
              ],
          ),
        ),
      );
    }

    return Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: AspectRatio(
              aspectRatio:1,
              child: Container(
                margin:EdgeInsets.all(Configuration.smpadding),
                width: Configuration.width*0.6,
                decoration: BoxDecoration(
                  borderRadius:BorderRadius.circular(Configuration.borderRadius),
                  color:Colors.grey
                ),
              ),
            )
          ),

          Positioned(
            bottom: 20,
            right:10,
            left:10,
            child: Column(
            children: [
              pauseButton(),
              SizedBox(height:Configuration.verticalspacing),
              slider()
            ]),
          ),
        /*
        _meditationstate.shadow ? 
        Positioned.fill(
          child: GestureDetector(
            onTap: () {
              _meditationstate.light();
            },
            child: Container(
              decoration: BoxDecoration(color:Colors.black.withOpacity(0.9))
            ),
          ),
        ): Container(), 

        _meditationstate.selmeditation != null ? guidedMeditation(): freeMeditation()
        */

      ]);
  }


  @override
  Widget build(BuildContext context) {
    _meditationstate = Provider.of<MeditationState>(context);

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar:AppBar(
        // ESTO HABRÁ QUE HACERLO PARA LOS DOS
        leading: CloseButton(
            color: Colors.black,
            onPressed: () => showAlertDialog(
              title: 'Are you sure you want to exit ?',
              context: context,
              text: text
          )),
          backgroundColor: Colors.transparent,
          elevation: 0,
      ),
      body:
        !started ? portada(c:widget.content): 
        widget.content.isMeditation() ? meditation(widget.content):
        Container()
    );
  }
}



