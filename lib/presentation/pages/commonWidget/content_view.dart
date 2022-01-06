
// WIDGET COMÚN DE VISTA DE CONTENIDO
// SE PODRÁN VER LECCIONES Y MEDITACIONES, Y EDITAR 
import 'package:flutter/material.dart';
import 'package:meditation_app/domain/entities/content_entity.dart';
import 'package:meditation_app/presentation/pages/commonWidget/alert_dialog.dart';
import 'package:meditation_app/presentation/pages/commonWidget/start_button.dart';
import 'package:meditation_app/presentation/pages/config/configuration.dart';


class ContentShow extends StatefulWidget {
  Content content;

  ContentShow({this.content}) : super();

  @override
  _ContentShowState createState() => _ContentShowState();
}

class _ContentShowState extends State<ContentShow> {

  bool started = false;

  bool  isMeditation;

  String type;

  @override
  void didChangeDependencies(){
    super.didChangeDependencies();

    if(widget.content.type=='meditation-practice'){
      isMeditation = true;
      type = 'Meditation';
    }else{
      isMeditation = false;
      type = 'Lesson';
    }
  }



  Widget portada() {
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



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar:AppBar(
        leading: CloseButton(
            color: Colors.black,
            onPressed: () => showAlertDialog(
              title: 'Are you sure you want to exit ?',
              context: context,
              text: "This lesson will not count as read one"
          )),
          backgroundColor: Colors.transparent,
          elevation: 0,
      ),
      body:!started ? portada(): Container()
    );
  }
}
